/obj/item/gun/projectile/ballistic/jsdf_rifle
	name = "\improper JSDF service rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I have brought this motivational device! Uses 9.5x40mm rounds."
	icon_state = "battlerifle"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "battlerifle_i"
	item_icons = null
	w_class = ITEMSIZE_LARGE
	recoil = 2 // The battlerifle was known for its nasty recoil.
	max_shells = 36
	caliber = "9.5x40mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m95
	allowed_magazines = list(/obj/item/ammo_magazine/m95)
	fire_sound = 'sound/weapons/battlerifle.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	one_handed_penalty = 60 // The weapon itself is heavy

/obj/item/gun/projectile/ballistic/shotgun/pump/JSDF
	name = "\improper JSDF tactical shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day. Uses 12g rounds."
	icon_state = "haloshotgun"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "haloshotgun_i"
	item_icons = null
	ammo_type = /obj/item/ammo_casing/a12g
	max_shells = 12
