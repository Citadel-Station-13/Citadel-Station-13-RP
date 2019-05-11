/datum/space_level
	var/name = "NAME MISSING"
	var/id
	var/list/neighbours = list()			//dir = datum
	var/list/traits
	var/z_value = 1 //actual z placement
	var/linkage = SELFLOOPING
	var/xi
	var/yi   //imaginary placements on the grid

/datum/space_level/New(new_z, new_name, list/new_traits = list())
	z_value = new_z
	name = new_name
	set_traits(new_traits)

/datum/space_level/proc/set_traits(list/new_traits = list())
	SSmapping.zlevels_by_id -= id
	traits = new_traits
	id = traits[ZTRAIT_LEVEL_ID]
	if(id)
		SSmapping[id] = src
	set_linkage(new_traits[ZTRAIT_LINKAGE])
