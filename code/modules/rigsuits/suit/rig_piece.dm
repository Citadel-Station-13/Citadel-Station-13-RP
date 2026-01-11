//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/rig_piece
	//* Appearance
	/// display name - what is used for UIs
	var/display_name
	var/state_sealed
	var/state_unsealed
	var/state_worn_sealed
	var/state_worn_unsealed

	//* Deployment
	/// currently undeploying - used as a mutex-ish so deploy/undeploy can interrupt each other.
	var/currently_retracting = FALSE

	//* Flags
	/// piece intrinsic flags
	var/rig_piece_flags = NONE
	/// which zones we count as
	var/rig_zone_bits = NONE
	/// inventory hide flags when sealed
	var/inv_hide_flags_sealed
	/// inventory hide flags when unsealed
	var/inv_hide_flags_unsealed

	//* RIG / Piece
	/// Our controller
	var/obj/item/rig/controller
	/// Our deployment slot
	var/inventory_slot
	/// our controller-unique ID; this is set per controller
	var/lookup_id
	/// lookup prefix
	var/lookup_prefix = "unkw"

	//* Sealing
	/// are we sealed?
	/// if we're currently cycling, seal_mutex should always be TRUE. the opposite is not always the case.
	var/sealed = RIG_PIECE_UNSEALED
	/// in the process of a seal operation - used internally as a mutex. don't fuck with this var.
	/// this is set to TRUE at the start of a cycle and set to FALSe after
	/// do not use this to interrupt, do not fuck with this var.
	var/seal_mutex = FALSE
	/// the cycle of the sealing operation we're in, so we can override existing ones by changing this number
	/// when a new operation starts, the current number is used; interrupting or finishing adds 1.
	var/seal_operation = 0

	//* Stats
	//! todo: legacy
	/// insulated gloves support
	var/always_fully_insulated = FALSE

	//* UI
	//! todo: this is fucking evil
	/// cached b64 string of our UI icon
	var/cached_tgui_icon_b64
	/// is our UI update queued?
	var/ui_update_queued = FALSE

/datum/component/rig_piece/Initialize(obj/item/rig/controller)
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!isitem(parent))
		return . | COMPONENT_INCOMPATIBLE
	src.controller = controller
	#warn impl

/datum/component/rig_piece/Destroy()
	controller = null
	return ..()

/datum/component/rig_piece/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_UNEQUIPPED, PROC_REF(signal_unequipped))

/datum/component/rig_piece/UnregisterFromParent()
	// todo: optimize this
	interrupt_if_sealing()
	interrupt_if_unsealing()
	. = ..()
	UnregisterSignal(parent, COMSIG_ITEM_UNEQUIPPED)

/datum/component/rig_piece/proc/signal_unequipped(datum/source, mob/unequipper, slot, flags)
	SIGNAL_HANDLER
	if(flags & INV_OP_SHOULD_NOT_INTERCEPT)
		return
	retract(INV_OP_FORCE)
	#warn so we do need this on unequipped not just dropped fuck
	return COMPONENT_ITEM_INV_OP_RELOCATE | COMPONENT_ITEM_INV_OP_SUPPRESS_SOUND

/datum/component/rig_piece/proc/rig_data()
	var/obj/item/physical = parent
	#warn needs to have better caching for the b64, this is way too slow for production
	return list(
		"$tgui" = "RigsuitPiece",
		"$src" = RIG_UI_ENCODE_MODULE_REF(ref(src)),
		"name" = display_name,
		"id" = lookup_id,
		"sealed" = sealed,
		"deployed" = is_deployed(),
		"flags" = rig_piece_flags,
		"sprite64" = isnull(cached_tgui_icon_b64)? (cached_tgui_icon_b64 = icon2base64(icon(physical.icon, state_sealed, SOUTH, 1, FALSE))) : cached_tgui_icon_b64
	)

/datum/component/rig_piece/proc/rig_push_data(list/data)
	controller?.push_ui_modules(updates = list(RIG_UI_ENCODE_PIECE_REF(src) = data))

