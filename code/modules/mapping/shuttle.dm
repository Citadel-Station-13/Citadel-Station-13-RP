/datum/map_template/shuttle

	var/prefix = null
	var/suffix = null

/datum/map_template/shuttle/New()
	// if(!name && id)
	//	name = id

	mappath = prefix + suffix
	..(path = mappath)
