/obj/item/gun/projectile/ballistic/z8
	name = "designated marksman rifle"
	desc = "The Z8 Bulldog is an older model designated marksman rifle, made by the now defunct Zendai Foundries. Makes you feel like a space marine when you hold it, even though it can only hold 10 round magazines. Uses 7.62mm rounds."
	icon = 'icons/modules/projectiles/guns/ballistic/semirifle.dmi'
	icon_state = "z8-1"
	base_icon_state = "z8"
	render_mob_wielded = TRUE
	w_class = ITEMSIZE_LARGE
	damage_force = 10
	regex_this_caliber = /datum/caliber/a7_62mm
	slot_flags = SLOT_BACK
	worn_icon = 'icons/modules/projectiles/guns/generic.dmi'
	worn_state = "rifle2"
	inhand_icon = 'icons/modules/projectiles/guns/ballistic/semirifle.dmi'
	render_mob_base = "z8"
	use_magazines = TRUE
	magazine_type = /obj/item/ammo_magazine/m762
	magazine_auto_eject = TRUE
	magazine_auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	magazine_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	recoil = GUN_RECOIL_HEAVY
	recoil_wielded_multiplier = GUN_RECOIL_MITIGATION_HIGH
	instability_draw = GUN_INSTABILITY_DRAW_HEAVY
	instability_wield = GUN_INSTABILITY_WIELD_MEDIUM
	instability_motion = GUN_INSTABILITY_MOTION_MEDIUM

	regex_this_firemodes = list(
		/datum/firemode{
			name = "single fire";
		},
	)
