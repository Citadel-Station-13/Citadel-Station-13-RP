//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Default trash bag storage.
 */
/datum/object_system/storage/trash_bag
	mass_operation_dumping_limit_per_second = 8
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	limited_random_access_amount = 8
	limited_random_access_total_weight_volume = WEIGHT_VOLUME_NORMAL * 3
	// needed for LRA to work
	ui_force_slot_mode = TRUE
