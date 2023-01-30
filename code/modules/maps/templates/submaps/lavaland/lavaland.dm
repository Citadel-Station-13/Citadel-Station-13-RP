/datum/map_template/submap/level_specific/lavaland
	name = "Lava Land POIs"
	desc = "Submaps for Lava Land"
	allow_duplicates = FALSE // TRUE means the same submap can spawn twice
	annihilate = TRUE
	prefix = "_maps/submaps/level_specific/lavaland/"

/datum/map_template/submap/level_specific/lavaland/horrors
	name = "Lava Land - Shrine"
	suffix = "horrors.dmm" // map is in root folder, so just the name.dmm is fine
	cost = 5 // budget cost for this submap. total budget is set in _triumph_submaps.dm where the seed_submaps proc is called
	discard_prob = 0 // set probability of not spawning. 0 ensures always spawn. removing this line will leave it default which is shit

/datum/map_template/submap/level_specific/lavaland/dogs
	name = "Lava Land - Four Pillars"
	suffix = "dogs.dmm"
	cost = 5
	discard_prob = 25

/datum/map_template/submap/level_specific/lavaland/botany
	name = "Lava Land - Botany"
	suffix = "botany.dmm"
	cost = 5
	discard_prob = 25

/datum/map_template/submap/level_specific/lavaland/idleruins1
	name = "Lava Land - Idle Ruins"
	suffix = "idleruins1.dmm"
	cost = 5
	discard_prob = 25

/datum/map_template/submap/level_specific/lavaland/idleruins2
	name = "Lava Land - Idle Ruins 2"
	suffix = "idleruins2.dmm"
	cost = 5
	discard_prob = 25
	fixed_orientation = TRUE // this really doesn't work, but i dont see a way to fix it without redoing the system

/datum/map_template/submap/level_specific/lavaland/ashlander_camp
	name = "Lava Land - Ashlander Camp"
	suffix = "ashlandercamp.dmm"
	cost = 5
	discard_prob = 50
	allow_duplicates = TRUE

/datum/map_template/submap/level_specific/lavaland/shelter
	name = "Lava Land - Shelter"
	suffix = "shelter.dmm"
	cost = 5
	discard_prob = 25
	allow_duplicates = TRUE
	fixed_orientation = TRUE

/datum/map_template/submap/level_specific/lavaland/boss1
	name = "Lava Land - Boss 1"
	suffix = "boss1.dmm"
	cost = -1
	discard_prob = 0
	allow_duplicates = FALSE
	fixed_orientation = TRUE
