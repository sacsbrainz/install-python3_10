#!/bin/bash

set -e

echo "Installing Python 3.10 and troubleshooting venv creation"

# Install Python 3.10
echo "Installing Python 3.10..."
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.10 python3.10-venv python3.10-distutils

# Create symlink
echo "Creating symlink for python3.10..."
sudo ln -sf /usr/bin/python3.10 /usr/local/bin/python3.10

# Check Python 3.10 installation
echo "Checking Python 3.10 installation..."
if ! python3.10 --version; then
    echo "Python 3.10 installation failed. Please check the error messages above."
    exit 1
fi

# Check venv module
echo "Checking venv module..."
if ! python3.10 -m venv --help > /dev/null; then
    echo "venv module not found. Attempting to install python3.10-venv..."
    sudo apt install -y python3.10-venv
fi

# Attempt to create venv
echo "Attempting to create virtual environment..."
if python3.10 -m venv venv; then
    echo "Virtual environment created successfully!"
    exit 0
fi

# If venv creation failed, try without pip
echo "Regular venv creation failed. Attempting to create venv without pip..."
if python3.10 -m venv --without-pip venv; then
    echo "Virtual environment created without pip. Installing pip manually..."
    source venv/bin/activate
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
    deactivate
    rm get-pip.py
    echo "Pip installed in virtual environment."
    exit 0
fi

# If all else fails, show verbose output
echo "All attempts failed. Showing verbose output for debugging:"
python3.10 -m venv venv -v

echo "Script completed. If issues persist, please check the verbose output above for more details."
