/datum/map_template/shuttle
	abstract_type = /datum/map_template/shuttle
	var/prefix = null
	var/suffix = null

/datum/map_template/shuttle/New()
	// if(!name && id)
	//	name = id

	if(isnull(mappath))
		mappath = prefix + suffix
	..(path = mappath)

/datum/map_template/shuttle/overmap
	abstract_type = /datum/map_template/shuttle/overmap
