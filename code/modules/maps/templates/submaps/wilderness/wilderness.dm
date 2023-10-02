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
	prefix = "maps/submaps/wilderness/"

// 'Normal' templates get used on the top half, and should be challenging.
/datum/map_template/submap/level_specific/wilderness/normal

// 'Deep' templates get used on the bottom half, and should be (even more) dangerous and rewarding.
/datum/map_template/submap/level_specific/wilderness/deep

// To be added: Templates for surface exploration when they are made.

/datum/map_template/submap/level_specific/wilderness/normal/spider1
	name = "Spider Nest 1"
	desc = "A small spider nest, in the forest."
	suffix = "spider1.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Flake
	name = "Forest Lake"
	desc = "A serene lake sitting amidst the surface."
	suffix = "Flake.dmm"
	cost = 10

/datum/map_template/submap/level_specific/wilderness/normal/Mcamp1
	name = "Military Camp 1"
	desc = "A derelict military camp host to some unsavory dangers"
	suffix = "MCamp1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Mudpit
	name = "Mudpit"
	desc = "What happens when someone is a bit too careless with gas.."
	suffix = "Mudpit.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Rocky1
	name = "Rocky1"
	desc = "DununanununanununuNAnana"
	suffix = "Rocky1.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Rocky2
	name =  "Rocky2"
	desc = "More rocks."
	suffix = "Rocky2.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Rocky3
	name = "Rocky3"
	desc = "More and more and more rocks."
	suffix = "Rocky3.dmm"
	desc = "DununanununanununuNAnana"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Shack1
	name = "Shack1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	suffix = "Shack1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Smol1
	name = "Smol1"
	desc = "A tiny grove of trees, The Nemesis of thicc"
	suffix = "Smol1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Snowrock1
	name = "Snowrock1"
	desc = "A rocky snow covered area"
	suffix = "Snowrock1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Cragzone1
	name = "Cragzone1"
	desc = "Rocks and more rocks."
	suffix = "Cragzone1.dmm"
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/submap/level_specific/wilderness/normal/Lab1
	name = "Lab1"
	desc = "An isolated small robotics lab."
	suffix = "Lab1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Rocky4
	name = "Rocky4"
	desc = "An interesting geographic formation."
	suffix = "Rocky4.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/DJOutpost1
	name = "DJOutpost1"
	desc = "Home of Sif Free Radio, the best - and only - radio station for miles around."
	suffix = "DJOutpost1.dmm"
	template_group = "Sif Free Radio"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/DJOutpost2
	name = "DJOutpost2"
	desc = "The cratered remains of Sif Free Radio, the best - and only - radio station for miles around."
	suffix = "DJOutpost2.dmm"
	template_group = "Sif Free Radio"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/DJOutpost3
	name = "DJOutpost3"
	desc = "The surprisingly high-tech home of Sif Free Radio, the best - and only - radio station for miles around."
	suffix = "DJOutpost3.dmm"
	template_group = "Sif Free Radio"
	cost = 10

/datum/map_template/submap/level_specific/wilderness/deep/DJOutpost4
	name = "DJOutpost4"
	desc = "The surprisingly high-tech home of Sif Free Radio, the only radio station run by mindless clones."
	suffix = "DJOutpost4.dmm"
	template_group = "Sif Free Radio"
	cost = 10

/datum/map_template/submap/level_specific/wilderness/deep/Boombase
	name = "Boombase"
	desc = "What happens when you don't follow SOP."
	suffix = "Boombase.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/BSD
	name = "Black Shuttle Down"
	desc = "You REALLY shouldn't be near this."
	suffix = "Blackshuttledown.dmm"
	cost = 30
	template_group = "Shuttle Down"

/datum/map_template/submap/level_specific/wilderness/deep/BluSD
	name = "Blue Shuttle Down"
	desc = "You REALLY shouldn't be near this. Mostly because they're Police."
	suffix = "Blueshuttledown.dmm"
	cost = 50
	template_group = "Shuttle Down"

/datum/map_template/submap/level_specific/wilderness/deep/Rockybase
	name = "Rocky Base"
	desc = "A guide to upsetting Icarus and the EIO"
	suffix = "Rockybase.dmm"
	cost = 35

/datum/map_template/submap/level_specific/wilderness/deep/MHR
	name = "Manhack Rock"
	desc = "A rock filled with nasty Synthetics."
	suffix = "MHR.dmm"
	cost = 15

/datum/map_template/submap/level_specific/wilderness/normal/GovPatrol
	name = "Government Patrol"
	desc = "A long lost SifGuard ground survey patrol. Now they have you guys!"
	suffix = "GovPatrol.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/DecoupledEngine
	name = "Decoupled Engine"
	desc = "A damaged fission engine jettisoned from a starship long ago."
	suffix = "DecoupledEngine.dmm"
	cost = 15

/datum/map_template/submap/level_specific/wilderness/deep/DoomP
	name = "DoomP"
	desc = "Witty description here."
	suffix = "DoomP.dmm"
	cost = 30

/datum/map_template/submap/level_specific/wilderness/deep/Cave
	name = "CaveS"
	desc = "Chitter chitter!"
	suffix = "CaveS.dmm"
	cost = 20

/datum/map_template/submap/level_specific/wilderness/normal/Drugden
	name = "Drugden"
	desc = "The remains of ill thought out whims."
	suffix = "Drugden.dmm"
	cost = 20

/datum/map_template/submap/level_specific/wilderness/normal/Musk
	name = "Musk"
	desc = "0 to 60 in 1.9 seconds."
	suffix = "Musk.dmm"
	cost = 10

/datum/map_template/submap/level_specific/wilderness/deep/Manor1
	name = "Manor1"
	desc = "Whodunit"
	suffix = "Manor1.dmm"
	cost = 20

/datum/map_template/submap/level_specific/wilderness/deep/Epod3
	name = "Emergency Pod 3"
	desc = "A webbed Emergency pod in the middle of nowhere."
	suffix = "Epod3.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/Epod4
	name = "Emergency Pod 4"
	desc = "A flooded Emergency pod in the middle of nowhere."
	suffix = "Epod4.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/normal/ButcherShack
	name = "Butcher Shack"
	desc = "An old, bloody butcher's shack. Get your meat here!"
	suffix = "butchershack.dmm"
	cost = 5

/datum/map_template/submap/level_specific/wilderness/deep/Chapel1
	name = "Chapel1"
	desc = "The chapel of lights and a robot."
	suffix = "Chapel.dmm"
	cost = 20

/datum/map_template/submap/level_specific/wilderness/normal/Shelter1
	name = "Shelter1"
	desc = "The remains of a resourceful, but prideful explorer."
	suffix = "Shelter.dmm"
	cost = 10
