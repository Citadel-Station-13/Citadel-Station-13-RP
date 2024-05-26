/obj/item/gun/projectile/ballistic/jsdf_rifle
	name = "\improper JSDF service rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I have brought this motivational device! Uses 9.5x40mm rounds."
	icon = 'icons/factions/governments/oricon/guns.dmi'
	icon_state = "battlerifle"
	base_icon_state = "battlerifle"
	worn_state = "battlerifle"
	inhand_state = "battlerifle"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK

	recoil = GUN_RECOIL_HEAVY
	recoil_wielded_multiplier = GUN_RECOIL_MITIGATION_MEDIUM

	fire_sound = 'sound/weapons/battlerifle.ogg'

	use_magazines = TRUE
	regex_this_caliber = /datum/caliber/a9_5mm

/obj/item/gun/projectile/ballistic/shotgun/pump/JSDF
	name = "\improper JSDF tactical shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day. Uses 12g rounds."
	icon_state = "haloshotgun"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "haloshotgun_i"
	item_icons = null
	ammo_type = /obj/item/ammo_casing/a12g
	max_shells = 12
