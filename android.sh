#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Input parameters
username="panini"
blocks="$1"
mac_name="$2"
password="panini"
echo "Username=$username"
echo "num_blocks=$blocks"
echo "Machine Name=$mac_name"
venv_name="petals-venv"

## Install python3-pip, python3-venv and git
sudo apt update
sudo apt install python3-pip python3-venv ntpdate git -y
pip3 install --upgrade pip
sudo ntpdate time.nist.gov

# Create user
encrypted_password=$(openssl passwd -1 "$password")
useradd -m -s /bin/bash -p $encrypted_password $username
#passwd $username

# Switch to the user
su - $username << EOF

# Create Python virtual environment
python3 -m venv $venv_name

# Clone the project repo
git clone https://code.swecha.org/telugu-ai/panini-cluster.git

# Change directory
cd panini-cluster

# Changing the permissions to executable
chmod +x *.sh

EOF

source /home/panini/$venv_name/bin/activate

sudo pip3 install git+https://github.com/bigscience-workshop/petals

deactivate

touch /home/panini/panini-cluster/run.sh
echo "#!/bin/bash" >> /home/panini/panini-cluster/run.sh
echo "source /home/panini/petals-venv/bin/activate" >> /home/panini/panini-cluster/run.sh
echo "python3 -m petals.cli.run_server bigscience/bloomz-560m --initial_peers /ip4/65.108.151.120/tcp/31337/p2p/QmbPdbE4bsjPGEV7KDepxPFBqmRtQuK479LVi8qvB8seL1 --torch_dtype auto --num_blocks ${blocks} --public_name ${mac_name}" >> /home/panini/panini-cluster/run.sh
chmod +x /home/panini/panini-cluster/run.sh

echo "User $username created with Python virtual environment and dependencies installed. Swecha DHPC (Panini Cluster) is setup succesfully in the machine!"
