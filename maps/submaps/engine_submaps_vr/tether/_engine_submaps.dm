/datum/map_template/engine
	name = "Engine Content"
	desc = "It would be boring to have the same engine every day right?"
	// annihilate = TRUE - Would wipe out in a rectangular area unfortunately
	allow_duplicates = FALSE
	/// announce name
	var/display_name

/datum/map_template/engine/New()
	. = ..()
	if(isnull(display_name))
		display_name = name
	else if(islist(display_name))
		display_name = pick(display_name)

/datum/map_template/engine/rust
	name = "EngineSubmap_RUST"
	desc = "R-UST Fusion Tokamak Engine"
	mappath = '_maps/templates/engines/tether/engine_rust.dmm'
	display_name = list("Contained Star", "Synthetic Killer", "Glowy Field", "R-UST", "Fusion Reactor", "Miniature Star")

/datum/map_template/engine/singulo
	name = "EngineSubmap_Singulo"
	desc = "Lord Singuloth"
	mappath = '_maps/templates/engines/tether/engine_singulo.dmm'
	display_name = list("Hypnosis Swirls", "Lord Singuloth", "The Devourer of Stations", "Contained Black Hole", "The Forbidden Succ")

/datum/map_template/engine/supermatter
	name = "EngineSubmap_SM"
	desc = "Old Faithful Supermatter"
	mappath = '_maps/templates/engines/tether/engine_sme.dmm'
	display_name = list("Angry Rock", "The Forbidden Rock Candy", "Supermatter", "Death Crystal", "Spicy Crystal")

/datum/map_template/engine/tesla
	name = "EngineSubmap_Tesla"
	desc = "The Telsa Engine"
	mappath = '_maps/templates/engines/tether/engine_tesla.dmm'
	display_name = list("Edison's Bane", "Lady Tesla", "Lightning Ball", "Overpowered Phone Charger", "Exploder of Machines")

// Landmark for where to load in the engine on permament map
/obj/landmark/engine_loader
	name = "Engine Loader"
	var/clean_turfs // A list of lists, where each list is (x, )

/obj/landmark/engine_loader/New()
	if(SSmapping.engine_loader)
		warning("Duplicate engine_loader landmarks: [log_info_line(src)] and [log_info_line(SSmapping.engine_loader)]")
		delete_me = TRUE
	SSmapping.engine_loader = src
	return ..()

/obj/landmark/engine_loader/proc/get_turfs_to_clean()
	. = list()
	if(clean_turfs)
		for(var/list/coords in clean_turfs)
			. += block(locate(coords[1], coords[2], src.z), locate(coords[3], coords[4], src.z))

/obj/landmark/engine_loader/proc/annihilate_bounds()
	var/deleted_atoms = 0
	admin_notice("<span class='danger'>Annihilating objects in engine loading locatation.</span>", R_DEBUG)
	var/list/turfs_to_clean = get_turfs_to_clean()
	if(turfs_to_clean.len)
		for(var/x in 1 to 2) // Requires two passes to get everything.
			for(var/turf/T in turfs_to_clean)
				for(var/atom/movable/AM in T)
					++deleted_atoms
					qdel(AM)
	admin_notice("<span class='danger'>Annihilated [deleted_atoms] objects.</span>", R_DEBUG)

