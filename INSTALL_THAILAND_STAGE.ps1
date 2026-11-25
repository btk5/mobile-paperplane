# Run in the existing Flutter project directory after extracting this overlay.
$ErrorActionPreference = 'Stop'
if (-not (Test-Path '.\pubspec.yaml')) { throw 'Open the Flutter project root first.' }
Write-Host 'The Thailand stage source is installed. Check build and tests:'
flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
dart format lib test
flutter analyze
if ($LASTEXITCODE -ne 0) { Write-Warning 'Analyzer found issues; inspect errors before running.'; exit $LASTEXITCODE }
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter run -d emulator-5554
