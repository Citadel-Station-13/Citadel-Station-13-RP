/datum/firemode/ballistic/autorifle/automat
	burst_amount = 3
	burst_spacing = 1.5
	fire_delay = 7.5

/obj/item/gun/projectile/ballistic/automat
	name = "Avtomat Rifle"
	desc = " A Bolt Action Rifle taken apart and retooled into a primitive machine gun. Bulky and obtuse, it still capable of unleashing devastating firepower with its 15 round internal drum magazine. Loads with 7.62 stripper clips."
	icon = 'icons/modules/projectiles/guns/ballistic/autorifle.dmi'
	icon_state = "automat"
	base_icon_state = "automat"
	render_flick_firing = "automat-fire"
	damage_force = 10
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	worn_icon = 'icons/modules/projectiles/guns/ballistic/autorifle.dmi'
	worn_state = "automat"
	inhand_icon = 'icons/modules/projectiles/guns/generic.dmi'
	inhand_state = "rifle1"
	render_mob_wielded = TRUE
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	wieldable = TRUE
	encumbrance = ITEM_ENCUMBRANCE_GUN_LARGE

	regex_this_firemodes = /datum/caliber/a7_62mm

	recoil = GUN_RECOIL_HEAVY
	recoil_wielded_multiplier = GUN_RECOIL_MITIGATION_HIGH
	instability_motion = GUN_INSTABILITY_MOTION_HEAVY

	use_magazines = FALSE
	speedloader_allowed = TRUE
	internal_ammo_capacity = 14
	internal_ammo_preload = /obj/item/ammo_casing/a762

	regex_this_firemodes = list(
		/datum/firemode/ballistic/autorifle/automat,
	)

/obj/item/gun/projectile/ballistic/automat/holy
	internal_ammo_preload = /obj/item/ammo_casing/a762/silver
