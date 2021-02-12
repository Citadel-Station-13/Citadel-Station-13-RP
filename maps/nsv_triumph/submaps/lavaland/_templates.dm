/datum/map_template/lavaland
	name = "Lava Land POIs"
	desc = "Submaps for Lava Land"
	allow_duplicates = FALSE // TRUE means the same submap can spawn twice
	annihilate = TRUE

/datum/map_template/lavaland/horrors
	name = "Lava Land - Shrine"
	mappath = 'horrors.dmm' // map is in root folder, so just the name.dmm is fine
	cost = 5 // budget cost for this submap. total budget is set in _triumph_submaps.dm where the seed_submaps proc is called
	discard_prob = 0 // set probability of not spawning. 0 ensures always spawn. removing this line will leave it default which is shit
	
/datum/map_template/lavaland/dogs
	name = "Lava Land - Four Pillars"
	mappath = 'dogs.dmm'
	cost = 5
	discard_prob = 25

/datum/map_template/lavaland/botany
	name = "Lava Land - Botany"
	mappath = 'botany.dmm'
	cost = 5
	discard_prob = 25

/datum/map_template/lavaland/idleruins1
	name = "Lava Land - Idle Ruins"
	mappath = 'idleruins1.dmm'
	cost = 5
	discard_prob = 25
/datum/map_template/lavaland/idleruins2
	name = "Lava Land - Idle Ruins 2"
	mappath = 'idleruins2.dmm'
	cost = 5
	discard_prob = 25
	fixed_orientation = TRUE // this really doesn't work, but i dont see a way to fix it without redoing the system

/datum/map_template/lavaland/shelter
	name = "Lava Land - Shelter"
	mappath = 'shelter.dmm'
	cost = 5
	discard_prob = 25
	allow_duplicates = TRUE
	fixed_orientation = TRUE 

/datum/map_template/lavaland/boss1
	name = "Lava Land - Boss 1"
	mappath = 'boss1.dmm'
	cost = -1
	discard_prob = 0
	allow_duplicates = FALSE
	fixed_orientation = TRUE
