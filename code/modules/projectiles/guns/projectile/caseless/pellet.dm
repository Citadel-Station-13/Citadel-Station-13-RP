/datum/ammo_caliber/pellet
	caliber = "pellet"

/obj/item/gun/projectile/ballistic/caseless/pellet
	name = "pellet gun"
	desc = "An air powered rifle that shoots near harmless plastic pellets. Used for recreation in enviroments where firearm ownership is restricted."
	icon = 'icons/obj/gun/ballistic/caseless/pellet.dmi'
	icon_state = "pellet"
	item_state = "pellet"
	wielded_item_state = "pellet-wielded"
	caliber = /datum/ammo_caliber/pellet
	fire_sound = 'sound/weapons/tap.ogg'
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/p_pellet
	load_method = SINGLE_CASING
	item_icons = list("left_hand" = 'icons/mob/items/lefthand_guns.dmi', "right_hand" = 'icons/mob/items/righthand_guns.dmi')
