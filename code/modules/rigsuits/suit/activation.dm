//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

#warn impl all; rig module on_online/offline

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
 * checks if we're in the right inventory slot to activate.
 */
/obj/item/rig/proc/is_in_right_slot()
	return inv_slot_or_index == wearer_required_slot_id

/**
 * blocking proc
 *
 * uses existing activation operation if one is in progress
 * interrupts existing deactivation operation if one is in progress
 *
 * @return TRUE / FALSE success / failure
 */
/obj/item/rig/proc/activation_sequence(instant, deploy, auto_seal = TRUE, instant_seal, subtle, silent, force)
	if(!is_in_right_slot())
		return FALSE

	ASSERT(!isnull(wearer))

	if(activation_state == RIG_ACTIVATION_ONLINE)
		return TRUE
	interrupt_if_deactivating()
	if(activation_mutex)
		if(instant)
			interrupt_if_activating()
		else
			return block_on_activation(activation_operation)

	if(deploy)
		deploy_suit_async(FALSE, FALSE, force)

	activation_mutex = TRUE
	activation_state = RIG_ACTIVATION_ACTIVATING
	push_ui_data(data = list("activation" = RIG_ACTIVATION_ACTIVATING))
	maint_panel?.push_ui_data(data = list("activation" = RIG_ACTIVATION_ACTIVATING))

	if(!instant)
		wearer.visible_message(
			SPAN_NOTICE("[src] hums to life, adjusting its seals as it starts to attach to [wearer].")
		)

	var/delay = instant? 0 : boot_delay
	var/start_time = world.time
	var/operation_id = activation_operation

	while(world.time < start_time + delay)
		if(activation_operation != operation_id)
			break
		stoplag(1)

	if(activation_operation == operation_id)
		activate(deploy, auto_seal, instant_seal, silent, subtle, force, instant)
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
/obj/item/rig/proc/deactivation_sequence(instant, undeploy, silent, subtle, force)
	if(activation_state == RIG_ACTIVATION_OFFLINE)
		return TRUE
	if(interrupt_if_activating())
		return TRUE
	if(activation_mutex)
		if(instant)
			interrupt_if_deactivating()
		else
			return block_on_deactivation(activation_operation)

	activation_mutex = TRUE
	activation_state = RIG_ACTIVATION_DEACTIVATING
	push_ui_data(data = list("activation" = RIG_ACTIVATION_DEACTIVATING))
	maint_panel?.push_ui_data(data = list("activation" = RIG_ACTIVATION_DEACTIVATING))

	if(!instant)
		// wearer is not necessarily there for deactivation
		wearer?.visible_message(
			SPAN_NOTICE("[src] hums to life, adjusting its seals as it starts to detach from [wearer].")
		)

	var/delay = instant? 0 : boot_delay
	var/start_time = world.time
	var/operation_id = activation_operation

	while(world.time < start_time + delay)
		if(activation_operation != operation_id)
			break
		stoplag(1)

	if(activation_operation == operation_id)
		deactivate(silent, subtle, force, instant)
		++activation_operation
		activation_mutex = FALSE

/obj/item/rig/proc/activate(deploy, auto_seal, instant_seal, silent, subtle, force, was_instant)
	if(!is_in_right_slot())
		return FALSE

	ASSERT(!isnull(wearer))

	interrupt_if_deactivating()

	. = TRUE

	set_weight(online_weight)
	set_encumbrance(online_encumbrance)

	ADD_TRAIT(src, TRAIT_ITEM_NODROP, RIG_CONTROLLER_TRAIT(src))

	if(activation_state != RIG_ACTIVATION_ONLINE)
		activation_state = RIG_ACTIVATION_ONLINE
		push_ui_data(data = list("activation" = RIG_ACTIVATION_ONLINE))
		maint_panel?.push_ui_data(data = list("activation" = RIG_ACTIVATION_ONLINE))

		if(was_instant)
			wearer.visible_message(
				SPAN_NOTICE("[src] latches itself around [wearer], its seals and mechanisms locking snugly around their body.")
			)
		else
			wearer.visible_message(
				SPAN_NOTICE("[src] finishes adjusting its seals around [wearer], snugly latching itself around their body")
			)

	if(deploy)
		deploy_suit_async(auto_seal, instant_seal, force)
	else if(auto_seal)
		for(var/id in piece_lookup)
			var/datum/component/rig_piece/piece = piece_lookup[id]
			if(!piece.is_deployed())
				continue
			INVOKE_ASYNC(src, PROC_REF(seal_piece_sync), piece)

/obj/item/rig/proc/deactivate(undeploy, silent, subtle, force, was_instant)
	set_weight(offline_weight)
	set_encumbrance(offline_encumbrance)

	interrupt_if_activating()

	// todo: for now, undeploy/unseal is just instant, instead of being done before the main shutdown sequence
	if(undeploy)
		undeploy_suit_async(TRUE, force)
	else
		for(var/id in piece_lookup)
			var/datum/component/rig_piece/piece = piece_lookup[id]
			if(!piece.is_deployed())
				continue
			unseal_piece_sync(piece, TRUE)

	REMOVE_TRAIT(src, TRAIT_ITEM_NODROP, RIG_CONTROLLER_TRAIT(src))

	if(activation_state != RIG_ACTIVATION_OFFLINE)
		activation_state = RIG_ACTIVATION_OFFLINE
		push_ui_data(data = list("activation" = RIG_ACTIVATION_OFFLINE))
		maint_panel?.push_ui_data(data = list("activation" = RIG_ACTIVATION_OFFLINE))

		// wearer is not always there for deactivation
		wearer?.visible_message(
			SPAN_NOTICE("[src] completely detaches from [wearer], its lights and panels going dim.")
		)

/**
 * @return TRUE if op was interrupted
 */
/obj/item/rig/proc/interrupt_if_activating()
	if(activation_state != RIG_ACTIVATION_ACTIVATING)
		return FALSE
	++activation_operation
	activation_mutex = FALSE
	activation_state = RIG_ACTIVATION_OFFLINE
	return TRUE

/**
 * @return TRUE if op was interrupted
 */
/obj/item/rig/proc/interrupt_if_deactivating()
	if(activation_state != RIG_ACTIVATION_DEACTIVATING)
		return TRUE
	++activation_operation
	activation_mutex = FALSE
	activation_state = RIG_ACTIVATION_ONLINE
	return FALSE

/obj/item/rig/proc/block_on_activation(operation_id)
	// todo: behavior unverified; operation id is not checked.
	UNTIL(!activation_mutex)
	return activation_state == RIG_ACTIVATION_ONLINE

/obj/item/rig/proc/block_on_deactivation(operation_id)
	// todo: behavior unverified; operation id is not checked.
	UNTIL(!activation_mutex)
	return activation_state == RIG_ACTIVATION_OFFLINE
