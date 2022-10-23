/datum/asset/simple/namespaced/nanoui
	keep_local_name = TRUE

/datum/asset/simple/namespaced/nanoui/register()
	var/list/static_dirs = list(
		"nano/css/",
		"nano/images/",
		"nano/images/status_icons/",
		"nano/images/modular_computers/",
	)

	var/list/parent_dirs = list(
		"nano/js/",
		"nano/templates/"
	)

	var/list/filenames = null
	for(var/path in static_dirs)
		filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) == "/") // filenames which end in "/" are actually directories, which we want to ignore
				continue
			if(fexists(path + filename))
				assets[filename] = file(path + filename)
	for(var/path in parent_dirs)
		filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) == "/") // filenames which end in "/" are actually directories, which we want to ignore
				continue
			if(fexists(path + filename))
				parents[filename] = file(path + filename)
	. = ..()
