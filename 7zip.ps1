<#
    Download and run installer for TAFEITLAB: 7zip
    Last updated: 2020-07-02
#>

# Introduction
Write-Host "Download 7-zip for deployment"
Write-Host "============================="

# Ask for admin credentials
Write-Host "Input administrator credentials"
$cred = Get-Credential

# Inform re: version number format
Write-Host "Input version number"
Write-Host "Format: ####"
Write-Host "e.g. 1900 for version 19.0.0"

# Create filename from user input
$Version = Read-Host -Prompt 'Version:'
$Prefix = '7z'
$Suffix = '-x64'
$Ext = '.msi'

$Filename = $Prefix + $Version + $Suffix + $Ext

Write-Host $Filename

# Create download and target variables
## Download source
$DLUri = 'https://www.7-zip.org/a'
$Source = "$DLUri/$Filename"
Write-Host "Downloading $Source"
## Repository/Target
$Repository = '\\rnas\appstore\7zip'
$Destination ="$Repository\$Filename"
Write-Host "Saving $Filename to $Repository"

# Download to the repository
Invoke-WebRequest -Uri $Source -OutFile $Destination

# Run installer
## Set parameters
$Parms = "ALLUSERS=1 /q /norestart INSTALLDIR="C:\Program Files\7-Zip""
$Prms = $Parms.Split(" ")
## Run
& "$Destination" $Prms

# Create file associations
## Call batch file (Replace with PS native commands when possible)
cmd.exe /k ""$Repository\7zipAssoc.bat" & powershell"

# End
Pause
