//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/material_recipe
	/// recipe name
	var/name = "???"
	/// result type
	var/result_type = /obj/item/clothing/mask/ninjascarf
	/// result amount; stacks will be processed accordingly
	var/result_amount = 1
	/// the amount of time to craft result_amount of result_type
	var/time = 3 SECONDS
	/// bypass checks for preventing turf stacking/whatnot
	var/no_automatic_sanity_checks = FALSE
	// todo: material constraints

#warn impl

/datum/material_recipe
