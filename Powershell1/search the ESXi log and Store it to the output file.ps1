#Author : Ganesh Sekarbabu
#Site - https://techbrainblog.com/
#Purpose: To search the ESXi log for the Specific word
#Reference - http://techbrainblog.com/2015/12/11/powershell-script-to-audit-the-vmware-vcenteresxi-windows-logs/
# ESXi has three type of logs 'hostd' 'vnkernal' 'vpxa' 
# By selecting the options we can point to the logs and search them using the key word
# Output of the search will be stored in the given path and also it will append the result.



$Hostname = read-host " Enter the ESX HOST NAME"
$Username = read-host " Enter the username "
$Password = read-host " Enter the password"
$outfile = read-host " Enter the out-put file path  "

Connect-VIServer -server $Hostname -user $Username -password $Password

do
{
cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' for the Hostd log."
     Write-Host "2: Press '2' for this VMKernal Log."
     Write-Host "3: Press '3' for this VPXA Log."
     Write-Host "Q: Press 'Q' to quit."
    
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                 cls
                 $logs = $vmhost | Get-Log -Key 'hostd'
                 $result = $logs.Entries | Select-String -Pattern (read-host "Etner the key word") 
                 $result | out-file $outfile -append
                 
                }'2' {
                cls

                $logs = $vmhost | Get-Log -Key 'vmkernel'
                $result1 = $logs.Entries | Select-String -Pattern (read-host "Etner the key word") 
                $result1 | out-file $outfile -append

                } '3' {
                cls

                 $logs = $vmhost | Get-Log -Key 'vpxa'
                 $result2 = $logs.Entries | Select-String -Pattern (read-host "Etner the key word") 
                 $result2 | out-file $outfile -append
                 } 
                 'q' {
               
               Write-Host "End of the Search "
          }
     }
    
}
until ($input -eq 'q')