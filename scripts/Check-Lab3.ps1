param(
    [string]$FlutterSdk = 'C:\Users\Yarema\flutter'
)

$ErrorActionPreference = 'Stop'
$taskProjectRoot = Split-Path -Parent $PSScriptRoot
$taskSdkBin = Join-Path $FlutterSdk 'bin'
$taskFlutter = Join-Path $taskSdkBin 'flutter.bat'
$taskDart = Join-Path $taskSdkBin 'dart.bat'
$taskLogDirectory = Join-Path $taskProjectRoot 'verification'
if (-not (Test-Path -LiteralPath $taskFlutter)) {
    throw "Flutter not found: $taskFlutter"
}
New-Item -ItemType Directory -Path $taskLogDirectory -Force | Out-Null
$taskOriginalPath = $env:PATH
$env:PATH = "$taskSdkBin;$taskOriginalPath"
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
Push-Location $taskProjectRoot
try {
    $taskSteps = @(
        @{ Name = '01-version'; Program = $taskFlutter; Arguments = @('--version') },
        @{ Name = '02-dependencies'; Program = $taskFlutter; Arguments = @('pub', 'get') },
        @{ Name = '03-format'; Program = $taskDart; Arguments = @('format', 'lib', 'test') },
        @{ Name = '04-analysis'; Program = $taskFlutter; Arguments = @('analyze', 'lib', 'test') },
        @{ Name = '05-tests'; Program = $taskFlutter; Arguments = @('test') },
        @{ Name = '06-web-build'; Program = $taskFlutter; Arguments = @('build', 'web', '--release') }
    )
    foreach ($taskStep in $taskSteps) {
        Write-Host "Running $($taskStep.Name)" -ForegroundColor Cyan
        $taskLogPath = Join-Path $taskLogDirectory "$($taskStep.Name).txt"
        $taskProgram = $taskStep.Program
        $taskArguments = $taskStep.Arguments
        # Native tools can print progress to stderr. Their exit code decides success.
        $ErrorActionPreference = 'Continue'
        & $taskProgram @taskArguments 2>&1 | ForEach-Object { $_.ToString() } | Tee-Object -FilePath $taskLogPath
        $taskExitCode = $LASTEXITCODE
        $ErrorActionPreference = 'Stop'
        if ($taskExitCode -ne 0) {
            throw "Step $($taskStep.Name) failed ($taskExitCode). Log: $taskLogPath"
        }
    }
    Write-Host "Checks completed. Logs: $taskLogDirectory" -ForegroundColor Green
    Write-Host 'To open the app: flutter run -d chrome'
} finally {
    Pop-Location
    $env:PATH = $taskOriginalPath
}
