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
