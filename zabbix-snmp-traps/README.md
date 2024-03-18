# Zabbix Trap Installation
## Instructions
1. Make sure Zabbix is installed
2. Get the files on the target system.
    - This can be done via various methods such as the `scp` command, via an external storage device, etc.
3. Get the perl script here ``https://git.zabbix.com/projects/ZBX/repos/zabbix/raw/misc/snmptrap/zabbix_trap_receiver.pl`` and put it in the same directory as the script.
    - Use `scp`
4. Give execute permissions to the files with `chmod u+x [file_name]` .
5. Execute installation script and follow the instructions.
8. You're done, what is left is manual configuration to your likings!