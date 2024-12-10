function ExtractVersion {
	param([string] $Path, [string] $Key)
	foreach ($Line in Get-Content $Path) {
		if ($Line.StartsWith("export $Key=")) {
			return $Line.Substring("export $Key=".Length)
		}
	}
	throw "Couldn't find value for $Key in $Path"
}

function ResolveMariaDBURL {
	param([string] $Version)
	return "https://mirror.rackspace.com/mariadb//mariadb-$Version/winx64-packages/mariadb-$Version-winx64.zip"
}

function ResolveFlywayURL {
	param([string] $Version)
	return "https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/$Version/flyway-commandline-$Version-windows-x64.zip"
}

# Path is a /path/to/folder
# Archive will be temporarily downloaded as /path/to/folder.zip
function PullURLAndUnpack {
	param([string] $URL, [string] $Path)
	if(Test-Path "$Path.zip" -PathType Leaf) {
		Remove-Item -Path "$Path.zip"
	}
	Write-Output "Pulling $URL to $Path.zip"
	$ProgressPreference = 'SilentlyContinue'
	Invoke-WebRequest `
		"$URL" `
		-OutFile "$Path.zip" `
		-ErrorAction Stop
	$ProgressPreference = 'Continue'
	Write-Output "Expanding $Path.zip to $Path"
	Expand-Archive "$Path.zip" -DestinationPath "$Path"
}

$ToolRoot = Split-Path $script:MyInvocation.MyCommand.Path

$MARIADB_VERSION = ExtractVersion -Path "$ToolRoot/../../dependencies.sh" -Key "MARIADB_VERSION"
$FLYWAY_VERSION = ExtractVersion -Path "$ToolRoot/../../dependencies.sh" -Key "FLYWAY_VERSION"

$MARIADB_FOLDER = "$ToolRoot/.cache/mariadb/$MARIADB_VERSION"
$MARIADB_BIN_FOLDER = "$MARIADB_FOLDER/mariadb-$MARIADB_VERSION-winx64/bin"
$FLYWAY_FOLDER = "$ToolRoot/.cache/flyway/$FLYWAY_VERSION"

$MYSQLD_PATH = "$MARIADB_BIN_FOLDER/mariadbd.exe"
$MYSQLD_ADMIN_PATH = "$MARIADB_BIN_FOLDER/mariadb-admin.exe"
$FLYWAY_PATH = "$FLYWAY_FOLDER/flyway-$FLYWAY_VERSION/flyway.cmd"

# GET mariadb IF NOT EXISTS

if(!(Test-Path $MYSQLD_PATH -PathType Leaf)) {
	$MARIADB_URL = ResolveMariaDBURL $MARIADB_VERSION
	PullURLAndUnpack $MARIADB_URL $MARIADB_FOLDER
	if(!(Test-Path $MYSQLD_PATH -PathType Leaf)) {
		Write-Error "Failed to find '$MYSQLD_PATH' after unpacking."
		exit 1
	}
}

# GET flyway IF NOT EXISTS

if(!(Test-Path $FLYWAY_PATH -PathType Leaf)) {
	$FLYWAY_URL = ResolveFlywayURL $FLYWAY_VERSION
	PullURLAndUnpack $FLYWAY_URL $FLYWAY_FOLDER
	if(!(Test-Path $FLYWAY_PATH -PathType Leaf)) {
		Write-Error "Failed to find '$FLYWAY_PATH' after unpacking."
		exit 1
	}
}

# run database

$DATABASE_DATA_DIR_RAW = "$ToolRoot/../../data/setup_dev_db"
if(!(Test-Path $DATABASE_DATA_DIR_RAW -PathType Container)) {
	New-Item $DATABASE_DATA_DIR_RAW -ItemType Directory
	$DATABASE_DATA_DIR = Resolve-Path "$ToolRoot/../../data/setup_dev_db"
	Write-Output "Bootstrapping database with data directory '$DATABASE_DATA_DIR'."
	& $MARIADB_BIN_FOLDER/mariadb-install-db.exe -d $DATABASE_DATA_DIR -p password -D
}
$DATABASE_DATA_DIR = Resolve-Path "$ToolRoot/../../data/setup_dev_db"

& $ToolRoot/../bootstrap/python_.ps1 $ToolRoot/invoke.py --dataDir $DATABASE_DATA_DIR --mysqld $MYSQLD_PATH --flyway $FLYWAY_PATH --migrations "../../sql/migrations" --mysql_admin $MYSQLD_ADMIN_PATH $args
