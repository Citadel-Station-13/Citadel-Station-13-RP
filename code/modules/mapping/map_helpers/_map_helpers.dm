//Landmarks and other helpers which speed up the mapping process and reduce the number of unique instances/subtypes of items/turf/ect
/obj/map_helper
	icon = 'icons/mapping/helpers/mapping_helpers.dmi'
	icon_state = ""
	var/late = FALSE

/obj/map_helper/Initialize(mapload)
	. = ..()
	return late ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL

/* these need renaming because airlock already exist!

//airlock helpers
/obj/map_helper/airlock
	layer = DOOR_HELPER_LAYER

/obj/map_helper/airlock/cyclelink_helper
	name = "airlock cyclelink helper"
	icon_state = "airlock_cyclelink_helper"

/obj/map_helper/airlock/cyclelink_helper/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return
	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(airlock)
		if(airlock.cyclelinkeddir)
			log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] cyclelinkeddir, but it's already set!")
		else
			airlock.cyclelinkeddir = dir
	else
		log_mapping("[src] failed to find an airlock at [AREACOORD(src)]")


/obj/map_helper/airlock/locked
	name = "airlock lock helper"
	icon_state = "airlock_locked_helper"

/obj/map_helper/airlock/locked/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return
	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(airlock)
		if(airlock.locked)
			log_mapping("[src] at [AREACOORD(src)] tried to bolt [airlock] but it's already locked!")
		else
			airlock.locked = TRUE
	else
		log_mapping("[src] failed to find an airlock at [AREACOORD(src)]")

/obj/map_helper/airlock/unres
	name = "airlock unresctricted side helper"
	icon_state = "airlock_unres_helper"

/obj/map_helper/airlock/unres/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return
	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(airlock)
		airlock.unres_sides ^= dir
	else
		log_mapping("[src] failed to find an airlock at [AREACOORD(src)]")


//needs to do its thing before spawn_rivers() is called
INITIALIZE_IMMEDIATE(/obj/map_helper/no_lava)

/obj/map_helper/no_lava
	icon_state = "no_lava"

/obj/map_helper/no_lava/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	T.flags_1 |= NO_LAVA_GEN
*/

//This helper applies components to things on the map directly.
/obj/map_helper/component_injector
	name = "Component Injector"
	late = TRUE
	var/target_type
	var/target_name
	var/component_type

//Late init so everything is likely ready and loaded (no warranty)
/obj/map_helper/component_injector/LateInitialize()
	if(!ispath(component_type,/datum/component))
		CRASH("Wrong component type in [type] - [component_type] is not a component")
	var/turf/T = get_turf(src)
	for(var/atom/A in T.GetAllContents())
		if(A == src)
			continue
		if(target_name && A.name != target_name)
			continue
		if(target_type && !istype(A,target_type))
			continue
		var/cargs = build_args()
		A._AddComponent(cargs)
		qdel(src)
		return

/obj/map_helper/component_injector/proc/build_args()
	return list(component_type)

/*
/obj/map_helper/component_injector/infective
	name = "Infective Injector"
	icon_state = "component_infective"
	component_type = /datum/component/infective
	var/disease_type

/obj/map_helper/component_injector/infective/build_args()
	if(!ispath(disease_type,/datum/disease))
		CRASH("Wrong disease type passed in.")
	var/datum/disease/D = new disease_type()
	return list(component_type,D)
*/
