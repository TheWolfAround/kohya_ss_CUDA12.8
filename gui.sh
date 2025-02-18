#!/usr/bin/env bash

# Set the ANSI escape sequence for yellow text
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
# Set the ANSI escape sequence to reset text color
RESET='\033[0m'

# List of packages to check
packages="python3-pip python3-dev python3-venv python3-tk"

update_package_index=0
# Loop through each package and check if it is installed
for pkg in $packages; do
    if dpkg -s "$pkg" 1> /dev/null; then
        echo -e "${GREEN}$pkg is already installed.${RESET}"
    else
        if [ $update_package_index -eq 0 ]; then
            sudo apt update
            update_package_index=1 #the script will update the package index once
        fi
        echo -e "${YELLOW}$pkg is not installed. It will be installed via 'apt'${RESET}"
        sudo apt install $pkg -y
    fi
done

# This gets the directory the script is run from so pathing can work relative to the script where needed.
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

# Step into GUI local directory
cd "$SCRIPT_DIR" || exit 1

if [ -z "$PREFERRED_PYTHON" ]; then
    PREFERRED_PYTHON="python3"
fi

if [ -d "$SCRIPT_DIR/virt" ]; then
    source "$SCRIPT_DIR/virt/bin/activate"
else
    echo "Python Virtual Environment folder does not exist. Creating."
    "$PREFERRED_PYTHON" -m venv "$SCRIPT_DIR/virt"
    source "$SCRIPT_DIR/virt/bin/activate"
fi

if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "No Python virtual environment is activated."
else
    echo "Python virtual environment is activated: $VIRTUAL_ENV"
fi

# Get the Python version and extract the major, minor, and patch numbers
python_version=$($PREFERRED_PYTHON --version 2>&1 | awk '{print $2}')
major=$(echo $python_version | cut -d'.' -f1)
minor=$(echo $python_version | cut -d'.' -f2)
patch=$(echo $python_version | cut -d'.' -f3)

# Check if the Python version is within the desired range
if [[ $major -eq 3 && $minor -ge 11 && $minor -lt 13 ]]; then
    echo "Python version $python_version is within the acceptable range."
else
    echo "Error: Python version $python_version is not within the acceptable range (3.11.0 to 3.13.0)."
    exit 1
fi

REQUIREMENTS_FILE="$SCRIPT_DIR/requirements_linux.txt"

# pip3 install -r "$REQUIREMENTS_FILE"

# Check if LD_LIBRARY_PATH environment variable exists
if [[ -z "${LD_LIBRARY_PATH}" ]]; then
    echo -e " "
    echo -e "${YELLOW}Warning: LD_LIBRARY_PATH environment variable is not set.${RESET}"
    echo -e "${YELLOW}Certain functionalities may not work correctly.${RESET}"
    echo -e "${YELLOW}Please ensure that the required libraries are properly configured.${RESET}"
    echo -e " "
fi

"$PREFERRED_PYTHON" "$SCRIPT_DIR/kohya_gui.py" "$@"
