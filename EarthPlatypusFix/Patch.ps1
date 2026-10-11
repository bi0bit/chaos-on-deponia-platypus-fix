param(
    [ValidateSet('Install','Uninstall')][string]$Action = 'Install',
    [string]$GameFolder = ''
)
$ErrorActionPreference = 'Stop'
$temporary = $null
function Get-Sha([string]$Path) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}
function Assert-Sha([string]$Path, [string]$Expected) {
    if ((Get-Sha $Path) -ne $Expected) { throw ('Checksum mismatch: ' + $Path) }
}
try {
    $manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'manifest.json') -Raw | ConvertFrom-Json
    if ($manifest.format -ne 'EPLATYP2') { throw 'Unsupported patch format.' }
    foreach ($hash in @($manifest.original_sha256, $manifest.patched_sha256, $manifest.delta_sha256)) {
        if ($hash -notmatch '^[0-9a-f]{64}$') { throw 'Invalid patch manifest.' }
    }
    if (-not $GameFolder) {
        $parent = Split-Path -Parent $PSScriptRoot
        foreach ($candidate in @($PSScriptRoot, $parent)) {
            if (Test-Path -LiteralPath (Join-Path $candidate 'deponia2.exe') -PathType Leaf) {
                $GameFolder = $candidate
                break
            }
        }
    }
    if (-not $GameFolder) {
        Write-Host 'In Steam: right-click Chaos on Deponia > Manage > Browse local files.'
        $GameFolder = (Read-Host 'Paste that game folder path here').Trim().Trim('"')
    }
    $GameFolder = (Resolve-Path -LiteralPath $GameFolder).Path
    $archive = Join-Path $GameFolder 'data.vis'
    if (-not (Test-Path -LiteralPath (Join-Path $GameFolder 'deponia2.exe') -PathType Leaf) -or
        -not (Test-Path -LiteralPath $archive -PathType Leaf)) {
        throw 'Choose the Chaos on Deponia folder containing deponia2.exe and data.vis.'
    }
    if (Get-Process -Name deponia2 -ErrorAction SilentlyContinue) {
        throw 'Close Chaos on Deponia, then run this installer again.'
    }
    $current = Get-Sha $archive
    $backupFolder = Join-Path $GameFolder 'EarthPlatypusFixBackup'
    $originalBackup = Join-Path $backupFolder 'data.vis.original'
    if ($Action -eq 'Install') {
        if ($current -eq $manifest.patched_sha256) {
            Write-Host 'The minigame fix is already installed. No files changed.'
            exit 0
        }
        if ($current -ne $manifest.original_sha256) {
            throw 'Unsupported or modified data.vis. This package supports game build 3.3.2351 with the matching original archive. No game or save files changed.'
        }
        $delta = Join-Path $PSScriptRoot 'minigame.delta.gz'
        Assert-Sha $delta $manifest.delta_sha256
        if (Test-Path -LiteralPath $originalBackup) { Assert-Sha $originalBackup $manifest.original_sha256 }
        Add-Type -Path (Join-Path $PSScriptRoot 'PatchCore.cs')
        $temporary = Join-Path $GameFolder ('data.vis.EarthPlatypusFix.' + [guid]::NewGuid().ToString('N') + '.tmp')
        [EarthPlatypusPatchCore]::CreatePatchedArchive($archive, $delta, $temporary,
            $manifest.original_sha256, $manifest.patched_sha256)
        Assert-Sha $temporary $manifest.patched_sha256

        New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
        if (-not (Test-Path -LiteralPath $originalBackup)) {
            Copy-Item -LiteralPath $archive -Destination $originalBackup
        }
        Assert-Sha $originalBackup $manifest.original_sha256

        $saveFolder = Join-Path $env:LOCALAPPDATA 'Daedalic Entertainment\Deponia 2\Savegames'
        if (Test-Path -LiteralPath $saveFolder -PathType Container) {
            $snapshot = Join-Path $backupFolder ('saves-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8))
            New-Item -ItemType Directory -Path $snapshot | Out-Null
            Copy-Item -LiteralPath $saveFolder -Destination (Join-Path $snapshot 'Savegames') -Recurse
            $records = @(Get-ChildItem -LiteralPath $saveFolder -File -Recurse -Force | ForEach-Object {
                $relative = $_.FullName.Substring($saveFolder.Length + 1)
                $sourceHash = Get-Sha $_.FullName
                Assert-Sha (Join-Path (Join-Path $snapshot 'Savegames') $relative) $sourceHash
                [PSCustomObject]@{file=$relative; sha256=$sourceHash; bytes=$_.Length}
            })
            ConvertTo-Json -InputObject $records -Depth 3 | Set-Content -LiteralPath (Join-Path $snapshot 'manifest.json') -Encoding UTF8
            Write-Host ('Backed up and verified ' + $records.Count + ' save/profile files in ' + $snapshot)
        } else {
            Write-Host 'No existing save folder found. Original game archive backed up.'
        }
        # Recheck after preparation, then replace on the same volume atomically.
        Assert-Sha $archive $manifest.original_sha256
        [EarthPlatypusPatchCore]::ReplaceArchive($temporary, $archive)
        $temporary = $null
        Assert-Sha $archive $manifest.patched_sha256
        Write-Host 'Installed: Earth Platypus minigame fix. Your saves were not edited.'
        Write-Host 'Start the game through Steam, load your save, and play the puzzle normally.'
    } else {
        if ($current -eq $manifest.original_sha256) {
            Write-Host 'Original game archive is already installed. No files changed.'
            exit 0
        }
        if ($current -ne $manifest.patched_sha256) {
            throw 'Game archive changed after patching. Uninstall refused; no files changed.'
        }
        Assert-Sha $originalBackup $manifest.original_sha256
        Add-Type -Path (Join-Path $PSScriptRoot 'PatchCore.cs')
        $temporary = Join-Path $GameFolder ('data.vis.EarthPlatypusFix.' + [guid]::NewGuid().ToString('N') + '.tmp')
        Copy-Item -LiteralPath $originalBackup -Destination $temporary
        Assert-Sha $temporary $manifest.original_sha256
        Assert-Sha $archive $manifest.patched_sha256
        [EarthPlatypusPatchCore]::ReplaceArchive($temporary, $archive)
        $temporary = $null
        Assert-Sha $archive $manifest.original_sha256
        Write-Host 'Minigame fix uninstalled. Original game archive restored; current saves and backups retained.'
    }
    exit 0
} catch {
    Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
} finally {
    if ($temporary -and (Test-Path -LiteralPath $temporary)) {
        Remove-Item -LiteralPath $temporary -Force
    }
}
