 #!/bin/bash
# This script intsalls daily biological tools

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to install SnapGene/IGV/PyMOL
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install daily biological tools, such as SnapGene and PyMOL? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing daily biological tools (SnapGene/IGV/PyMOL)...${TEXT_RESET} \n" && sleep 1

        # install IGV/PyMOL/FastQC
        sudo apt-get update && sudo apt-get install igv pymol fastqc -y

        # install snapgene font
        echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
        sleep 3 && sudo apt-get install ttf-mscorefonts-installer -y && sleep 3

        # install snapgene
        [ ! -d ./snapgene/ ] && mkdir ./snapgene/
        wget -q 'https://www.snapgene.com/local/targets/download.php?variant=viewer&os=linux_deb&majorRelease=latest&minorRelease=latest' -O snapgene.deb
        wget -q 'http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1l-1ubuntu1_amd64.deb'
        mv -f ./*.deb ./snapgene/ && sudo dpkg -i ./snapgene/*.deb
        sudo apt-get -f -y install
        
        # install zotero
        sudo flatpak install -y --noninteractive flathub org.zotero.Zotero
        
        # configure
        sudo sed -i 's+Exec=/opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U+Exec=XDG_CURRENT_DESKTOP=GNOME /opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U+g' /usr/share/applications/snapgene-viewer.desktop
        echo -e " \n${TEXT_YELLOW}Please config and then close SnapGene to continue.${TEXT_RESET} \n" && sleep 1
        XDG_CURRENT_DESKTOP=GNOME /opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U
        
        # cleanup
        sudo apt-get autoremove -y && sudo apt-get clean
        rm -rf ./snapgene/

        # notify end
        echo -e " \n${TEXT_GREEN}Daily biological tools installed!${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Daily biological tools not installed.${TEXT_RESET} \n" && sleep 5;;

esac

# mark setup.sh
sed -i 's+bash ./src/biodaily.sh+#bash ./src/biodaily.sh+g' ~/.setup_cache/setup.sh
