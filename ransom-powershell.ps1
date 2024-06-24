# Check for administrative privileges
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "This script must be run as an administrator."
    Start-Process powershell.exe "-File $PSCommandPath" -Verb RunAs
    Exit
}

# Function to install Chocolatey if not already installed
function Install-Chocolatey {
    if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

# Function to install a package if not already installed
function Install-PackageIfNotInstalled {
    param (
        [string]$PackageName
    )
    if (-Not (Get-Command $PackageName -ErrorAction SilentlyContinue)) {
        choco install $PackageName -y
    }
}

# Install Chocolatey
Install-Chocolatey

# Install required packages
Install-PackageIfNotInstalled -PackageName "git"
Install-PackageIfNotInstalled -PackageName "python"

# Clone the GitHub repository
if (-Not (Test-Path "anti-ransomware-test")) {
    git clone https://github.com/Sbussiso/anti-ransomware-test.git
}
Set-Location anti-ransomware-test

# Create and activate a virtual environment
python -m venv venv
venv\Scripts\Activate

# Install required Python packages
pip install --upgrade pip setuptools wheel
pip install cryptography
pip install psutil

# Ensure the main.py script is executable
# (On Windows, we typically don't need to set execute permissions)

# Run the main.py script
python main.py
