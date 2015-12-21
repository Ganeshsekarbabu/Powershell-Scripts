#Author - Ganesh
#Site - https://techbrainblog.com/
#Purpose - To search and read the content from the log file
#Reference - http://techbrainblog.com/2015/12/11/powershell-script-to-audit-the-vmware-vcenteresxi-windows-logs/
#Using the context - n we can read n lines before and after
#if lines requried only after the search items use -context 0, n ( n - number of lines )


 
 Get-ChildItem -Recurse -Include *.log | Select-String -Pattern (Read-Host "Enter the search item in the log")  -SimpleMatch -list  -Context 1