#!/bin/bash
Help()
{
	# Display Help
	echo "OpenBgInfo shows system info on the desktop background."
	echo
   	echo "Usage: openbginfo.sh [-h|--help] [-n]"
   	echo "options:"
   	echo "  -h | --help	Print this Help."
   	echo "  -n		Hide the timestamp on the output background image"
}

font="Ubuntu-Mono"
fontsize_normal=15
fontsize_title=20
fontsize_hostname=30
DISPLAY=:1
dconf reset -f /org/compiz

while getopts ":-help :n :h" option; do
   case $option in
      -help) # display Help
      	 Help
      	 exit;;
      h) # display Help
         Help
         exit;;
      n) # Hide timestamp on output
      	 hidetimestamp=1;;
   esac
done

if [[ $hidetimestamp = 1 ]];
then
	TS=""
else
	TS=$(date)
fi

loggedinusers=$(who)
lannic=$(route | grep default | awk '{print $NF}')
arptable=$(arp -a | awk '{printf($4"\t"$2"\t"$1"\n")}' | sed 's/(//g; s/)//g')

convert -size 1920x1080 xc:black +repage \
    -pointsize $fontsize_title -fill white -font $font -annotate +1300+60 "$TS" +repage \
    -pointsize $fontsize_hostname -fill green -font $font -annotate +400+60 "$(cat /etc/hostname) - $(ip a s dev $lannic | grep "inet " | awk '{print $2}')" +repage \
    -pointsize $fontsize_normal -fill blue -font $font -annotate +400+75 "$(uptime -p)" +repage \
    -pointsize $fontsize_title -fill white -font $font -annotate +400+120 "Users: " +repage \
    -pointsize $fontsize_normal -fill white -font $font -annotate +400+120 "\n$(cat /etc/passwd | grep -v 'nologin' | grep -v 'bin/false' | grep -v 'bin/sync' | awk -F ':' '{print $1}' | sort | tr '\n' ' ')" +repage \
    -pointsize $fontsize_title -fill white -font $font -annotate +400+170 "Logged-in users:" +repage \
    -pointsize $fontsize_normal -fill white -font $font -annotate +400+170 "\n$loggedinusers" +repage \
    -pointsize $fontsize_title -fill white -font $font -annotate +950+120 "Memory" +repage \
    -pointsize $fontsize_normal -fill white -font $font -annotate +950+130 "\n$(free -h)" +repage \
    -pointsize $fontsize_title -fill white -font $font -annotate +400+250 "ARP Table" +repage \
    -pointsize $fontsize_normal -fill white -font $font -annotate +400+275 "$(echo 'MAC                  IPv4            Hostname')" +repage \
    -pointsize $fontsize_normal -fill white -font $font -annotate +400+275 "$(echo '\n-----------------    --------------  --------------')" +repage \
    -pointsize $fontsize_normal -fill white -font $font -annotate +400+310 "$(arp -a | awk '{printf($4"    "$2"    "$1"\n")}' | sed 's/(//g; s/)//g')" +repage \
    -pointsize $fontsize_title -fill white -font $font -annotate +400+500 "Storage" +repage \
    -pointsize $fontsize_normal -fill white -font $font -annotate +400+520 "$(df -h --output=source,fstype,size,used,avail,pcent,target | grep -v 'squashfs' | grep -v 'tmpfs')" +repage \
    -pointsize $fontsize_title -fill white -font $font -annotate +400+650 "Listening ports" +repage \
    -pointsize $fontsize_normal -fill white -font $font -annotate +400+670 "$(sudo netstat -tln4p | sort)" output.bmp 

gsettings set org.gnome.desktop.background picture-uri "'file://$(pwd)/output.bmp'"
