//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/shield_projector
	name = "shield projector"
	desc = "A shield projector that forms a deflector shield some distance away from the vehicle."
	#warn sprite

	module_slot = VEHICLE_MODULE_SLOT_HULL

	var/active = FALSE

	var/make_comp_shield_pattern = /datum/directional_shield_pattern
	var/make_comp_shield_health = 200
	var/make_comp_shield_health_max = 200

	var/make_comp_shield_color_empty = "#ff0000"
	var/make_comp_shield_color_full = "#44cccc"

	var/make_comp_shield_regen_rate = 10
	var/make_comp_shield_regen_delay = 5 SECONDS
	var/make_comp_shield_regen_ignore_gradual = TRUE
	var/make_comp_shield_rebuild_rate = 20
	var/make_comp_shield_rebuild_ratio = 1

	/// joules to use when recharging 1 health
	var/make_comp_shield_build_cost_factor = 30
	/// watts to maintain per 1 health
	var/make_comp_shield_maintain_cost_factor = 10

	/// do we rebuild when off?
	/// * if off, this needs to rebuild when it's turned on.
	var/make_comp_shield_rebuilds_while_off = FALSE

	var/datum/component/directional_shield/shield_component

/obj/item/vehicle_module/shield_projector/on_install(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	. = ..()

/obj/item/vehicle_module/shield_projector/on_uninstall(obj/vehicle/vehicle, datum/event_args/actor/actor, silent)
	. = ..()

/obj/item/vehicle_module/shield_projector/proc/activate(datum/event_args/actor/actor)
	#warn impl

/obj/item/vehicle_module/shield_projector/proc/deactivate(datum/event_args/actor/actor)
	#warn impl

#warn impl all
/obj/item/vehicle_module/shield_projector/proc/handle_damage_instance(list/shieldcall_args)


/obj/item/vehicle_module/shield_projector/omnidirectional
	name = "omnidirectional shield projector"
	desc = /obj/item/vehicle_module/shield_projector::desc + " This one projects in the shape of a full radius around the hull."
	shield_pattern = /datum/directional_shield_pattern/square/r_5x5

/obj/item/vehicle_module/shield_projector/omnidirectional/reticence
	name = "faint omni shield"
	desc = "A perfected Silencium combat shield. The manner by which it distorts the air is the only way to tell it's there at all."
	#warn sprite
	shield_color_full = "#CFCFCF"
	shield_color_empty = "#FFC2C2"

/obj/item/vehicle_module/shield_projector/linear
	name = "linear shield projector"
	desc = /obj/item/vehicle_module/shield_projector::desc + " This one projects in the shape of a line in-front of the chassis."
	shield_pattern = /datum/directional_shield_pattern/linear/gap_2/width_5

/obj/item/vehicle_module/shield_projector/linear/reticent
	name = "linear combat shield"
	desc = "A Silencium infused linear combat shield. Its faint presence cannot be easily detected."
	#warn sprite
	icon_state = "shield_mime"
	shield_color_full = "#CFCFCF"
	shield_color_empty = "#FFC2C2"
