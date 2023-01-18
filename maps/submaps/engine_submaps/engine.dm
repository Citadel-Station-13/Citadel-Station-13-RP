// This causes engine maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new engine, please add it to this list.

/datum/map_template/engine
	name = "Engine Content"
	desc = "It would be boring to have the same engine every day right?"
	// annihilate = TRUE - Would wipe out in a rectangular area unfortunately
	allow_duplicates = FALSE
	/// world announce name
	var/display_name

/datum/map_template/engine/New()
	. = ..()
	if(isnull(display_name))
		display_name = name

/datum/map_template/engine/rust
	name = "EngineSubmap_RUST"
	desc = "R-UST Fusion Tokamak Engine"
	mappath = "_maps/templates/engines/triumph/triumph_engine_rust.dmm"
	display_name = "Budget Star"

/*
/datum/map_template/engine/singulo
	name = "Singularity Engine"
	desc = "Lord Singuloth"
	mappath = '_maps/templates/engines/triumph/engine_singulo.dmm'
*/

/datum/map_template/engine/supermatter
	name = "EngineSubmap_SM"
	desc = "Old Faithful Supermatter"
	mappath = "_maps/templates/engines/triumph/triumph_engine_sme.dmm"
	display_name = "Angry Rock"

/*
/datum/map_template/engine/tesla
	name = "Edison's Bane"
	desc = "The Telsa Engine"
	mappath = '_maps/templates/engines/triumph/engine_tesla.dmm'
*/

/datum/map_template/engine/burnchamber
	name = "EngineSubmap_Burn"
	desc = "Burn Chamber Engine"
	mappath = "_maps/templates/engines/triumph/triumph_engine_burnchamber.dmm"
	display_name = "Toxins Lab"

/datum/map_template/engine/fission
	name = "EngineSubmap_Fission"
	desc = "The Fission Reactor"
	mappath = "_maps/templates/engines/triumph/triumph_engine_fission.dmm"
	display_name = "Nuclear Bomb"

// Landmark for where to load in the engine on permament map
/obj/landmark/engine_loader
	name = "Engine Loader"
	var/clean_turfs // A list of lists, where each list is (x, )

/obj/landmark/engine_loader/Initialize(mapload)
	. = ..()
	if(SSmapping.engine_loader)
		warning("Duplicate engine_loader landmarks: [log_info_line(src)] and [log_info_line(SSmapping.engine_loader)]")
		return INITIALIZE_HINT_QDEL
	SSmapping.engine_loader = src

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

