#!/bin/bash
# This script downloads all scripts for setup

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# font size
read -p "$(echo -e $TEXT_YELLOW'You may press [Ctrl] and [+]/[-] to adjust the font size. Press [Enter] to continue.'$TEXT_RESET)"$' \n'

# check internet connection
echo -e "${TEXT_YELLOW}Checking internet connection...${TEXT_RESET} \n"
wget -q --spider http://google.com
until [[ $? -eq 0 ]] ; do
    read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'No internet connection! Please first connect to internet then press [Enter] to continue.'$TEXT_RESET)"$' \n'
    echo ""
    wget -q --spider http://google.com
done
echo -e "${TEXT_GREEN}Internet is connected!${TEXT_RESET} \n" && sleep 1

# setup
echo -e "${TEXT_YELLOW}Preparing setup scripts...${TEXT_RESET} \n" && sleep 1
###>>>sed-i-d-start-0
unset start end

## ask for password
unset password
until [[ "$password" == te*ld && ${#password} == 9 ]] ; do
    echo ""
    read -s -p "$(echo -e $TEXT_YELLOW'Please enter the password to unzip the licenses: '$TEXT_RESET)"$' \n' password
done
echo ""

## prepare all scripts
[ ! -f main.zip ] && wget -q "https://github.com/chenh19/MyWorkspace/archive/refs/heads/main.zip" && sleep 1
unzip -o -q main.zip && sleep 1 && rm -f main.zip
cp -rf ./MyWorkspace-main/setup.sh ./
[ ! -d ./inst/ ] && mkdir ./inst/
cp -rf ./MyWorkspace-main/src/inst/* ./inst/
[ ! -d ./cfg/ ] && mkdir ./cfg/
cp -rf ./MyWorkspace-main/src/cfg/* ./cfg/
cp -rf ./cfg/System/ ~/Pictures/
sudo cp -rf ./cfg/icon/ ./cfg/grub/ /opt/
[ ! -d ~/Templates/ ] && mkdir ~/Templates/
kwriteconfig5 --file ~/Templates/.directory --group "Desktop Entry" --key Icon "folder-templates"
cp -rf ./cfg/template/* ~/Templates/
[ ! -d ~/Licenses/ ] && mkdir ~/Licenses/
kwriteconfig5 --file ~/Licenses/.directory --group "Desktop Entry" --key Icon "certificate-server"
[ ! -f ~/Licenses/license.zip ] && wget -q "https://www.dropbox.com/scl/fi/g1ishrqzp3hxyep1srb56/license.zip?rlkey=up5mmfxz8huf5f1kqr2cfcq1d&st=p08bfy7u&dl=0" -O ~/Licenses/license.zip && sleep 1
7z x -p$password ~/Licenses/license.zip -o$HOME/Licenses/
rm -f ~/Licenses/license.zip
[ ! -d ~/snap/ ] && mkdir ~/snap/
kwriteconfig5 --file ~/snap/.directory --group "Desktop Entry" --key Icon "folder-snap"
rm -rf ./MyWorkspace-main/

## hide files and folders
echo -e "igv\nPublic\nR\nLicenses\nTemplates\nsnap\nZotero\nSync\nsync\nDeveloping\ndeveloping" > ~/.hidden
echo -e "Enpass\nWeChat Files" > ~/Documents/.hidden
echo -e "bin\ndev\nlib\nlibx32\nmnt\nproc\nsbin\nswapfile\nusr\nboot\netc\nlib32\nlost+found\nopt\nroot\nsnap\nsys\nvar\ncdrom\nlib64\npackages.expandrive.gpg\nrun\nsrv\ntmp\ninitrd.img\ninitrd.img.old\nvmlinuz\nvmlinuz.old" | sudo tee /.hidden >/dev/null 2>&1
echo -e "rslsync" | sudo tee /home/.hidden >/dev/null 2>&1

## Power Management
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group DPMSControl --key idleTime "300"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group SuspendSession --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group SuspendSession --key suspendType --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group SuspendSession --key suspendThenHibernate "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group BrightnessControl --key value --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group SuspendSession --key suspendThenHibernate "false"

## for resuming
echo ""
sed -i 's+Preparing setup scripts+Continue setting up+g' ~/.setup_cache/setup.sh
echo -e "${TEXT_GREEN}All setup scripts ready!${TEXT_RESET} \n" && sleep 1
start0="$(grep -wn "###>>>sed-i-d-start-0" ~/.setup_cache/setup.sh | head -n 1 | cut -d: -f1)"
end0="$(grep -wn "###>>>sed-i-d-end-0" ~/.setup_cache/setup.sh | tail -n 1 | cut -d: -f1)"
sed -i "$start0,$end0"'d' ~/.setup_cache/setup.sh
unset start0 end0
###>>>sed-i-d-end-0

# setup
bash ./inst/0_deb.sh
bash ./inst/1_flathub.sh
bash ./inst/2_fcitx.sh
bash ./inst/3_biodaily.sh
bash ./inst/4_biodevr.sh

# config
bash ./cfg/0_sysstg.sh
bash ./cfg/1_sysapp.sh
bash ./cfg/2_sysdsp.sh
bash ./cfg/3_reboot.sh
