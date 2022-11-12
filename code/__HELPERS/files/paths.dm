/proc/pathflatten(path)
	return replacetext(path, "/", "_")

/**
 * Sanitizes the name of each node in the path.
 *
 * Im case you are wondering when to use this proc and when to use SANITIZE_FILENAME,
 *
 * You use SANITIZE_FILENAME to sanitize the name of a file [e.g. example.txt]
 *
 * You use sanitize_filepath sanitize the path of a file [e.g. root/node/example.txt]
 *
 * If you use SANITIZE_FILENAME to sanitize a file path things will break.
 */
/proc/sanitize_filepath(path)
	. = ""
	// Very much intentionally hardcoded.
	var/delimiter = "/"
	var/list/all_nodes = splittext(path, delimiter)
	for(var/node in all_nodes)
		if(.)
			// Add the delimiter before each successive node.
			. += delimiter
		. += SANITIZE_FILENAME(node)
