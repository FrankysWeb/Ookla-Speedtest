# Ookla Speedtest with PowerShell
 Dieses PowerShell Script nutzt den Ookla Speedtest um die Ergebnisse zu InfluxDB zu exportieren.
 Alternativ lassen sich die Ergenisse auch als JSON, CSV, TXT exportieren oder als PRTG Sensor nutzen.
 
## Voraussetzungen
 Die Ookla Speedtest CLI wird benötigt: [Ookla SpeedTest CLI](https://www.speedtest.net/apps/cli)
 Für den Export in eine InfluxDB wird das PowerShell Influx Modul benötigt: [markwragg/PowerShell-Influx](https://github.com/markwragg/PowerShell-Influx)
 
## Beispiele
Export zu InfluxDB
```powershell
.\Speedtest.ps1 -Output INFLUXDB -InfluxDBHost "http://localhost:8086" -InfluxDBName "demo" -InfluxDBCredential (Get-Credential)
```
Als PRTG Sensor:
```powershell
.\Speedtest.ps1 -Output PRTG
```

Weitere Beispiele auf dem Blog: [Ookla Speedtest.net und PowerShell](https://www.frankysweb.de/ookla-speedtest-net-und-powershell/)
 
## Website
 [FrankysWeb](https://www.frankysweb.de/)