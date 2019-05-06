//The physical object of an overmap entity.
/atom/movable/overmap_object
	name = "overmap entity"
	desc = "You shouldn't be seeing this. Report it to a coder!"
	var/datum/overmap_entity/entity

/atom/movable/overmap_object/Initialize(mapload, datum/overmap_entity/E)
	if(istype(E))
		entity = E
	else
		stack_trace("Warning! Overmap object with no entity in creation proc created!")
	return ..()

/atom/movable/overmap_object/Destroy()
	if(entity.object == src)
		entity.object = null
	return ..()

/atom/movable/overmap_object/Cross(atom/movable/overmap_object/other)
	if(entity && istype(other))
		return entity.allow_cross(other.entity)
	return ..()

/atom/movable/overmap_object/Crossed(atom/movable/overmap_object/other)
	if(entity && istype(other))
		return entity.on_cross(other.entity)
	return ..()

/atom/movable/overmap_object/Uncross(atom/movable/overmap_object/other)
	if(entity && istype(other))
		return entity.allow_uncross(other.entity)
	return ..()

/atom/movable/overmap_object/Uncrossed(atom/movable/overmap_object/other)
	if(entity && istype(other))
		return entity.on_uncross(other.entity)
	return ..()

/atom/movable/overmap_object/Enter(atom/movable/overmap_object/other)
	if(entity && istype(other))
		return entity.allow_enter(other.entity)
	return ..()

/atom/movable/overmap_object/Entered(atom/movable/overmap_object/other)
	if(entity && istype(other))
		return entity.on_enter(other.entity)
	return ..()

/atom/movable/overmap_object/Exit(atom/movable/overmap_object/other)
	if(entity && istype(other))
		return entity.allow_exit(other.entity)
	return ..()

/atom/movable/overmap_object/Exited(atom/movable/overmap_object/other)
	if(entity && istype(other))
		return entity.on_exit(other.entity)
	return ..()
