// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "spider1.dmm"
#include "Flake.dmm"
#include "MCamp1.dmm"
#include "Rocky1.dmm"
#include "Rocky2.dmm"
#include "Rocky3.dmm"
#include "Shack1.dmm"
#include "Smol1.dmm"
#include "Mudpit.dmm"
#include "Snowrock1.dmm"
#include "Boombase.dmm"
#include "Blackshuttledown.dmm"
#include "Lab1.dmm"
#include "Rocky4.dmm"
#include "DJOutpost1.dmm"
#include "DJOutpost2.dmm"
#include "Rockybase.dmm"
#include "MHR.dmm"
#include "GovPatrol.dmm"
#include "DecoupledEngine.dmm"
#include "DoomP.dmm"
#include "CaveS.dmm"
#include "Drugden.dmm"
#include "Musk.dmm"
#include "Manor1.dmm"

#endif

// The 'wilderness' is the endgame for Explorers. Extremely dangerous and far away from help, but with vast shinies.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The top half connects to the outpost z-level, and is seperated from the bottom half by a river. It should provide a challenge to a well equiped Explorer team.
// The bottom half should be even more dangerous, where only the robust, fortunate, or lucky can survive.
// Cit change: This seems to control V2 now for whatever reason, though the stuff said above applies for spawning, as the lower half still houses the dangerous stuff.

/datum/map_template/submap/surface/wilderness
	name = "Surface Content - Wildy"
	desc = "Used to make the surface's wilderness be 17% less boring."
	abstract_type = /datum/map_template/submap/surface/wilderness

// 'Normal' templates get used on the top half, and should be challenging.
/datum/map_template/submap/surface/wilderness/normal
	abstract_type = /datum/map_template/submap/surface/wilderness/normal

// 'Deep' templates get used on the bottom half, and should be (even more) dangerous and rewarding.
/datum/map_template/submap/surface/wilderness/deep
	abstract_type = /datum/map_template/submap/surface/wilderness/deep

// To be added: Templates for surface exploration when they are made.

/datum/map_template/submap/surface/wilderness/normal/spider1
	name = "Spider Nest 1"
	desc = "A small spider nest, in the forest."
	id = "surface_spider1"
	mappath = 'maps/submaps/surface_submaps/wilderness/spider1.dmm'
	allow_duplicates = TRUE
	cost = 1

/datum/map_template/submap/surface/wilderness/normal/Flake
	name = "Forest Lake"
	id = "surface_forestlake"
	desc = "A serene lake sitting amidst the surface."
	mappath = 'maps/submaps/surface_submaps/wilderness/Flake.dmm'
	cost = 3

/datum/map_template/submap/surface/wilderness/normal/Mcamp1
	name = "Military Camp 1"
	id = "surface_milcamp"
	desc = "A derelict military camp host to some unsavory dangers"
	mappath = 'maps/submaps/surface_submaps/wilderness/MCamp1.dmm'
	cost = 1

/datum/map_template/submap/surface/wilderness/normal/Mudpit
	name = "Mudpit"
	id = "surface_mudpit"
	desc = "What happens when someone is a bit too careless with gas.."
	mappath = 'maps/submaps/surface_submaps/wilderness/Mudpit.dmm'
	cost = 1

/datum/map_template/submap/surface/wilderness/normal/Rocky1
	name = "Rocky1"
	id = "surface_rocky1"
	desc = "DununanununanununuNAnana"
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky1.dmm'
	allow_duplicates = TRUE
	cost = 1

/datum/map_template/submap/surface/wilderness/normal/Rocky2
	name =  "Rocky2"
	id = "surface_rocky2"
	desc = "More rocks."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky2.dmm'
	allow_duplicates = TRUE
	cost = 1

/datum/map_template/submap/surface/wilderness/normal/Rocky3
	name = "Rocky3"
	id = "surface_rocky3"
	desc = "More and more and more rocks."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky3.dmm'
	desc = "DununanununanununuNAnana"
	cost = 1

/datum/map_template/submap/surface/wilderness/normal/Shack1
	name = "Shack1"
	id = "surface_shack1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	mappath = 'maps/submaps/surface_submaps/wilderness/Shack1.dmm'
	allow_duplicates = FALSE //Cit change; these spawn everywhere, cluttering the place with pretty much nothing, and wasting points
	cost = 3

///datum/map_template/surface/wilderness/normal/Smol1
//	name = "Smol1"
//	id = "surface_smol1"
//	desc = "A tiny grove of trees, The Nemesis of thicc"
//	mappath = 'maps/submaps/surface_submaps/wilderness/Smol1.dmm'
//	cost = 2
//cit change; this dosnt even spawn in v2, or anywhere else and eats up a fuckton of init time, disabled.

/datum/map_template/submap/surface/wilderness/normal/Snowrock1
	name = "Snowrock1"
	id = "surface_snowrock1"
	desc = "A rocky snow covered area"
	mappath = 'maps/submaps/surface_submaps/wilderness/Snowrock1.dmm'
	cost = 3

