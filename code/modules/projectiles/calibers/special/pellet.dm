/datum/caliber/pellet
	caliber = "pellet"

#warn this

//* Ammunition *//

/obj/item/ammo_casing/p_pellet
	name = "pellet"
	desc = "Also know as a BB, it is shot from airguns for recreational shooting."
	regex_this_caliber = /datum/caliber/pellet
	icon_state = "pellet"
	projectile_type = /obj/projectile/bullet/practice
	casing_flags = CASING_DELETE
	materials_base = list(
		/datum/material/plastic::id = 10,
	)

//* Magazines *//

/obj/item/ammo_magazine/pellets
	name = "box of pellets"
	desc = "A box containing small pellets for a pellet gun."
	icon_state = "pelletbox"
	ammo_caliber = /datum/caliber/pellet
	ammo_type = /obj/item/ammo_casing/p_pellet
	is_magazine = FALSE
	materials_base = list(
		/datum/material/steel::id = 100,
	)
	ammo_max = 50
	multiple_sprites = 1
