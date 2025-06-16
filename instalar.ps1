# Ruta temporal para el script Python
$tempPath = "$env:TEMP\anycleaner_service.py"

# URL del script en GitHub RAW
$scriptURL = "https://raw.githubusercontent.com/iAmHarvey2/anycleaner/main/anycleaner_service.py"

# Descargar el script
Invoke-WebRequest -Uri $scriptURL -OutFile $tempPath -UseBasicParsing
Write-Output "Script descargado en $tempPath"

# Verificar instalación de pywin32
if (-not (pip show pywin32)) {
    Write-Output "Instalando pywin32..."
    pip install pywin32
}

# Instalar y arrancar el servicio
Write-Output "Instalando servicio..."
python $tempPath install

Write-Output "Iniciando servicio..."
python $tempPath start

Write-Output "Servicio instalado y ejecutándose. Creditos Juan Ortiz"
