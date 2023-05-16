/datum/map_template/submap
	abstract_type = /datum/map_template/submap
	var/prefix = null
	var/suffix = null

/datum/map_template/submap/New()
	// if(!name && id)
	//	name = id

	if(isnull(mappath))
		mappath = prefix + suffix
	..(path = mappath)

/datum/map_template/submap/level_specific
	abstract_type = /datum/map_template/submap/level_specific
