// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.


// The 'wilderness' is the endgame for Explorers. Extremely dangerous and far away from help, but with vast shinies.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The top half connects to the outpost z-level, and is seperated from the bottom half by a river. It should provide a challenge to a well equiped Explorer team.
// The bottom half should be even more dangerous, where only the robust, fortunate, or lucky can survive.

/datum/map_template/submap/level_specific/wilderness
	name = "Surface Content - Wildy"
	desc = "Used to make the surface's wilderness be 17% less boring."
	prefix = "_maps/submaps/wilderness/"

// 'Normal' templates get used on the top half, and should be challenging.
/datum/map_template/submap/level_specific/wilderness/normal

// 'Deep' templates get used on the bottom half, and should be (even more) dangerous and rewarding.
/datum/map_template/submap/level_specific/wilderness/deep

// To be added: Templates for surface exploration when they are made.

/datum/map_template/submap/level_specific/wilderness/normal/spider1
	name = "Spider Nest 1"
	desc = "A small spider nest, in the forest."
	mappath = "spider1.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Flake
	name = "Forest Lake"
	desc = "A serene lake sitting amidst the surface."
	mappath = "Flake.dmm"
	cost = 10

/datum/map_template/submap/level_specific/wilderness/normal/Mcamp1
	name = "Military Camp 1"
	desc = "A derelict military camp host to some unsavory dangers"
	mappath = "MCamp1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Mudpit
	name = "Mudpit"
	desc = "What happens when someone is a bit too careless with gas.."
	mappath = "Mudpit.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Rocky1
	name = "Rocky1"
	desc = "DununanununanununuNAnana"
	mappath = "Rocky1.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Rocky2
	name =  "Rocky2"
	desc = "More rocks."
	mappath = "Rocky2.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Rocky3
	name = "Rocky3"
	desc = "More and more and more rocks."
	mappath = "Rocky3.dmm"
	desc = "DununanununanununuNAnana"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Shack1
	name = "Shack1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	mappath = "Shack1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Smol1
	name = "Smol1"
	desc = "A tiny grove of trees, The Nemesis of thicc"
	mappath = "Smol1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Snowrock1
	name = "Snowrock1"
	desc = "A rocky snow covered area"
	mappath = "Snowrock1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Cragzone1
	name = "Cragzone1"
	desc = "Rocks and more rocks."
	mappath = "Cragzone1.dmm"
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/submap/level_specific/wilderness/normal/Lab1
	name = "Lab1"
	desc = "An isolated small robotics lab."
	mappath = "Lab1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Rocky4
	name = "Rocky4"
	desc = "An interesting geographic formation."
	mappath = "Rocky4.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/DJOutpost1
	name = "DJOutpost1"
	desc = "Home of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = "DJOutpost1.dmm"
	template_group = "Sif Free Radio"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/DJOutpost2
	name = "DJOutpost2"
	desc = "The cratered remains of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = "DJOutpost2.dmm"
	template_group = "Sif Free Radio"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/DJOutpost3
	name = "DJOutpost3"
	desc = "The surprisingly high-tech home of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = "DJOutpost3.dmm"
	template_group = "Sif Free Radio"
	cost = 10

/datum/map_template/submap/level_specific/wilderness/deep/DJOutpost4
	name = "DJOutpost4"
	desc = "The surprisingly high-tech home of Sif Free Radio, the only radio station run by mindless clones."
	mappath = "DJOutpost4.dmm"
	template_group = "Sif Free Radio"
	cost = 10

/datum/map_template/submap/level_specific/wilderness/deep/Boombase
	name = "Boombase"
	desc = "What happens when you don't follow SOP."
	mappath = "Boombase.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/BSD
	name = "Black Shuttle Down"
	desc = "You REALLY shouldn't be near this."
	mappath = "Blackshuttledown.dmm"
	cost = 30
	template_group = "Shuttle Down"

/datum/map_template/submap/level_specific/wilderness/deep/BluSD
	name = "Blue Shuttle Down"
	desc = "You REALLY shouldn't be near this. Mostly because they're Police."
	mappath = "Blueshuttledown.dmm"
	cost = 50
	template_group = "Shuttle Down"

/datum/map_template/submap/level_specific/wilderness/deep/Rockybase
	name = "Rocky Base"
	desc = "A guide to upsetting Icarus and the EIO"
	mappath = "Rockybase.dmm"
	cost = 35

/datum/map_template/submap/level_specific/wilderness/deep/MHR
	name = "Manhack Rock"
	desc = "A rock filled with nasty Synthetics."
	mappath = "MHR.dmm"
	cost = 15

/datum/map_template/submap/level_specific/wilderness/normal/GovPatrol
	name = "Government Patrol"
	desc = "A long lost SifGuard ground survey patrol. Now they have you guys!"
	mappath = "GovPatrol.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/DecoupledEngine
	name = "Decoupled Engine"
	desc = "A damaged fission engine jettisoned from a starship long ago."
	mappath = "DecoupledEngine.dmm"
	cost = 15

/datum/map_template/submap/level_specific/wilderness/deep/DoomP
	name = "DoomP"
	desc = "Witty description here."
	mappath = "DoomP.dmm"
	cost = 30

/datum/map_template/submap/level_specific/wilderness/deep/Cave
	name = "CaveS"
	desc = "Chitter chitter!"
	mappath = "CaveS.dmm"
	cost = 20

/datum/map_template/submap/level_specific/wilderness/normal/Drugden
	name = "Drugden"
	desc = "The remains of ill thought out whims."
	mappath = "Drugden.dmm"
	cost = 20

/datum/map_template/submap/level_specific/wilderness/normal/Musk
	name = "Musk"
	desc = "0 to 60 in 1.9 seconds."
	mappath = "Musk.dmm"
	cost = 10

/datum/map_template/submap/level_specific/wilderness/deep/Manor1
	name = "Manor1"
	desc = "Whodunit"
	mappath = "Manor1.dmm"
	cost = 20

/datum/map_template/submap/level_specific/wilderness/deep/Epod3
	name = "Emergency Pod 3"
	desc = "A webbed Emergency pod in the middle of nowhere."
	mappath = "Epod3.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Epod4
	name = "Emergency Pod 4"
	desc = "A flooded Emergency pod in the middle of nowhere."
	mappath = "Epod4.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/ButcherShack
	name = "Butcher Shack"
	desc = "An old, bloody butcher's shack. Get your meat here!"
	mappath = "ButcherShack.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/Chapel1
	name = "Chapel1"
	desc = "The chapel of lights and a robot."
	mappath = "Chapel.dmm"
	cost = 20

/datum/map_template/submap/level_specific/wilderness/normal/Shelter1
	name = "Shelter1"
	desc = "The remains of a resourceful, but prideful explorer."
	mappath = "Shelter.dmm"
	cost = 10
