#Author : Ganesh Sekarbabu
#Site - https://techbrainblog.com/
#Purpose: To vaildate the ESX as per the security hardeneing 
# Pls make sure to use the Powercli latest version which have option -V2


# PLS PUT THE INPUT AS PER THE ENVIRONEMNT
# Enter the vCenter Name
$vCenter= 'VC Name'

# Enter the username and password to connect the vCenter
Connect-VIServer -Server $vcenter -user username -Password password

# Enter the Cluster name to vaildate the ESX
$cluster = "Clustername1", "Clustername2"

ForEach ($clu in $cluster )
{
$hostsincluster = Get-Cluster $clu | Get-VMHost -State "Connected"
# Time Server service Status and the server names and make sure dont mention comma while pointing more than one Time server

$orignial = 'ntp.timeserver1.com ntp.timeserver2.com'

# Mention the DNS and make sure it is seperated with commas 
$original3 = '10.10.10.10' , '10.10.10.11'

# PLS DONT CHANGE ANYTHING BELOW. 

# Null Value to compare the results
$null

# Default Values and Scratchlog location

$orignial1 = '[] /scratch/log'
$orignial2 = '900'
$status = 'True'

# Below is to compare the results
$correct = 'True'
$result = '1 1 1 1 1 1 1'
# for loop to check each hosts
ForEach ($vmhost in $hostsincluster)

{
# To get the Time Server
$output = Get-VMHostNtpServer -VMHost $vmhost 
# To get the Time Server Services
$service = (Get-VmHostService -VMHost $vmhost |Where-Object {$_.key-eq “ntpd“}).Running
# To get the AD Authentication 
$output1 = Get-VMHost $vmhost| Get-VMHostAuthentication | Select -ExpandProperty DomainMembershipStatus
# To get the scratch log partition 
$out = $vmhost | Get-AdvancedSetting -Name Syslog.global.logdir | Select -ExpandProperty Value 
# To get the SSH Iedal and Shell Timeout
$out1 = $vmhost | Get-AdvancedSetting UserVars.ESXiShellInteractiveTimeOut | Select -ExpandProperty value
$out2 = $vmhost |  Get-AdvancedSetting UserVars.ESXiShellTimeOut | Select -ExpandProperty value
# To get the DNS Address
$out3 = Get-VMHostNetwork -VMHost $vmhost | Select -ExpandProperty  DnsAddress 
# Below will compare the ESX host DNS IPs with the orignal DNS
$new = Compare-Object $original3 $out3
# To get the DNS firewall settings and make sure to use the Powersli later version which have option -V2 
$esxcli = get-esxcli –vmhost (Get-VMHost $vmhost | Select -First 1 ) -V2
#$out4 = $esxcli.ruleset.allowedip.list() | where {$_.Ruleset -eq "dns"} | select -ExpandProperty AllowedIPAddresses
$out4 = $esxcli.network.firewall.ruleset.allowedip.list.Invoke() | where {$_.Ruleset -eq "dns"} | select -ExpandProperty AllowedIPAddresses
# It will compare the DNS settings in firewall with orginal
$new1 = Compare-Object $original3 $out4


# Below will check the condtion and store the result in the variable
If ($orignial -ne $output -or  $status -ne $service) { $report = ' Check the Time Server Settings and its service status' } else { $report = '1' }
If ($null -eq $output1 ) {   $report1 = ' Host is not in AD Auth  ' } else { $report1 = '1' }   

If ($orignial1 -eq $out ) {   $report2 = ' Wrong persistent-logs path ' } else { $report2 = '1' }   

If ($orignial2 -ne $out1 ) {   $report3 = ' Wrong Timeout for ESX Ideal Session  ' } else { $report3 = '1' }  

If($orignial2 -ne $out2 ) {   $report4 = ' Wrong Timeout for ESX SSH Session ' } else { $report4 = '1' }  

If($new -ne $null ) {   $report5 = ' Wrong DNS for ESX  ' } else { $report5 = '1' }  

If ($new1 -ne $null ) {   $report6 = '  Wrong DNSclient settings in Host Firewall  ' } else { $report6 = '1' }  

# Below will check the results is True or False 

$final = $result -contains @("$report","$report1","$report2","$report3","$report4","$report5","$report6")

# If the result is True then it will show the Hosts as Fully Protected or else it will show the wrong parameter to be changed
# Results which is showing as 1 is good and if all the condition is 1 then it will be considered as true and host is fully protected

if ( $final -eq $correct ) { Write-Host "ESXHOST $vmhost is fully protected" -ForegroundColor Green } else { "Pls check the $vmhost $report , $report1 , $report2 , $report3 , $report4 , $report5 , $report6"  }

}

}
