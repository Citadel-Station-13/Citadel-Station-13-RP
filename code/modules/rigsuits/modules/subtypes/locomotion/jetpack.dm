//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * locomotion modules that provide space / frictionless movement
 */
/obj/item/rig_module/locomotion/jetpack

#warn impl
#warn ion trail?

/obj/item/rig_module/locomotion/jetpack/gas
	name = /obj/item/rig_module::name + " (maneuvering jets)"
	desc = /obj/item/rig_module::desc + " This one allows a user to manevuer while off the ground using \
	jets of gas."

	#warn resource route system
	/// gas key to pull from
	var/gas_route = "jetpack"

	/// grams of gas to go one tile
	var/jet_movement_mass = 0.0625 * 28 // ~ 3 x 192 tiles for 28 molar mass n2 gas

/obj/item/rig_module/locomotion/jetpack/gas/Initialize()

/obj/item/rig_module/locomotion/jetpack/gas/rig_data()
	. = ..()



/**
 * @return grams pulled
 */
/obj/item/rig_module/locomotion/jetpack/gas/proc/attempt_run_mass(grams, datum/gas_mixture/send_to)
	var/datum/gas_mixture/mixture = host.resources.gas_mixture_ref(src, gas_route)
	if(!mixture)
		return 0


#warn impl

/obj/item/rig_module/locomotion/jetpack/gas/ion
	name = /obj/item/rig_module::name + " (ion thruster)"
	desc = /obj/item/rig_module::desc + " This one allows a maneuver while off the ground using jets of \
	gas released through an ion thruster. Far more efficient than a normal gas maneuvering unit when powered, \
	but significantly less efficient when ran unpowered."

	jet_movement_mass = /obj/item/rig_module/locomotion/jetpack/gas::jet_movement_mass * 1.33 // less efficient when unpowered

	/// is ion engine on
	var/ion_assist_enabled = FALSE
	/// ion assist movement mass multiplier
	/// * lower is better, 0.5 = lasts twice as long.
	var/ion_assist_mass_multiplier = 0.5 // overall lasts 50% longer
	/// joules per tile
	var/ion_assist_tile_energy = 2000

/obj/item/rig_module/locomotion/jetpack/gas/ion/attempt_run_mass(grams, datum/gas_mixture/send_to)


/obj/item/rig_module/locomotion/jetpack/gas/ion/rig_data()
	. = ..()
	.["ion"] = TRUE
	.["ionEnabled"] = ion_assist_enabled

/obj/item/rig_module/locomotion/jetpack/gas/ion/rig_act(datum/event_args/actor/actor, control_flags, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggleIon")
			#warn right flags?
			if(!check_control_flags_or_reject_topic_act(actor, RIG_CONTROL_MODULES))
				return TRUE
			ion_assist_enabled = !ion_assist_enabled
			rig_push_data(list("ionEnabled" = ion_assist_enabled))
			return TRUE

