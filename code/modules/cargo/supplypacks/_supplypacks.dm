
/datum/supply_pack
	// the container
	/// the type of the containier we spawn at - our contained objects will spawn in this.
	var/container_type = /obj/structure/closet/crate/plastic
	/// the name to set on our container, if any
	var/container_name
	/// the desc to set on our container, if any
	var/container_desc

	// the contained
	/// what we contain - list of typepaths associated to count. if no count is associated, it's assumed to be one.
	var/list/contains

	var/access
	var/one_access = FALSE
	var/contraband = 0

/**
 * creates our container
 */
/datum/supply_pack/proc/InstanceContainer(atom/loc)
	RETURN_TYPE(/atom/movable)
	return new container_type(loc)

/**
 * sets up our container, happens before objects are spawned
 */
/datum/supply_pack/proc/SetupContainer(atom/movable/container)
	if(container_name)
		container.name = container_name
	if(container_desc)
		container.desc = container_desc
	if(isobj(container))
		var/obj/O = container
		// only objs have the concept of access
		if(access)
			if(isnum(access))
				O.req_access = list(access)
			else if(islist(access) && one_access)
				var/list/L = access	// Access var is a plain var, we need a list
				O.req_one_access = L.Copy()
				O.req_access = null
			else if(islist(access) && !one_access)
				var/list/L = access
				O.req_access = L.Copy()
			else
				log_debug(SPAN_DEBUGERROR("Supply pack with invalid access restriction [access] encountered!"))

/**
 * spawwns our contents into a container. if you need special behavior like randomization, besure to modify default manifest too!
 */
/datum/supply_pack/proc/SpawnContents(atom/loc)
	var/list/to_spawn = preprocess_contents_list()
	if(!LAZYLEN(to_spawn))
		return
	var/safety = 500
	for(var/path in to_spawn)
		var/amount = to_spawn[path] || 1
		for(var/i in 1 to amount)
			if(!--safety)
				// adminproofing
				// no, no admin would fuck this up but myself
				// hence, self-proofing
				// ~silicons
				CRASH("Ran out of safety during SpawnContents")
			InstanceObject(path, loc)

/**
 * generates our HTML manifest as a **list**
 *
 * argument is provided for container incase you want to modify based on what actually spawned
 */
/datum/supply_pack/proc/get_html_manifest(atom/movable/container)
	RETURN_TYPE(/list)
	var/list/lines = list()
	lines += "Contents:<br>"
	lines += "<ul>"
	for(var/path in contains)
		var/amount = contains[path] || 1
		var/atom/movable/AM = path
		var/name = initial(AM.name)
		lines += "<li>[amount > 1? "[amount] [name](s)" : "[name]"]</li>"
	lines += "</ul>"
	return lines

	// ^\s+to_chat\(world\s*,\s*"[a-zA-Z0-9 .\[\]_]*"\)\n

/**
 * returns if we're random. if we are, return number of items.
 * required for old nanoui
 * this proc's existence, as well as hardcoded ui data for packs, really makes me hate life
 * but i'm not doing nanoui/tgui conversion today.
 */
/datum/supply_pack/proc/is_random()
	return FALSE

/**
 * gets a list of things to show on nanoui
 * god, i hate nanoui
 * burn this proc and is_random() with fire at some point, please.
 */
/datum/supply_pack/proc/flattened_nanoui_manifest()
	. = list()
	for(var/path in contains)
		var/amount = contains[path] || 1
		var/atom/movable/AM = path
		var/name = initial(AM.name)
		. += "[amount > 1? "[amount] [name](s)" : "[name]"]"

/datum/supply_pack/randomised/get_html_manifest(atom/movable/container)
	var/list/lines = list()
	lines += "Contains any [num_contained] of the following:<br>"
	lines += "<ul>"
	for(var/path in contains)
		var/amount = contains[path] || 1
		var/atom/movable/AM = path
		var/name = initial(AM.name)
		lines += "<li>[amount > 1? "[amount] [name](s)" : "[name]"]</li>"
	lines += "</ul>"
	return lines


/datum/supply_pack/randomised/is_random()
	return num_contained
