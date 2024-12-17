//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_chassis/quadruped

/datum/prototype/robot_chassis/quadruped/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		normal_out |= /obj/item/dogborg/boop_module
		#warn route the matsynth?
		normal_out |= /obj/item/dogborg/tongue
	return ..()
