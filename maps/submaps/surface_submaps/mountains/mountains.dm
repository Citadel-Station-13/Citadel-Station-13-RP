// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "deadBeacon.dmm"
#include "prepper1.dmm"
#include "quarantineshuttle.dmm"
#include "Mineshaft1.dmm"
#include "Scave1.dmm"
#include "crashed_ufo.dmm"
#include "crystal1.dmm"
#include "crystal2.dmm"
#include "crystal3.dmm"
#include "lost_explorer.dmm"
#include "CaveTrench.dmm"
#include "Cavelake.dmm"
#include "Rockb1.dmm"
#include "ritual.dmm"
#include "temple.dmm"
#include "CrashedMedShuttle1.dmm"
#include "digsite.dmm"
#include "vault1.dmm"
#include "vault2.dmm"
#include "vault3.dmm"
#include "vault4.dmm"
#include "vault5.dmm"
#include "IceCave1A.dmm"
#include "IceCave1B.dmm"
#include "IceCave1C.dmm"
#include "SwordCave.dmm"
#include "SupplyDrop1.dmm"
#include "BlastMine1.dmm"
#include "crashedcontainmentshuttle.dmm"
#include "deadspy.dmm"
#include "lava_trench.dmm"
#endif

// The 'mountains' is the mining z-level, and has a lot of caves.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The bottom half should be fairly tame, with perhaps a few enviromental hazards.
// The top half is when things start getting dangerous, but the loot gets better.

/datum/map_template/submap/surface/mountains
	name = "Mountain Content"
	desc = "Don't dig too deep!"
	abstract_type = /datum/map_template/submap/surface/mountains
	id = "mountain_"

// 'Normal' templates get used on the bottom half, and should be safer.
/datum/map_template/submap/surface/mountains/normal
	abstract_type = /datum/map_template/submap/surface/mountains/normal

// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/submap/surface/mountains/deep
	abstract_type = /datum/map_template/submap/surface/mountains/deep

// To be added: Templates for cave exploration when they are made.

/****************
 * Normal Caves *
 ****************/

/datum/map_template/submap/surface/mountains/normal/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	id = "mountain_relay"
	mappath = 'maps/submaps/surface_submaps/mountains/deadBeacon.dmm'
	cost = 3

/datum/map_template/submap/surface/mountains/normal/prepper1
	name = "Prepper Bunker"
	desc = "A little hideaway for someone with more time and money than sense."
	id = "mountain_bunker"
	mappath = 'maps/submaps/surface_submaps/mountains/prepper1.dmm'
	cost = 4

/datum/map_template/submap/surface/mountains/normal/qshuttle
	name = "Quarantined Shuttle"
	desc = "An emergency landing turned viral outbreak turned tragedy."
	mappath = 'maps/submaps/surface_submaps/mountains/quarantineshuttle.dmm'
	id = "mountain_crashed_shuttle_quarantine"
	cost = 6

/datum/map_template/submap/surface/mountains/normal/Mineshaft1
	name = "Abandoned Mineshaft 1"
	desc = "An abandoned minning tunnel from a lost money making effort."
	mappath = 'maps/submaps/surface_submaps/mountains/Mineshaft1.dmm'
	id = "mountain_mineshaft1"
	cost = 1

/datum/map_template/submap/surface/mountains/normal/crystal1
	name = "Crystal Cave 1"
	desc = "A small cave with glowing gems and diamonds."
	mappath = 'maps/submaps/surface_submaps/mountains/crystal1.dmm'
	id = "mountain_crystal1"
	cost = 1
	allow_duplicates = TRUE

/datum/map_template/submap/surface/mountains/normal/crystal2
	name = "Crystal Cave 2"
	desc = "A moderate sized cave with glowing gems and diamonds."
	mappath = 'maps/submaps/surface_submaps/mountains/crystal2.dmm'
	id = "mountain_crystal2"
	cost = 2
	allow_duplicates = TRUE

/datum/map_template/submap/surface/mountains/normal/crystal2
	name = "Crystal Cave 3"
	desc = "A large spiral of crystals with diamonds in the center."
	id = "mountain_crystal3"
	mappath = 'maps/submaps/surface_submaps/mountains/crystal3.dmm'
	cost = 5

