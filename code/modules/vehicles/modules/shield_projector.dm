//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/shield_projector
	name = "shield projector"
	desc = "A shield projector that forms a deflector shield some distance away from the vehicle."

	module_slot = VEHICLE_MODULE_SLOT_HULL

	var/active = FALSE
	var/shield_pattern = /datum/directional_shield_pattern
	var/shield_health = 200
	var/shield_health_max = 200

	var/shield_regen_rate = 10
	var/shield_regen_delay = 5 SECONDS
	var/shield_regen_ignore_gradual = TRUE
	var/shield_rebuild_rate = 20
	var/shield_rebuild_ratio = 1

	/// joules to use when recharging 1 health
	var/shield_build_cost_factor = 30
	/// watts to maintain per 1 health
	var/shield_maintain_cost_factor = 10

	/// do we rebuild when off?
	/// * if off, this needs to rebuild when it's turned on.
	var/shield_rebuilds_while_off = FALSE

/obj/item/vehicle_module/shield_projector/Initialize()
	projector = new projector_type(src)
	return ..()

/obj/item/vehicle_module/shield_projector/Destroy()
	QDEL_NULL(projector)
	return ..()

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
	shield_pattern = /datum/directional_shield_pattern/square/vehicle

/datum/directional_shield_pattern/square/vehicle
	radius = 2

/obj/item/vehicle_module/shield_projector/linear
	name = "linear shield projector"
	desc = /obj/item/vehicle_module/shield_projector::desc + " This one projects in the shape of a line in-front of the chassis."
	shield_pattern = /datum/directional_shield_pattern/linear/vehicle

/datum/directional_shield_pattern/linear/vehicle
	distance = 2
	halflength = 2
