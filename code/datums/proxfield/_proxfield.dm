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
	/// do we work when attached isn't on a turf? if so, we use get_turf
	var/scan_from_turf = TRUE

/datum/proxfield/New(datum/parent, ...)
	ASSERT(parent)
	src.parent = parent
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, .proc/on_parent_qdel)
	Init(arglist(args.Copy(2)))

/datum/proxfield/Destroy()
	Stop()
	UnregisterSignal(parent, list(
		COMSIG_PARENT_QDELETING
	))
	Attach(null)
	parent = null
	return ..()

/datum/proxfield/proc/Init()
	SHOULD_CALL_PARENT(TRUE)
	Start()

/datum/proxfield/proc/Attach(atom/A)
	if(attached == A)
		return
	if(attached)
		UnregisterSignal(attached, list(
			COMSIG_MOVABLE_MOVED,
			COMSIG_MOVABLE_Z_CHANGED
		))
		if(attached != parent)
			UnregisterSignal(attached, COMSIG_PARENT_QDELETING)
	if(active)
		Stop()
		attached = A
		Start()
	else
		attached = A
	if(attached != parent)
		RegisterSignal(attached, COMSIG_PARENT_QDELETING, .proc/on_attached_qdel)
	RegisterSignal(attached, COMSIG_MOVABLE_MOVED, .proc/on_move)
	RegisterSignal(attached, COMSIG_MOVABLE_Z_CHANGED, .proc/on_z_transit)

/datum/proxfield/proc/on_move(datum/source, atom/movable/oldLoc, dir, forced)
	SIGNAL_HANDLER

/datum/proxfield/proc/on_z_transit(datum/source, old_z, new_z)
	SIGNAL_HANDLER

/datum/proxfield/proc/on_parent_qdel(datum/source)
	SIGNAL_HANDLER
	if(QDELING(src) || QDELETED(src))
		return
	qdel(src)

/datum/proxfield/proc/on_attached_qdel(datum/source)
	SIGNAL_HANDLER
	Attach(null)

/datum/proxfield/proc/Start()
	SHOULD_NOT_OVERRIDE(TRUE)
	if(active)
		Stop()
	active = TRUE
	Build()
	Update()

/datum/proxfield/proc/Stop()
	if(!active)
		return
	active = FALSE
	Teardown()

/datum/proxfield/proc/Build()
	return

/datum/proxfield/proc/Teardown()
	return

/datum/proxfield/proc/Update()
	return

/datum/proxfield/proc/Anchor()
	return scan_from_turf? get_turf(attached) : attached

/datum/proxfield/proc/Detect(...)

/datum/proc/Proximity(datum/proxfield/field, ...)

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