///datum/map_template/surface/wilderness/normal/Cragzone1
//	name = "Cragzone1"
//	desc = "Rocks and more rocks."
//	id = "surface_cragzone1"
//	mappath = 'maps/submaps/surface_submaps/wilderness/Cragzone1.dmm'
//	cost = 5
//	allow_duplicates = TRUE
//Cit change; I dunno why this is here it takes up a massive space with no loot, a default cost of 5, and it ALLOWS FOR MORE THAN ONE??

/datum/map_template/submap/surface/wilderness/normal/Lab1
	name = "Lab1"
	id = "surface_lab1"
	desc = "An isolated small robotics lab."
	mappath = 'maps/submaps/surface_submaps/wilderness/Lab1.dmm'
	cost = 1

/datum/map_template/submap/surface/wilderness/normal/Rocky4
	name = "Rocky4"
	id = "surface_rocky4"
	desc = "An interesting geographic formation."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky4.dmm'
	cost = 1

/datum/map_template/submap/surface/wilderness/deep/DJOutpost1
	name = "DJOutpost1"
	id = "surface_djoutpost1"
	desc = "Home of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = 'maps/submaps/surface_submaps/wilderness/DJOutpost1.dmm'
	template_group = "Sif Free Radio"
	cost = 2

/datum/map_template/submap/surface/wilderness/deep/DJOutpost2
	name = "DJOutpost2"
	id = "surface_djoutpost2"
	desc = "The cratered remains of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = 'maps/submaps/surface_submaps/wilderness/DJOutpost2.dmm'
	template_group = "Sif Free Radio"
	cost = 2

/datum/map_template/submap/surface/wilderness/deep/Boombase
	name = "Boombase"
	id = "surface_boombase"
	desc = "What happens when you don't follow SOP."
	mappath = 'maps/submaps/surface_submaps/wilderness/Boombase.dmm'
	cost = 2

/datum/map_template/submap/surface/wilderness/deep/BSD
	name = "Black Shuttle Down"
	id = "surface_blackshuttledown"
	desc = "You REALLY shouldn't be near this."
	mappath = 'maps/submaps/surface_submaps/wilderness/Blackshuttledown.dmm'
	cost = 10

/datum/map_template/submap/surface/wilderness/deep/Rockybase
	name = "Rocky Base"
	id = "surface_rockybase"
	desc = "A guide to upsetting Icarus and the EIO"
	mappath = 'maps/submaps/surface_submaps/wilderness/Rockybase.dmm'
	cost = 12

/datum/map_template/submap/surface/wilderness/deep/MHR
	name = "Manhack Rock"
	id = "surface_manhack"
	desc = "A rock filled with nasty Synthetics."
	mappath = 'maps/submaps/surface_submaps/wilderness/MHR.dmm'
	cost = 2

/datum/map_template/submap/surface/wilderness/normal/GovPatrol
	name = "Government Patrol"
	id = "surface_govpatrol"
	desc = "A long lost SifGuard ground survey patrol. Now they have you guys!"
	mappath = 'maps/submaps/surface_submaps/wilderness/GovPatrol.dmm'
	cost = 1

/datum/map_template/submap/surface/wilderness/normal/DecoupledEngine
	name = "Decoupled Engine"
	id = "surface_crashed_engine"
	desc = "A damaged fission engine jettisoned from a starship long ago."
	mappath = 'maps/submaps/surface_submaps/wilderness/DecoupledEngine.dmm'
	cost = 3

/datum/map_template/submap/surface/wilderness/deep/DoomP
	name = "DoomP"
	id = "surface_doomp"
	desc = "Witty description here."
	mappath = 'maps/submaps/surface_submaps/wilderness/DoomP.dmm'
	cost = 10

/datum/map_template/submap/surface/wilderness/deep/Cave
	name = "CaveS"
	id = "surface_spidercave"
	desc = "Chitter chitter!"
	mappath = 'maps/submaps/surface_submaps/wilderness/CaveS.dmm'
	cost = 6

/datum/map_template/submap/surface/wilderness/normal/Drugden
	name = "Drugden"
	id = "surface_drugden"
	desc = "The remains of ill thought out whims."
	mappath = 'maps/submaps/surface_submaps/wilderness/Drugden.dmm'
	cost = 6

/datum/map_template/submap/surface/wilderness/normal/Musk
	name = "Musk"
	id = "surface_musk"
	desc = "0 to 60 in 1.9 seconds."
	mappath = 'maps/submaps/surface_submaps/wilderness/Musk.dmm'
	cost = 3

/datum/map_template/submap/surface/wilderness/deep/Manor1
	name = "Manor1"
	id = "surface_manor1"
	desc = "Whodunit"
	mappath = 'maps/submaps/surface_submaps/wilderness/Manor1.dmm'
	cost = 6