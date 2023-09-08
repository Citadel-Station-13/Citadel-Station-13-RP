//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/stack_recipe/material/furniture
	abstract_type = /datum/stack_recipe/material/furniture
	category = "Material - Furniture"

#warn chair, bed, double bed, stool, grave marker, sculpting block

/datum/stack_recipe/material/furniture/bed
	name = "bed"
	result_type = /obj/structure/bed
	exclusitivity = /obj/structure/bed
	cost = 2

/datum/stack_recipe/material/furniture/bed/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return new /obj/structure/bed(where, stack.material)

/datum/stack_recipe/material/furniture/double_bed
	name = "double bed"
	result_type = /obj/structure/bed/double
	exclusitivity = /obj/structure/bed
	cost = 3

/datum/stack_recipe/material/furniture/double_bed/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return new /obj/structure/bed/double(where, stack.material)

/datum/stack_recipe/material/furniture/stool
	name = "stool"
	result_type = /obj/item/stool
	exclusitivity = /obj/item/stool
	cost = 3

/datum/stack_recipe/material/furniture/stool/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return new /obj/item/stool(where, stack.material)

/datum/stack_recipe/material/furniture/chair
	name = "chair"
	result_type = /obj/structure/bed/chair
	exclusitivity = /obj/structure/bed
	cost = 3

/datum/stack_recipe/material/furniture/chair/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return new /obj/structure/bed/chair(where, stack.material)
