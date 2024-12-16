#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi


echo "Select an option:"
echo "1. Blocks Change"
echo "2. Model Change"

read -p "Enter your choice (1 or 2): " choice

change=$1

case $choice in
    1)
        # Add your logic for blocks change here
        echo "Performing Blocks Change..."
        old_blocks=$(grep -o -P -- '--num_blocks \K\d+' /usr/local/bin/run.sh)
        sed -i "s|${old_blocks}|${change}|g" /usr/local/bin/run.sh
        ;;
    2)
        # Add your logic for model change here
        echo "Performing Model Change..."
        old_model=$(awk '/python3 -m petals\.cli\.run_server/ {print $4}' "/usr/local/bin/run.sh")
        sed -i "s|${old_model}|${change}|g" /usr/local/bin/run.sh
        ;;
    *)
        echo "Invalid choice. Please enter 1 or 2."
        ;;
esac



#Restart panini service
systemctl restart panini.service
