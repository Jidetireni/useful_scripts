#!/bin/bash

key_path="$HOME/.ssh/github_key"
if [ ! -f $key_path ]
then
    echo "SSH key not found at $key_path. Generating a new one..."
    ssh-keygen -t rsa -b 4096 -f $key_path
      if [ $? -ne 0 ]; then
        echo "Error: SSH key generation failed."
        exit 1
    fi
    chmod 600 $key_path
    echo "SSH key generated and saved at $key_path."
    cat $key_path.pub > ./github_pub_key
else 
    echo "SSH key already exists at $key_path. No changes made."
fi
