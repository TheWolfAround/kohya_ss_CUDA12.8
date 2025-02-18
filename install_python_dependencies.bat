@echo off

:: Define colors using ANSI escape codes
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "RESET=[0m"

:: Get the Python version
for /f "tokens=2 delims= " %%i in ('python --version 2^>^&1') do set python_version=%%i

:: Check if Python version was found
if "%python_version%"=="program" (
    echo %RED%Error: Python is not installed or not accessible as 'python'%RESET%
    exit /b 1
)

:: Extract major, minor, and patch version numbers
for /f "tokens=1,2,3 delims=." %%a in ("%python_version%") do (
    set major=%%a
    set minor=%%b
    set patch=%%c
)

:: Check if the Python version is within the desired range
if not "%major%"=="3" (
    echo %RED%Error: Python version %python_version% is not within the acceptable range '3.11.0 to 3.13.0'%RESET%
    exit /b 1
)
if %minor% lss 11 (
    echo %RED%Error: Python version %python_version% is not within the acceptable range '3.11.0 to 3.13.0'%RESET%
    exit /b 1
)
if %minor% geq 13 (
    echo %RED%Error: Python version %python_version% is not within the acceptable range '3.11.0 to 3.13.0'%RESET%
    exit /b 1
)

:: If we reach here, the version is valid
echo %GREEN%Python version %python_version% is within the acceptable range '3.11.0 to 3.13.0'%RESET%

if exist "virt" (
    echo %YELLOW%Python Virtual Environment folder exist.%RESET%
    call %cd%\virt\Scripts\activate.bat
    echo %YELLOW%Python Virtual Environment activated.%RESET%
) else (
    echo %YELLOW%Python Virtual Environment folder does not exist.%RESET%
    echo %YELLOW%Creating a Python Virtual Environment.%RESET%
    python -m venv virt
    echo %YELLOW%Python Virtual Environment created.%RESET%
    call %cd%\virt\Scripts\activate.bat
    echo %YELLOW%Python Virtual Environment activated.%RESET%
)

:: Install Python dependencies
pip install --use-pep517 -r requirements_linux.txt

call %cd%\virt\Scripts\deactivate.bat
echo %YELLOW%Python Virtual Environment deactivated.%RESET%

:: end of file
