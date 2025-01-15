//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/energy_handler
	name = "weapon energy handler"
	desc = "A basic power regulator used in powered weaponry."
	icon = 'icons/modules/projectiles/components/energy_handler.dmi'
	component_slot = GUN_COMPONENT_ENERGY_HANDLER

/obj/item/gun_component/energy_handler/slide_rack
	name = "weapon energy handler (slide charging)"
	desc = {"
		An energy handler that requires an user to rack the weapon to perform a charge cycle.
	"}

/obj/item/gun_component/energy_handler/slide_rack/summarize_bullet_points(datum/event_args/actor/actor, range)
	. = list()
	var/keybind_render_unique_action = actor?.initiator.client?.print_keys_for_keybind_with_prefs_link(/datum/keybinding/item/unique_action)
	. += "Requires racking the weapon via Unique Action (<b>[keybind_render_unique_action]</b>) between shots. This will initiate an 'active reload', with a <b>constant</b> reload interval where you can finish the action early."
	. += "Pressing Unique action (<b>[keybind_render_unique_action]</b>) again will attempt to finish the active reload early. This will <b>abort</b> the reload if it is done at the wrong time."
	. += "Slowly recharges without a slide rack."
	. += "Increases the available power on a fired shot."
	. += "Suffers decreased efficiency on burst shots."

/obj/item/gun_component/energy_handler/slide_rack/active_reload
	name = "weapon energy handler (synchronous slide charging)"
	desc = {"
		An energy handler that requires an user to rack the weapon at a specific point in the charge cycle.
	"}

/obj/item/gun_component/energy_handler/slide_rack/active_reload/summarize_bullet_points(datum/event_args/actor/actor, range)
	. = list()
	var/keybind_render_unique_action = actor?.initiator.client?.print_keys_for_keybind_with_prefs_link(/datum/keybinding/item/unique_action)
	. += "Requires racking the weapon via Unique Action (<b>[keybind_render_unique_action]</b>) between shots. This will initiate an 'active reload', with a <b>ranndomized</b> reload interval where you can finish the action early."
	. += "Pressing Unique action (<b>[keybind_render_unique_action]</b>) again will attempt to finish the active reload early. This will <b>abort</b> the reload if it is done at the wrong time."
	. += "Slowly recharges without a slide rack."
	. += "Increases the available power on a fired shot."
	. += "On a <b>successful active reload</b> (early finish), this will further increase the available power on a fired shot."
	. += "Suffers decreased efficiency on burst shots."

// TODO: This file is mostly stubs and WIPs.
