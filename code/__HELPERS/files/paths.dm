/**
 * flattens a path, replacing all /'s with _
 */
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

/**
 * gets file name of a path
 * expensive, duh.
 */
/proc/filepath_extract_name(path)
	var/pos = findlasttext_char(path, "/")
	return copytext(path, pos + 1)

/// reasonable loading roots for server configuration
///
/// * this should never be player accessible
/// * this should never be admin accessible
GLOBAL_REAL_LIST(safe_config_file_access_roots) = list(
	"config",
)
/// reasonable loading roots for server persistent data stores
///
/// * this should never be player accessible
/// * this should never be admin accessible
GLOBAL_REAL_LIST(safe_data_file_access_roots) = list(
	"data",
)
/// reasonable loading roots for something like maps to be loading
///
/// * prevents escalation to config / data stores
GLOBAL_REAL_LIST(safe_content_file_access_roots) = list(
	"code",
	"icons",
	"sound",
	"strings",
	"tgui",
	"nano",
	"fluff",
	"html",
	"ingame_manuals",
)

/**
 * makes sure a path is allowed to be parsed
 *
 * * used for security purposes, touch with extreme care
 * * "/.." is entirely banned
 * * must start with one of the safe roots
 * * the empty path "" is allowed!
 */
/proc/filepath_is_safe(path, list/safe_roots)
	if(!path)
		return TRUE
	var/list/fragments = splittext_char(path, "/")
	switch(length(fragments))
		if(0)
			CRASH("how")
	for(var/i in 1 to length(fragments))
		var/fragment = fragments[i]
		switch(fragment)
			if("..", ".")
				return FALSE
	return fragments[1] in safe_roots
