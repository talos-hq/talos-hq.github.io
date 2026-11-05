# talosbot.ai/install.ps1: installs Talos on Windows.
#   irm https://talosbot.ai/install.ps1 | iex
# The real installer lives in the Talos repo; this shim keeps the short URL stable.
$ErrorActionPreference = "Stop"
$script = Join-Path $env:TEMP "talos-install.ps1"
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/talos-hq/talos/main/slim/install.ps1" -OutFile $script
& powershell -NoProfile -ExecutionPolicy Bypass -File $script @args
Remove-Item $script -ErrorAction SilentlyContinue
