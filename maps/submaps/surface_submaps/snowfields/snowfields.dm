// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include ".dmm"

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

//near and far replacing deep and normal
			//////////////////
			//Near templates//
			//////////////////

/datum/map_template/surface/snowfields/near/



			/////////////////
			//Far templates//
			/////////////////

/datum/map_template/surface/snowfields/far/IceCave1D
	name = "Ice Cave"
	desc = "An ice cave home to a pack of Savik and their previous meal."
	mappath = 'maps/submaps/surface_submaps/snowfields/Icecave1D.dmm'
	cost = 20

/datum/map_template/surface/snowfields/far/quarantineshuttlesnow
	name = "Ice Cave"
	desc = "An ice cave home to a pack of Savik and their previous meal."
	mappath = 'maps/submaps/surface_submaps/snowfields/quarantineshuttlesnow.dmm'
	cost = 20

