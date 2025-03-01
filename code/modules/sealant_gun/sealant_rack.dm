//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/structure/sealant_rack
	name = "sealant rack"
	desc = "A rack for holding tanks of sealant, and a sealant gun."
	icon = 'icons/modules/sealant_gun/sealant_rack.dmi'
	icon_state = "rack"
	base_icon_state = "rack"

	var/obj/item/gun/projectile/sealant_gun/stored_gun
	var/list/obj/item/sealant_tank/stored_tanks
	var/stored_tanks_lazy_init

	var/initial_gun_path
	var/initial_stored_tanks = 0

	var/max_stored_tanks = 5

/obj/structure/sealant_rack/Initialize()
	. = ..()
	if(initial_gun_path)
		stored_gun = new initial_gun_path(src)

/obj/structure/sealant_rack/Destroy()
	QDEL_LIST(stored_tanks)
	QDEL_NULL(stored_gun)
	return ..()

/obj/structure/sealant_rack/update_icon()
	cut_overlays()
	. = ..()
	for(var/i in 1 to min(5, ceil(5 * (get_tank_count() / max_stored_tanks))))
		var/image/tank_overlay = image(icon, "[base_icon_state]-tank")
		tank_overlay.pixel_x = (i - 1) * 5
		add_overlay(tank_overlay)
	if(stored_gun)
		add_overlay("[base_icon_state]-gun")

/obj/structure/sealant_rack/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()

/obj/structure/sealant_rack/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/structure/sealant_rack/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/structure/sealant_rack/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/structure/sealant_rack/proc/get_tank_count()
	return length(stored_tanks) + (isnull(stored_tanks_lazy_init) ? initial_stored_tanks : stored_tanks_lazy_init)

/obj/structure/sealant_rack/proc/user_retrieve_gun(datum/event_args/actor/actor, no_sound, no_message)

/obj/structure/sealant_rack/proc/retrieve_gun(atom/new_loc, silent) as /obj/item/gun/projectile/sealant_gun
	RETURN_TYPE(/obj/item/gun/projectile/sealant_gun)

	if(!stored_gun)
		return
	. = stored_gun
	if(new_loc)
		stored_gun.forceMove(new_loc)
	stored_gun = null

/obj/structure/sealant_rack/proc/user_retrieve_tank(datum/event_args/actor/actor, no_sound, no_message)

/obj/structure/sealant_rack/proc/retrieve_tank(atom/new_loc, silent) as /obj/item/sealant_tank
	RETURN_TYPE(/obj/item/sealant_tank)

#warn impl

/obj/structure/sealant_rack/loaded
	initial_gun_path = /obj/item/gun/projectile/sealant_gun
	initial_stored_tanks = 5
