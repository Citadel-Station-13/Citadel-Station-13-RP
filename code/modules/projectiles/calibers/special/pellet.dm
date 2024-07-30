
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
