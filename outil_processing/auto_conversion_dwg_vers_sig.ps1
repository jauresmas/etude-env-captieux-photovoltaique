<#
Conversion automatique et récurrente des fichiers CAO (DWG/DXF) du dossier dwg/
vers des GeoPackage dans data/traite/, via FME (lecteur ACAD -> écrivain GEOPACKAGE).

Ne reconvertit un fichier que si la source a été modifiée après le dernier
GeoPackage généré (ou si celui-ci n'existe pas encore), pour supporter
l'ajout périodique de nouveaux plans sans tout retraiter.
#>

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$FmeExe      = "C:\Program Files\FME\fme.exe"
$SourceDir   = Join-Path $ProjectRoot "dwg"
$OutputDir   = Join-Path $ProjectRoot "data\traite"
$LogFile     = Join-Path $PSScriptRoot "auto_conversion_dwg_vers_sig.log"

function Write-Log($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$timestamp  $message"
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$sourceFiles = Get-ChildItem -Path $SourceDir -Include *.dwg, *.dxf -Recurse -File

if (-not $sourceFiles) {
    Write-Log "Aucun fichier DWG/DXF trouve dans $SourceDir"
    return
}

foreach ($file in $sourceFiles) {
    $outputName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name) + ".gpkg"
    $outputPath = Join-Path $OutputDir $outputName

    $needsConversion = $true
    if (Test-Path $outputPath) {
        $outputTime = (Get-Item $outputPath).LastWriteTime
        if ($file.LastWriteTime -le $outputTime) {
            $needsConversion = $false
        }
    }

    if (-not $needsConversion) {
        Write-Log "A jour, ignore : $($file.Name)"
        continue
    }

    Write-Log "Conversion : $($file.Name) -> $outputName"

    if (Test-Path $outputPath) {
        Remove-Item $outputPath -Force
    }

    # Sortie de fme.exe capturee dans un fichier temporaire dedie (via cmd /c) puis
    # fusionnee dans le log apres coup : evite le conflit d'acces concurrent sur le
    # log partage et le mauvais comportement de PowerShell 5.1 qui transforme chaque
    # ligne stderr d'un exe natif en ErrorRecord (et force $? = $false) meme quand le
    # code de sortie reel est 0.
    $tempOut = [System.IO.Path]::GetTempFileName()
    $cmdLine = '"' + $FmeExe + '" GENTRANS ACAD "' + $file.FullName + '" GEOPACKAGE "' + $outputPath + '" >> "' + $tempOut + '" 2>&1'
    cmd /c $cmdLine
    $exitCode = $LASTEXITCODE

    Get-Content -Path $tempOut -ErrorAction SilentlyContinue | Add-Content -Path $LogFile
    Remove-Item $tempOut -Force -ErrorAction SilentlyContinue

    if ($exitCode -eq 0) {
        Write-Log "OK : $outputName"
    } else {
        Write-Log "ECHEC (code $exitCode) : $($file.Name)"
    }
}
