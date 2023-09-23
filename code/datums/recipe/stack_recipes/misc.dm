//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/stack_recipe/oar
	name = "oar"
	result_type = /obj/item/oar
	cost = 2

/datum/stack_recipe/oar/make(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir)
	var/obj/item/stack/material/material_stack = stack
	if(istype(material_stack))
		for(var/i in 1 to amount)
			new result_type(where, material_stack.material)
	else
		for(var/i in 1 to amount)
			new result_type(where)

/datum/stack_recipe/boat
	name = "boat"
	result_type = /obj/vehicle/ridden/boat
	cost = 15

/datum/stack_recipe/boat/make(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir)
	var/obj/item/stack/material/material_stack = stack
	if(istype(material_stack))
		for(var/i in 1 to amount)
			new result_type(where, material_stack.material)
	else
		for(var/i in 1 to amount)
			new result_type(where)

/datum/stack_recipe/dragon_boat
	name = "dragon boat"
	result_type = /obj/vehicle/ridden/boat/dragon
	cost = 25

/datum/stack_recipe/dragon_boat/make(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir)
	var/obj/item/stack/material/material_stack = stack
	if(istype(material_stack))
		for(var/i in 1 to amount)
			new result_type(where, material_stack.material)
	else
		for(var/i in 1 to amount)
			new result_type(where)

/datum/stack_recipe/pew
	abstract_type = /datum/stack_recipe/pew
	exclusitivity = /obj/structure/bed
	cost = 1

/datum/stack_recipe/pew/make(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir)
	var/obj/item/stack/material/material_stack = stack
	if(istype(material_stack))
		for(var/i in 1 to amount)
			new result_type(where, material_stack.material)
	else
		for(var/i in 1 to amount)
			new result_type(where)

/datum/stack_recipe/pew/middle
	name = "pew (middle)"
	result_type = /obj/structure/bed/chair/pew

/datum/stack_recipe/pew/left
	name = "pew (left)"
	result_type = /obj/structure/bed/chair/pew/left

/datum/stack_recipe/pew/right
	name = "pew (right)"
	result_type = /obj/structure/bed/chair/pew/right
