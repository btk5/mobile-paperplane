# Run from the Flutter project root. Preserve old files outside the project.
$ErrorActionPreference = 'Stop'
$backup = Join-Path $env:USERPROFILE 'Documents\Paperbound_Previous_Code'
New-Item -ItemType Directory -Force -Path $backup | Out-Null
$legacy = @('lib/audio.dart','lib/game.dart','lib/logic.dart','lib/storage.dart','test/logic_test.dart','test/widget_test.dart','lib/audio.backup.dart','lib/game.backup.dart','lib/sky_game backup.dart')
foreach ($relative in $legacy) {
  if (Test-Path -LiteralPath $relative) {
    $dest = Join-Path $backup ($relative.Replace('/','_'))
    Move-Item -LiteralPath $relative -Destination $dest -Force
    Write-Host "Archived $relative"
  }
}
if (Test-Path 'paperbound_legacy_backup') {
  $dest = Join-Path $backup 'paperbound_legacy_backup'
  if (Test-Path $dest) { $dest = Join-Path $backup ('paperbound_legacy_backup_' + (Get-Date -Format 'yyyyMMddHHmmss')) }
  Move-Item 'paperbound_legacy_backup' $dest
}
Write-Host 'Legacy source archived outside the Flutter project.'
