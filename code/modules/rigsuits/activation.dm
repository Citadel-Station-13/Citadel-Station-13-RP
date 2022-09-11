// activation - bit of a misnomer: this is actually whether or not the rig is attached/sealed to you
/**
 * set current activation state to
 */
/obj/item/rig/proc/set_activation_state(new_state)
	activation_state = new_state

/obj/item/rig/proc/is_activated()
	return activation_state == RIG_ACTIVATION_ON

/obj/item/rig/proc/is_activating()
	return activation_state == RIG_ACTIVATION_STARTUP

/obj/item/rig/proc/is_deactivating()
	return activation_state == RIG_ACTIVATION_SHUTDOWN

/obj/item/rig/proc/is_cycling()
	return activation_state == RIG_ACTIVATION_STARTUP || activation_state == RIG_ACTIVATION_SHUTDOWN

/**
 * online - whether or not the rig is semantically online. a completely depowered suit can be activated but not online.
 */
/obj/item/rig/proc/is_online()
	return is_activated() && cell?.charge

/// hook - automatically deactivate if dropped
/obj/item/rig/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	reset()
	// todo: above is utter shitcode fuck springtrap suits rigs need refactored

// todo: the rest of activation logic should be refactored and put in this file
