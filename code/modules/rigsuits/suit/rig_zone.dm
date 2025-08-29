//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * to avoid having 10 lists, we instead have 6 datums :/
 */
/datum/rig_zone
	//* STATIC VALUES, DO NOT CHANGE AT RUNTIME *//
	var/zone_enum
	var/zone_bit

	//* State Store *//
	/// our brute damage
	var/brute_damage = 0
	/// our burn damage
	var/burn_damage = 0
	/// our max integrity
	var/max_integrity = 100
	/// used complexity
	var/complexity_used = 0
	/// complexity available
	var/complexity_capacity = 0
	/// used volume
	var/volume_used = 0
	/// volume available
	var/volume_capacity = 0

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
