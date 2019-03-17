/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon_state = "crossbow"
	w_class = ITEMSIZE_SMALL
	item_state = "crossbow"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	suppressed = TRUE
	selfcharge = TRUE
	charge_delay = 0
	removable_battery = FALSE
	automatic_charge_overlays = FALSE
	firemodes = /datum/firemode/energy/ebow

/obj/item/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	firemodes = /datum/firemode/energy/ebow/ninja

/obj/item/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = ITEMSIZE_LARGE
	force = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200000)
	slot_flags = SLOT_BELT
	firemodes = /datum/firemode/energy/ebow/large
