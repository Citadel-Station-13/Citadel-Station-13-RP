// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "DestroyedPod.dmm"
#include "DiyaabEpod.dmm"
#include "Icecave1D.dmm"
#include "QuarantineShuttleSnow.dmm"
#include "SPatrol1.dmm"
#endif

//The snowfields are a wide open field coated in a blanket of snow, contains no caves, and is dangerous without proper heat insulation and armor.
//POIs here spawn in two different sections, the points marked far and the points marked near, which the map file details.
//The right side of the map is marked 'far', while the shuttle and left side is marked near.
//'Near' will be less threatening than 'far' and will have more passive mobs, but will still allow spawns to occur close to the LZ.
//'Far' will have more dangerous mob spawns, as well as larger and more rewarding POIs.

/datum/map_template/surface/snowfields
	name = "Snowfield Content"
	desc = "Bring a coat!"

// 'Near' templates get used on the bottom half, and should be safer.
/datum/map_template/surface/snowfields/near

// 'Far' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/surface/snowfields/far

			//////////////////
			//Near templates//
			//////////////////

/datum/map_template/surface/snowfields/near/

/datum/map_template/surface/snowfields/near/destroyedpod
	name = "Destroyed Pod"
	desc = "A pod smashed upon impact, its contents redused to piles of scrap."
	mappath = 'maps/submaps/surface_submaps/snowfields/DestroyedPod.dmm'
	cost = 5
	allow_duplicates = FALSE

/datum/map_template/surface/snowfields/near/diyaabepod
	name = "Diyaab Epod"
	desc = "An escape pod suffering a hard landing on the surface of the planet, its passenger food for a pack of ravenous Diyaabs."
	mappath = 'maps/submaps/surface_submaps/snowfields/DiyaabEpod.dmm'
	cost = 5
	allow_duplicates = FALSE

			/////////////////
			//Far templates//
			/////////////////

/datum/map_template/surface/snowfields/far/crashedshuttlefront
	name = "Syndicate Patrol 1"
	desc = "The remains of a research vessal now overtaken by stranded russians."
	mappath = 'maps/submaps/surface_submaps/snowfields/CrashedShuttleFront.dmm'
	cost = 10

/datum/map_template/surface/snowfields/far/icecave1D
	name = "Ice Cave"
	desc = "An ice cave home to a pack of Savik and their previous meal."
	mappath = 'maps/submaps/surface_submaps/snowfields/Icecave1D.dmm'
	cost = 20
	annihilate = TRUE

/datum/map_template/surface/snowfields/far/quarantineshuttlesnow
	name = "Quarantined Shuttle(snow)"
	desc = "A quarantined shuttle that holds a gruesome horror within."
	mappath = 'maps/submaps/surface_submaps/snowfields/QuarantineShuttleSnow.dmm'
	cost = 15

/datum/map_template/surface/snowfields/far/spatrol1
	name = "Syndicate Patrol 1"
	desc = "A Syndicate patrol, patrolling, of course."
	mappath = 'maps/submaps/surface_submaps/snowfields/SPatrol1.dmm'
	cost = 10
