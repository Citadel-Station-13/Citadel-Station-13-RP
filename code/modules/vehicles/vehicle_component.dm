//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/vehicle_component
	name = "vehicle component"
	desc = "Some kind of component that presumably goes on some kind of vehicle."

	/// bind shieldtype type; must be a path of /datum/shieldcall/bound/vehicle_component if set.
	var/autobind_shieldcall_type
	var/datum/shieldcall/bound/vehicle_component/autobind_shieldcall

#warn impl

/**
 * @return string
 */
/obj/item/vehicle_component/proc/examine_render_name(datum/event_args/examine/examine)
	return name

/**
 * @return list or string
 */
/obj/item/vehicle_component/proc/examine_render_on_vehicle(datum/event_args/examine/examine)
	var/integrity_string = examine_render_integrity(examine)
	return "It has [examine_render_name(examine)] attached.[integrity_string ? " [integrity_string]" : ""]"

/obj/item/vehicle_component

/obj/item/vehicle_component

/obj/item/vehicle_component

/obj/item/vehicle_component

/obj/item/vehicle_component

/**
 * Supertype of shieldcalls that handle vehicle hits. Just subtype one
 * and set the path on your component to use them.
 */
/datum/shieldcall/bound/vehicle_component
	expected_type = /obj/vehicle
