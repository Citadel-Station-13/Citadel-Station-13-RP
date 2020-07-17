// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
/*
#if MAP_TEST
#include "deadBeacon.dmm"
#include "prepper1.dmm"
#include "quarantineshuttle.dmm"
#include "Mineshaft1.dmm"
#include "Scave1.dmm"
#include "crashed_ufo.dmm"
#include "crashed_ufo_frigate.dmm"
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
#include "Geyser1.dmm"
#include "Geyser2.dmm"
#include "Geyser3.dmm"
#include "Cliff1.dmm"
#endif
*/
/*
Mountain POIs converted to be friendly with Boreas
*/

/datum/map_template/surface/mountains_snow
	name = "Mountain Content"
	desc = "Don't dig too deep!"

// 'Normal' templates get used on the station side of the ravine, where they can be safer
/datum/map_template/surface/mountains_snow/normal

// 'Deep' templates get used on the far side of the ravine.
/datum/map_template/surface/mountains_snow/deep

// 'Under' templates will get used underground.
/datum/map_template/surface/mountains_snow/under

/****************
 * Normal Caves *
 ****************/

/datum/map_template/surface/mountains_snow/normal/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/deadBeacon.dmm'
	cost = 10

/datum/map_template/surface/mountains_snow/under/prepper1
	name = "Prepper Bunker"
	desc = "A little hideaway for someone with more time and money than sense."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/prepper1.dmm'
	cost = 10

/datum/map_template/surface/mountains_snow/deep/qshuttle
	name = "Quarantined Shuttle"
	desc = "An emergency landing turned viral outbreak turned tragedy."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/quarantineshuttle.dmm'
	cost = 20

/datum/map_template/surface/mountains_snow/under/Mineshaft1
	name = "Abandoned Mineshaft 1"
	desc = "An abandoned minning tunnel from a lost money making effort."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/Mineshaft1.dmm'
	cost = 5

/datum/map_template/surface/mountains_snow/under/crystal1
	name = "Crystal Cave 1"
	desc = "A small cave with glowing gems and diamonds."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/crystal1.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains_snow/under/crystal2
	name = "Crystal Cave 2"
	desc = "A moderate sized cave with glowing gems and diamonds."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/crystal2.dmm'
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains_snow/under/crystal3
	name = "Crystal Cave 3"
	desc = "A large spiral of crystals with diamonds in the center."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/crystal3.dmm'
	cost = 15

/datum/map_template/surface/mountains_snow/normal/lost_explorer
	name = "Lost Explorer"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/lost_explorer.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains_snow/normal/Rockb1
	name = "Rocky Base 1"
	desc = "Someones underground hidey hole"
	mappath = 'maps/submaps/surface_submaps/mountains_snow/Rockb1.dmm'
	cost = 15

/datum/map_template/surface/mountains_snow/deep/corgiritual
	name = "Dark Ritual"
	desc = "Who put all these plushies here? What are they doing?"
	mappath = 'maps/submaps/surface_submaps/mountains_snow/ritual.dmm'
	cost = 15

/datum/map_template/surface/mountains_snow/deep/abandonedtemple
	name = "Abandoned Temple"
	desc = "An ancient temple, long since abandoned. Perhaps alien in origin?"
	mappath = 'maps/submaps/surface_submaps/mountains_snow/temple.dmm'
	cost = 20

/datum/map_template/surface/mountains_snow/under/digsite
	name = "Dig Site"
	desc = "A small abandoned dig site."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/digsite.dmm'
	cost = 10

/datum/map_template/surface/mountains_snow/under/vault1
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/vault1.dmm'
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains_snow/under/vault2
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/vault2.dmm'
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains_snow/under/vault3
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/vault3.dmm'
	cost = 15
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains_snow/under/IceCave1A
	name = "Ice Cave 1A"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/IceCave1A.dmm'
	cost = 10

/datum/map_template/surface/mountains_snow/under/IceCave1B
	name = "Ice Cave 1B"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/IceCave1B.dmm'
	cost = 10

/datum/map_template/surface/mountains_snow/under/IceCave1C
	name = "Ice Cave 1C"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/IceCave1C.dmm'
	cost = 10

