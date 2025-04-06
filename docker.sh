#!/bin/bash

service=docker

if command -v $service &> /dev/null
then
    echo "$service is installed"
    $service -v
else
    echo "$service is NOT installed"
    echo "Installing $service ....."

    # Update and install prerequisites
    if ! sudo apt-get update -y &> /dev/null
    then
        echo "Failed to update package list. Exiting..."
        exit 1
    fi
    if ! sudo apt-get install -y ca-certificates curl &> /dev/null
    then
        echo "Failed to install prerequisites. Exiting..."
        exit 1
    fi

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    if ! sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    then
        echo "Failed to download Docker's GPG key. Exiting..."
        exit 1
    fi
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the Docker repository
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update and install Docker
    if ! sudo apt-get update &> /dev/null || \
       ! sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &> /dev/null
    then
        echo "Failed to install Docker. Exiting..."
        exit 1
    fi

    echo "$service INSTALLED ..."
    $service -v

    # Allow current user to use Docker without sudo
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker "$USER"
    echo "User '$USER' has been added to the 'docker' group."

    echo "You need to log out and log back in for the group changes to take effect."
    echo "Alternatively, run: newgrp docker"
fi
