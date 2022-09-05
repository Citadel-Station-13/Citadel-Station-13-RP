/**
 * proximity monitoring
 *
 * can be subtyped for advanced field handling
 *
 * constructor: (parent, attach to (if not parent), ...) where ... is the rest of args in Init().
 */
/datum/proxfield
	/// what we're attached to
	VAR_PRIVATE/atom/attached
	/// what we notify if it's not attached
	VAR_PRIVATE/datum/parent
	/// are we built?
	VAR_PRIVATE/active = FALSE
	/// our objects
	VAR_PRIVATE/list/atom/movable/proximity_checker/checkers
	#warn impl
	/// do we work when attached isn't on a turf? if so, we use get_turf
	var/scan_from_turf = TRUE

/datum/proxfield/New(datum/parent, atom/attach_to, ...)
	checkers = list()
	src.parent = parent
	if(attach_to)
		src.attached = attach_to
	else
		src.attached = parent
	Init(args.Copy(2))
	#warn signals

/datum/proxfield/Destroy()
	Teardown()
	UnregisterSignal(attached, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOVABLE_Z_CHANGED
	))
	UnregisterSignal(parent, list(
		COMSIG_PARENT_QDELETING
	))
	attached = null
	parent = null
	return ..()

/datum/proxfield/proc/Init()
	Build()

/datum/proxfield/proc/Build()
	if(active)
		Teardown()
	Update()

/datum/proxfield/proc/Teardown()
	if(!active)
		return
	QDEL_LIST(checkers)
	active = FALSE

/datum/proxfield/proc/Update()
	var/existing = checkers.len


/datum/proxfield/proc/Turfs()
	return list()

/datum/proxfield/proc/Detect(atom/movable/AM)
	parent?.Proximity(src, AM)

/datum/proc/Proximity(datum/proxfield/field, atom/movable/AM)

/atom/movable/proximity_checker
	name = ""
	icon = null
	icon_state = ""
	density = FALSE
	opacity = FALSE
	alpha = 0
	pass_flags_self = ALL
	flags = ATOM_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT		// our ONE JOB is to detect Crossed(). NOTHING ELSE.

	/// our proxfield
	var/datum/proxfield/field

/atom/movable/proximity_checker/Initialize(mapload, datum/proxfield/field)
	src.field = field
	return ..()

/atom/movable/proximity_checker/Destroy()
	field = null
	return ..()

/atom/movable/proximity_checker/CanPass(atom/movable/mover, turf/target)
	return TRUE

/atom/movable/proximity_checker/CanAtmosPass(turf/T, d)
	return TRUE

/atom/movable/proximity_checker/Crossed(atom/movable/AM)
	field.Detect(AM)
