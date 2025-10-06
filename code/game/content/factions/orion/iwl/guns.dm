// todo: default-unloaded, add /loaded
/obj/item/gun/projectile/ballistic/automatic/k25
	name = "League Service Rifle"
	desc = "A cheaply-made but rugged and reliable K25 semi-automatic rifle. A staple weapon of the Interplanetary Worker's League naval and armed forces, it handles a lighter caliber than other weaponry but packs quite the punch either way."
	icon = 'icons/content/factions/orion/iwl/items/guns/k25.dmi'
	icon_state = "k25"
	w_class = WEIGHT_CLASS_BULKY
	recoil = 2 // The battlerifle was known for its nasty recoil.
	caliber = /datum/ammo_caliber/a9_5mm
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	magazine_preload = /obj/item/ammo_magazine/a9_5mm/k25
	magazine_restrict = /obj/item/ammo_magazine/a9_5mm/k25
	fire_sound = 'sound/content/factions/orion/iwl/gun_k25.ogg'
	slot_flags = SLOT_BACK
	one_handed_penalty = 40 // The weapon itself is heavy
	render_use_legacy_by_default = FALSE
	item_state = null

/obj/item/gun/projectile/ballistic/automatic/k25/update_icon()
	. = ..()
	update_worn_icon()

/obj/item/gun/projectile/ballistic/automatic/k25/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = "k25"
	else
		icon_state = "k25-empty"

// ---------- AMMO & MAGAZINE

/obj/item/ammo_magazine/a9_5mm/k25
	name = "box mag (9.5x40mm)"
	icon = 'icons/content/factions/orion/iwl/ammo_vr.dmi'
	icon_state = "k25_m"
	ammo_caliber = /datum/ammo_caliber/a9_5mm
	ammo_preload = /obj/item/ammo_casing/a95
	ammo_max = 45
	magazine_type = MAGAZINE_TYPE_NORMAL

/obj/item/ammo_magazine/a9_5mm/k25/empty
	ammo_current = 0

// /obj/item/ammo_casing/s72
// 	desc = "A 9.5x40mm bullet casing."
// 	icon_state = "rifle-casing"
// 	caliber = "9.5x40mm"
// 	projectile_type = /obj/projectile/bullet/rifle/s72

// /obj/projectile/bullet/rifle/s72
// 	damage_force = 35
