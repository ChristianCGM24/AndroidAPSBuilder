(get-host).ui.rawui.backgroundcolor = "black"
(get-host).ui.rawui.foregroundcolor = "green"
(get-host).ui.rawui.WindowTitle = "Install Android SDK"

$sdkFolder="$Env:USERPROFILE\AppData\Local\Android\Sdk"
$url = "https://dl.google.com/android/repository/sdk-tools-windows-3859397.zip"
$output = "$sdkFolder\AndroidSDK.zip"
$start_time = Get-Date

function Unzip {
    param([string]$zipfile, [string]$outpath)
	write-host "Unzipping $zipfile"
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

if (!(Test-Path $sdkFolder)) {
	new-item $sdkFolder -itemtype directory
}


if (!(Test-Path $sdkFolder\tools)) {
if (test-path .\preDownloadPackage) {
copy-item .\preDownloadPackage\AndroidSDK\* $sdkFolder -force -verbose -recurse

} else { 	

Import-Module BitsTransfer
	Start-BitsTransfer -Source $url -Destination $output
	Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	Unzip $output $sdkFolder
	If (Test-Path $output){			
		Remove-Item $output
	}
}

}

$AndroidToolPath = "$sdkFolder\tools\bin\sdkmanager.bat"
& $AndroidToolPath 'platform-tools' 'platforms;android-23' 'build-tools;27.0.2' 'extras;google;m2repository' 'extras;android;m2repository' 'extras;google;usb_driver' 'emulator' --verbose
Start-Process CMD -ArgumentList "/C setx -m ANDROID_HOME `"$sdkFolder`"" -Verb RunAs
