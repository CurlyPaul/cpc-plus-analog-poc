$env = "c:\tools\cpc"
$isDebug = 1

$winape = Get-Process WinApe -ErrorAction SilentlyContinue
if ($winape) {
  if (!$winape.HasExited) {
    $winape | Stop-Process -Force
  }
}
Remove-Variable winape

Write-Host "Building.."

if($isDebug){

    $buildProcess = Start-Process -FilePath $env"\rasm\rasm.exe" -Wait -PassThru -NoNewWindow -ArgumentList "./debug.asm -o ./artifacts/debug -s -sl -sq -sb"

    if ($buildProcess.ExitCode)
    {
        Write-Host "Build failed"
        exit
    }

    Start-Process -FilePath "$env\WinApe\WinApe.exe" -ArgumentList "/SN:$(Get-Location)\artifacts\debug.sna /SYM:$(Get-Location)\artifacts\debug.sym"
}
else {

    $buildProcess = Start-Process -FilePath $env"\rasm\rasm.exe" -Wait -PassThru -NoNewWindow -ArgumentList "./release.asm -o ./artifacts/release"

    if ($buildProcess.ExitCode)
    {
        Write-Host "Build failed"
        exit
    }

    Start-Process -FilePath "$env\WinApe\WinApe.exe" 
}
