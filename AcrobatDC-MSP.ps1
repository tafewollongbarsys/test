<#
    Download and run patch for Adobe Acrobat Reader DC
    Last updated: 2020-07-02
#>

# Introduction
Write-Host "Download Adobe Acrobat Reader DC: Update Patch for deployment"
Write-Host "=============================" ; ""

# Ask for admin credentials
Write-Host "Input administrator credentials" ; ""
#$cred = Get-Credential

# Inform re: version number format
Write-Host "Input version number" ; "Format: ##########" ; "e.g. 1234567890" ; ""

# Create filename from user input
$Version = Read-Host -Prompt 'Version'
$Prefix = 'AcroRdrDCUpd'
#$Suffix = ''
$Ext = '.msp'

$Filename = $Prefix + $Version + $Suffix + $Ext

Write-Host $Filename ; ""

# Create download and target variables
## Download source
$DLFileName = $Filename
$DLUri = -join('ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/',$Version)
$Source = "$DLUri/$DLFilename"
Write-Host "Downloading $Source" ; ""
## Repository/Target
$Repository = '\\rnas\appstore\AdobeAcrobatReaderDC'
$Destination ="$Repository\$Filename"
Write-Host "Saving $Filename to $Repository" ; ""

# Download to the repository
## NB: Headers obtained via Chrome Developer Mode
Invoke-WebRequest -Uri "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/2000920067/AcroRdrDCUpd2000920067.msp" -Headers @{
    "Upgrade-Insecure-Requests"="1"
    } -OutFile $Destination

# Run installer
## Set parameters
$Parms = "/qn /NORESTART /ALLUSERS "
$Prms = $Parms.Split(" ")
## Warning
Write-Host "Installing $Filename with the following parameters:" ; "$Prms" ; ""
## Run
msiexec /i "$Destination" $Prms

# Delete scheduled update tasks

Write-Host ""

# End
Pause
