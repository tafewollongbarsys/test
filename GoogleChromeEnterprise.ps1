<#
    Download and run installer for TAFEITLAB: Dropbox
    Last updated: 2020-07-02
#>

# Introduction
Write-Host "Download DGoogle Chrome Enterprise for deployment"
Write-Host "=============================" ; ""

# Ask for admin credentials
Write-Host "Input administrator credentials" ; ""
#$cred = Get-Credential

# Inform re: version number format
Write-Host "Input version number" ; "Format: ##.#.####.###" ; "e.g. 12.3.4567.890" ; ""

# Create filename from user input
$Version = Read-Host -Prompt 'Version'
$Prefix = 'chrome.enterprise.'
#$Suffix = ''
$Ext = '.msi'

#$Filename = $Prefix + $Version + $Suffix + $Ext
$Filename = $Prefix + $Version + $Ext

Write-Host $Filename ; ""

# Create download and target variables
## Download source
$DLFileName =  googlechromestandaloneenterprise64.msi
$DLUri = 'https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BAA78905E-463A-0AC2-D94D-B4C8DFD55518%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/'
$Source = "$DLUri/$DLFilename"
Write-Host "Downloading $Source" ; ""
## Repository/Target
$Repository = '\\rnas\appstore\GoogleChromeEnterprise'
$Destination ="$Repository\$Filename"
Write-Host "Saving $Filename to $Repository" ; ""

# Check if file exists
$FileExists = Test-Path $Destination
If ($FileExists -eq $True) {
Write-Host "A file with the name $Filename already exists in the repository." ; "Please exit the script."
Pause
}


# Download to the repository
## NB: Headers obtained via Chrome Developer Mode
Invoke-WebRequest -Uri $Source -Headers @{
    "method"="GET"
      "authority"="dl.google.com"
      "scheme"="https"
      "path"="/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BAA78905E-463A-0AC2-D94D-B4C8DFD55518%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/googlechromestandaloneenterprise64.msi"
      "upgrade-insecure-requests"="1"
      "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"
      "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
      "x-omnibox-on-device-suggestions"="Enabled_V2"
      "x-client-data"="CJO2yQEIpLbJAQjEtskBCKmdygEImMfKAQjnyMoBGJu+ygEYhr/KAQ=="
      "sec-fetch-site"="cross-site"
      "sec-fetch-mode"="navigate"
      "sec-fetch-user"="?1"
      "sec-fetch-dest"="document"
      "referer"="https://chromeenterprise.google/browser/download/thank-you/?platform=WIN64_MSI&channel=stable&usagestats=0"
      "accept-encoding"="gzip, deflate, br"
      "accept-language"="en-US,en;q=0.9"
      "cookie"="HSID=ATlFij9uwkMgxyZgh; SSID=AMlXchJYvS89Ynxsj; APISID=IY6Sm1g7WCeNwyPc/AcyRuF0-YIDB6MzIT; SAPISID=cyyQV42CxBVisLxi/AwOJq8xQ_4RnJ6PUd; CONSENT=YES+AU.en+20171217-09-0; __Secure-3PAPISID=cyyQV42CxBVisLxi/AwOJq8xQ_4RnJ6PUd; __Secure-HSID=ATlFij9uwkMgxyZgh; __Secure-SSID=AMlXchJYvS89Ynxsj; __Secure-APISID=IY6Sm1g7WCeNwyPc/AcyRuF0-YIDB6MzIT; SID=yAcMQL8x_mmrttHrT03h4-mgNYMY29lqgpIT5wGWCDlU9Kv3zClBYyabqQj9EMvstA9O_A.; __Secure-3PSID=yAcMQL8x_mmrttHrT03h4-mgNYMY29lqgpIT5wGWCDlU9Kv3Cotk8jc5pjcSQxtyR8z-pQ.; 1P_JAR=2020-7-4-5; NID=204=qt59GKDpiueeSQqtoAE8qBMQ_hJUtOPPuoM5cc_QiGWEWqXtAPn9CeG68ZPYPKqarsvRqn3tpqEyzcuIU3uqZ0MMWOQfqcF741NjhYvGRYQEZU-HDPy0Zljt1roP-_mgs8QRXZWDIVtPboJZgQX9in3jUOFG8kiAsF0BKDuVvW3jK116HU9Pg1zNFUL0BM-9XHBRagVSJ4FKDo2TqPg4JgSNwKh7ThfnAinLI6kCYIADEJfHokVrfVXkmQ; SIDCC=AJi4QfEQRE9WSkEzqKLerlKNCNIUTKozkoE2wwaalgZg7JSrlQ1GeJnwHSNk-8TQx65MngJebg"
    }

# Stop running tasks that may interfere with installation
## Task array
$TaskArray = @('chrome','GoogleCrashHandler','GoogleCrashHandler64','GoogleUpdate')
## Kill the runnning tasks
foreach ($RunningTask in $TaskArray)
{
    Stop-Process -Name $RunningTask -Force
}

# Run installer
## Set parameters
$Parms = "ALLUSERS=1 /q /norestart"
$Prms = $Parms.Split(" ")
## Warning
Write-Host "Installing $Filename with the following parameters:" ; "$Prms" ; ""
## Run
#& "$Destination" $Prms

# Delete scheduled update tasks
Write-Host "Deleting scheduled update tasks" ; ""
## DropboxUpdateTaskMachineCore
if ($(Get-ScheduledTask -TaskName "GoogleUpdateTaskMachineCor" -ErrorAction SilentlyContinue).TaskName -eq "GoogleUpdateTaskMachineCore") {
    Unregister-ScheduledTask -TaskName "GoogleUpdateTaskMachineCor" -Confirm:$False
}
## DropboxUpdateTaskMachineUA
if ($(Get-ScheduledTask -TaskName "GoogleUpdateTaskMachineUA" -ErrorAction SilentlyContinue).TaskName -eq "GoogleUpdateTaskMachineUA") {
    Unregister-ScheduledTask -TaskName "GoogleUpdateTaskMachineUA" -Confirm:$False
}
Write-Host ""

# Delete update executables and folders
Write-Host "Deleting unneeded Google Update folders and files" ; ""
$FolderArray = @('C:\Program Files (x86)\Google\Update','C:\Program Files\Google\Update','C:\Windows\System32\Tasks\GoogleUpdate*','C:\Windows\System32\Tasks_Migrated\GoogleUpdate*')
foreach ($FolderToDelete in $FolderArray)
{
  Get-ChildItem -Path "$FolderToDelete" -Recurse | Remove-Item -force -recurse
}

# End
Pause
