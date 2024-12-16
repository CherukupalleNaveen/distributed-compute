# PANINI CLUSTER

## Deploying in Microsoft Windows,

If you are using Microsoft Windows, then follow the below instructions,
### 1. Enable Windows Subsystem for Linux
1. Open the Start menu and type **"Windows features"** into the search bar and click on **"Turn Windows Features On or Off"**.
2. Tick the **"Windows Subsystem for Linux"** & **"Virtual Machine Platform"** checkbox and press the “OK” button.
3. When the operation is complete, you will be asked to **restart your computer**.

### 2. Open Power Shell as Administrator

1. Update the WSL,
    ```
    wsl --update
    ```
2. Install Ubuntu in WSL,
    ```
    wsl --install -d Ubuntu
    ```
3. Make Ubuntu a startup process - [Tutorial](https://www.youtube.com/watch?v=xFpgf9eLUlk)
    - Open the startup folder by running the below command in the "Run",
    ```
    shell:common startup
    ```
    - If it is not working, just open the folder explorer and just type **"startup"** in the location bar above and press enter.
    - Copy "wsl.bat" file to the above startup folder.
4. Then follow the steps in the [**Deploying in Linux**](https://code.swecha.org/telugu-ai/panini-cluster#deploying-in-linux-as-a-service-debian-ubuntu-archlinux-etc) Section below.


## Deploying in Linux as a service [Debian, Ubuntu, ArchLinux etc,.]

1. Install curl on your machine,
    ```
    sudo apt update && sudo apt install -y curl ca-certificates
    ```

2. Run the the below shell command using the following arguments,
    ### DO NOT EXECUTE THE BELOW
    ``` 
    curl -sSL https://code.swecha.org/telugu-ai/panini-cluster/-/raw/main/setup.sh | sudo bash -s [Number_of_Blocks_based_on_machine_capacity] [Machine-Name]
    ```
    ### CAN TRY THE BELOW - CHANGE THE NUMBER OF BLOCKS AND MACHINE NAME AT THE END OF THE COMMAND
    Below is the example which can be executed,
    ```
    curl -sSL https://code.swecha.org/telugu-ai/panini-cluster/-/raw/main/setup.sh | sudo bash -s 5 Swecha_CPU1
    ```

## Deploying in Android,

1. Install **UserLAnd** App from **Play Store** and open it.
2. Install **Ubuntu** terminal in **UserLAnd** App.
3. Install curl, ca-certificates on your machine,
    ```
    sudo apt update && sudo apt install -y curl ca-certificates
    ```

4. Run the the below shell command using the following arguments to setup the cluster,
    ### CAN TRY THE BELOW - CHANGE THE NUMBER OF BLOCKS AND MACHINE NAME AT THE END OF THE COMMAND
    Below is the example which can be executed,
    ```
    curl -sSL https://code.swecha.org/telugu-ai/panini-cluster/-/raw/main/android.sh | sudo bash -s 1 Swecha_Android
    ```

5. Run the the below shell command to connect your device to the cluster,
    Below is the example whcih can be executed,
    ```
    curl -sSL https://code.swecha.org/telugu-ai/panini-cluster/-/raw/main/android_start.sh | sudo bash
    ```

## Deploying in macOS as a service
1. Install curl on your machine,
    ```
    brew update; brew install curl; brew install openssl
    ```

2. Run the the below shell command using the following arguments,
    ### DO NOT EXECUTE THE BELOW
    ``` 
    curl -sSL https://code.swecha.org/telugu-ai/panini-cluster/-/raw/main/setup_mc.sh | bash -s [Number_of_Blocks_based_on_machine_capacity] [Machine-Name]
    ```
    ### CAN TRY THE BELOW - CHANGE THE NUMBER OF BLOCKS AND MACHINE NAME AT THE END OF THE COMMAND
    Below is the example whcih can be executed,
    ```
    curl -sSL https://code.swecha.org/telugu-ai/panini-cluster/-/raw/main/setup_mc.sh | bash -s 5 Swecha_CPU1
    ```

### Issues & Fixes

#### If Python Virtual Environment is not working, you need to install miniconda using the below commands (If failing at step-3 above),

- You need to install miniconda and run the experiment manually as below. ([Working on improvements](https://code.swecha.org/telugu-ai/panini-cluster/-/issues/1))

## To join your device as a peer into the inferencing network manually,

- (Optional, recommended) Create a virtual environment and activate it,

  ``` sh
  python3 -m venv ~/petals-venv
  source ~/petals-venv/bin/activate
  ```

- Install the requirements,
  ```
  pip3 install git+https://github.com/bigscience-workshop/petals
  ```
- To join the peer to the cluster network,

  ```
  python3 -m petals.cli.run_server bigscience/bloomz-560m --initial_peers /ip4/65.108.151.120/tcp/31337/p2p/QmbPdbE4bsjPGEV7KDepxPFBqmRtQuK479LVi8qvB8seL1 --torch_dtype auto --num_blocks 11 --public_name XYZ
  ```

## Debugging & Fixes:
- If you encounter issue time not being sync with the server. Please sync the peer time with server using below command,
    - Install ntpdate package
        ```
        sudo apt install ntpdate
        ```
    - Run the below command to sync the time,
        ```
        sudo ntpdate time.nist.gov
        ```
    - Then restart panini.service
        ```
        sudo systemctl panini.service
        ```


## Resources
https://github.com/bigscience-workshop/petals

https://github.com/petals-infra/chat.petals.dev

https://github.com/petals-infra/health.petals.dev
