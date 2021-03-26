#!/bin/bash

#assign variables
ACTION=${1:-}
VERSION="1.0.0"

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

function show_version(){
	echo $VERSION
}

function display_help(){

cat << EOF
Usage: {0} {-h|--help|-r|--remove|-v|--version} 

OPTIONS:
	-h | --help	Display the command help
	-v | --version	Version of the script
	-r | --remove	Remove nginx service

Examples:
	Display help:
		$ ${0} -h

	Remove  nginx:
		${0} -r

	Display version:
		${0} -v

EOF
}


case "$ACTION" in
	-h|--help)
		display_help
		;;
	-r|--remove)
		remove
		;;
	-v|--version)
		show_version
		;;
	*)
		install_nginx
	#echo Usage ${0} {-h|-r|-v}"
	exit 1

esac
