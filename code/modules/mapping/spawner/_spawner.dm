/**
 * our only job is to spawn something and then self-delete
 */
/obj/spawner
	icon = 'icons/mapping/spawners/spawners.dmi'
	icon_state = ""
	layer = MID_LANDMARK_LAYER
	/// lateload?
	var/late = FALSE

/obj/spawner/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	flags |= INITIALIZED
	if(!late)
		Spawn()	// we always spawn in Initialize(), because if anything we spawn has LateInitialize behavior, that'll be really bad, huh.
				// keep in mind though, anything requiring even regular Initialize() behavior will be trampled, so, spawners are only good for
				// simple things.
		return INITIALIZE_HINT_QDEL
	else
				// do not use late unless you absolutely know what you're doing
		return INITIALIZE_HINT_LATELOAD

/obj/spawner/LateInitialize()
	Spawn()

/obj/spawner/proc/Spawn()
	return

/**
 * simple spawner - spawn a typepath x times
 */
/obj/spawner/simple
	var/path
	var/amount

/obj/spawner/simple/Spawn()
	for(var/i in 1 to min(50, amount))
		new path(loc)

/**
 * multi spawner - spawn a typepath x times for paths in list
 * paths can be text as **byond params**, not json.
 */
/obj/spawner/multi
	var/list/paths

/obj/spawner/multi/Spawn()
	// check lists
	var/list/_paths = list()
	// if is text, params2list
	if(istext(paths))
		paths = params2list(paths)
	if(!islist(paths))
		return
	// manual verify
	for(var/path in paths)
		// first check amount
		if(!paths[path])
			paths[path] = 1
		else if(isnum(paths[path]))
			if(paths[path] <= 0)
				stack_trace("invalid amount [paths[path]] at multi spawner at [AREACOORD(src)]")
				continue
		else
			stack_trace("invalid amount [paths[path]] at multi spawner at [AREACOORD(src)]")
		// then type
		if(ispath(path))
			_paths[path] = paths[path]
		else if(istext(path))
			var/_path = text2path(path)
			if(!_path)
				stack_trace("invalid path [path] at multi spawner at [AREACOORD(src)]")
			_paths[_path] = paths[path]

		else
			stack_trace("invalid path [path] at multi spawner at [AREACOORD(src)]")
	// spawn
	for(var/path in _paths)
		for(var/i in 1 to _paths[path])
			new path(loc)
