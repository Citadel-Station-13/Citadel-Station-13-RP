////The datum of entites like stations, planets, "effects", fields, shuttles, ships, etc.
/datum/overmap_entity
	var/name = "entity"
	var/desc = "Looks like an anomaly. A null anomaly. Report this to a coder!"
	var/atom/movable/overmap_object/object

	var/overmap_entity_flags = NONE

	//Maploading
	var/datum/map_template/map_template		//the template to load from
	var/datum/turf_bounds/loaded_bounds		//current loaded bounds of the map.

	//Docking/etc system


	//Structure/parts used for combat


	//movement - UNIMPLEMENTED
	var/datum/point/vector/velocity

	var/last_move = 0		//world.time of last movement tick

/datum/overmap_entity/New()
	setName(name)
	setDesc(desc)
	object = new(null, src)

/datum/overmap_entity/Destroy()
	QDEL_NULL(object)
	if(!CHECK_BITFIELD(overmap_entity_flags, OVERMAP_ENTITY_DESTROY_KEEP_ALIVE))
		deinstantiate_map()
	return ..()

/datum/overmap_entity/proc/setName(name)
	src.name = name
	object?.setName(name)

/datum/overmap_entity/proc/setDesc(desc)
	src.desc = desc
	object?.setDesc(desc)

/datum/overmap_entity/proc/forceMove(loc, step_x, step_y)
	object?.forceMove(loc, step_x, step_y)

//things like shuttles landing on a planet (other would be the shuttle), shuttles docking with a ship. When the physical object disappears from the "map view" and instead is contained inside another object.
/datum/overmap_entity/proc/allow_enter(datum/overmap_entity/other)
	return FALSE

/datum/overmap_entity/proc/allow_exit(datum/overmap_entity/other)
	return TRUE

//when the actual landing/docking/whatnot happens.
/datum/overmap_entity/proc/on_enter(datum/overmap_entity/other)
	return

/datum/overmap_entity/proc/on_exit(datum/overmap_entity/other)
	return

//when another thing tries to overlap this on the map. eg, shuttle passing THROUGH a planet object (this should be allowed because even though the world is 2D, we're trying to simulate a semi-3D environment.
/datum/overmap_entity/proc/allow_cross(datum/overmap_entity/other)
	return TRUE

/datum/overmap_entity/proc/allow_uncross(datum/overmap_entity/other)
	return TRUE

//when another thing overlaps this on the map. use for things like asteroid fields being crossed by a shuttle or whatnot.
/datum/overmap_entity/proc/on_cross(datum/overmap_entity/other)
	return

/datum/overmap_entity/proc/on_uncross(datum/overmap_entity/other)
	return

/datum/overmap_entity/proc/instantiate_map()

/datum/overmap_entity/proc/deinstantiate_map()
