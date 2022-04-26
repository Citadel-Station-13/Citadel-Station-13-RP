/**
 * supplypacks
 * these are the "bundle buys" of cargo
 * they usually ship in a crate and is used by the main
 * cargo system, as opposed to trading, but is perfectly usable
 * by anything using the spawn procs.
 */

//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.
//NOTE NOTE: Hidden var is now deprecated, whoever removed support for it should've removed the var altogether

var/list/all_supply_groups = list("Atmospherics",
								  "Costumes",
								  "Engineering",
								  "Hospitality",
								  "Hydroponics",
								  "Materials",
								  "Medical",
								  "Miscellaneous",
								  "Munitions",
								  "Reagents",
								  "Reagent Cartridges",
								  "Recreation",
								  "Robotics",
								  "Science",
								  "Security",
								  "Supplies",
								  "Voidsuits")

/datum/supply_pack
	var/name
	var/cost

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
	var/group = "Miscellaneous"

/**
 * instance the supply pack at a location. returns the container used.
 */
/datum/supply_pack/proc/Instantiate(atom/loc)
	RETURN_TYPE(/atom/movable)
	. = InstanceContainer(loc)
	SetupContainer(.)
	SpawnContents(.)

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
			else if(islist(access) && SP.one_access)
				var/list/L = access	// Access var is a plain var, we need a list
				O.req_one_access = L.Copy()
				Oo.req_access = null
			else if(islist(access) && !SP.one_access)
				var/list/L = access
				O.req_access = L.Copy()
			else
				log_debug("<span class='danger'>Supply pack with invalid access restriction [access] encountered!</span>")

/**
 * spawn an object of a certain type
 */
/datum/supply_pack/proc/InstanceObject(path, atom/loc, ...)
	RETURN_TYPE(/atom/movbale)
	return new path(arglist(args.Copy(2)))

/**
 * spawwns our contents into a container. if you need special behavior like randomization, besure to modify default manifest too!
 */
/datum/supply_pack/SpawnContents(atom/loc)
	if(!contained)
		return
	var/safety = 500
	for(var/path in contained)
		var/amount = contained[path] || 1
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
 */
/datum/supply_pack/proc/get_html_manifest()
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

/**
 * randomized supplypacks
 * only x items can be ever spawned
 * weighting is equal - the list of typepaths normally spawned is treated as pick-and-take-one-of.
 */
/datum/supply_pack/randomised
	/// how many of our items at random to spawn
	var/num_contained = 1


/datum/supply_pack/New()
	for(var/path in contains)
		if(!path || !ispath(path, /atom))
			continue
		var/atom/O = path
		manifest += "\proper[initial(O.name)]"

/datum/supply_pack/proc/get_html_manifest()
	var/dat = ""
	if(num_contained)
		dat +="Contains any [num_contained] of:"
	dat += "<ul>"
	for(var/O in manifest)
		dat += "<li>[O]</li>"
	dat += "</ul>"
	return dat

		// Supply manifest generation begin
		var/obj/item/paper/manifest/slip
		if(!SP.contraband)
			slip = new /obj/item/paper/manifest(A)
			slip.is_copy = 0
			slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			slip.info +="Order #[SO.ordernum]<br>"
			slip.info +="Destination: [station_name()]<br>"
			slip.info +="[orderedamount] PACKAGES IN THIS SHIPMENT<br>"
			slip.info +="CONTENTS:<br><ul>"

		// Spawn the stuff, finish generating the manifest while you're at it

		var/list/contains
		if(istype(SP,/datum/supply_pack/randomised))
			var/datum/supply_pack/randomised/SPR = SP
			contains = list()
			if(SPR.contains.len)
				for(var/j=1,j<=SPR.num_contained,j++)
					contains += pick(SPR.contains)
		else
			contains = SP.contains

		for(var/typepath in contains)
			if(!typepath)
				continue

			var/number_of_items = max(1, contains[typepath])
			for(var/j = 1 to number_of_items)
				var/atom/B2 = new typepath(A)
				if(slip)
					slip.info += "<li>[B2.name]</li>"	// Add the item to the manifest

		// Manifest finalisation
		if(slip)
			slip.info += "</ul><br>"
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
