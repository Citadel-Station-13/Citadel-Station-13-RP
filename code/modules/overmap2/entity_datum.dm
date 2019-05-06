////The datum of entites like stations, planets, "effects", fields, shuttles, ships, etc.
/datum/overmap_entity
	var/name = "entity"
	var/desc = "Looks like an anomaly. A null anomaly. Report this to a coder!"
	var/atom/movable/overmap_object/object

	//movement - UNIMPLEMENTED
	var/velocity_x = 0		//pixel speed per decisecond
	var/velocity_y = 0

	var/overrun_px = 0		//used for preventing rounding from unfairly cutting off speed
	var/overrun_py = 0

	var/last_move = 0		//world.time of last movement tick

/datum/overmap_entity/New()
	setName(name)
	setDesc(desc)
	object = new(null, src)

/datum/overmap_entity/Destroy()
	QDEL_NULL(object)
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
