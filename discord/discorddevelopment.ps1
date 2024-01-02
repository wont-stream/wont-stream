$url = "https://discord.com/api/downloads/distributions/app/installers/latest?channel=development&platform=win&arch=x64"
$outputPath = "$env:TEMP\DiscordInstaller.exe"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Run the downloaded file
Start-Process -FilePath $outputPath -Wait