/datum/component/rig_piece/proc/seal_sync(instant, silent, subtle)
	if(sealed == RIG_PIECE_SEALED)
		return TRUE
	interrupt_if_unsealing()
	// we're still sealing / not interrupted
	if(seal_mutex)
		// if instant, interrupt anyways
		if(instant)
			interrupt_if_sealing()
		else
			return block_on_sealing(seal_operation)
	seal_mutex = TRUE
	sealed = RIG_PIECE_SEALING
	push_piece_data(list("sealed" = RIG_PIECE_SEALING))
	#warn maint panel

	var/delay = instant? 0 : controller.seal_delay
	var/start_time = world.time
	var/operation_id = seal_operation

	while(world.time < start_time + delay)
		if(seal_operation != operation_id)
			break
		stoplag(1)

	if(seal_operation == operation_id)
		seal(silent, subtle)
		++seal_operation
		seal_mutex = FALSE

	return sealed == RIG_PIECE_SEALED

/datum/component/rig_piece/proc/unseal_sync(instant, silent, subtle)
	if(sealed == RIG_PIECE_UNSEALED)
		return TRUE
	interrupt_if_sealing()
	// we're still sealing / not interrupted
	if(seal_mutex)
		// if instant, interrupt anyways
		if(instant)
			interrupt_if_unsealing()
		else
			return block_on_unsealing(seal_operation)
	seal_mutex = TRUE
	sealed = RIG_PIECE_UNSEALING
	push_piece_data(list("sealed" = RIG_PIECE_UNSEALING))
	#warn maint panel

	var/delay = instant? 0 : controller.seal_delay
	var/start_time = world.time
	var/operation_id = seal_operation

	while(world.time < start_time + delay)
		if(seal_operation != operation_id)
			break
		stoplag(1)

	if(seal_operation == operation_id)
		unseal(silent, subtle)
		++seal_operation
		seal_mutex = FALSE

	return sealed == RIG_PIECE_UNSEALED

/**
 * @params
 * * silent - suppress sound
 * * subtle - suppress message
 */
/datum/component/rig_piece/proc/seal(silent, subtle)
	// todo: sound
	// todo: feedback visual?
	var/obj/item/physical = parent
	physical.worn_state = state_worn_sealed
	physical.icon_state = state_sealed
	physical.update_worn_icon()
	controller.legacy_sync_piece(src, TRUE)
	sealed = RIG_PIECE_SEALED
	#warn maint panel
	update_piece_data()

	if(!is_deployed())
		stack_trace("not properly deployed?")

	ADD_TRAIT(src, TRAIT_ITEM_NODROP, RIG_PIECE_TRAIT(src))

	if(!subtle)
		physical.visible_message(
			SPAN_NOTICE("[physical] snugly latches around [controller.wearer]."),
			range = MESSAGE_RANGE_INVENTORY_SOFT,
		)

	return TRUE

/**
 * @params
 * * actor - (optional) actor data for this action
 * * silent - suppress sound
 * * subtle - suppress message
 */
/datum/component/rig_piece/proc/unseal(silent, subtle)
	// todo: sound
	// todo: feedback visual?
	var/obj/item/physical = parent
	physical.worn_state = state_worn_unsealed
	physical.icon_state = state_unsealed
	physical.update_worn_icon()
	controller.legacy_sync_piece(src, FALSE)
	sealed = RIG_PIECE_UNSEALED
	#warn maint panel
	update_piece_data()

	REMOVE_TRAIT(src, TRAIT_ITEM_NODROP, RIG_PIECE_TRAIT(src))

	if(!subtle)
		physical.visible_message(
			SPAN_NOTICE("[physical] unlatches from [controller.wearer]."),
			range = MESSAGE_RANGE_INVENTORY_SOFT,
		)

	return TRUE

/datum/component/rig_piece/proc/deploy(mob/onto, inv_op_flags, subtle, silent)
	if(isnull(onto))
		return FALSE
	var/obj/item/I = parent
	if(I.loc == onto)
		return TRUE
	else if(I.loc != controller)
		retract(INV_OP_FORCE, TRUE, TRUE)
	if(isnull(inventory_slot))
		return FALSE
	. = onto.equip_to_slot_if_possible(I, inventory_slot, inv_op_flags, onto)
	if(!.)
		return
	// todo: some kind of visual feedback to people around them?
	#warn impl - audio only
	#warn maint panel
	update_piece_data()