/datum/map_template/surface/mountains_snow/under/SwordCave
	name = "Cursed Sword Cave"
	desc = "An underground lake. The sword on the lake's island holds a terrible secret."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/SwordCave.dmm'

/datum/map_template/surface/mountains_snow/normal/supplydrop1
	name = "Supply Drop 1"
	desc = "A drop pod that landed deep within the mountains_snow."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/SupplyDrop1.dmm'
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains_snow/deep/crashedcontainmentshuttle
	name = "Crashed Cargo Shuttle"
	desc = "A severely damaged military shuttle, its cargo seems to remain intact."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/crashedcontainmentshuttle.dmm'
	cost = 30

/datum/map_template/surface/mountains_snow/deep/deadspy
	name = "Spy Remains"
	desc = "W+M1 = Salt."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/deadspy.dmm'
	cost = 15

/datum/map_template/surface/mountains_snow/normal/geyser1
	name = "Ore-Rich Geyser"
	desc = "A subterranean geyser that produces steam. This one has a particularly abundant amount of materials surrounding it."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/Geyser1.dmm'
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/surface/mountains_snow/normal/geyser2
	name = "Fenced Geyser"
	desc = "A subterranean geyser that produces steam. This one has a damaged fence surrounding it."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/Geyser2.dmm'
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/surface/mountains_snow/normal/geyser3
	name = "Magmatic Geyser"
	desc = "A subterranean geyser that produces incendiary gas. It is recessed into the ground, and filled with magma. It's a relatively dormant volcano."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/Geyser2.dmm'
	cost = 10
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/surface/mountains_snow/normal/cliff1
	name = "Ore-Topped Cliff"
	desc = "A raised area of rock created by volcanic forces."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/Cliff1.dmm'
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Cliffs"

/**************
 * Deep Caves *
 **************/

/datum/map_template/surface/mountains_snow/deep/crashed_ufo
	name = "Crashed UFO"
	desc = "A (formerly) flying saucer that is now embedded into the surface, yet it still seems to be running..."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/crashed_ufo.dmm'
	cost = 40
	discard_prob = 50

/datum/map_template/surface/mountains_snow/deep/crashed_ufo_frigate
	name = "Crashed UFO Frigate"
	desc = "A (formerly) flying saucer that is now embedded into the surface, yet its combat protocols still seem to be running..."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/crashed_ufo.dmm'
	cost = 60
	discard_prob = 50

/datum/map_template/surface/mountains_snow/under/Scave1
	name = "Spider Cave 1"
	desc = "A minning tunnel home to an aggressive collection of spiders."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/Scave1.dmm'
	cost = 20

/datum/map_template/surface/mountains_snow/under/CaveTrench
	name = "Cave River"
	desc = "A strange underground river."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/CaveTrench.dmm'
	cost = 20

/datum/map_template/surface/mountains_snow/under/vault4
	name = "Mine Vault 4"
	desc = "A small xeno vault with potential loot. Also horrible suprises."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/vault4.dmm'
	cost = 20
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains_snow/under/vault5
	name = "Mine Vault 5"
	desc = "A small xeno vault with potential loot. Also major horrible suprises."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/vault5.dmm'
	cost = 25
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains_snow/deep/vault6
	name = "Mine Vault 6"
	desc = "A small mercenary tower with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/vault6.dmm'
	cost = 25
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains_snow/under/BlastMine1
	name = "Blast Mine 1"
	desc = "An abandoned blast mining site, seems that local wildlife has moved in."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/BlastMine1.dmm'
	cost = 20

/datum/map_template/surface/mountains_snow/under/lava_trench
	name = "lava trench"
	desc = "A long stretch of lava underground, almost river-like, with a small crystal research outpost on the side."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/lava_trench.dmm'
	cost = 20
	fixed_orientation = TRUE

/datum/map_template/surface/mountains_snow/deep/crashedmedshuttle
	name = "Crashed Med Shuttle"
	desc = "A medical response shuttle that went missing some time ago. So this is where they went."
	mappath = 'maps/submaps/surface_submaps/mountains_snow/CrashedMedShuttle1.dmm'
	cost = 20
	fixed_orientation = TRUE
