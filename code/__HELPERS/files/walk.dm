#warn turn into world procs
/proc/directory_walk(list/roots, maxdepth = 10)
	return directory_walk_internal(islist(roots)? roots : list(roots), maxdepth)

/proc/directory_walk_exts(list/roots, list/exts, maxdepth = 10)
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
					. += found
			else
				nested += path + found
	var/list/recursed = directory_walk_internal(nested, R, depth_remaining - 1)
	if(recursed)
		. += recursed
