## bootstrap/node_.ps1
## Downloads a Node version to a cache directory and invokes it.
## This will download / load a vendored version of node, as specified by dependencies.sh

# Set flags
$ErrorActionPreference = "Stop"

# Init
. $PSScriptRoot/common.ps1
Initialize-Bootstrap

# Write-Output "bootstrap-node: starting (powershell)"

$NodePath = "$global:CacheDir/node-v$global:NODE_VERSION_PRECISE-windows-x64"
$NodeExe = "$NodePath/node.exe"

# Download Node if it isn't there
if (Test-Path $NodeExe -PathType Leaf) {
	# Write-Output "bootstrap-node: found at $NodeExe"
}
else {
	# Write-Output "bootstrap-node: downloading node v$global:NODE_VERSION_PRECISE"
	New-Item $NodePath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
	$NodeDownloader = New-Object Net.WebClient
	$NodeDownloader.DownloadFile("https://nodejs.org/download/release/v$global:NODE_VERSION_PRECISE/win-x64/node.exe", "$NodeExe.downloading")
	Rename-Item "$NodeExe.downloading" "$NodeExe"
}

# Set PATH
$Env:PATH = "$NodePath;$Env:PATH"

# Invoke Node with passed in params
$ErrorActionPreference = "Continue"
# Write-Output "bootstrap-node: path is $NodeExe"
Write-Output "Using vendored node $(& "$NodeExe" --version)"
& "$NodeExe" @Args
exit $LastExitCode
