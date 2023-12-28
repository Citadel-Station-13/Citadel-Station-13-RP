//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig/proc/set_activation_state(new_state)
	activation_state = new_state
	if(activation_state & (RIG_ACTIVATION_ACTIVATING | RIG_ACTIVATION_OFFLINE))
		set_weight(offline_weight)
		set_encumbrance(offline_encumbrance)
	else
		set_weight(online_weight)
		set_encumbrance(online_encumbrance)

/obj/item/rig/proc/fully_activated()
	return activation_state == RIG_ACTIVATION_ONLINE

/obj/item/rig/proc/partially_activated()
	return activation_state & RIG_ACTIVATION_IS_CYCLING

/**
 * blocking proc
 *
 * uses existing activation operation if one is in progress
 * interrupts existing deactivation operation if one is in progress
 *
 * @return TRUE / FALSE success / failure
 */
/obj/item/rig/proc/activation_sequence(instant, deploy, auto_seal = TRUE, instant_seal)
	if(activation_state == RIG_ACTIVATION_ONLINE)
		return TRUE
	interrupt_if_deactivating()
	if(activation_mutex)
		if(instant)
			interrupt_if_activating()
		else
			block_on_activation(activation_operation)

	activation_mutex = TRUE
	activation_state = RIG_ACTIVATION_ACTIVATING
	push_ui_data(list("activation" = RIG_ACTIVATION_ACTIVATING))

	#warn feedback to people around

	var/delay = instant? 0 : boot_delay
	var/start_time = world.time
	var/operation_id = activation_operation

	while(world.time < start_time + delay)
		if(activation_operation != operation_id)
			break
		stoplag(1)

	if(activation_operation == operation_id)
		activate(deploy, auto_seal, instant_seal)
		++activation_operation
		activation_mutex = FALSE

/**
 * blocking proc
 *
 * uses existing activation operation if one is in progress
 * interrupts existing deactivation operation if one is in progress
 *
 * @return TRUE / FALSE success / failure
 */
/obj/item/rig/proc/deactivation_sequence(instant)
	if(activation_state == RIG_ACTIVATION_OFFLINE)
		return TRUE
	interrupt_if_activating()
	if(activation_mutex)
		if(instant)
			interrupt_if_deactivating()
		else
			block_on_deactivation(activation_operation)

	activation_mutex = TRUE
	activation_state = RIG_ACTIVATION_DEACTIVATING
	push_ui_data(list("activation" = RIG_ACTIVATION_DEACTIVATING))

	#warn feedback to people around

	var/delay = instant? 0 : boot_delay
	var/start_time = world.time
	var/operation_id = activation_operation

	while(world.time < start_time + delay)
		if(activation_operation != operation_id)
			break
		stoplag(1)

	if(activation_operation == operation_id)
		deactivate()
		++activation_operation
		activation_mutex = FALSE

/obj/item/rig/proc/activate()
	set_weight(online_weight)
	set_encumbrance(online_encumbrance)

	activation_state = RIG_ACTIVATION_ONLINE
	push_ui_data(list("activation" = RIG_ACTIVATION_ONLINE))

	#warn feedback to people around

/obj/item/rig/proc/deactivate()
	set_weight(offline_weight)
	set_encumbrance(offline_encumbrance)

	activation_state = RIG_ACTIVATION_OFFLINE
	push_ui_data(list("activation" = RIG_ACTIVATION_OFFLINE))

	#warn feedback to people around

/obj/item/rig/proc/interrupt_if_activating()
	if(activation_state != RIG_ACTIVATION_ACTIVATING)
		return
	++activation_operation

/obj/item/rig/proc/interrupt_if_deactivating()
	if(activation_state != RIG_ACTIVATION_DEACTIVATING)
		return
	++activation_operation

/obj/item/rig/proc/block_on_activation(operation_id)
	// todo: behavior unverified; operation id is not checked.
	UNTIL(!activation_mutex)
	return activation_state == RIG_ACTIVATION_ONLINE

/obj/item/rig/proc/block_on_deactivation(operation_id)
	// todo: behavior unverified; operation id is not checked.
	UNTIL(!activation_mutex)
	return activation_state == RIG_ACTIVATION_OFFLINE
