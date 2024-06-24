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

# Detect the package manager and install required packages
if command -v apt > /dev/null; then
    apt update
    apt install -y git python3 python3-venv python3-pip
elif command -v yum > /dev/null; then
    yum update -y
    yum install -y git python3 python3-venv python3-pip
elif command -v dnf > /dev/null; then
    dnf update -y
    dnf install -y git python3 python3-venv python3-pip
elif command -v zypper > /dev/null; then
    zypper refresh
    zypper install -y git python3 python3-virtualenv python3-pip
elif command -v pacman > /dev/null; then
    pacman -Syu --noconfirm
    pacman -S --noconfirm git python python-virtualenv python-pip
elif command -v apk > /dev/null; then
    apk update
    apk add git python3 py3-virtualenv py3-pip
else
    echo "Unsupported package manager. Please install git, python3, python3-venv, and python3-pip manually."
    exit 1
fi

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


