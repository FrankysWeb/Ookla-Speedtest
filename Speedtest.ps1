param (
 [Parameter(Position=0, Mandatory=$True, HelpMessage="Please set Output format: CSV, JSON, PRTG, INFLUXDB, TXT")]
  [string]$Output = "TXT",
 [Parameter(Position=1, Mandatory=$False, HelpMessage="Specify InfluxDB Server Connection String")]
  [string]$InfluxDBHost = "http://localhost:8086",
 [Parameter(Position=2, Mandatory=$False, HelpMessage="Specify Influx DB Name")]
  [string]$InfluxDBName = "InfluxDB",
 [Parameter(Position=3, Mandatory=$False, HelpMessage="Specify InfluxDB Credentials")]
  [pscredential]$InfluxDBCredential,
 [Parameter(Position=4, Mandatory=$False, HelpMessage="Specify CSV File Path")]
  [string]$CSVFile
)

if (Test-Path .\speedtest.exe) {
 try {
  $Results = .\speedtest.exe -f json | ConvertFrom-Json
  
  $DownBandwidth = $results.download.bandwidth
  $DownBytes = $results.download.bytes
  $DownElapsed = $results.download.elapsed
 
  $UpBandwidth = $results.upload.bandwidth
  $UpBytes = $results.upload.bytes
  $UpElapsed = $results.upload.elapsed
 
  $ISP = $results.isp
  $ExternalIP = $results.interface.externalip
  $InternalIP = $results.interface.internalIp

  $Latency = $results.ping.latency
 }
 catch {
 }
}
else {
 write-host "
  speedtest.exe not found!
  Download it here: https://www.speedtest.net/apps/cli
  "
}

#CSV Output
if ($Results -and $Output -eq "CSV") {
 if (test-path $CSVFile) {
 "$DownBandwidth;$UpBandwidth;$DownBytes;$UpBytes;$DownElapsed;$UpElapsed" | add-content $CSVFile
 }
 else {
  "DownloadBandwidth;UploadBandwidth;DownloadBytes;UploadBytes;DownloadElapsed;UploadElapsed" | set-content $CSVFile
  "$DownBandwidth;$UpBandwidth;$DownBytes;$UpBytes;$DownElapsed;$UpElapsed" | add-content $CSVFile
 }
}

#JSON Output
if ($Results -and $Output -eq "JSON") {
 return $Results
}

if ($Results -and $Output -eq "PRTG") {
	"<prtg>"
	
	"<result>"
	"<channel>DownloadBandwidth</channel>"
	"<value>$DownBandwidth</value>"
	"</result>"
	
	"<result>"
	"<channel>UploadBandwidth</channel>"
	"<value>$UpBandwidth</value>"
	"</result>"
	
	"<result>"
	"<channel>DownloadBytes</channel>"
	"<value>$DownBytes</value>"
	"</result>"
	
	"<result>"
	"<channel>UploadBytes</channel>"
	"<value>$UpBytes</value>"
	"</result>"
	
	"<result>"
	"<channel>DownloadElapsed</channel>"
	"<value>$DownElapsed</value>"
	"</result>"
	
	"<result>"
	"<channel>UploadElapsed</channel>"
	"<value>$UpElapsed</value>"
	"</result>"
	
	"</prtg>"
}

#Influx Output
if ($Results -and $Output -eq "INFLUXDB") {
 $Metrics = @{DownloadBandwidth=$DownBandwidth;UploadBandwidth=$UpBandwidth;DownloadBytes=$DownBytes;UploadBytes=$UpBytes;DownloadElapsed=$DownElapsed;UploadElapsed=$UpElapsed}
 Write-Influx -Measure Speedtest -Tags @{SourceIP=$ExternalIP} -Metrics $Metrics -Database $InfluxDBName -Server $InfluxDBHost -Credential $InfluxDBCredential
}

#TXT Output
if ($Results -and $Output -eq "TXT") {
 write-host "
  Download Bandwidth: $DownBandwidth
  Upload Bandwidth: $UpBandwidth
  Download Bytes: $DownBytes
  Upload Bytes: $UpBytes
  Download Elapsed: $DownElapsed
  Upload Elapsed: $UpElapsed
 "
}

#No Results found
if (!$Results) {
 write-error "No Results found"
}