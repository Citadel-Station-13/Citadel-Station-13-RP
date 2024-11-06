//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/energy_handler
	name = "weapon energy handler"
	component_slot = GUN_COMPONENT_ENERGY_HANDLER

/obj/item/gun_component/energy_handler/active_reload
	name = "weapon energy handler (slide charging)"
	desc = {"
		An uncommon energy handler. Requires the user to rack the weapon to recharge
		a linked supercapacitor array between shots for fast operation. In return,
		the power provided to a given shot is improved by a decent margin.
	"}

/obj/item/gun_component/energy_handler/active_reload/summarize_bullet_points(datum/event_args/actor/actor, range)
	. = list()
	#warn hotkey hook
	. += "Requires racking the weapon via Unique Action (<b>[]</b>) between shots. This will initiate an 'active reload', with a <b>constant</b> reload interval where you can finish the action early."
	. += "Pressing Unique action (<b>[]</b>) again will attempt to finish the active reload early. This will <b>abort</b> the reload if it is done at the wrong time."
	. += "Slowly recharges without a slide rack."
	. += "Increases the available power on a fired shot."
	. += "Suffers decreased efficiency on burst shots."

/obj/item/gun_component/energy_handler/active_reload/perfect
	name = "weapon energy handler (synchronous slide charging)"
	desc = {"
		An uncommon energy handler. Requires the user to rack the weapon to recharge
		a linked supercapacitor array between shots for fast operation. In return,
		the power provided to a given shot is improved by a decent margin. This one is
		even more unwieldly to use, requiring the slide action to coincide with the chaotic peak
		of an initiated recharging cycle for optimal performance.
	"}

/obj/item/gun_component/energy_handler/active_reload/perfect/summarize_bullet_points(datum/event_args/actor/actor, range)
	. = list()
	#warn hotkey hook
	. += "Requires racking the weapon via Unique Action (<b>[]</b>) between shots. This will initiate an 'active reload', with a <b>ranndomized</b> reload interval where you can finish the action early."
	. += "Pressing Unique action (<b>[]</b>) again will attempt to finish the active reload early. This will <b>abort</b> the reload if it is done at the wrong time."
	. += "Slowly recharges without a slide rack."
	. += "Increases the available power on a fired shot."
	. += "On a <b>successful active reload</b> (early finish), this will further increase the available power on a fired shot."
	. += "Suffers decreased efficiency on burst shots."

#warn impl all

// TODO: This file is mostly stubs and WIPs.
