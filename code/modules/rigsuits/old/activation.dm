// activation - bit of a misnomer: this is actually whether or not the hardsuit is attached/sealed to you
/**
 * set current activation state to
 */
/obj/item/hardsuit/proc/set_activation_state(new_state)
	activation_state = new_state

/obj/item/hardsuit/proc/is_activated()
	return activation_state == HARDSUIT_ACTIVATION_ON

/obj/item/hardsuit/proc/is_activating()
	return activation_state == HARDSUIT_ACTIVATION_STARTUP

/obj/item/hardsuit/proc/is_deactivating()
	return activation_state == HARDSUIT_ACTIVATION_SHUTDOWN

/obj/item/hardsuit/proc/is_cycling()
	return activation_state == HARDSUIT_ACTIVATION_STARTUP || activation_state == HARDSUIT_ACTIVATION_SHUTDOWN

/**
 * online - whether or not the hardsuit is semantically online. a completely depowered suit can be activated but not online.
 */
/obj/item/hardsuit/proc/is_online()
	return is_activated() && cell?.charge

/// hook - automatically deactivate if dropped
/obj/item/hardsuit/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	reset()
	// todo: above is utter shitcode fuck springtrap suits rigs need refactored

// todo: the rest of activation logic should be refactored and put in this file
