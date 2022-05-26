// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.

// The 'mountains' is the mining z-level, and has a lot of caves.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The bottom half should be fairly tame, with perhaps a few enviromental hazards.
// The top half is when things start getting dangerous, but the loot gets better.

/datum/map_template/submap/level_specific/mountains
	name = "Mountain Content"
	desc = "Don't dig too deep!"
	prefix = "_maps/submaps/mountains/"

// 'Normal' templates get used on the bottom half, and should be safer.
/datum/map_template/submap/level_specific/mountains/normal

// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/submap/level_specific/mountains/deep

// To be added: Templates for cave exploration when they are made.

/****************
 * Normal Caves *
 ****************/

/datum/map_template/submap/level_specific/mountains/normal/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	suffix = "deadBeacon.dmm"
	cost = 10

/datum/map_template/submap/level_specific/mountains/normal/prepper1
	name = "Prepper Bunker"
	desc = "A little hideaway for someone with more time and money than sense."
	suffix = "prepper1.dmm"
	cost = 10

/datum/map_template/submap/level_specific/mountains/normal/qshuttle
	name = "Quarantined Shuttle"
	desc = "An emergency landing turned viral outbreak turned tragedy."
	suffix = "quarantineshuttle.dmm"
	cost = 20

/datum/map_template/submap/level_specific/mountains/normal/Mineshaft1
	name = "Abandoned Mineshaft 1"
	desc = "An abandoned minning tunnel from a lost money making effort."
	suffix = "Mineshaft1.dmm"
	cost = 5

/datum/map_template/submap/level_specific/mountains/normal/crystal1
	name = "Crystal Cave 1"
	desc = "A small cave with glowing gems and diamonds."
	suffix = "crystal1.dmm"
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/submap/level_specific/mountains/normal/crystal2
	name = "Crystal Cave 2"
	desc = "A moderate sized cave with glowing gems and diamonds."
	suffix = "crystal2.dmm"
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/submap/level_specific/mountains/normal/crystal2
	name = "Crystal Cave 3"
	desc = "A large spiral of crystals with diamonds in the center."
	suffix = "crystal3.dmm"
	cost = 15

/datum/map_template/submap/level_specific/mountains/normal/lost_explorer
	name = "Lost Explorer"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment."
	suffix = "lost_explorer.dmm"
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/submap/level_specific/mountains/normal/Rockb1
	name = "Rocky Base 1"
	desc = "Someones underground hidey hole"
	suffix = "Rockb1.dmm"
	cost = 15

/datum/map_template/submap/level_specific/mountains/normal/corgiritual
	name = "Dark Ritual"
	desc = "Who put all these plushies here? What are they doing?"
	suffix = "ritual.dmm"
	cost = 15

/datum/map_template/submap/level_specific/mountains/normal/abandonedtemple
	name = "Abandoned Temple"
	desc = "An ancient temple, long since abandoned. Perhaps alien in origin?"
	suffix = "temple.dmm"
	cost = 20

/datum/map_template/submap/level_specific/mountains/normal/digsite
	name = "Dig Site"
	desc = "A small abandoned dig site."
	suffix = "digsite.dmm"
	cost = 10

/datum/map_template/submap/level_specific/mountains/normal/vault1
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	suffix = "vault1.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/vault2
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	suffix = "vault2.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/vault3
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	suffix = "vault3.dmm"
	cost = 15
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/IceCave1A
	name = "Ice Cave 1A"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	suffix = "IceCave1A.dmm"
	cost = 10

/datum/map_template/submap/level_specific/mountains/normal/IceCave1B
	name = "Ice Cave 1B"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	suffix = "IceCave1B.dmm"
	cost = 10

/datum/map_template/submap/level_specific/mountains/normal/IceCave1C
	name = "Ice Cave 1C"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	suffix = "IceCave1C.dmm"
	cost = 10

/datum/map_template/submap/level_specific/mountains/normal/SwordCave
	name = "Cursed Sword Cave"
	desc = "An underground lake. The sword on the lake's island holds a terrible secret."
	suffix = "SwordCave.dmm"

/datum/map_template/submap/level_specific/mountains/normal/supplydrop1
	name = "Supply Drop 1"
	desc = "A drop pod that landed deep within the mountains."
	suffix = "SupplyDrop1.dmm"
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/submap/level_specific/mountains/normal/crashedcontainmentshuttle
	name = "Crashed Cargo Shuttle"
	desc = "A severely damaged military shuttle, its cargo seems to remain intact."
	suffix = "crashedcontainmentshuttle_vr.dmm"
	cost = 30

