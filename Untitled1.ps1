
$url = "http://169.57.28.203/symantec/setup.exe"
$outfile = "c:\setup.exe"
Invoke-WebRequest $url -outfile $outfile
start-Process -Wait -FilePath $outfile -ArgumentList '/S /v/qn'
Restart-Computer

