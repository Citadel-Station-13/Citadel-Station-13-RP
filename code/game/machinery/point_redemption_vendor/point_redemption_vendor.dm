//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/point_redemption_vendor
	name = "point redemption vendor"
	desc = "An equipment vendor that trades points for various gear. Usually found in the station's departments \
		and used to incentivize good performance."
	#warn sprite
#warn impl	density = TRUE
	anchored = TRUE

	/// point type we operate with
	var/point_type

	/// flick tihs state when denying sometihng
	var/icon_state_append_deny
	/// set to this state if panel is open
	//  todo: render at /obj/machinery level
	var/icon_state_append_open
	/// set to this state if we're depowered
	//  todo: render at /obj/machinery level
	var/icon_state_append_off
	/// flick this state when vending something
	var/icon_state_append_vend
	/// set to this state if we're broken
	var/icon_state_append_broken

/obj/machinery/point_redemption_vendor/drop_products(method, atom/where)
	. = ..()
	if(inserted_id)
		drop_product(inserted_id, where)
		inserted_id = null

/obj/machinery/point_redemption_vendor/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/machinery/point_redemption_vendor/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/point_redemption_vendor/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/point_redemption_vendor/ui_data(mob/user, datum/tgui/ui)
	. = ..()

