# OpenBgInfo
OpenBgInfo shows system info on your desktop background.

## Dependencies
The script assumes that you have ImageMagick installed.
If you don't, you can install it easily on Ubuntu using apt:
```console
user@ubuntu:~$ sudo apt install -y imagemagick
Reading package lists... Done
Building dependency tree
...
```
Next to **ImageMagick** you also need so common linux tools. In most 
installations these will already be available by default:
- Awk (part of package net-tools on Ubuntu)
- Route (part of package net-tools on Ubuntu)
- Netstat (part of package net-tools on Ubuntu)
- Sudo (The user executing the script also needs sudo-rights)

## Usage
Executing the script is easy:
```console
user@ubuntu:~$ chmod +x openbginfo.sh
user@ubuntu:~$ ./openbginfo.sh -h
OpenBgInfo shows system info on the desktop background.

Usage: openbginfo.sh [-h|--help] [-n]
options:
  -h | --help	Print this Help.
  -n		Hide the timestamp on the output background image
user@ubuntu:~$ ./openbginfo.sh
user@ubuntu:~$ 
```
