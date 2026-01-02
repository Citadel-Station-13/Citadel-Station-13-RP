/**
 * Checks for specific types in a list.
 */
/proc/is_type_in_list(atom/A, list/L)
	for(var/type in L)
		if(istype(A, type))
			return TRUE
	return FALSE

/**
 * Checks for specific types in a list.
 */
/proc/is_path_in_list(path, list/L)
	for(var/P in L)
		if(ispath(path, P))
			return TRUE
	return FALSE

/proc/subtypesof(prototype)
	return (typesof(prototype) - prototype)

/**
 *! Typecaches,
 *? Specially formatted lists used to check for types with priority to speed rather than memory efficiency.
 */

/**
 * Checks for specific types in specifically structured (Assoc "type" = TRUE) lists ('typecaches')
 */
#define is_type_in_typecache(A, L) (A && length(L) && L[(ispath(A) ? A : A:type)])

/**
 * Returns a new list with only atoms that are in typecache L.
 */
/proc/typecache_filter_list(list/atoms, list/typecache)
	RETURN_TYPE(/list)
	. = list()
	for(var/atom/A as anything in atoms)
		if (typecache[A.type])
			. += A

/proc/typecache_filter_list_reverse(list/atoms, list/typecache)
	RETURN_TYPE(/list)
	. = list()
	for(var/atom/A as anything in atoms)
		if(!typecache[A.type])
			. += A

/proc/typecache_filter_multi_list_exclusion(list/atoms, list/typecache_include, list/typecache_exclude)
	. = list()
	for(var/atom/A as anything in atoms)
		if(typecache_include[A.type] && !typecache_exclude[A.type])
			. += A

/**
 * Like typesof() or subtypesof(), but returns a typecache instead of a list.
 *
 * Arguments:
 * - path: A typepath or list of typepaths.
 * - only_root_path: Whether the typecache should be specifically of the passed types.
 * - ignore_root_path: Whether to ignore the root path when caching subtypes.
 */
/proc/typecacheof(path, only_root_path = FALSE, ignore_root_path = FALSE)
	if(isnull(path))
		return

	if(ispath(path))
		. = list()
		if(only_root_path)
			.[path] = TRUE
			return

		for(var/subtype in (ignore_root_path ? subtypesof(path) : typesof(path)))
			.[subtype] = TRUE
		return

	if(!islist(path))
		CRASH("Tried to create a typecache of [path] which is neither a typepath nor a list.")

	. = list()
	var/list/pathlist = path
	if(only_root_path)
		for(var/current_path in pathlist)
			.[current_path] = TRUE
	else if(ignore_root_path)
		for(var/current_path in pathlist)
			for(var/subtype in subtypesof(current_path))
				.[subtype] = TRUE
	else
		for(var/current_path in pathlist)
			for(var/subpath in typesof(current_path))
				.[subpath] = TRUE

/**
 * Like typesof() or subtypesof(), but returns a typecache instead of a list.
 * This time it also uses the associated values given by the input list for the values of the subtypes.
 *
 * Latter values from the input list override earlier values.
 * Thus subtypes should come _after_ parent types in the input list.
 * Notice that this is the opposite priority of [/proc/is_type_in_list] and [/proc/is_path_in_list].
 *
 * Arguments:
 * - path: A typepath or list of typepaths with associated values.
 * - single_value: The assoc value used if only a single path is passed as the first variable.
 * - only_root_path: Whether the typecache should be specifically of the passed types.
 * - ignore_root_path: Whether to ignore the root path when caching subtypes.
 * - clear_nulls: Whether to remove keys with null assoc values from the typecache after generating it.
 */
/proc/zebra_typecacheof(path, single_value = TRUE, only_root_path = FALSE, ignore_root_path = FALSE, clear_nulls = FALSE)
	if(isnull(path))
		return

	if(ispath(path))
		if (isnull(single_value))
			return

		. = list()
		if(only_root_path)
			.[path] = single_value
			return

		for(var/subtype in (ignore_root_path ? subtypesof(path) : typesof(path)))
			.[subtype] = single_value
		return

	if(!islist(path))
		CRASH("Tried to create a typecache of [path] which is neither a typepath nor a list.")

	. = list()
	var/list/pathlist = path
	if(only_root_path)
		for(var/current_path in pathlist)
			.[current_path] = pathlist[current_path]
	else if(ignore_root_path)
		for(var/current_path in pathlist)
			for(var/subtype in subtypesof(current_path))
				.[subtype] = pathlist[current_path]
	else
		for(var/current_path in pathlist)
			for(var/subpath in typesof(current_path))
				.[subpath] = pathlist[current_path]

	if(!clear_nulls)
		return

	for(var/cached_path in .)
		if (isnull(.[cached_path]))
			. -= cached_path

/**
 * cached typecache of a given path list
 *
 * do not mutate the lists returned by this!
 */
/proc/cached_typecacheof(path = list(), ignore_root_path = FALSE, only_root_path = FALSE)
	var/key = json_encode(args)
	if(GLOB.typecaches[key])
		return GLOB.typecaches[key]
	return (GLOB.typecaches[key] = typecacheof(path, ignore_root_path, only_root_path))

GLOBAL_LIST_EMPTY(typecaches)
