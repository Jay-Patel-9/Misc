$loop_count=5 #UPDATE ME
$sleep_interval=1 #seconds #UPDATE ME
$global:folder="C:\somefolder\capture"  #UPDATE ME
$ErrorActionPreference = 'silentlycontinue'

if ( -not (Test-Path "$folder") ) {  
    mkdir $folder > $null
}

#Screenshot code
[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null
function screenshot([Drawing.Rectangle]$bounds, $path) {
    $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height 2> $null
    $graphics = [Drawing.Graphics]::FromImage($bmp) 2> $null
    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size) 2> $null
    $bmp.Save($path)
    $graphics.Dispose()
    $bmp.Dispose()
}
####

for ($loop_count -eq 0; $loop_count--){
    #declate variables
    $gdate=$(Get-Date -Format 'ddMMyyyy-HHmmss')
    $filename="$folder\$gdate.png"
    $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1920, 1280) #UPDATE ME screen resolution if required. 
    screenshot $bounds "$filename"
    Start-Sleep $sleep_interval
}