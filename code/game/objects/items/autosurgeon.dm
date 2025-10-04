//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/autosurgeon

	var/one_use = FALSE

	var/obj/item/organ/organ
	var/organ_initial_type

#warn impl all or atleast get wip semi-working
#warn allow picking organ location if multiple locations are valid

/obj/item/autosurgeon/one_use
	one_use = TRUE

/obj/item/autosurgeon/one_use/augment

/obj/item/autosurgeon/one_use/augment/single_deploy

/obj/item/autosurgeon/one_use/augment/single_deploy/laser_array
	organ_initial_type = /obj/item/organ/internal/augment/single_deploy/laser_array

/obj/item/autosurgeon/one_use/augment/single_deploy/laser_array/gamma
	organ_initial_type = /obj/item/organ/internal/augment/single_deploy/laser_array/gamma

/obj/item/autosurgeon/one_use/augment/single_deploy/engineering_multitool
	organ_initial_type = /obj/item/organ/internal/augment/single_deploy/engineering_multitool

/obj/item/autosurgeon/one_use/augment/single_deploy/surgical_multitool
	organ_initial_type = /obj/item/organ/internal/augment/single_deploy/surgical_multitool

/obj/item/autosurgeon/one_use/augment/single_deploy/hardlight_shield
	organ_initial_type = /obj/item/organ/internal/augment/single_deploy/hardlight_shield

/obj/item/autosurgeon/one_use/augment/single_deploy/cns_rebooter
	organ_initial_type = /obj/item/organ/internal/augment/cns_rebooter
