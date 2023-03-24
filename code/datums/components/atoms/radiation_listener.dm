/datum/component/radiation_listener

/datum/component/radiation_listener/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/radiation_listener/RegisterWithParent()
	. = ..()
	construct()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/datum/component/radiation_listener, update))

/datum/component/radiation_listener/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	teardown()

/datum/component/radiation_listener/proc/teardown(atom/root = parent:loc)
	var/atom/movable/last
	while(ismovable(root))
		last = root
		UnregisterSignal(root, COMSIG_MOVABLE_MOVED)
		root = root.loc
	if(!isnull(last))
		UnregisterSignal(last, COMSIG_ATOM_RAD_PULSE_ITERATE)

/datum/component/radiation_listener/proc/construct(atom/root = parent:loc)
	var/atom/movable/last
	while(ismovable(root) && !(root.rad_flags & RAD_BLOCK_CONTENTS))
		last = root
		RegisterSignal(root, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/datum/component/radiation_listener, update))
		root = root.loc
	if(!isnull(last))
		RegisterSignal(last, COMSIG_ATOM_RAD_PULSE_ITERATE, TYPE_PROC_REF(/datum/component/radiation_listener, relay))

/datum/component/radiation_listener/proc/update(atom/source)
	teardown(source.loc)
	construct(source.loc)

/datum/component/radiation_listener/proc/relay(datum/source, strength, datum/radiation_wave/wave)
	var/atom/A = parent
	A.rad_act(strength, wave)
