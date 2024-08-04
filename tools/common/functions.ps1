# Get version of a dependency from dependencies.sh
# Output is always a string.
# Input is a path and key. You should usually input dependencies.sh for the path.
function Read-Dependency-Version {
	param([string] $Path, [string] $Key)
	foreach ($Line in Get-Content $Path) {
		if ($Line.StartsWith("export $Key=")) {
			return $Line.Substring("Export $Key=".Length)
		}
	}
	throw "Couldn't extract version for $Key in dependency specifier file $Path"
}

# function Import-Dependency-Versions {
# 	param([string] $Path)
# 	foreach ($Line in Get-Content $Path) {
# 		# todo: impl this & include; right now we have no use for it
# 	}
# }
