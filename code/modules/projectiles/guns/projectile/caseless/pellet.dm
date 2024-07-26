///////////////////////////////////////
// Pellet Gun - For Recerational Use //
///////////////////////////////////////

#define DEFINE_CALIBER_PELLET 804

/obj/item/gun/ballistic/caseless/pellet
	name = "pellet gun"
	desc = "An air powered rifle that shoots near harmless plastic pellets. Used for recreation in enviroments where firearm ownership is restricted."
	icon = 'icons/obj/gun/ballistic/caseless/pellet.dmi'
	icon_state = "pellet"
	item_state = "pellet"
	wielded_item_state = "pellet-wielded"
	caliber = "pellet"
	fire_sound = 'sound/weapons/tap.ogg'
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/p_pellet
	load_method = SINGLE_CASING
	item_icons = list("left_hand" = 'icons/mob/items/lefthand_guns.dmi', "right_hand" = 'icons/mob/items/righthand_guns.dmi')

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
