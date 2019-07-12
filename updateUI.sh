#!/usr/bin/env bash
folder='pulsetile-nodered-ui-build'
cd ~
git clone https://github.com/PulseTile/PulseTile-RA.git $folder
cd $folder
git checkout nodered-demo
cp -rf ./build/* ~/nodered/nginx/html/
cd ..
rm -rf ~/$folder
green=`tput setaf 2`
reset=`tput sgr0`
echo "${green}You successfully updated PulseTile ${reset}"
