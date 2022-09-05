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

/datum/proxfield/bsaic/proc/Turfs()
	return list()

/datum/proxfield/basic/Build()
	checkers = list()

/datum/proxfield/basic/Update()
	#warn impl

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
	return RANGE_TURFS(radius, center)

/atom/movable/proximity_checker/basic

/atom/movable/proximity_checker/basic/Crossed(atom/movable/AM)
	. = ..()
	field.Detect(AM)
