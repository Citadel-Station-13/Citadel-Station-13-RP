//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/stack_recipe/material_recipe
	abstract_type = /datum/stack_recipe/material
	sort_order = -1
	category = "Material - Misc"
	// todo: material constraints

// these are here to have the langserv cast for us since we know stack is material

/datum/stack_recipe/material_recipe/craft(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return ..()

/datum/stack_recipe/material_recipe/check(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return ..()

/datum/stack_recipe/material_recipe/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return ..()
