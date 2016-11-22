Push-Location
Set-Location HKLM:
New-Item -Path .\System\CurrentControlSet\BackupRestore -Name FileNotToBackup
New-Item -Path .\System\CurrentControlSet\BackupRestore -Name FilesNotToSnapshot
New-Item -Path .\System\CurrentControlSet\BackupRestore -Name KeysNotToRestore
$url = "https://dal05.objectstorage.softlayer.net/v1/AUTH_e5e0820d-faeb-480a-9901-be2a60bb149c/ashaw/setup.exe?temp_url_sig=19266ca6950a00d08a80e540690d9cadc1bce4f1&temp_url_expires=2079486989"
$outfile = "c:\setup.exe"
Invoke-WebRequest $url -outfile $outfile
start-Process -Wait -FilePath $outfile -ArgumentList '/s'
Restart-Computer
