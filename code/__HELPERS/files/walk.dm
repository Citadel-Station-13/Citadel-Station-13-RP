/**
 * walks a directory, returning paths of all files.
 *
 * @params
 * - roots - a single or a list of roots. roots MUST end with /, or they won't work.
 * - maxdepth - maximum depth to walk. default is 5.
 */
/proc/directory_walk(list/roots, maxdepth = 5)
	ASSERT(roots)
	if(!islist(roots))
		roots = list(roots)
	return directory_walk_internal(islist(roots)? roots : list(roots), null, maxdepth)

/**
 * walks a directory, returning paths of all files with certain extensions
 *
 * @params
 * - roots - a single or a list of roots. roots MUST end with /, or they won't work.
 * - exts - a single or a list of extensions. do not including the ., e.g. pass in "txt", not ".txt".
 * - maxdepth - maximum depth to walk. default is 5.
 */
/proc/directory_walk_exts(list/roots, list/exts, maxdepth = 5)
	ASSERT(roots)
	if(!islist(roots))
		roots = list(roots)
	ASSERT(exts)
	if(!islist(exts))
		exts = list(exts)
	return directory_walk_internal(islist(roots)? roots : list(roots), new /regex("\\.([exts.Join("|")])$", "i"), maxdepth)

/proc/directory_walk_internal(list/roots, regex/R, depth_remaining)
	if(!length(roots))
		return
	if(!islist(roots))
		CRASH("Invalid roots: [roots]")
	if(depth_remaining < 0)
		return
	. = list()
	var/list/nested = list()
	for(var/path in roots)
		if(path[1] == "/")
			// seriously you don't need byond servers touching outside of their sandboxes.
			CRASH("absolute path not allowed: [path]")
		for(var/found in flist(path))
			if(found[length(found)] != "/")	// file
				if(!R || R.Find(found))
					. += path + found
			else
				nested += path + found
	var/list/recursed = directory_walk_internal(nested, R, depth_remaining - 1)
	if(recursed)
		. += recursed
