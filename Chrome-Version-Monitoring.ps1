$file="C:\TEMP\chrome-version"
$lastrev=Get-Content $file
$currev=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo | Select -ExpandProperty ProductVersion

function sendalert {
$webhookurl="WEBHOOK-URL HERE"

[String]$var = "Text which appears in the message content"
$JSONBody = [PSCustomObject][Ordered]@{
"@type" = "MessageCard"
"@context" = "<http://schema.org/extensions>"
"summary" = "Chrome Update Warning!"
"themeColor" = 'FFA500'
"title" = "In D3O-PDCH02 Chrome Drive update required!"
"text" = "<strong>THIS IS ONE TIME WARNING. Please update chrome driver accordingly in MACHINE_NAME.</strong><br> Previous Chrome Version:<pre>$lastrev</pre><br>Current Chrome Version:<pre>$currev</pre><br>Chrome Driver Location:<pre>DRIVER_LOCATION_HERE</pre>Download Chrome Driver from:<pre>https://chromedriver.storage.googleapis.com/index.html</pre>"
}

$TeamMessageBody = ConvertTo-Json $JSONBody

$parameters = @{
"Uri" = $webhookurl
"Method" = 'POST'
"Body" = $TeamMessageBody
"ContentType" = 'application/json'
}

Invoke-RestMethod @parameters
#################################################
}

#Compairing the revisions before overwriting.
if ( $lastrev -eq $currev)
{
    Write-Output "Last & Current revision are same."
    Write-Output "Last Revision: $lastrev"
    Write-Output "Current Revision: $currev"
}
else {
    Write-Warning "Last & Current chrome version are different"
    Write-Output "Last Revision: $lastrev"
    Write-Output "Current Revision: $currev"
	  #Fixed: Ref: https://stackoverflow.com/questions/66050990/the-underlying-connection-was-closed-an-unexpected-error-occurred-on-a-receive
	  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    sendalert
}

#Over write the file with latest revision
$currev > $file
