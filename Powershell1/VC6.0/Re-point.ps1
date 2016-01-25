# Author : Ganesh Sekarbabu
# Site - https://techbrainblog.com/
# Purpose: to re-point\fail-over the VC to another replication Platform Service Controller
# Download the Plink.exe from http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
# Make sure to change the default shell to Bash ( chsh -s "/bin/bash" root )
# Reference : http://techbrainblog.com/2016/01/24/powershell-script-to-find-which-platform-service-controller-psc-is-pointing-to-my-vcenter-appliance-vcsa-6-0

$Computer = Read-Host 'Enter the VC Appliance Name'
$User = 'root'
$Pswd = Read-Host 'Enter the password for the root user'
$plink = Read-host "Enter the path of the plink.exe "
$plinkoptions = " -v -batch -pw $Pswd"

$psc = Read-host 'Enter the Replication patrner PSC Name'

$cmd1 = "/bin/cmsso-util repoint  --repoint-psc $psc"

$remoteCommand = '"' + $cmd1 + '"'



$command = $plink + " " + $plinkoptions + " " + $User + "@" + $computer + " " + $remoteCommand

$msg = Invoke-Expression -command $command 
$msg