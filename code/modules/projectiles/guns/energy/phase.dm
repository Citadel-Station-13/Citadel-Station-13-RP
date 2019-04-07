// Phase weapons go here

/obj/item/gun/energy/phasegun
	name = "phase carbine"
	desc = "The NT EW26 Artemis is a downsized energy weapon, specifically designed for use against wildlife."
	icon_state = "phasecarbine"
	item_state = "phasecarbine"
	wielded_item_state = "phasecarbine-wielded"
	slot_flags = SLOT_BACK|SLOT_BELT
	firemodes = /datum/firemode/energy/phase

/obj/item/gun/energy/phasegun/pistol
	name = "phase pistol"
	desc = "The NT  EW15 Apollo is an energy handgun, specifically designed for self-defense against aggressive wildlife."
	icon_state = "phase"
	item_state = "taser"	//I don't have an in-hand sprite, taser will be fine
	w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	firemodes = /datum/firemode/energy/phase/pistol

/obj/item/gun/energy/phasegun/pistol/mounted
	name = "mounted phase pistol"
	self_recharge = TRUE
	use_external_power = ENERGY_GUN_EXTERNAL_CHARGE

/obj/item/gun/energy/phasegun/rifle
	name = "phase rifle"
	desc = "The NT EW31 Orion is a specialist energy weapon, intended for use against hostile wildlife."
	icon_state = "phaserifle"
	item_state = "phaserifle"
	wielded_item_state = "phaserifle-wielded"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	firemodes = /datum/firemode/energy/phase/rifle

/obj/item/gun/energy/phasegun/cannon
	name = "phase cannon"
	desc = "The NT EW50 Gaia is a massive energy weapon, purpose-built for clearing land. You feel dirty just looking at it."
	icon_state = "phasecannon"
	item_state = "phasecannon"
	wielded_item_state = "phasecannon-wielded"	//TODO: New Sprites
	w_class = ITEMSIZE_HUGE		// This thing is big.
	slot_flags = SLOT_BACK
	firemodes = /datum/firemode/energy/phase/cannon
