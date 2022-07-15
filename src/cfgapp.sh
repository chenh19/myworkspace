#!/bin/bash
# This script configures KDE plasma settings

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


#-------------------------------------------------------------------------------------

# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Configuring applications...${TEXT_RESET} \n" && sleep 1

######################################################################################

# Konsole

## Konsole window height 32
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1536x864' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1536x960' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1920x1080' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1920x1200' "625"

## Konsole window height 96
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1536x864' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1536x960' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1920x1080' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1920x1200' "803"

## konsole window show "Main Toolbar" and "Session Toolbar"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key State "AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAfsAAAAcAFMAUwBIAE0AYQBuAGEAZwBlAHIARABvAGMAawAAAAAA/////wAAANUBAAADAAADIwAAAiUAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAgAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAAAAAAcAHMAZQBzAHMAaQBvAG4AVABvAG8AbABiAGEAcgEAAADo/////wAAAAAAAAAA"

######################################################################################

# kwrite hide minimap
kwriteconfig5 --file ~/.config/kwriterc --group 'KTextEditor View' --key 'Scroll Bar MiniMap' "false"

######################################################################################

## System Monitor
#Edit or remove pages: uncheck "Applications" and list in this order: "Overview", "Processes", "History"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'hiddenPages' "applications.page"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'pageOrder' "overview.page,process.page,history.page,application.page"

######################################################################################

# spectacle
kwriteconfig5 --file ~/.config/spectaclerc --group GuiConfig --key 'quitAfterSaveCopyExport' "true"

######################################################################################

# okular
[ -f ~/.config/okularpartrc ] && rm ~/.config/okularpartrc
[ -f ~/.config/okularrc ] && rm ~/.config/okularrc
touch ~/.config/okularpartrc ~/.config/okularrc

# Settings > Configure Okular > General > check "Open new files in tabs"
kwriteconfig5 --file ~/.config/okularpartrc --group General --key 'ShellOpenFileInTabs' "true"

# Settings > Configure Okular > Performance > Memory usage > select "Greedy"
kwriteconfig5 --file ~/.config/okularpartrc --group 'Core Performance' --key 'MemoryLevel' "Greedy"

# Settings > Configure Okular > Presentation > uncheck "Show progress indicator"
kwriteconfig5 --file ~/.config/okularpartrc --group 'Dlg Presentation' --key 'SlidesShowProgress' "false"

# Open and close multiple PDF files, uncheck "Warn me when I attempt to close multiple tabs"
kwriteconfig5 --file ~/.config/okularrc --group 'Notification Messages' --key 'ShowTabWarning' "false"

# Configure Toolbars
[ -d ~/.local/share/kxmlgui5/okular/ ] && rm -rf ~/.local/share/kxmlgui5/okular/
cp -rf ./cfg/okular/ ~/.local/share/kxmlgui5/

######################################################################################

# windows fonts
wget -q https://www.dropbox.com/s/nsfxnl3tt1md56u/windows-fonts.zip?dl=0 && sleep 1
unzip -o -q windows-fonts.zip?dl=0 && sleep 1 && rm windows-fonts.zip?dl=0 && sleep 1
sudo cp -rf ./fonts/windows/ /usr/share/fonts/

######################################################################################

# alt_rm
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/alt_rm/main/install.sh)

######################################################################################

# Inkscape
echo -e " \n${TEXT_YELLOW}Please config and then close Inkscape to continue.${TEXT_RESET} \n" && sleep 1
inkscape

######################################################################################

# Plasma widgets
## install widgets
#/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/id #id=1704465/1245902/1274218/1274975 (test in the future)
wget -q https://www.dropbox.com/s/6n5g9a8q5etvtx5/adhe.textcommand.zip?dl=0 && sleep 1 #_to_be_updated
unzip -o -q adhe.textcommand.zip?dl=0 && sleep 1 && rm adhe.textcommand.zip?dl=0
[ ! -d ~/.local/share/plasma/ ] && mkdir ~/.local/share/plasma/
[ ! -d ~/.local/share/plasma/plasmoids/ ] && mkdir ~/.local/share/plasma/plasmoids/
cp -rf ./adhe.textcommand/ ~/.local/share/plasma/plasmoids/ && sleep 1 && rm -rf ./adhe.textcommand/

# config widgets

######################################################################################

# Dolphin

## install widgets
[ ! -d ~/.local/share/kservices5/ ] && mkdir ~/.local/share/kservices5/
[ ! -d ~/.local/share/kservices5/ServiceMenus/ ] && mkdir ~/.local/share/kservices5/ServiceMenus/
echo -e '[Desktop Entry] \nType=Service \n#ServiceTypes=application/x-cd-image;model/x.stl-binary \n#MimeType=all/all; \nServiceTypes=KonqPopupMenu/Plugin \nMimeType=application/x-cd-image;model/x.stl-binary \nX-KDE-StartupNotify=false \nX-KDE-Priority=TopLevel \nActions=mountiso; \nInitialPreference=99 \nVersion=1.0 \n \n[Desktop Action mountiso] \nName=Mount the image \nName[ru]=Смонтировать образ \nExec=udisksctl loop-setup -r -f %u \nIcon=media-optical' > ~/.local/share/kservices5/ServiceMenus/mountiso.desktop
echo -e '[Desktop Entry] \nType=Service \nIcon=system-file-manager \nActions=OpenAsRootKDE5 \nServiceTypes=KonqPopupMenu/Plugin,inode/directory,inode/directory-locked \n \n[Desktop Action OpenAsRootKDE5] \nExec=if [ "$XDG_SESSION_TYPE" = "wayland" ]; then xhost +si:localuser:root && pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dbus-launch dolphin %U && xhost -si:localuser:root ; else pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin %U; fi; \nIcon=system-file-manager \nName=Open as Root \nName[ru]=Открыть папку с правами рут \nName[ua]=Відкрити папку з правами рут \nName[zh_CN]=打开具有根权限的文件夹 \nName[zh_TW]=打開具有根許可權的資料夾 \nName[de]=Öffnen des Ordners mit Root-Berechtigungen \nName[ja]=ルート権限を持つフォルダを開く \nName[ko]=루트 권한이 있는 폴더 열기 \nName[fr]=Ouvrez le dossier avec les privilèges root \nName[el]=Ανοίξτε ως Root \nName[es]=Abrir la carpeta con privilegios de root \nName[tr]=Kök ayrıcalıkları olan klasörü açma \nName[he]=פתח תיקיה עם הרשאות שורש \nName[it]=Aprire la cartella con privilegi radice \nName[ar]=فتح المجلد بامتيازات الجذر \nName[pt_BR]=Abrir pasta com privilégios de root \nName[pt_PT]=Abrir pasta com privilégios de root \nName[sv]=Öppna mapp med root-behörigheter \nName[nb]=Åpne mappen med rotprivilegier' > ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop

## config Dolphin
kbuildsycoca5
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key OpenAsRootKDE5 "root"
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key mountiso "true"

######################################################################################

# kde browser integration reminder hide
kwriteconfig5 --file ~/.config/kded5rc --group 'Module-browserintegrationreminder' --key 'autoload' "false"

######################################################################################

# notify end
echo -e " \n${TEXT_GREEN}All applications configured!${TEXT_RESET} \n" && sleep 5


#-------------------------------------------------------------------------------------

# cleanup
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./fonts/

# mark setup.sh
sed -i 's+bash ./src/settings.sh+#bash ./src/settings.sh+g' ~/.setup_cache/setup.sh