/datum/map_template/submap/surface/mountains/normal/lost_explorer
	name = "Lost Explorer"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment."
	id = "mountain_explorer_remains"
	mappath = 'maps/submaps/surface_submaps/mountains/lost_explorer.dmm'
	cost = 2
	allow_duplicates = TRUE

/datum/map_template/submap/surface/mountains/normal/Rockb1
	name = "Rocky Base 1"
	desc = "Someones underground hidey hole"
	id = "mountain_base1"
	mappath = 'maps/submaps/surface_submaps/mountains/Rockb1.dmm'
	cost = 5

/datum/map_template/submap/surface/mountains/normal/corgiritual
	name = "Dark Ritual"
	desc = "Who put all these plushies here? What are they doing?"
	id = "mountain_ritual"
	mappath = 'maps/submaps/surface_submaps/mountains/ritual.dmm'
	cost = 5

/datum/map_template/submap/surface/mountains/normal/abandonedtemple
	name = "Abandoned Temple"
	desc = "An ancient temple, long since abandoned. Perhaps alien in origin?"
	mappath = 'maps/submaps/surface_submaps/mountains/temple.dmm'
	id = "mountain_temple"
	cost = 6

/datum/map_template/submap/surface/mountains/normal/crashedmedshuttle
	name = "Crashed Med Shuttle"
	desc = "A medical response shuttle that went missing some time ago. So this is where they went."
	mappath = 'maps/submaps/surface_submaps/mountains/CrashedMedShuttle1.dmm'
	id = "mountain_crashed_shuttle_med"
	cost = 6

/datum/map_template/submap/surface/mountains/normal/digsite
	name = "Dig Site"
	desc = "A small abandoned dig site."
	mappath = 'maps/submaps/surface_submaps/mountains/digsite.dmm'
	id = "mountain_digsite"
	cost = 3

/datum/map_template/submap/surface/mountains/normal/vault1
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains/vault1.dmm'
	id = "minevault1_s"
	cost = 2
	allow_duplicates = TRUE

/datum/map_template/submap/surface/mountains/normal/vault2
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains/vault2.dmm'
	id = "minevault2_s"
	cost = 2
	allow_duplicates = TRUE

/datum/map_template/submap/surface/mountains/normal/vault3
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	mappath = 'maps/submaps/surface_submaps/mountains/vault3.dmm'
	id = "minevault3_s"
	cost = 5

/datum/map_template/submap/surface/mountains/normal/IceCave1A
	name = "Ice Cave 1A"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains/IceCave1A.dmm'
	id = "mountain_icecave1"
	cost = 3

/datum/map_template/submap/surface/mountains/normal/IceCave1B
	name = "Ice Cave 1B"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains/IceCave1B.dmm'
	id = "mountain_icecave2"
	cost = 3

/datum/map_template/submap/surface/mountains/normal/IceCave1C
	name = "Ice Cave 1C"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains/IceCave1C.dmm'
	id = "mountain_icecave3"
	cost = 3

/datum/map_template/submap/surface/mountains/normal/SwordCave
	name = "Cursed Sword Cave"
	desc = "An underground lake. The sword on the lake's island holds a terrible secret."
	mappath = 'maps/submaps/surface_submaps/mountains/SwordCave.dmm'
	id = "mountain_swordcave"
	cost = 8

/datum/map_template/submap/surface/mountains/normal/supplydrop1
	name = "Supply Drop 1"
	desc = "A drop pod that landed deep within the mountains."
	mappath = 'maps/submaps/surface_submaps/mountains/SupplyDrop1.dmm'
	id = "mountain_droppod"
	cost = 4
	allow_duplicates = TRUE

/datum/map_template/submap/surface/mountains/normal/crashedcontainmentshuttle
	name = "Crashed Cargo Shuttle"
	desc = "A severely damaged military shuttle, its cargo seems to remain intact."
	mappath = 'maps/submaps/surface_submaps/mountains/crashedcontainmentshuttle.dmm'
	id = "mountain_crashed_shuttle_cargo"
	cost = 10

/datum/map_template/submap/surface/mountains/normal/deadspy
	name = "Spy Remains"
	desc = "W+M1 = Salt."
	id = "mountain_remains_spy"
	mappath = 'maps/submaps/surface_submaps/mountains/deadspy.dmm'
	cost = 5


/**************
 * Deep Caves *
 **************/

