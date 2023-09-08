//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/stack_recipe/material/tools
	abstract_type = /datum/stack_recipe/material/tools
	category = "Material - tools"

/datum/stack_recipe/material/tools/ring
	name = "ring"
	result_type = /obj/item/clothing/gloves/ring/material
	cost = 1

/datum/stack_recipe/material/tools/ring/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return new /obj/item/clothing/gloves/ring/material(where, stack.material)

/datum/stack_recipe/material/tools/braclet
	name = "ring"
	result_type = /obj/item/clothing/accessory/bracelet/material
	cost = 1

/datum/stack_recipe/material/tools/ring/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	return new /obj/item/clothing/accessory/bracelet/material(where, stack.material)

/**
 * for the /obj/item/material path
 */
/datum/stack_recipe/material/tools/simple
	abstract_type = /datum/stack_recipe/material/tools/simple

/datum/stack_recipe/material/tools/simple/make(atom/where, amount, obj/item/stack/material/stack, mob/user, silent, use_dir)
	ASSERT(ispath(result_type, /obj/item/material))
	return new result_type(where, stack.material)

/datum/stack_recipe/material/tools/simple/baseball_bat
	name = "baseball bat"
	result_type = /obj/item/material/twohanded/baseballbat
	cost = 7

/datum/stack_recipe/material/tools/simple/astray
	name = "ashtray"
	result_type = /obj/item/material/ashtray
	cost = 2

/datum/stack_recipe/material/tools/simple/spoon
	name = "spoon"
	result_type = /obj/item/material/kitchen/utensil/spoon
	cost = 1

/datum/stack_recipe/material/tools/simple/armor_plate
	name = "improvised armor plate"
	result_type = /obj/item/material/armor_plating
	cost = 2

/datum/stack_recipe/material/tools/simple/grave_marker
	name = "grave marker"
	result_type = /obj/item/material/gravemarker
	cost = 5

/datum/stack_recipe/material/tools/simple/fork
	name = "fork"
	result_type = /obj/item/material/kitchen/utensil/fork
	cost = 1

/datum/stack_recipe/material/tools/simple/blade
	name = "blade"
	result_type = /obj/item/material/butterflyblade
	cost = 4

/datum/stack_recipe/material/tools/simple/hammer_head
	name = "fork"
	result_type = /obj/item/material/hammer_head
	cost = 8
