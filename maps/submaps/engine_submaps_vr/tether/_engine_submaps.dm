/datum/map_template/engine
	name = "Engine Content"
	desc = "It would be boring to have the same engine every day right?"
	// annihilate = TRUE - Would wipe out in a rectangular area unfortunately
	allow_duplicates = FALSE

/datum/map_template/engine/rust
	name = "EngineSubmap_RUST"
	desc = "R-UST Fusion Tokamak Engine"
	mappath = '_maps/templates/engines/tether/engine_rust.dmm'

/datum/map_template/engine/singulo
	name = "EngineSubmap_Singulo"
	desc = "Lord Singuloth"
	mappath = '_maps/templates/engines/tether/engine_singulo.dmm'

/datum/map_template/engine/supermatter
	name = "EngineSubmap_SM"
	desc = "Old Faithful Supermatter"
	mappath = '_maps/templates/engines/tether/engine_sme.dmm'

/datum/map_template/engine/tesla
	name = "EngineSubmap_Tesla"
	desc = "The Telsa Engine"
	mappath = '_maps/templates/engines/tether/engine_tesla.dmm'


// Landmark for where to load in the engine on permament map
/obj/effect/landmark/engine_loader
	name = "Engine Loader"
	var/clean_turfs // A list of lists, where each list is (x, )

/obj/effect/landmark/engine_loader/New()
	if(SSmapping.engine_loader)
		warning("Duplicate engine_loader landmarks: [log_info_line(src)] and [log_info_line(SSmapping.engine_loader)]")
		delete_me = TRUE
	SSmapping.engine_loader = src
	return ..()

/obj/effect/landmark/engine_loader/proc/get_turfs_to_clean()
	. = list()
	if(clean_turfs)
		for(var/list/coords in clean_turfs)
			. += block(locate(coords[1], coords[2], src.z), locate(coords[3], coords[4], src.z))

/obj/effect/landmark/engine_loader/proc/annihilate_bounds()
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

