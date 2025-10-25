//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_module/shield_projector
	name = "shield projector"
	desc = "A shield projector that forms a deflector shield some distance away from the vehicle."

	module_slot = VEHICLE_MODULE_SLOT_HULL

	var/active = FALSE

	// TODO: item mount this so we don't need /exosuit paths
	var/projector_type = /obj/item/shield_projector/line/exosuit
	var/obj/item/shield_projector/projector

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

/obj/item/vehicle_module/shield_projector/omnidirectional
	name = "omnidirectional shield projector"
	desc = /obj/item/vehicle_module/shield_projector::desc + " This one projects in the shape of a full radius around the hull."

	projector_type = /obj/item/shield_projector/rectangle/mecha

/obj/item/vehicle_module/shield_projector/linear
	name = "linear shield projector"
	desc = /obj/item/vehicle_module/shield_projector::desc + " This one projects in the shape of a line in-front of the chassis."

	projector_type = /obj/item/shield_projector/line/exosuit
