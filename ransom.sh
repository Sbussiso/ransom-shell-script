#!/bin/bash

# Function to check if the script is run as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Re-running with sudo..."
        sudo "$0" "$@"
        exit $?
    fi
}

check_root

# Update the package list and install required packages
apt update
sudo apt install git
apt install -y git python3 python3-venv python3-pip

# Clone the GitHub repository
if [ ! -d "anti-ransomware-test" ]; then
    git clone https://github.com/Sbussiso/anti-ransomware-test.git
fi
cd anti-ransomware-test

# Create and activate a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install required Python packages
pip install --upgrade pip setuptools wheel
pip install cryptography
pip install psutil

# Ensure the main.py script is executable
chmod +x main.py

# Run the main.py script
python3 main.py
