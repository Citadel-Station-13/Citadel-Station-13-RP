
#warn this


/obj/item/ammo_casing/p_pellet
	name = "pellet"
	desc = "Also know as a BB, it is shot from airguns for recreational shooting."
	caliber = "pellet"
	icon_state = "pellet"
	projectile_type = /obj/projectile/bullet/practice
	casing_flags = CASING_DELETE


/obj/item/ammo_magazine/pellets
	name = "box of pellets"
	desc = "A box containing small pellets for a pellet gun."
	icon_state = "pelletbox"
	caliber = "pellet"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/p_pellet
	materials_base = list(MAT_PLASTIC = 600)
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_casing/p_pellet
	name = "pellet"
	desc = "Also know as a BB, it is shot from airguns for recreational shooting."
	icon = 'icons/obj/gun/ballistic/caseless/pellet.dmi'
	regex_this_caliber = /datum/caliber/pellet
	icon_state = "pellet_single"
	projectile_type = /obj/projectile/bullet/practice
	casing_flags = CASING_DELETE

/obj/item/ammo_magazine/pellets
	name = "box of pellets"
	desc = "A box containing small pellets for a pellet gun."
	icon = 'icons/obj/gun/ballistic/caseless/pellet.dmi'
	icon_state = "pelletbox"
	ammo_caliber = /datum/caliber/pellet
	ammo_type = /obj/item/ammo_casing/p_pellet
	materials_base = list(MAT_PLASTIC = 600)
	ammo_max = 50
	multiple_sprites = 1

	is_speedloader = TRUE
