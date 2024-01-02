@echo off
echo Closing Discord... (wait around 5 seconds)

for /L %%i in (1,1,3) do (
    C:\Windows\System32\TASKKILL.exe /f /im DiscordDevelopment.exe > nul 2> nul
)

C:\Windows\System32\TIMEOUT.exe /t 5 /nobreak > nul 2> nul

echo Installing OpenAsar... (ignore any blue output flashes)
for /D %%v in ("%localappdata%\DiscordDevelopment\app-1.0.*") do (
    for %%a in ("%%v\resources\app.asar" "%%v\resources\_app.asar" "%%v\resources\app.asar.orig") do (
        if exist "%%a" (
            copy /y "%%a" "%%v\resources\app.asar.backup" > nul 2> nul
        )
    )
    powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordDevelopment\%%v\resources\app.asar\"" > nul 2> nul
)

echo Opening Discord...
start "" "%localappdata%\DiscordDevelopment\Update.exe" --processStart DiscordDevelopment.exe > nul 2> nul

C:\Windows\System32\TIMEOUT.exe /t 1 /nobreak > nul 2> nul

echo.
echo.
echo OpenAsar should be installed! You can check by looking for an "OpenAsar" option in your Discord settings.
echo Not installed? Try restarting Discord, running the script again, or if still not join our Discord server.
echo.
echo openasar.dev

echo.
pause
