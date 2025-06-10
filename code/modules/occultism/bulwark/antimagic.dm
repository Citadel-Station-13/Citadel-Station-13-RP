//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Antimagic struct.
 * * This is a struct datum, like armor and bodytypes. It's not a prototype.
 */
/datum/antimagic
	/// priority; lower is checked first
	var/priority = ANTIMAGIC_PRIORITY_DEFAULT

/datum/antimagic/New(priority)
	if(!isnull(priority))
		src.priority = priority

/datum/antimagic/proc/handle_antimagic(list/antimagic_args)
	return

/**
 * Simple scaling
 *
 * We fully block magic at a given potency, falling off linearly to a given other potency.
 */
/datum/antimagic/simple_linear
	/// magic types blocked
	var/magic_types = MAGIC_TYPES_ALL
	/// potency we can block fully
	var/full_block_potency = MAGIC_POTENCY_BASELINE
	/// potency at which we can't block
	var/cant_block_potency = MAGIC_POTENCY_BASELINE

/datum/antimagic/simple_linear/handle_antimagic(list/antimagic_args)
	if(!(antimagic_args[ANTIMAGIC_ARG_TYPE] & magic_types))
		return
	var/attacking_potency = antimagic_args[ANTIMAGIC_ARG_POTENCY]
	if(attacking_potency <= full_block_potency)
		antimagic_args[ANTIMAGIC_ARG_EFFICIENCY] = 0
	else if(attacking_potency <= cant_block_potency)
		antimagic_args[ANTIMAGIC_ARG_EFFICIENCY] *= ((attacking_potency - full_block_potency) / (cant_block_potency - full_block_potency))

/**
 * Just invokes a callback to modify antimagic call args
 */
/datum/antimagic/use_callback
	var/datum/callback/antimagic_callback

/datum/antimagic/use_callback/New(priority, datum/callback/antimagic_callback)
	..(priority)
	src.antimagic_callback = antimagic_callback

/datum/antimagic/use_callback/handle_antimagic(list/antimagic_args)
	antimagic_callback?.invoke_no_sleep(antimagic_args)
