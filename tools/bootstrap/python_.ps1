## bootstrap/python_.ps1
##
## Python bootstrapping script for Windows.
##
## Automatically downloads a portable edition of a pinned Python version to
## a cache directory, installs Pip, installs `requirements.txt`, and then invokes
## Python.
##
## The underscore in the name is so that typing `bootstrap/python` into
## PowerShell finds the `.bat` file first, which ensures this script executes
## regardless of ExecutionPolicy.

# Set Flags
$ErrorActionPreference = "Stop"

# Init
. $PSScriptRoot/common.ps1
Initialize-Bootstrap

Write-Output "bootstrap-python: starting (powershell)"

$PythonPath = "$global:CacheDir/python-$global:PYTHON_VERSION-windows-x64"
$PythonExe = "$PythonPath/python.exe"

# Download Python if it isn't there
if (Test-Path $PythonExe -PathType Leaf) {
	Write-Output "bootstrap-python: found at $PythonExe"
}
else {
	Write-Output "bootstrap-python: downloading python v$global:PYTHON_VERSION"
	New-Item $PythonPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

}

# Set PATH
$Env:PATH = "$PythonPath;$ENV:PATH"




[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Add-Type -AssemblyName System.IO.Compression.FileSystem



# Convenience variables
$PythonDir = "$Cache/python-$PythonVersion"
$PythonExe = "$PythonDir/python.exe"
$Log = "$Cache/last-command.log"

# Download and unzip a portable version of Python
if (!(Test-Path $PythonExe -PathType Leaf)) {
	$host.ui.RawUI.WindowTitle = "Downloading Python $PythonVersion..."
	New-Item $Cache -ItemType Directory -ErrorAction silentlyContinue | Out-Null

	$Archive = "$Cache/python-$PythonVersion-embed.zip"
	Invoke-WebRequest `
		"https://www.python.org/ftp/python/$PythonVersion/python-$PythonVersion-embed-amd64.zip" `
		-OutFile $Archive `
		-ErrorAction Stop

	[System.IO.Compression.ZipFile]::ExtractToDirectory($Archive, $PythonDir)

	$PythonVersionArray = $PythonVersion.Split(".")
	$PythonVersionString = "python$($PythonVersionArray[0])$($PythonVersionArray[1])"
	Write-Output "Generating PATH descriptor."
	New-Item "$Cache/$PythonVersionString._pth" | Out-Null
	Set-Content "$Cache/$PythonVersionString._pth" "$PythonVersionString.zip`n.`n..\..\..`nimport site`n"
	# Copy a ._pth file without "import site" commented, so pip will work
	Copy-Item "$Cache/$PythonVersionString._pth" $PythonDir `
		-ErrorAction Stop

	Remove-Item $Archive
}

# Install pip
if (!(Test-Path "$PythonDir/Scripts/pip.exe")) {
	$host.ui.RawUI.WindowTitle = "Downloading Pip..."

	Invoke-WebRequest "https://bootstrap.pypa.io/get-pip.py" `
		-OutFile "$Cache/get-pip.py" `
		-ErrorAction Stop

	& $PythonExe "$Cache/get-pip.py" --no-warn-script-location
	if ($LASTEXITCODE -ne 0) {
		exit $LASTEXITCODE
	}

	Remove-Item "$Cache/get-pip.py" `
		-ErrorAction Stop
}

# Use pip to install our requirements
if (!(Test-Path "$PythonDir/requirements.txt") -or ((Get-FileHash "$Tools/requirements.txt").hash -ne (Get-FileHash "$PythonDir/requirements.txt").hash)) {
	$host.ui.RawUI.WindowTitle = "Updating dependencies..."

	& $PythonExe -m pip install -U pip -r "$Tools/requirements.txt"
	if ($LASTEXITCODE -ne 0) {
		exit $LASTEXITCODE
	}

	Copy-Item "$Tools/requirements.txt" "$PythonDir/requirements.txt"
	Write-Output "`n---`n"
}

# Invoke Python with passed in params
$ErrorActionPreference = "Continue"
Write-Output "bootstrap-python: path is $PythonExe"
Write-Output "bootstrap-python: using vendored node $(& "$PythonExe" -- version)"
$ "$PythonExe" -u @Args
exit $LastExitCode
