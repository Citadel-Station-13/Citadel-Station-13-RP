function ExtractVersion {
	param([string] $Path, [string] $Key)
	foreach ($Line in Get-Content $Path) {
		if ($Line.StartsWith("export $Key=")) {
			return $Line.Substring("export $Key=".Length)
		}
	}
	throw "Couldn't find value for $Key in $Path"
}

function ResolveMariadbURL {
	param([string] $Version)
	return "https://mirror.rackspace.com/mariadb//mariadb-$Version/winx64-packages/mariadb-$Version-winx64.zip"
}

function ResolveFlywayURL {
	param([string] $Version)
	return "https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/$Version/flyway-commandline-$Version-windows-x64.zip"
}

$ToolRoot = Split-Path $script:MyInvocation.MyCommand.Path

$MARIADB_VERSION = ExtractVersion -Path "$ToolRoot/../../dependencies.sh" -Key "MARIADB_VERSION"
$FLYWAY_VERSION = ExtractVersion -Path "$ToolRoot/../../dependencies.sh" -Key "FLYWAY_VERSION"

$MYSQLD_PATH = "$ToolRoot/"
$FLYWAY_PATH = ""

# GET mariadb IF NOT EXISTS

if(!(Test-Path $MYSQLD_PATH -PathType Leaf)) {

}

# GET flyway IF NOT EXISTS

if(!(Test-Path $FLYWAY_PATH -PathType Leaf)) {

}

# run database

& $ToolRoot/../bootstrap/python._ps1 $ToolRoot/invoke.py $args
