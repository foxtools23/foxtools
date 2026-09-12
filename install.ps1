$ErrorActionPreference = "Stop"

function Write-Banner {
    $banner = @"
    ______           _______          __      
   / ____/___  _  __/_  __(_)  ___   / /____
  / /_  / __ \| |/_/ / / / __ \/ __ \/ / ___/
 / __/ / /_/ />  <  / / / /_/ / /_/ / (__  ) 
/_/    \____/_/|_| /_/ /_____/\____/_/____/  

"@
    Write-Host $banner -ForegroundColor Cyan
    Write-Host "        FoxTools Installer v2" -ForegroundColor Yellow
    Write-Host "  -------------------------------------------" -ForegroundColor DarkGray
}

function Write-Step($msg) {
    Write-Host " > " -ForegroundColor Green -NoNewline
    Write-Host $msg
}

function Write-Ok($msg) {
    Write-Host " [OK] " -ForegroundColor Black -BackgroundColor Green -NoNewline
    Write-Host " $msg"
}

function Write-Err($msg) {
    Write-Host " [ERROR] " -ForegroundColor White -BackgroundColor Red -NoNewline
    Write-Host " $msg"
}

Clear-Host
Write-Banner

$appName   = "FoxTools"
$url       = "https://github.com/foxtools23/foxtools/releases/download/v1.0.0/FoxTools.exe"
$installDir = "$env:LOCALAPPDATA\FoxTools"
$exePath    = Join-Path $installDir "FoxTools.exe"

try {
    Write-Step "Creando carpeta de instalación en $installDir ..."
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
    Write-Ok "Carpeta lista."

    Write-Step "Descargando $appName ..."
    $ProgressPreference = 'Continue'
    Invoke-WebRequest -Uri $url -OutFile $exePath -UseBasicParsing
    Write-Ok "Descarga completada."

    Write-Step "Desbloqueando archivo..."
    Unblock-File -Path $exePath
    Write-Ok "Archivo desbloqueado."

    Write-Step "Creando acceso directo en el escritorio..."
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\$appName.lnk")
    $Shortcut.TargetPath = $exePath
    $Shortcut.Save()
    Write-Ok "Acceso directo creado."

    Write-Step "Iniciando $appName ..."
    Start-Process $exePath
    Write-Ok "¡Listo! $appName se está ejecutando."

    Write-Host ""
    Write-Host "  Instalación completada con éxito." -ForegroundColor Green
    Write-Host "  -------------------------------------------" -ForegroundColor DarkGray
}
catch {
    Write-Err $_.Exception.Message
    Write-Host "  La instalación no se pudo completar." -ForegroundColor Red
}
