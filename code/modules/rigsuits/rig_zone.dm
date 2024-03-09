//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * to avoid having 10 lists, we instead have 6 datums :/
 */
/datum/rig_zone
	//* STATIC VALUES, DO NOT CHANGE AT RUNTIME *//
	var/zone_enum
	var/zone_bit

	//* State Store *//
	/// modules registered on us
	var/list/obj/item/rig_module/modules
	/// our brute damage
	var/brute_damage = 0
	/// our burn damage
	var/burn_damage = 0
	/// our max integrity
	var/max_integrity = 100
	/// used slots
	var/slot_used = 0
	/// slots available
	var/slot_capacity = 0
	/// used volume
	var/volume_used = 0
	/// volume available
	var/volume_capacity = 0

/datum/rig_zone/Destroy()
	if(length(modules))
		stack_trace("deleted with active modules")
		modules = null
	return ..()

/datum/rig_zone/proc/reset_state_after_wipe()
	ASSERT(!length(modules))
	brute_damage = 0
	burn_damage = 0
	slot_used = 0
	volume_used = 0

/datum/rig_zone/head
	zone_enum = RIG_ZONE_HEAD
	zone_bit = RIG_ZONE_BIT_HEAD

/datum/rig_zone/chest
	zone_enum = RIG_ZONE_CHEST
	zone_bit = RIG_ZONE_BIT_CHEST

/datum/rig_zone/left_arm
	zone_enum = RIG_ZONE_LEFT_ARM
	zone_bit = RIG_ZONE_BIT_LEFT_ARM

/datum/rig_zone/right_arm
	zone_enum = RIG_ZONE_RIGHT_ARM
	zone_bit = RIG_ZONE_BIT_RIGHT_ARM

/datum/rig_zone/left_leg
	zone_enum = RIG_ZONE_LEFT_LEG
	zone_bit = RIG_ZONE_BIT_LEFT_LEG

/datum/rig_zone/right_leg
	zone_enum = RIG_ZONE_RIGHT_LEG
	zone_bit = RIG_ZONE_BIT_RIGHT_LEG