/datum/map_template/submap/level_specific/mountains/normal/deadspy
	name = "Spy Remains"
	desc = "W+M1 = Salt."
	suffix = "deadspy.dmm"
	cost = 15

/datum/map_template/submap/level_specific/mountains/normal/geyser1
	name = "Ore-Rich Geyser"
	desc = "A subterranean geyser that produces steam. This one has a particularly abundant amount of materials surrounding it."
	suffix = "Geyser1.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/submap/level_specific/mountains/normal/geyser2
	name = "Fenced Geyser"
	desc = "A subterranean geyser that produces steam. This one has a damaged fence surrounding it."
	suffix = "Geyser2.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/submap/level_specific/mountains/normal/geyser3
	name = "Magmatic Geyser"
	desc = "A subterranean geyser that produces incendiary gas. It is recessed into the ground, and filled with magma. It's a relatively dormant volcano."
	suffix = "Geyser2.dmm"
	cost = 10
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/submap/level_specific/mountains/normal/cliff1
	name = "Ore-Topped Cliff"
	desc = "A raised area of rock created by volcanic forces."
	suffix = "Cliff1.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Cliffs"

/**************
 * Deep Caves *
 **************/

/datum/map_template/submap/level_specific/mountains/normal/crashed_ufo
	name = "Crashed UFO"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet it still seems to be running..."
	suffix = "crashed_ufo.dmm"
	cost = 40
	discard_prob = 50

/datum/map_template/submap/level_specific/mountains/normal/crashed_ufo_frigate
	name = "Crashed UFO Frigate"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet its combat protocols still seem to be running..."
	suffix = "crashed_ufo.dmm"
	cost = 60
	discard_prob = 50

/datum/map_template/submap/level_specific/mountains/normal/Scave1
	name = "Spider Cave 1"
	desc = "A minning tunnel home to an aggressive collection of spiders."
	suffix = "Scave1.dmm"
	cost = 20

/datum/map_template/submap/level_specific/mountains/normal/CaveTrench
	name = "Cave River"
	desc = "A strange underground river."
	suffix = "CaveTrench.dmm"
	cost = 20

/datum/map_template/submap/level_specific/mountains/normal/Cavelake
	name = "Cave Lake"
	desc = "A large underground lake."
	suffix = "Cavelake.dmm"
	cost = 20

/datum/map_template/submap/level_specific/mountains/normal/vault1
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	suffix = "vault1.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/vault2
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	suffix = "vault2.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/vault3
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	suffix = "vault3.dmm"
	cost = 15
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/vault4
	name = "Mine Vault 4"
	desc = "A small xeno vault with potential loot. Also horrible suprises."
	suffix = "vault4.dmm"
	cost = 20
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/vault5
	name = "Mine Vault 5"
	desc = "A small xeno vault with potential loot. Also major horrible suprises."
	suffix = "vault5.dmm"
	cost = 25
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/vault6
	name = "Mine Vault 6"
	desc = "A small mercenary tower with potential loot."
	suffix = "vault6.dmm"
	cost = 25
	template_group = "Buried Vaults"

/datum/map_template/submap/level_specific/mountains/normal/BlastMine1
	name = "Blast Mine 1"
	desc = "An abandoned blast mining site, seems that local wildlife has moved in."
	suffix = "BlastMine1.dmm"
	cost = 20

/datum/map_template/submap/level_specific/mountains/normal/lava_trench
	name = "lava trench"
	desc = "A long stretch of lava underground, almost river-like, with a small crystal research outpost on the side."
	suffix = "lava_trench.dmm"
	cost = 20
	fixed_orientation = TRUE

/datum/map_template/submap/level_specific/mountains/normal/crashedmedshuttle
	name = "Crashed Med Shuttle"
	desc = "A medical response shuttle that went missing some time ago. So this is where they went."
	suffix = "CrashedMedShuttle1_vr.dmm"
	cost = 20
	fixed_orientation = TRUE

/datum/map_template/submap/level_specific/mountains/normal/cultmine
	name = "Cult Mine"
	desc = "A mining operation that found more than it bargained for."
	suffix = "cultmine.dmm"
	cost = 10
