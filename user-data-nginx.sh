#!/bin/bash
sudo dnf update
sudo dnf install -y nginx unzip
sudo curl -o /usr/share/nginx/html/master.zip -L https://codeload.github.com/gabrielecirulli/2048/zip/master
cd /usr/share/nginx/html/ && sudo unzip master.zip && sudo mv 2048-master/* . && sudo rm -rf 2048-master master.zip
sudo systemctl start nginx.service
sudo systemctl enable nginx.service