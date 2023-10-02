/**
 * basic proxfields, automatically attaches to parent if it's a datum
 * safe to juggle around with Attach() so we don't provide init param for attach.
 */
/datum/proxfield/basic
	/// our objects
	VAR_PRIVATE/list/atom/movable/proximity_checker/checkers

/datum/proxfield/basic/Init()
	if(isatom(parent))
		Attach(parent)
	return ..()

/datum/proxfield/basic/proc/Turfs()
	return list()

/datum/proxfield/basic/Build()
	checkers = list()

/datum/proxfield/basic/Update()
	var/list/turf/creating = Turfs()
	var/needed = length(creating)
	var/has = length(checkers)
	var/atom/movable/proximity_checker/sensor
	for(var/i in 1 to min(has, needed))
		sensor = checkers[i]
		sensor.loc = creating[1]
	if(has < needed)
		for(var/i in has + 1 to needed)
			checkers += new /atom/movable/proximity_checker/basic(creating[i], src)

	else if(has > needed)
		for(var/i in needed + 1 to has)
			qdel(checkers[i])
		checkers.Cut(needed + 1)

/datum/proxfield/basic/on_z_transit(datum/source, old_z, new_z)
	. = ..()
	Update()

/datum/proxfield/basic/on_move(datum/source, atom/movable/oldLoc, dir, forced)
	. = ..()
	Update()

/datum/proxfield/basic/Teardown()
	QDEL_LIST(checkers)

/datum/proxfield/basic/Detect(atom/movable/AM)
	parent.Proximity(src, AM)

/datum/proxfield/basic/square
	/// radius
	var/radius = 3

/datum/proxfield/basic/square/Init(radius)
	if(isnum(radius))
		if(radius < 0 || radius > 7)
			stack_trace("invalid radius")
			radius = clamp(radius, 0, 7)
		src.radius = radius
	else
		stack_trace("no radius number")
	return ..()

/datum/proxfield/basic/square/Turfs()
	var/turf/center = Anchor()
	return RANGE_TURFS_OR_EMPTY(radius, center)

/atom/movable/proximity_checker/basic

/atom/movable/proximity_checker/basic/Crossed(atom/movable/AM)
	SHOULD_CALL_PARENT(FALSE) // we don't care about parent
	field.Detect(AM)