/datum/component/rig_piece/proc/retract(inv_op_flags, subtle, silent)
	var/obj/item/I = parent
	if(I.loc == controller)
		return TRUE

	switch(sealed)
		if(RIG_PIECE_SEALED)
			unseal()
		if(RIG_PIECE_SEALING)
			interrupt_if_sealing()
		if(RIG_PIECE_UNSEALING)
			interrupt_if_unsealing()
			unseal()

	var/mob/wearing = I.worn_mob()
	if(isnull(wearing))
		I.forceMove(controller)
	else
		. = wearing.transfer_item_to_loc(I, controller, inv_op_flags | INV_OP_SHOULD_NOT_INTERCEPT, wearing)
		if(!.)
			return
	// todo: some kind of visual feedback to people around them?
	#warn impl - audio only
	#warn maint panel
	update_piece_data()

/datum/component/rig_piece/proc/is_deployed()
	var/obj/item/I = parent
	if(ispath(inventory_slot))
		var/datum/inventory_slot/slot_meta = inventory_slot
		inventory_slot = initial(slot_meta.id)
	return I.worn_slot == inventory_slot

/**
 * interrupt if sealing
 */
/datum/component/rig_piece/proc/interrupt_if_sealing()
	if(sealed != RIG_PIECE_SEALING)
		return
	sealed = RIG_PIECE_UNSEALED
	++seal_operation
	seal_mutex = FALSE

/**
 * interrupt if unsealing
 */
/datum/component/rig_piece/proc/interrupt_if_unsealing()
	if(sealed != RIG_PIECE_UNSEALING)
		return
	sealed = RIG_PIECE_SEALED
	++seal_operation
	seal_mutex = FALSE

/datum/component/rig_piece/proc/block_on_sealing(operation_id)
	// todo: behavior unverified; operation id is not checked.
	UNTIL(!(seal_mutex && (sealed == RIG_PIECE_SEALING)))
	return sealed == RIG_PIECE_SEALED

/datum/component/rig_piece/proc/block_on_unsealing(operation_id)
	// todo: behavior unverified; operation id is not checked.
	UNTIL(!(seal_mutex && (sealed == RIG_PIECE_UNSEALING)))
	return sealed == RIG_PIECE_UNSEALED

//* Console *//
//  TODO: implement

// /**
//  * @return list(command = desc, ...)
//  */
// /datum/component/rig_piece/proc/console_query(effective_control_flags, username)
// 	return list(
// 		"deploy \['seal'?\]" = "Deploy to user. Use 'deploy seal' to seal after deployment.",
// 		"retract" = "Retract into controller.",
// 		"seal" = "Seal around user",
// 		"unseal" = "Unseal from user.",
// 	)

// /**
//  * @return list(output, admin log text)
//  */
// /datum/component/rig_piece/proc/console_process(effective_control_flags, username, command, list/arguments)
// 	switch(command)
// 		if("deploy")
// 			#warn impl
// 		if("retract")
// 			#warn impl
// 		if("seal")
// 			#warn impl
// 		if("unseal")
// 			#warn impl
// 	return list("unknown command", "<invalid>")

//* Base Piece Defs *//

/obj/item/clothing/head/rig
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | ALLOW_SURVIVALFOOD | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB | CLOTHING_ALLOW_SINGLE_LIMB | ALLOWINTERNALS
	inv_hide_flags = HIDEEARS | HIDEEYES | HIDEFACE | BLOCKHAIR
	body_cover_flags = HEAD | FACE | EYES
	heat_protection_cover = HEAD | FACE | EYES
	cold_protection_cover = HEAD | FACE | EYES

/obj/item/clothing/suit/rig

/obj/item/clothing/gloves/rig
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | ALLOW_SURVIVALFOOD | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB | CLOTHING_ALLOW_SINGLE_LIMB | ALLOWINTERNALS
	inv_hide_flags = NONE
	body_cover_flags = HANDS
	heat_protection_cover = HANDS
	cold_protection_cover = HANDS

/obj/item/clothing/gloves/rig/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	return !istype(I, /obj/item/clothing/gloves/rig)

/obj/item/clothing/shoes/rig

/obj/item/clothing/shoes/rig/equip_worn_over_check(mob/M, slot, mob/user, obj/item/I, flags)
	return !istype(I, /obj/item/clothing/shoes/rig)