///datum/map_template/surface/mountains/deep/lost_explorer
//	name = "Lost Explorer, Deep"
//	id = "mountain_remains_explorer_deep"
//	desc = "The remains of an explorer who rotted away ages ago, and their equipment. Again."
//	mappath = 'maps/submaps/surface_submaps/mountains/lost_explorer.dmm'
//	cost = 1
//	allow_duplicates = FALSE //Citadel change; A million of these spawning instead of interesting stuff in the deep part sucks.
//Cit change; Removal, with 3x high activity changes, there will already be quite a few scattered on the lower half, no need to waste space where space is needed.

/datum/map_template/submap/surface/mountains/deep/crashed_ufo
	name = "Crashed UFO"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet it still seems to be running..."
	mappath = 'maps/submaps/surface_submaps/mountains/crashed_ufo.dmm'
	id = "mountain_ufo"
	cost = 15
	discard_prob = 50

/datum/map_template/submap/surface/mountains/deep/Scave1
	name = "Spider Cave 1"
	desc = "A minning tunnel home to an aggressive collection of spiders."
	mappath = 'maps/submaps/surface_submaps/mountains/Scave1.dmm'
	id = "mountain_spidercave"
	cost = 6

/datum/map_template/submap/surface/mountains/deep/CaveTrench
	name = "Cave River"
	desc = "A strange underground river."
	mappath = 'maps/submaps/surface_submaps/mountains/CaveTrench.dmm'
	id = "mountain_caveriver"
	cost = 6

/datum/map_template/submap/surface/mountains/deep/Cavelake
	name = "Cave Lake"
	desc = "A large underground lake."
	mappath = 'maps/submaps/surface_submaps/mountains/Cavelake.dmm'
	id = "mountain_cavelake"
	cost = 6

//Citadel change
//Vaults 1-3 kept in the normal area, since they're basically just a box and two xenos.
//datum/map_template/surface/mountains/deep/vault1
	//name = "Mine Vault 1"
	//desc = "A small vault with potential loot."
	//	id = "minevault1"
	//mappath = 'maps/submaps/surface_submaps/mountains/vault1.dmm'
	//cost = 3
	//allow_duplicates = TRUE

//datum/map_template/surface/mountains/deep/vault2
	//name = "Mine Vault 2"
	//desc = "A small vault with potential loot."
	//id = "minevault2"
	//mappath = 'maps/submaps/surface_submaps/mountains/vault2.dmm'
	//cost = 3
	//low_duplicates = TRUE

//datum/map_template/surface/mountains/deep/vault3
	//name = "Mine Vault 3"
	//id = "minevault3"
	//desc = "A small vault with potential loot. Also a horrible suprise."
	//mappath = 'maps/submaps/surface_submaps/mountains/vault3.dmm'
	//cost = 5

/datum/map_template/submap/surface/mountains/deep/vault4
	name = "Mine Vault 4"
	desc = "A small xeno vault with potential loot. Also horrible suprises."
	mappath = 'maps/submaps/surface_submaps/mountains/vault4.dmm'
	cost = 6
	id = "minevault4"

/datum/map_template/submap/surface/mountains/deep/vault5
	name = "Mine Vault 5"
	desc = "A small xeno vault with potential loot. Also major horrible suprises."
	mappath = 'maps/submaps/surface_submaps/mountains/vault5.dmm'
	id = "minevault5"
	cost = 8

/datum/map_template/submap/surface/mountains/deep/BlastMine1
	name = "Blast Mine 1"
	desc = "An abandoned blast mining site, seems that local wildlife has moved in."
	mappath = 'maps/submaps/surface_submaps/mountains/BlastMine1.dmm'
	id = "mountain_blastmine"
	cost = 6

/datum/map_template/submap/surface/mountains/deep/lava_trench
	name = "lava trench"
	desc = "A long stretch of lava underground, almost river-like, with a small crystal research outpost on the side."
	mappath = 'maps/submaps/surface_submaps/mountains/lava_trench.dmm'
	id = "mountain_lavariver"
	fixed_orientation = TRUE
	cost = 6

/datum/map_template/submap/surface/mountains/deep/cultmine
	name = "Cult Mine"
	desc = "A mining operation that found more than it bargained for."
	mappath = 'maps/submaps/surface_submaps/mountains/cultmine.dmm'
	id = "mountain_cultmine"
	cost = 10
