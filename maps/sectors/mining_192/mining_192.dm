/datum/map/sector/mining_192
	id = "mining_192"
	name = "Sector - Mining World"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/mining_192,
	)

/datum/map_level/sector/mining_192
	id = "MiningWorld192"
	name = "Sector - Mining World"
	display_name = "Class-G Mineral Rich Planet"
	path = "maps/sectors/mining_192/levels/mining_192.dmm"
	traits = list(
		ZTRAIT_GRAVITY,
	)
	planet_path = /datum/planet/classg
	air_outdoors = /datum/atmosphere/planet/classg

	injections = list(
		new /datum/map_injection/legacy_automata_caves/on_dmm,
		new /datum/map_injection/legacy_noise_ores(
			null,
			0.6,
			0.4,
		),
	)
