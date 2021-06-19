/datum/map_template/submap

	var/prefix = null
	var/suffix = null

/datum/map_template/submap/New()
	// if(!name && id)
	//	name = id

	mappath = prefix + suffix
	..(path = mappath)
