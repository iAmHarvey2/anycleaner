# install.ps1 - Instala AnyCleaner para que se ejecute al iniciar Windows

$destPath = "$env:APPDATA\AnyDeskCleaner"
$exeName = "anycleaner.exe"
$exeUrl = "https://github.com/iAmHarvey2/anycleaner/raw/main/dist/anycleaner.exe"
$exeFullPath = Join-Path $destPath $exeName

# Crear la carpeta de destino si no existe
if (-not (Test-Path $destPath)) {
    New-Item -ItemType Directory -Path $destPath -Force | Out-Null
}

# Descargar el ejecutable
Write-Host "Descargando $exeName desde GitHub..."
Invoke-WebRequest -Uri $exeUrl -OutFile $exeFullPath -UseBasicParsing

# Crear acceso directo en la carpeta de inicio del usuario
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcutPath = Join-Path $startupFolder "AnyCleaner.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $exeFullPath
$shortcut.WorkingDirectory = $destPath
$shortcut.WindowStyle = 7  # Minimizado
$shortcut.Save()

Write-Host "✅ Instalación completada. AnyCleaner se ejecutará automáticamente al iniciar sesión."

