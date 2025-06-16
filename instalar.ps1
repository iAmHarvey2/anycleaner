¿Cómo hago que este script se ejecute al inicio? # Ruta base
$basePath = "$env:APPDATA\AnyDesk"

# Carpetas a limpiar
$folders = @("chat", "msg_thumbnails", "thumbnails")

foreach ($folder in $folders) {
    $fullPath = Join-Path $basePath $folder
    if (Test-Path $fullPath) {
        Remove-Item "$fullPath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "Contenido de '$folder' eliminado."
    } else {
        Write-Output "La carpeta '$folder' no existe."
    }
}

# Borrar archivo ad.trace
$traceFile = Join-Path $basePath "ad.trace"
if (Test-Path $traceFile) {
    Remove-Item $traceFile -Force
    Write-Output "Archivo 'ad.trace' eliminado."
} else {
    Write-Output "Archivo 'ad.trace' no encontrado."
}

# Renombrar service.conf a service.conf.old
$confFile = Join-Path $basePath "service.conf"
$oldConfFile = Join-Path $basePath "service.conf.old"

if (Test-Path $confFile) {
    Move-Item -Path $confFile -Destination $oldConfFile -Force
    Write-Output "'service.conf' renombrado a 'service.conf.old'."
} else {
    Write-Output "'service.conf' no encontrado."
}

# Vaciar el contenido de connection_trace.txt
$logFile = Join-Path $basePath "connection_trace.txt"
if (Test-Path $logFile) {
    Set-Content -Path $logFile -Value ""
    Write-Output "Contenido de 'connection_trace.txt' vaciado."
} else {
    Write-Output "'connection_trace.txt' no encontrado."
}
