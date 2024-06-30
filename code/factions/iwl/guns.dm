/obj/item/gun/ballistic/automatic/k25
	name = "League Service Rifle"
	desc = "A cheaply-made but rugged and reliable K25 semi-automatic rifle. A staple weapon of the Interplanetary Worker's League naval and armed forces, it handles a lighter caliber than other weaponry but packs quite the punch either way."
	icon_state = "k25"
	w_class = WEIGHT_CLASS_BULKY
	recoil = 2 // The battlerifle was known for its nasty recoil.
	max_shells = 45
	caliber = "9.5x40mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/k25_m
	allowed_magazines = list(/obj/item/ammo_magazine/k25_m)
	fire_sound = 'sound/factions/iwl/gun_k25.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	one_handed_penalty = 40 // The weapon itself is heavy

/obj/item/gun/ballistic/automatic/k25/update_icon()
	. = ..()
	update_held_icon()

/obj/item/gun/ballistic/automatic/k25/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/k25_m))
		icon_state = "k25"
	else
		icon_state = (ammo_magazine)? "k25" : "k25_e"

// ---------- AMMO & MAGAZINE

/obj/item/ammo_magazine/k25_m
	name = "box mag (9.5x40mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "k25_m"
	caliber = "9.5x40mm"
	ammo_type = /obj/item/ammo_casing/a95
	max_ammo = 45
	mag_type = MAGAZINE
	multiple_sprites = 1

/obj/item/ammo_casing/s72
	desc = "A 9.5x40mm bullet casing."
	icon_state = "rifle-casing"
	caliber = "9.5x40mm"
	projectile_type = /obj/projectile/bullet/rifle/s72

/obj/projectile/bullet/rifle/s72
	damage = 35

/obj/item/ammo_magazine/k25_m/empty
	initial_ammo = 0
