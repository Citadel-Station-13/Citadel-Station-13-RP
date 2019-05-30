/datum/space_level
	var/name = "NAME MISSING"
	var/id
	var/tmp/list/neighbours = list()			//dir = datum
	var/list/neighbour_static_ids = list()	//dir = id
	var/list/traits = list()
	var/tmp/z_value = 1 //actual z placement
	//var/xi		space grid/dynamic system, maybe later...
	//var/yi   //imaginary placements on the grid
	var/tmp/list/datum/transition_effects = list()		//"[dir]" = list() holds the transition effects, wiped on transition change.
	var/tmp/list/turf/transition_turfs = list()			//"[dir]" = list() transition turfs set on transition set.

/datum/space_level/New(new_z, new_name, list/new_traits = list())
	z_value = new_z
	name = new_name
	set_traits(new_traits, !SSmapping.transitions_initialized)

/datum/space_level/proc/set_traits(list/new_traits = list(), defer_transition_update = FALSE)
	//Cleanup/cache old traits
	SSmapping.zlevels_by_id -= id
	var/old_linkage = traits[ZTRAIT_LINKAGE]
	var/old_idn = traits[ZTRAIT_TRANSITION_ID_NORTH]
	var/old_ids = traits[ZTRAIT_TRANSITION_ID_SOUTH]
	var/old_ide = traits[ZTRAIT_TRANSITION_ID_EAST]
	var/old_idw = traits[ZTRAIT_TRANSITION_ID_WEST]
	var/old_padding = traits[ZTRAIT_TRANSITION_PADDING]
	var/old_mirage = traits[ZTRAIT_TRANSITION_NO_MIRAGE]
	var/old_mirage_dist = traits[ZTRAIT_MIRAGE_DISTANCE]
	var/old_mode = traits[ZTRAIT_TRANSITION_MODE]
	//Set traits
	traits = new_traits
	//Setup new traits
	id = traits[ZTRAIT_LEVEL_ID]
	if(id)
		SSmapping.zlevels_by_id[id] = src
	if(isnull(traits[ZTRAIT_MIRAGE_DISTANCE]))
		traits[ZTRAIT_MIRAGE_DISTANCE] = traits[ZTRAIT_TRANSITION_PADDING] || 7
	if(\
		old_linkage != traits[ZTRAIT_LINKAGE] ||\
		old_idn != traits[ZTRAIT_TRANSITION_ID_NORTH] ||\
		old_ids != traits[ZTRAIT_TRANSITION_ID_SOUTH] ||\
		old_ide != traits[ZTRAIT_TRANSITION_ID_EAST] ||\
		old_idw != traits[ZTRAIT_TRANSITION_ID_WEST] ||\
		old_padding != traits[ZTRAIT_TRANSITION_PADDING] ||\
		old_mirage != traits[ZTRAIT_TRANSITION_NO_MIRAGE] ||\
		old_mode != traits[ZTRAIT_TRANSITION_MODE] ||\
		old_mirage_dist != traits[ZTRAIT_MIRAGE_DISTANCE] \
		)
		set_linkage(new_traits[ZTRAIT_LINKAGE], defer_transition_update)


/datum/space_level/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, traits) && islist(var_value))
		return set_traits(var_value)
	return ..()
