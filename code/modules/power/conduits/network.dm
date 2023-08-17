//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * the plasma network
 */
/datum/wirenet/plasma
	/// volume of plasma
	var/volume
	/// temperature of plasma
	var/temperature
	/// materials in plasma
	var/list/materials
	/// energy lost per second
	var/energy_loss = 0.025
	/// cached rendering objects
	var/atom/movable/plasmanet_renderer/renderers

#warn take joint.energy_loss into account

/datum/wirenet/plasma/New()
	START_PROCESSING(SSobj, src)
	return ..()

/datum/wirenet/plasma/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/wirenet/plasma/process(delta_time)
	volume *= (1 - energy_loss) ** (delta_time * 0.1)
	update_icons()

/datum/wirenet/plasma/proc/update_icons()
	#warn impl

/datum/wirenet/plasma/proc/vis_object(vis_key)
	if(!vis_key)
		return
	#warn impl

/datum/wirenet/plasma/remove_segment(obj/structure/wire/conduit/joint)
	. = ..()

/datum/wirenet/plasma/remove_segments(list/obj/structure/wire/conduit/joints)
	. = ..()

/datum/wirenet/plasma/add_segment(obj/structure/wire/conduit/joint)
	. = ..()

/atom/movable/plasmanet_renderer
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER | VIS_INHERIT_ID
