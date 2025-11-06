//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * simple single-item deployer augments
 * * deployed items will be mounted to the augment's resource bus.
 */
/obj/item/organ/internal/augment/single_deploy
	#warn name
	#warn sprite

	var/obj/item/gear
	var/gear_path
	var/gear_display_name

/obj/item/organ/internal/augment/single_deploy/Initialize(mapload)
	. = ..()
	init_gear()

/obj/item/organ/internal/augment/single_deploy/Destroy()
	QDEL_NULL(gear)
	return ..()

/obj/item/organ/internal/augment/single_deploy/proc/init_gear()

/obj/item/organ/internal/augment/single_deploy/proc/deploy_gear()

/obj/item/organ/internal/augment/single_deploy/proc/retract_gear()

#warn impl all

#warn gun impls for these

/obj/item/organ/internal/augment/single_deploy/laser_array

/obj/item/organ/internal/augment/single_deploy/laser_array/gamma

/obj/item/organ/internal/augment/single_deploy/engineering_multitool

/obj/item/organ/internal/augment/single_deploy/surgical_multitool

/obj/item/organ/internal/augment/single_deploy/hardlight_shield
