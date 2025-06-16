# ----------------------------------------
# Instalador de AnyCleaner Service (PowerShell)
# ----------------------------------------

Write-Host "`n🧹 Instalador de AnyCleaner iniciado..." -ForegroundColor Cyan

# 1. Verificar si Python está instalado
$python = Get-Command python -ErrorAction SilentlyContinue

if (-not $python) {
    Write-Host "🐍 Python no está instalado. Descargando instalador..." -ForegroundColor Yellow

    $installer = "$env:TEMP\python-installer.exe"
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe" -OutFile $installer

    Write-Host "⚙️ Instalando Python..."
    Start-Process -Wait -FilePath $installer -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_pip=1"
    Remove-Item $installer

    # Actualizar variable de entorno temporalmente
    $env:Path += ";C:\Program Files\Python312\;C:\Program Files\Python312\Scripts\"

    Write-Host "✅ Python instalado correctamente." -ForegroundColor Green
} else {
    Write-Host "✔ Python ya está instalado."
}

# 2. Verificar e instalar pywin32
if (-not (pip show pywin32)) {
    Write-Host "🔧 Instalando pywin32..."
    pip install pywin32
} else {
    Write-Host "✔ pywin32 ya está instalado."
}

# 3. Descargar el script desde GitHub
$scriptURL = "https://raw.githubusercontent.com/iAmHarvey2/anycleaner/main/anycleaner_service.py"
$scriptPath = "$env:TEMP\anycleaner_service.py"

Invoke-WebRequest -Uri $scriptURL -OutFile $scriptPath -UseBasicParsing
Write-Host "📄 Script descargado en $scriptPath"

# 4. Instalar e iniciar el servicio
Write-Host "🛠 Instalando el servicio..."
python $scriptPath install

Write-Host "🚀 Iniciando el servicio..."
python $scriptPath start

Write-Host "`n✅ Instalación completada. El servicio 'AnyCleanerService' ya está ejecutándose. Créditos Juan Ortiz" -ForegroundColor Green
