#define pick_list(FILE, KEY) (pick(strings(FILE, KEY)))
#define pick_list_weighted(FILE, KEY) (pick_weight(strings(FILE, KEY)))
#define pick_list_replacements(FILE, KEY) (strings_replacement(FILE, KEY))
#define json_load(FILE) (json_decode(file2text(FILE)))

GLOBAL_LIST(string_cache)
GLOBAL_VAR(string_filename_current_key)

/**
 * ? Load and cache a json file into a list.
 * ! Note If the file is already cached, it will CRASH
 *
 * * @param filename The filename to load.
 * * @param directory The directory to load from.
 * * @return Nothing.
 */
/proc/load_strings_file(filepath, directory = STRING_DIRECTORY)
	if(IsAdminAdvancedProcCall())
		return

	GLOB.string_filename_current_key = filepath
	if(filepath in GLOB.string_cache)
		return //no work to do

	if(!GLOB.string_cache)
		GLOB.string_cache = new

	if(fexists("[directory]/[filepath]"))
		GLOB.string_cache[filepath] = json_load("[directory]/[filepath]")
	else
		CRASH("file not found: [directory]/[filepath]")

/**
 * ? Take in a JSON file and a target property (must be an array), and search for the property in the file.
 * ? If the property is a string, return it.
 *
 * * @param filename The filename to load.
 * * @param key The key to search for.
 * * @return The value of the key, or null if not found.
 */
/proc/strings(filepath as text, key as text, directory = STRING_DIRECTORY)
	if(IsAdminAdvancedProcCall())
		return

	filepath = sanitize_filepath(filepath)
	load_strings_file(filepath, directory)
	if((filepath in GLOB.string_cache) && (key in GLOB.string_cache[filepath]))
		return GLOB.string_cache[filepath][key]
	else
		CRASH("strings list not found: [directory]/[filepath], index=[key]")

/**
 * Macro Proc for /proc/strings_replacement(filepath, key)
 */
/proc/strings_subkey_lookup(match, group1)
	return pick_list(GLOB.string_filename_current_key, group1)

/**
 *? This function parses a json file and returns a string.
 ** @param filename The filename of the json file.
 ** @param key The key of the string to return.
 ** @return The string.
 *
 *
 * Further documentation:
 *- Pick a random string from the chosen array in the json file.
 *- Find and replaces all the @pick(VALUE) with a random string from the VALUE array.
 *- Return final string.
 */
/proc/strings_replacement(filepath, key)
	filepath = sanitize_filepath(filepath)
	load_strings_file(filepath)

	if((filepath in GLOB.string_cache) && (key in GLOB.string_cache[filepath]))
		var/response = pick(GLOB.string_cache[filepath][key])
		var/regex/r = regex("@pick\\((\\D+?)\\)", "g")
		response = r.Replace(response, /proc/strings_subkey_lookup)
		return response
	else
		CRASH("strings list not found: [STRING_DIRECTORY]/[filepath], index=[key]")
