/datum/map_template/submap/level_specific/generic
	name = "Generic POIs"
	desc = "Generic "
	allow_duplicates = FALSE // TRUE means the same submap can spawn twice
	prefix = "_maps/submaps/level_specific/generic/"

/datum/map_template/submap/level_specific/generic/test_1
	name = "Generic Room 1"
	suffix = "test_template_001.dmm" // map is in root folder, so just the name.dmm is fine
	cost = 5 // budget cost for this submap. total budget is set in _triumph_submaps.dm where the seed_submaps proc is called
	discard_prob = 0 // set probability of not spawning. 0 ensures always spawn. removing this line will leave it default which is shit
