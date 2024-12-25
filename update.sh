#!/bin/bash

release_file=/etc/os-release
logfile=./update.log
errorlog=./update_error.log

check_exit_status() {
    if [ $? -ne 0 ]
    then
        echo "An error ocurred, check the $errorlog file"
    else 
        echo "Operation sucessful ..."
    fi
}

update_arch() {
    sudo pacman -Syu 1>>$logfile 2>>$errorlog
    echo "Updating and Upgrading .... "
    check_exit_status
}
update_debian_ubuntu() {
    sudo apt update 1>> $logfile 2>>$errorlog
    check_exit_status
    sudo apt dist-upgrade -y 1>>$logfile 2>>$errorlog
    echo "Updating and Upgrading .... "
    check_exit_status
}

if [ ! -f $release_file ]
then 
    echo "$release_file does not exist.."
    exit 1      
fi    

if grep -q "Arch" $release_file
then 
    update_arch
fi

if  grep -q "Debian" $release_file || grep -q "Ubuntu" $release_file
then 
   update_debian_ubuntu
fi