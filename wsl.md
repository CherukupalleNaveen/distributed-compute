## For WSL Machines

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
4. Then now follow [README.md](https://code.swecha.org/panini-dhpc/panini-cluster/-/blob/main/README.md)
