/**
 * makes an atom at our loc
 * moves it with us
 * kills it when we get destroyed
 */
/datum/component/slaved_atom_to_loc
	dupe_mode = COMPONENT_DUPE_ALLOWED
	/// do we remake the atom when it's destroyed?
	var/remake = TRUE
	/// the attached atom
	var/atom/movable/slaved
	/// the path to make
	var/path

/datum/component/slaved_atom_to_loc/Initialize(path, remake = TRUE)
	if(!ispath(path, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.remake = remake
	src.path = path
	Create()

/datum/component/slaved_atom_to_loc/Destroy()
	Delete()
	return ..()

/datum/component/slaved_atom_to_loc/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, .proc/on_parent_qdel)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/on_parent_move)

/datum/component/slaved_atom_to_loc/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_MOVED
	))

/datum/component/slaved_atom_to_loc/proc/Create()
	if(slaved)
		return
	slaved = new path
	RegisterSignal(slaved, COMSIG_PARENT_QDELETING, .proc/on_created_qdel)

/datum/component/slaved_atom_to_loc/proc/Delete()
	if(!slaved)
		return
	remake = FALSE
	UnregisterSignal(slaved, COMSIG_PARENT_QDELETING)
	qdel(slaved)

/datum/component/slaved_atom_to_loc/proc/on_parent_qdel()
	qdel(src)

/datum/component/slaved_atom_to_loc/proc/on_parent_move()
	var/atom/movable/AM = parent
	if(slaved)
		slaved.forceMove(AM.loc)
	else
		stack_trace("why are we still here?")
		qdel(src)

/datum/component/slaved_atom_to_loc/proc/on_created_qdel()
	slaved = null
	if(!remake)
		qdel(src)
		return
	Create()
