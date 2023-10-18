//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/stack_recipe/material/structure
	abstract_type = /datum/stack_recipe/material/structure
	category = "material - structure"

/datum/stack_recipe/material/structure/door
	name = "simple door"
	result_type = /obj/structure/simple_door
	cost = 5

/datum/stack_recipe/material/structure/door/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir, list/created = list())
	for(var/i in 1 to amount)
		created += new /obj/structure/simple_door(where, stack.material)
	return TRUE

/datum/stack_recipe/material/structure/barricade
	name = "barricade"
	result_type = /obj/structure/barricade
	cost = 5

/datum/stack_recipe/material/structure/barricade/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir, list/created = list())
	for(var/i in 1 to amount)
		created += new /obj/structure/barricade(where, stack.material)
	return TRUE

/datum/stack_recipe/material/structure/girder
	name = "girder"
	result_type = /obj/structure/girder
	cost = 2

/datum/stack_recipe/material/structure/girder/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir, list/created = list())
	for(var/i in 1 to amount)
		created += new /obj/structure/girder(where, stack.material)
	return TRUE

/datum/stack_recipe/material/structure/low_wall
	name = "low walls"
	result_type = /obj/structure/wall_frame
	cost = 2

/datum/stack_recipe/material/structure/low_wall/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir, list/created = list())
	for(var/i in 1 to amount)
		created += new /obj/structure/wall_frame(where, stack.material)
	return TRUE

/datum/stack_recipe/material/structure/sculpting_block
	name = "sculpting block"
	result_type = /obj/structure/sculpting_block
	cost = 15

/datum/stack_recipe/material/structure/sculpting_block/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir, list/created = list())
	for(var/i in 1 to amount)
		created += new /obj/structure/sculpting_block(where, stack.material)
	return TRUE
