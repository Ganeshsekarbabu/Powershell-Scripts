#Author - Ganesh
#Site - https://techbrainblog.com/
#Purpose - To search and read the content from the logs in the ZIP folder
#Reference - http://techbrainblog.com/2015/12/11/powershell-script-to-audit-the-vmware-vcenteresxi-windows-logs/
#Using the context - n we can read n lines before and after
#if lines requried only after the search items use -context 0, n ( n - number of lines )


 $BackUpPath = read-host " Enter the path of the zip with name ( c:\tmp\test.zip) "
 $Destination = read-host " Enter the path to unzip ( c:\tmp) "

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination) 

 # -list - it will search the content and it will stop if it finds it and it wont search the entire file
 
Get-ChildItem $Destination -Recurse -Include *.log | Select-String -Pattern (Read-Host " Enter the search item in the log ")  -SimpleMatch -Context 1