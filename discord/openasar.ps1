# Function to stop Discord processes
function Stop-DiscordProcess {
    param([string]$version)
    $processName = "DiscordDevelopment"
    $path = "$Env:LOCALAPPDATA\DiscordDevelopment\app-$version\resources\"

    Stop-Process -Name $processName -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 5

    # Backup app.asar
    $backupPath = Join-Path -Path $path -ChildPath "app.asar.backup"
    $asarFiles = @("_app.asar", "app.asar.orig")

    foreach ($file in $asarFiles) {
        $filePath = Join-Path -Path $path -ChildPath "$file"
        if (Test-Path $filePath) {
            Copy-Item -Path $filePath -Destination $backupPath -Force -ErrorAction SilentlyContinue
        }
    }
}

# Function to install OpenAsar
function Install-OpenAsar {
    param([string]$version)
    $path = "$Env:LOCALAPPDATA\DiscordDevelopment\app-$version\resources\"

    # Backup existing app.asar files
    Stop-DiscordProcess -version $version

    # Download and install OpenAsar
    $openAsarUrl = "https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar"
    Invoke-WebRequest -Uri $openAsarUrl -OutFile (Join-Path -Path $path -ChildPath "app.asar") > $null 2>&1

    # Restart Discord
    Start-Process -FilePath "$Env:LOCALAPPDATA\DiscordDevelopment\Update.exe" -ArgumentList "--processStart DiscordDevelopment.exe" -WindowStyle Hidden > $null 2>&1
}

# Main script

# Close Discord and backup app.asar files
Stop-DiscordProcess -version "1.0.152"

# Install OpenAsar for the specified version
Install-OpenAsar -version "1.0.152"

# Check for additional versions and install OpenAsar
foreach ($version in ("1.0.151", "1.0.150", "1.0.149", "1.0.152")) {
    Install-OpenAsar -version $version
}

# Display installation completion message
Write-Host ""
Write-Host ""
Write-Host "OpenAsar should be installed! You can check by looking for an 'OpenAsar' option in your Discord settings."
Write-Host "Not installed? Try restarting Discord, running the script again, or if still not join our Discord server."
Write-Host ""
Write-Host "openasar.dev"

Write-Host ""
Pause
