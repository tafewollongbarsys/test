<#
    Download and run installer for TAFEITLAB: Dropbox
    Last updated: 2020-07-02
#>

# Introduction
Write-Host "Download Dropbox for deployment"
Write-Host "=============================" ; ""

# Ask for admin credentials
Write-Host "Input administrator credentials" ; ""
#$cred = Get-Credential

# Inform re: version number format
Write-Host "Input version number" ; "Format: ###.#.###" ; "e.g. 100.2.340" ; ""

# Create filename from user input
$Version = Read-Host -Prompt 'Version'
$Prefix = 'Dropbox.'
#$Suffix = ''
$Ext = '.exe'

$Filename = $Prefix + $Version + $Suffix + $Ext

Write-Host $Filename ; ""

# Create download and target variables
## Download source
$DLFileName =  -join('Dropbox%20',$Version,'%20Offline%20Installer.exe')
$DLUri = 'https://clientupdates.dropboxstatic.com/dbx-releng/client'
$Source = "$DLUri/$DLFilename"
Write-Host "Downloading $Source" ; ""
## Repository/Target
$Repository = '\\rnas\appstore\Dropbox'
$Destination ="$Repository\$Filename"
Write-Host "Saving $Filename to $Repository" ; ""

# Download to the repository
## NB: Headers obtained via Chrome Developer Mode
Invoke-WebRequest -Uri $Source -Headers @{
    "Upgrade-Insecure-Requests"="1"
      "DNT"="1"
      "User-Agent"="Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1"
      "Accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
      "Sec-Fetch-Site"="cross-site"
      "Sec-Fetch-Mode"="navigate"
      "Sec-Fetch-User"="?1"
      "Sec-Fetch-Dest"="document"
      "Referer"="https://www.dropbox.com/"
      "Accept-Encoding"="gzip, deflate, br"
      "Accept-Language"="en-AU,en-GB;q=0.9,en-US;q=0.8,en;q=0.7"
      "Cookie"="__cfduid=dcc16e62c6038561d6c80559c2323c0261593694596"
    } -OutFile $Destination

# Run installer
## Set parameters
$Parms = "/S"
$Prms = $Parms.Split(" ")
## Warning
Write-Host "Installing $Filename with the following parameters:" ; "$Prms" ; ""
## Run
#& "$Destination" $Prms

# Delete scheduled update tasks
Write-Host "Deleting scheduled update tasks" ; ""
## DropboxUpdateTaskMachineCore
if ($(Get-ScheduledTask -TaskName "DropboxUpdateTaskMachineCore" -ErrorAction SilentlyContinue).TaskName -eq "DropboxUpdateTaskMachineCore") {
    Unregister-ScheduledTask -TaskName "DropboxUpdateTaskMachineCore" -Confirm:$False
}
## DropboxUpdateTaskMachineUA
if ($(Get-ScheduledTask -TaskName "DropboxUpdateTaskMachineUA" -ErrorAction SilentlyContinue).TaskName -eq "DropboxUpdateTaskMachineUA") {
    Unregister-ScheduledTask -TaskName "DropboxUpdateTaskMachineUA" -Confirm:$False
}
Write-Host ""

# End
Pause
