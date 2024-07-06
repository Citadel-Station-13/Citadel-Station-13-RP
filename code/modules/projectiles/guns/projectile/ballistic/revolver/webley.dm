/obj/item/gun/projectile/ballistic/revolver/webley
	name = "service revolver"
	desc = "A rugged top break revolver based on the Webley Mk. VI model, with modern improvements. Uses .44 magnum rounds."
	icon_state = "webley2"
	item_state = "webley2"
	caliber = ".44"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/revolver/webley/holy
	name = "blessed service revolver"
	ammo_type = /obj/item/ammo_casing/a44/silver

/obj/item/gun/projectile/ballistic/revolver/webley/auto
	name = "autorevolver"
	icon_state = "mosley"
	desc = "A shiny Mosley Autococker automatic revolver, with black accents. Marketed as the 'Revolver for the Modern Era'. Uses .44 magnum rounds."
	fire_delay = 5.7 //Autorevolver. Also synced with the animation
	fire_anim = "mosley_fire"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)

