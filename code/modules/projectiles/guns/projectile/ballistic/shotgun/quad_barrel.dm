/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/quad
	name = "quad-barreled shotgun"
	desc = "A shotgun pattern designed to make the most out of the limited machining capability of the frontier. 4 Whole barrels of death, loads using 12 gauge rounds."
	icon_state = "shotgun_q"
	item_state = "qshotgun"
	recoil = 2
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 4
	w_class = ITEMSIZE_LARGE
	damage_force = 5
	accuracy = 40
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/a12g/pellet

	burst_delay = 0

	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		)
