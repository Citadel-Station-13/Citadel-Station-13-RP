// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.

// The 'mountains' is the mining z-level, and has a lot of caves. //TODO, change this to fit for Lythios - Bloop

// POIs here spawn in two different sections, the top half and bottom half of the map.
// The bottom half should be fairly tame, with perhaps a few enviromental hazards.
// The top half is when things start getting dangerous, but the loot gets better.


/* // TODO, commenting out rn as I work on it otherwise it will cause some integration issues -Bloop!
/datum/map_template/submap/level_specific/rift
	name = "Rift Content"
	desc = "Don't dig too deep!"
	prefix = "_maps/submaps/rift/"

// 'Normal' templates get used on the bottom half, and should be safer.
/datum/map_template/submap/level_specific/rift/west_caves




// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/submap/level_specific/rift/west_deep

// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/submap/level_specific/rift/west_base


/datum/map_template/submap/level_specific/rift/west_caves
	name = "Shitty Rock thing I just made"
	desc = "Debug to see if I can get this work -Bloop."
	suffix = "geothermal_vent.dmm"
	cost = 0
	allow_duplicates = TRUE
*/

/*
	/datum/map_template/submap/level_specific/mountains/normal/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	suffix = "deadBeacon.dmm"
	cost = 10
*/
