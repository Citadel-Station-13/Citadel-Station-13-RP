// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.

// The 'mountains' is the mining z-level, and has a lot of caves. //TODO, change this to fit for Lythios - Bloop

// POIs here spawn in two different sections, the top half and bottom half of the map.
// The bottom half should be fairly tame, with perhaps a few enviromental hazards.
// The top half is when things start getting dangerous, but the loot gets better.


 // TODO, commenting out rn as I work on it otherwise it will cause some integration issues -Bloop!
/datum/map_template/submap/level_specific/rift
	name = "Rift Content"
	desc = "Bring a coat!"
	allow_duplicates = FALSE

// 'Normal' templates get used on the bottom half, and should be safer.
/datum/map_template/submap/level_specific/rift/west_caves
	prefix = "_maps/submaps/lythios_rift/caves/"

/datum/map_template/submap/level_specific/rift/west_caves/west_caves_cavern1
	name = "Cavern 1"
	desc = "Medium Sized Rocky cavern"
	suffix = "west_caves_cavern1.dmm"
	cost = 3

/datum/map_template/submap/level_specific/rift/west_caves/west_caves_cavern2
	name = "Cavern 2"
	desc = "Small Sized Icy cavern"
	suffix = "west_caves_cavern2.dmm"
	cost = 2

/datum/map_template/submap/level_specific/rift/west_caves/west_caves_cavern13
	name = "Cavern 3"
	desc = "Small Sized Rocky cavern"
	suffix = "west_caves_cavern3.dmm"
	cost = 2

/datum/map_template/submap/level_specific/rift/west_caves/west_caves_cavern4
	name = "Cavern 4"
	desc = "Large Sized Rocky cavern"
	suffix = "west_caves_cavern4.dmm"
	cost = 4
	allow_duplicates = TRUE

/datum/map_template/submap/level_specific/rift/west_caves/west_caves_rock1
	name = "Rock 1"
	desc = "Small sized rock"
	suffix = "west_caves_rock1.dmm"
	cost = 1

/datum/map_template/submap/level_specific/rift/west_caves/west_caves_small_crystal
	name = "Crystal1"
	desc = "Small sized crystal cave"
	suffix = "west_caves_small_crystal.dmm"
	cost = 1

/datum/map_template/submap/level_specific/rift/west_caves/west_caves_survival_cave
	name = "Survival cave 1"
	desc = "Medium sized survival cave"
	suffix = "west_caves_survival_cave.dmm"
	cost = 2

// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/submap/level_specific/rift/west_deep

// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/submap/level_specific/rift/west_base


/*
	/datum/map_template/submap/level_specific/mountains/normal/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	suffix = "deadBeacon.dmm"
	cost = 10
*/
