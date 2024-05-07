/datum/asset/simple/namespaced/nanoui
	keep_local_name = TRUE

/datum/asset/simple/namespaced/nanoui/register()
	var/list/dirs = list(
		"nano/css/",
		"nano/images/",
		"nano/images/status_icons/",
		"nano/templates/",
		"nano/js/",
		"nano/js/libraries/",
	)
	var/list/exts = list(
		"js",
		"css",
		"html",
		"gif",
		"tmpl",
		"png",
	)
	// DO NOT recurse
	for(var/path in directory_walk_exts(dirs, exts, 0))
		var/fname = filepath_extract_name(path)
		assets[fname] = file(path)
	..()
