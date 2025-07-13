/datum/ammo_caliber/pellet
	id = "pellet"
	caliber = "pellet"

//* Ammunition *//

/obj/item/ammo_casing/p_pellet
	name = "pellet"
	desc = "Also know as a BB, it is shot from airguns for recreational shooting."
	casing_caliber = /datum/ammo_caliber/pellet
	icon = 'icons/obj/gun/ballistic/caseless/pellet.dmi'
	icon_state = "pellet_single"
	projectile_type = /obj/projectile/bullet/practice
	casing_flags = CASING_DELETE
	materials_base = list(
		/datum/prototype/material/plastic::id = 10,
	)

//* Magazines *//

/obj/item/ammo_magazine/pellets
	name = "box of pellets"
	desc = "A box containing small pellets for a pellet gun."

	icon = 'icons/obj/gun/ballistic/caseless/pellet.dmi'
	icon_state = "pelletbox-50"
	base_icon_state = "pelletbox"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	ammo_caliber = /datum/ammo_caliber/pellet
	ammo_preload = /obj/item/ammo_casing/p_pellet
	magazine_class = MAGAZINE_CLASS_POUCH
	materials_base = list(
		/datum/prototype/material/steel::id = 100,
	)
	ammo_max = 50
