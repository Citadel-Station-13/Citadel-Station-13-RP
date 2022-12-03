/// Landmarks and other helpers which speed up the mapping process and reduce the number of unique instances/subtypes of items/turf/ect.
/obj/map_helper
	icon = 'icons/mapping/helpers/map_helpers.dmi'
	icon_state = ""
	plane = MAPPING_PLANE
	layer = BASE_HELPER_LAYER

	/// If set to TRUE, we will wait till LateInitialize() to do our work.
	var/late = FALSE

/obj/map_helper/Initialize(mapload)
	. = ..()
	return late ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL

/*

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
	for(var/atom/A in T.get_all_contents())
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
