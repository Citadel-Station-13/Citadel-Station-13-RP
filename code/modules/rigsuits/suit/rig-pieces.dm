//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig/proc/get_piece_components()

/obj/item/rig/proc/get_piece_component_by_registered_id(id)

/obj/item/rig/proc/get_piece_components_by_zone_bits()

#warn impl

/// Regarding sealing / unsealing
///
/// RIG pieces are nominally sealed if the RIG is activated,
/// unsealed otherwise.
///
/// They must unseal to retract.
/// They should seal after deployment.

/**
 * does not block
 *
 * @return TRUE/FALSE success/failure
 */
/obj/item/rig/proc/deploy_piece_async(datum/component/rig_piece/piece, auto_seal = TRUE, instant_seal, force, subtle, silent)
	if(!piece.deploy(wearer, force? INV_OP_FORCE | INV_OP_CAN_DISPLACE : NONE, subtle, silent))
		return FALSE
	piece.currently_retracting = FALSE
	if(auto_seal)
		INVOKE_ASYNC(src, PROC_REF(seal_piece_sync), piece, instant_seal, subtle, silent)
	return TRUE

/**
 * blocks on unsealing
 *
 * @return TRUE/FALSE success/failure
 */
/obj/item/rig/proc/undeploy_piece_sync(datum/component/rig_piece/piece, instant_unseal, force, subtle, silent)
	piece.currently_retracting = TRUE
	if(!unseal_piece_sync(piece, instant_unseal, subtle, silent))
		return FALSE
	if(!piece.currently_retracting)
		return FALSE
	piece.currently_retracting = FALSE
	if(!piece.retract(force? INV_OP_FORCE : NONE, subtle, silent))
		return FALSE
	return TRUE

/**
 * blocks on sealing
 *
 * if existing sealing operation is occurring, uses that instead of starting a new one.
 * if existing unsealing operation is occurring, interrupts that.
 *
 * @return TRUE/FALSE success/failure
 */
/obj/item/rig/proc/seal_piece_sync(datum/component/rig_piece/piece, instant, subtle, silent)
	if(activation_state != RIG_ACTIVATION_ONLINE)
		return FALSE
	return piece.seal_sync(instant, subtle, silent)

/**
 * blocks on unsealing
 *
 * if existing unsealing operation is occurring, uses that instead of starting a new one.
 * if existing sealing operation is occurring, interrupts that.
 *
 * @return TRUE/FALSE success/failure
 */
/obj/item/rig/proc/unseal_piece_sync(datum/component/rig_piece/piece, instant, subtle, silent)
	return piece.unseal_sync(instant, subtle, silent)

/**
 * deploys all pieces; non-blocking
 */
/obj/item/rig/proc/deploy_suit_async(auto_seal = TRUE, instant_seal, force, subtle, silent)
	for(var/id in piece_lookup)
		var/datum/component/rig_piece/piece = piece_lookup[id]
		INVOKE_ASYNC(src, PROC_REF(deploy_piece_async), piece, auto_seal, instant_seal, force, subtle, silent)
	return TRUE

/**
 * undeploys all pieces; non-blocking
 */
/obj/item/rig/proc/undeploy_suit_async(instant_unseal, force, subtle, silent)
	for(var/id in piece_lookup)
		var/datum/component/rig_piece/piece = piece_lookup[id]
		if(!piece.is_deployed())
			continue
		INVOKE_ASYNC(src, PROC_REF(undeploy_piece_sync), piece, instant_unseal, force, subtle, silent)
	return TRUE

/**
 * undeploys all pieces; blocking
 *
 * can instantly fails if one piece fails, does not wait for the others.
 * this behavior is not ensured 100% of the time.
 *
 * @return TRUE / FALSE on success / failure
 */
/obj/item/rig/proc/undeploy_suit_sync(instant_unseal, force, subtle, silent)
	var/list/collected = list()
	. = TRUE
	for(var/id in piece_lookup)
		var/datum/component/rig_piece/piece = piece_lookup[id]
		if(!piece.is_deployed())
			continue
		INVOKE_ASYNC(src, PROC_REF(undeploy_piece_sync), piece, instant_unseal, force, subtle, silent)
		//* warning: shitcode ahead
		//* this relies on the fact byond is single-threaded
		//* because we know for sure that sync immediately sleeps, wihch means that
		//* we can grab the operation id immediately
		if(!piece.seal_mutex && (piece.sealed != RIG_PIECE_UNSEALED))
			// failed instantly
			. = FALSE
		else
			collected[piece] = piece.seal_operation
	if(!.)
		return
	for(var/datum/component/rig_piece/piece as anything in collected)
		. = . && piece.block_on_unsealing(collected[piece])

/obj/item/rig/proc/add_piece(datum/component/rig_piece/piece)
	LAZYINITLIST(piece_lookup)
	if(piece_lookup[piece.lookup_prefix])
		var/count = 1
		do
			piece.lookup_id = "[piece.lookup_prefix][++count]"
		while(piece_lookup[piece.lookup_id])
	else
		piece.lookup_id = piece.lookup_prefix
	piece_lookup[piece.lookup_id] = piece

/obj/item/rig/proc/remove_piece(datum/component/rig_piece/piece)
	piece_lookup -= piece.lookup_id
	// obliterates the component too
	QDEL_NULL(piece.parent)

/obj/item/rig/proc/legacy_sync_piece(datum/component/rig_piece/piece, sealed)
	var/obj/item/physical = piece.parent
	if(piece.rig_piece_flags & RIG_PIECE_APPLY_ARMOR)
		physical.set_armor(suit_armor)
	else
		physical.reset_armor()
	if((piece.rig_piece_flags & RIG_PIECE_APPLY_ENVIRONMENTALS) && sealed)
		physical.max_pressure_protection = max_pressure_protect
		physical.min_pressure_protection = min_pressure_protect
		physical.max_heat_protection_temperature = max_temperature_protect
		physical.min_cold_protection_temperature = min_temperature_protect
	else
		physical.max_pressure_protection = initial(physical.max_pressure_protection)
		physical.min_pressure_protection = initial(physical.min_pressure_protection)
		physical.max_heat_protection_temperature = initial(physical.max_heat_protection_temperature)
		physical.min_cold_protection_temperature = initial(physical.min_cold_protection_temperature)
	if(!piece.always_fully_insulated)
		physical.siemens_coefficient = siemens_coefficient
	else
		physical.siemens_coefficient = 0
