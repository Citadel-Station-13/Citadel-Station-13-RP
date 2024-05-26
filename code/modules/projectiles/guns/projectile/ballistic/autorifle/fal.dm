/obj/item/gun/projectile/ballistic/fal
	name = "FN-FAL"
	desc = "A 20th century Assault Rifle originally designed by Fabrique National. Famous for its use by mercs in grinding proxy wars in backwater nations. This reproduction was probably made for similar purposes."
	icon = 'icons/modules/projectiles/guns/ballistic/autorifle.dmi'
	icon_state = "fal"
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 10
	regex_this_caliber = /datum/caliber/a7_62mm
	slot_flags = SLOT_BACK
	use_magazines = TRUE
	magazine_type = /obj/item/ammo_magazine/m762

	magazine_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'

	recoil = GUN_RECOIL_HEAVY
	recoil_wielded_multiplier = GUN_RECOIL_MITIGATION_HIGH
	instability_draw = GUN_INSTABILITY_DRAW_HEAVY
	instability_wield = GUN_INSTABILITY_WIELD_MEDIUM
	instability_motion = GUN_INSTABILITY_MOTION_LIGHT


	regex_this_firemodes = list(
		/datum/firemode{
			name = "single fire";
		},
		/datum/firemode{
			name = "2-burst";
			burst_amount = 2;
			burst_spacing = 1;
		}
	)
