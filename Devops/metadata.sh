#!/bin/bash

#assign variables
ACTION=${1:-}
VERSION="0.5.0"

function install_nginx(){
sudo yum update -y
sudo amazon-linux-extras install nginx1.12 -y
sudo systemctl enable nginx.service
sudo aws cp s3://nalub001-assignment-3/index.html /usr/share/nginx/html/index.html
sudo  systemctl  start nginx.service
}

function remove(){
	sudo systemctl stop nginx.service
	sudo rm -rf /usr/share/nginx/html/index.html
	sudo yum remove nginx1.12
}

function create(){
	sudo touch backend1-identity.json
	sudo chmod 777 backend1-identity.json
	curl http://169.254.169.254/latest/dynamic/instance-identity/document/ > backend1-identity.json
	sudo touch backend1-message.txt
	sudo chmod 777 backend1-message.txt
	curl -vs https://s3.amazonaws.com/seis615/message.json 2>&1 | tee backend1-message.txt
	sudo cp /var/log/nginx/access.log .

}

function show_version(){
	echo $VERSION
}

function display_help(){

cat << EOF
Usage: {0} {-h|--help|-r|--remove|-v|--version}
OPTIONS:
	-h | --help	Display the command help
	-v | --version	Version of the script
	-c | --create	Create Files and redirects
Examples:
	Display help:
		$ ${0} -h
	Create Backend Files:
		${0} -c
	Display version:
		${0} -v
EOF
}


case "$ACTION" in
	-h|--help)
		display_help
		;;
	-c|--create)
		create
		;;
	-v|--version)
		show_version
		;;
	*)
	echo Usage ${0} {-h|-c|-v}
	exit 1

esac
