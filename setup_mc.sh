#!/bin/bash

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Input parameters
username="panini"
blocks="$1"
mac_name="$2"
user_password="panini" # Replace with a secure password

echo "Username=$username"
echo "num_blocks=$blocks"
echo "Machine Name=$mac_name"
venv_name="petals-venv"

# Check if the user already exists and delete if exists
if id "$username" &>/dev/null; then
    echo "User named '$username' already exists. Deleting the user..."
    sysadminctl -deleteUser "$username" -secure
fi

# Create user with a clear text password
sysadminctl -addUser "$username" -fullName "$username" -password "$user_password" -admin

# Switch to the newly created user for Homebrew commands
sudo -u "$username" bash << EOF

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Python3 and Git using Homebrew
echo "Updating Homebrew and installing Python3 and Git..."
brew update
brew install python3 git

EOF

# Set up NTP using sntp
sudo sntp -sS time.apple.com

# Switch to the user and set up the Python environment
sudo -u "$username" bash << EOF

# Create Python virtual environment
cd /Users/$username
python3 -m venv $venv_name

# Activate virtual environment
source $venv_name/bin/activate

# Clone the project repo
git clone https://code.swecha.org/telugu-ai/panini-cluster.git

# Changing the permissions to executable
chmod +x *.sh

# Upgrade pip and install dependencies using pip3
pip3 install --upgrade pip
pip3 install git+https://github.com/bigscience-workshop/petals

# Deactivate virtual environment
deactivate

EOF

# Create a script to run the server
cat << EOF > /usr/local/bin/run.sh
#!/bin/bash
source /Users/$username/$venv_name/bin/activate
python3 -m petals.cli.run_server bigscience/bloomz-560m --initial_peers /ip4/65.108.151.120/tcp/31337/p2p/QmbPdbE4bsjPGEV7KDepxPFBqmRtQuK479LVi8qvB8seL1 --torch_dtype auto --num_blocks ${blocks} --public_name ${mac_name}
EOF

chmod a+x /usr/local/bin/run.sh

# Set up the service using launchd instead of systemd
cat << EOF > /Library/LaunchDaemons/panini.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>panini</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/usr/local/bin/run.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# Check if the 'panini' service is running
if sudo launchctl list | grep -q 'panini'; then
    echo "Service 'panini' is running. Stopping it..."
    sudo launchctl bootout system /Library/LaunchDaemons/panini.plist
else
    echo "Service 'panini' is not running. Going to bootstrap now.... "
fi

# Bootstrap the panini service
sudo launchctl bootstrap system /Library/LaunchDaemons/panini.plist
sudo launchctl enable system/panini
sudo launchctl kickstart -k system/panini

echo "User $username created with Python virtual environment and dependencies installed. Swecha DHPC (Panini Cluster) is setup successfully on the machine!"
