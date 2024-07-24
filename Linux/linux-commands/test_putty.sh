


putty.exe [connection (-ssh)] [username@serverIP-or-Domain] [parameter (-pw password)] [parameter (-m (read a remote command or script from a file) sh file to local path)]

C:\path\to\putty.exe -ssh username@192.0.0.0.0 -pw "password" -m "C:\path\to\command_sh_script_file.sh"

# Example

"D:\Program Files\PuTTY\putty.exe" -ssh ubuntu@192.168.0.50 -pw "admin" -m server_install.sh