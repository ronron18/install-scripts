# Zabbix Installation
## Instructions
1. Make sure your system meets the minimum requirements.
    - If you are running a VM please set CPU type to host.
2. Install Debian 12 on the target system
    - Enable mirrors during setup.
    - Do not install any desktop environment.
    - Enable SSH server if you want.
3. Get the files on the target system.
    - This can be done via various methods such as the `scp` command, via an external storage device, etc.
4. Give execute permissions to the files with `chmod u+x [file_name]` .
5. Execute installation script and follow the instructions.
8. You're done, what is left is manual configuration to your likings.