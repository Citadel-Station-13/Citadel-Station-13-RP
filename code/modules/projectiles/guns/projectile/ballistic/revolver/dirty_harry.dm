/obj/item/gun/projectile/ballistic/revolver/dirty_harry
	name = "Model 29 Revolver"
	desc = "A powerful hand cannon made famous by the legendary lawman that wielded it. Even to this day people follow in his legacy. 'Are you feeling lucky punk?'"
	icon_state = "dirty_harry"
	item_state = "revolver"
	caliber = ".44"
	fire_sound = 'sound/weapons/Gunshot_deagle.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/revolver/dirty_harry/holy
	name = "Blessed Model 29"
	ammo_type = /obj/item/ammo_casing/a44/silver
