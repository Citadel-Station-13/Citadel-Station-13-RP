//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_chassis/quadruped
	abstract_type = /datum/prototype/robot_chassis/quadruped

/datum/prototype/robot_chassis/quadruped/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		normal_out |= list(
			/obj/item/robot_builtin/dog_boop_module,
			/obj/item/robot_builtin/dog_tongue,
			/obj/item/robot_builtin/dog_jaws,
			/obj/item/robot_builtin/dog_sleeper,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/robot_builtin/dog_pounce,
		)
	return ..()
