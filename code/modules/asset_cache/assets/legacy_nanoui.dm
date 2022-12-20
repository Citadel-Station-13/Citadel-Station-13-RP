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
	for(var/path in directory_walk_exts(static_dirs, ".js"))
		var/fname = filepath_extract_name(path)
		assets[fname] = file(path)
	for(var/path in parent_dirs)
		var/fname = filepath_extract_name(path)
		assets[fname] = file(path)
	..()
