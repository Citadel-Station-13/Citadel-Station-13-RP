//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * bindings for an access tunneler
 */
/obj/item/rig_module/basic/access_tunneler
	name = /obj/item/rig_module/basic::name + " (access tunneler)"
	desc = /obj/item/rig_module/basic::desc + " This one allows overriding some devices aboard the facility \
	via pre-inserted access codes."

	display_name = "access tunneler"
	display_desc = "Allows overriding certain facility devices, including airlocks, at a mild power cost. \
	This will emit an alert to command and security channels."

	impl_click = TRUE

	var/obj/item/access_tunneler/mounted
	/// automatically sets everything as needed.
	var/lazy_automount_path = /obj/item/access_tunneler

/obj/item/rig_module/basic/access_tunneler/Initialize(mapload)
	. = ..()
	if(lazy_automount_path)
		mounted = new lazy_automount_path

/obj/item/rig_module/basic/access_tunneler/Destroy()
	QDEL_NULL(mounted)
	return ..()

/obj/item/rig_module/basic/facility_access_override/lazy_on_click(atom/target, mob/user, intent, zone, efficiency, datum/event_args/actor/actor)
	. = ..()

#warn impl
#warn item mount it??
