//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/stack_synth/robot_stack_synth
	/// our id, if any. this is used to find us when binding things to the robot's synths.
	/// * null will use typepath
	/// * change this from default and things that look for path won't be able to
	///   find the default. this can be done intentionally for some use cases.
	var/id
	/// what this is called in-ui
	var/display_name = "material store"
	/// provides a stack of a given type automatically.
	var/provide_stack_path
	/// allow automatic computation of 'sum types'
	var/automatically_form_sum_types = FALSE

	// todo: proper recharge and/or storage system, instead of
	//       support only for charger restoration
	// todo: use cm3 maybe?

	/// total stack amount stored; null to default to max
	var/amount
	/// maximum stack amount stored
	var/amount_max = 10
	/// base sheets regenerated per recharge tick
	var/amount_regen = 1

/datum/stack_synth/robot_stack_synth/New()
	..()
	if(isnull(amount))
		amount = amount_max

//* presets - engineering *//

#warn name the ones in this section

/datum/stack_synth/robot_stack_synth/wire
	provide_stack_path = /obj/item/stack/cable_coil
	amount_max = 250
	amount_regen = 30

/datum/stack_synth/robot_stack_synth/material
	automatically_form_sum_types = TRUE

/datum/stack_synth/robot_stack_synth/material/steel
	provide_stack_path = /obj/item/stack/material/steel
	amount_max = 100
	amount_regen = 2.5

/datum/stack_synth/robot_stack_synth/material/glass
	provide_stack_path = /obj/item/stack/material/glass
	amount_max = 100
	amount_regen = 2.5

/datum/stack_synth/robot_stack_synth/material/wood
	provide_stack_path = /obj/item/stack/material/wood
	amount_max = 50
	amount_regen = 1

/datum/stack_synth/robot_stack_synth/material/plasteel
	provide_stack_path = /obj/item/stack/material/plasteel
	amount_max = 20
	amount_regen = 0.5

/datum/stack_synth/robot_stack_synth/material/plastic
	provide_stack_path = /obj/item/stack/material/plastic
	amount_max = 20
	amount_regen = 0.5

//* presets - medical *//

/datum/stack_synth/robot_stack_synth/bandages
	display_name = "bandage roller"
	provide_stack_path = /obj/item/stack/medical/bruise_pack
	amount_max = 50
	amount_regen = 5

/datum/stack_synth/robot_stack_synth/bandages/advanced
	display_name = "dermal nanowrap roller"
	provide_stack_path = /obj/item/stack/medical/advanced/bruise_pack
	amount_max = 50
	amount_regen = 5

/datum/stack_synth/robot_stack_synth/ointment
	display_name = "ointment tank"
	provide_stack_path = /obj/item/stack/medical/ointment
	amount_max = 50
	amount_regen = 5

/datum/stack_synth/robot_stack_synth/ointment/advanced
	display_name = "advanced ointment tank"
	provide_stack_path = 	amount_max = 50
	amount_max = 50
	amount_regen = 5

/datum/stack_synth/robot_stack_synth/nanopaste
	display_name = "synthetic polyfill nanites"
	provide_stack_path = /obj/item/stack/nanopaste/advanced
	amount_max = 50
	amount_regen = 5
