// This causes engine maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new engine, please add it to this list.
#if MAP_TEST
#include "engine_rust.dmm"
#include "engine_singulo.dmm"
#include "engine_sme.dmm"
#endif

/datum/map_template/engine
	name = "Engine Content"
	desc = "It would be boring to have the same engine every day right?"
	abstract_type = /datum/map_template/engine
	id = "engine"
	autoinit = TRUE
	// annihilate = TRUE - Would wipe out in a rectangular area unfortunately
	// allow_duplicates = FALSE

/datum/map_template/engine/rust
	name = "R-UST Engine"
	desc = "R-UST Fusion Tokamak Engine"
	id = "engine_rust"
	mappath = 'maps/submaps/engine_submaps/engine_rust.dmm'

/datum/map_template/engine/singulo
	name = "Singularity Engine"
	desc = "Lord Singuloth"
	id = "engine_singulo"
	mappath = 'maps/submaps/engine_submaps/engine_singulo.dmm'

/datum/map_template/engine/supermatter
	name = "Supermatter Engine"
	desc = "Old Faithful Supermatter"
	id = "engine_supermatter"
	mappath = 'maps/submaps/engine_submaps/engine_sme.dmm'

/datum/map_template/engine/tesla
	name = "Edison's Bane"
	desc = "The Tesla Engine"
	id = "engine_tesla"
	mappath = 'maps/submaps/engine_submaps/engine_tesla.dmm'

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
	admin_notice("<span class='danger'>Annihilating objects in engine loading locatation.</span>", R_DEBUG)
	var/list/turfs_to_clean = get_turfs_to_clean()
	for(var/i in turfs_to_clean)
		var/turf/T = i
		T.empty()
