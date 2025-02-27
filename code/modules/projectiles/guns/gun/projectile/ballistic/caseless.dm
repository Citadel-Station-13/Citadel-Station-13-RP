/obj/item/gun/projectile/ballistic/caseless/prototype
	name = "prototype caseless rifle"
	desc = "This experimental rifle is the efforts of Nanotrasen's R&D division, made manifest. Uses 5mm solid-phoron caseless rounds, obviously."
	icon_state = "caseless"
	item_state = "caseless"
	w_class = WEIGHT_CLASS_BULKY
	caliber = /datum/ammo_caliber/a5mm
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
	slot_flags = SLOT_BACK
	magazine_restrict = /obj/item/ammo_magazine/m5mmcaseless
	one_handed_penalty = 15

/obj/item/gun/projectile/ballistic/caseless/prototype/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/caseless/prototype/loaded
	magazine_preload = /obj/item/ammo_magazine/m5mmcaseless

/obj/item/gun/projectile/ballistic/caseless/pellet
	name = "pellet gun"
	desc = "An air powered rifle that shoots near harmless pellets. Used for recreation in enviroments where firearm ownership is restricted."
	icon_state = "pellet"
	item_state = "pellet"
	wielded_item_state = "pellet-wielded"
	caliber = /datum/ammo_caliber/pellet
	internal_magazine = TRUE
	internal_magazine_size = 1
	internal_magazine_preload_ammo = /obj/item/ammo_casing/p_pellet
	fire_sound = 'sound/weapons/tap.ogg'
