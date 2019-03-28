// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include ".dmm"

#endif

// The snowfields are a wide open field coated in a blanket of snow, contains no caves, and is dangerous without proper heat insulation and armor.
// POIs here spawn in two different sections, the points marked far and the points marked near, which the map file details.
// The right side of the map is marked 'far', while the shuttle and left side is marked near.
// 'Near' will be less threatening than 'far', but will still allow spawns to occur close to the LZ.

/datum/map_template/surface/snowfields
	name = "Snowfield Content"
	desc = "Bring a coat!"

// 'Near' templates get used on the bottom half, and should be safer.
/datum/map_template/surface/mountains/normal

// 'Far' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/surface/mountains/deep

//near and far replacing deep and normal
			//////////////////
			//Near templates//
			//////////////////

/*/datum/map_template/surface/snowfields/near/
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	mappath = 'maps/submaps/surface_submaps/mountains/deadBeacon.dmm'
	cost = 10
*/


			/////////////////
			//Far templates//
			/////////////////

