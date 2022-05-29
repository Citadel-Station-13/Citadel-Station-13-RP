// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.

// The 'plains' is the area outside the immediate perimeter of the big outpost.
// POIs here should not be dangerous, be mundane, and be somewhat conversative on the loot. Some of the loot can be useful, but it shouldn't trivialize the Wilderness.

/datum/map_template/submap/level_specific/plains
	name = "Surface Content - Plains"
	desc = "Used to make the surface outside the outpost be 16% less boring."
	prefix = "_maps/submaps/plains/"

// To be added: Templates for surface exploration when they are made.

/datum/map_template/submap/level_specific/plains/farm1
	name = "Farm 1"
	desc = "A small farm tended by a farmbot."
	suffix = "farm1_vr.dmm"
	cost = 10

/datum/map_template/submap/level_specific/plains/construction1
	name = "Construction Site 1"
	desc = "A structure being built. It seems laziness is not limited to engineers."
	suffix = "construction1.dmm"
	cost = 10

/datum/map_template/submap/level_specific/plains/camp1
	name = "Camp Site 1"
	desc = "A small campsite, complete with housing and bonfire."
	suffix = "camp1_vr.dmm"
	cost = 10

/datum/map_template/submap/level_specific/plains/house1
	name = "House 1"
	desc = "A fair sized house out in the frontier, that belonged to a well-traveled explorer."
	suffix = "house1_vr.dmm"
	cost = 10

/datum/map_template/submap/level_specific/plains/beacons
	name = "Collection of Marker Beacons"
	desc = "A bunch of marker beacons, scattered in a strange pattern."
	suffix = "beacons.dmm"
	cost = 5
	fixed_orientation = TRUE

/datum/map_template/submap/level_specific/plains/Epod
	name = "Emergency Pod"
	desc = "A vacant Emergency pod in the middle of nowhere."
	suffix = "Epod.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/Epod2
	name = "Emergency Pod 2"
	desc = "A locked Emergency pod in the middle of nowhere."
	suffix = "Epod2.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/normal/Rocky2
	name =  "Rocky2"
	desc = "More rocks."
	mappath = "maps/submaps/surface_submaps/wilderness/Rocky2.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/submap/level_specific/plains/PascalB
	name = "Irradiated Manhole Cover"
	desc = "How did this old thing get all the way out here?"
	suffix = "PascalB.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/bonfire
	name = "Abandoned Bonfire"
	desc = "Someone seems to enjoy orange juice a bit too much."
	suffix = "bonfire.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/Rocky5
	name = "Rocky 5"
	desc = "More rocks, Less Stalone"
	suffix = "Rocky5.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/Shakden
	name = "Shakden"
	desc = "Not to be confused with Shaq Den"
	suffix = "Shakden_vr.dmm"
	cost = 10

/datum/map_template/submap/level_specific/plains/Field1
	name = "Field 1"
	desc = "A regular field with a tug on it"
	suffix = "Field1.dmm"
	cost = 20

/datum/map_template/submap/level_specific/plains/Thiefc
	name = "Thieves Cave"
	desc = "A thieves stash"
	suffix = "Thiefc_vr.dmm"
	cost = 20

/datum/map_template/submap/level_specific/plains/smol2
	name = "Small 2"
	desc = "A small formation of mishaped surgery"
	suffix = "smol2.dmm"
	cost = 10

/datum/map_template/submap/level_specific/plains/Mechpt
	name = "Mechpit"
	desc = "A illmade Mech brawling ring"
	suffix = "Mechpt.dmm"
	cost = 15

/datum/map_template/submap/level_specific/plains/Boathouse
	name = "Boathouse"
	desc = "A fance house on a lake."
	suffix = "Boathouse_vr.dmm"
	cost = 30

/datum/map_template/submap/level_specific/plains/PooledR
	name = "Pooled Rocks"
	desc = "An intresting rocky location"
	suffix = "PooledR_vr.dmm"
	cost = 15

/datum/map_template/submap/level_specific/plains/Smol3
	name = "Small 3"
	desc = "A small stand"
	suffix = "Smol3.dmm"
	cost = 10

/datum/map_template/submap/level_specific/plains/Diner
	name = "Diner"
	desc = "Old Timey Tasty"
	suffix = "Diner_vr.dmm"
	cost = 25

/datum/map_template/submap/level_specific/plains/snow1
	name = "Snow1"
	desc = "Snow"
	suffix = "snow1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/snow2
	name = "Snow2"
	desc = "More snow"
	suffix = "snow2.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/snow3
	name = "Snow3"
	desc = "Snow Snow Snow"
	suffix = "snow3.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/snow4
	name = "Snow4"
	desc = "Too much snow"
	suffix = "snow4.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/snow5
	name = "Snow5"
	desc = "Please stop the snow"
	suffix = "snow5.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/RationCache
	name = "Ration Cache"
	desc = "A forgotten cache of emergency rations."
	suffix = "RationCache_vr.dmm"
	cost = 5

/datum/map_template/submap/level_specific/plains/SupplyDrop2
	name = "Supply Drop 2"
	desc = "A drop pod that's clearly been here a while, most of the things inside are rusted and worthless."
	suffix = "SupplyDrop2.dmm"
	cost = 8

/datum/map_template/submap/level_specific/plains/Oldhouse
	name = "Oldhouse"
	desc = "Someones old library it seems.."
	suffix = "Oldhouse_vr.dmm"
	cost = 15
