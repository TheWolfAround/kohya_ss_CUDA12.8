#!/bin/bash

# Set the ANSI escape sequence for yellow text
RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
# Set the ANSI escape sequence to reset text color
RESET='\033[0m'

if [ -z "$PREFERRED_PYTHON" ]; then
    PREFERRED_PYTHON="python3"
fi

# Get the Python version and extract the major, minor, and patch numbers
python_version=$($PREFERRED_PYTHON --version 2>&1 | awk '{print $2}')
major=$(echo $python_version | cut -d'.' -f1)
minor=$(echo $python_version | cut -d'.' -f2)
patch=$(echo $python_version | cut -d'.' -f3)

# Check if the Python version is within the desired range
if [[ $major -eq 3 && $minor -ge 11 && $minor -lt 13 ]]; then
    echo -e "${GREEN}Python version $python_version is within the acceptable range.${RESET}"
else
    echo -e "${RED}Error: Python version $python_version is not within the acceptable range (3.11.0 to 3.13.0).${RESET}"
    exit 1
fi

# This gets the directory the script is run from so pathing can work relative to the script where needed.
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

# Step into GUI local directory
cd "$SCRIPT_DIR" || exit 1

if [[ -d "$SCRIPT_DIR/virt" ]]; then
    echo -e "${YELLOW}Python Virtual Environment folder exist.${RESET}"
    source "$SCRIPT_DIR/virt/bin/activate"
    echo -e "${YELLOW}Python Virtual Environment activated.${RESET}"
else
    echo -e "${RED}Python Virtual Environment folder does not exist.${RESET}"
    echo -e "${RED}Make sure you have run 'install_python_dependencies.sh' first.${RESET}"
    exit 1
fi

# Check if LD_LIBRARY_PATH environment variable exists
if [[ -z "${LD_LIBRARY_PATH}" ]]; then
    echo -e " "
    echo -e "${YELLOW}Warning: LD_LIBRARY_PATH environment variable is not set.${RESET}"
    echo -e "${YELLOW}Certain functionalities may not work correctly.${RESET}"
    echo -e "${YELLOW}Please ensure that the required libraries are properly configured.${RESET}"
    echo -e " "
fi

"$PREFERRED_PYTHON" "$SCRIPT_DIR/kohya_gui.py" "$@"
