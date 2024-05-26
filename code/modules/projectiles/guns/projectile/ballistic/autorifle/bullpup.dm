/obj/item/gun/projectile/ballistic/bullpup
	name = "bullpup rifle"
	desc = "The bullpup configured GP3000 is a battle rifle produced by Gurov Projectile Weapons LLC. It is sold almost exclusively to standing armies. Uses 7.62mm rounds."
	icon = 'icons/modules/projectiles/guns/ballistic/autorifle.dmi'
	icon_state = "bullpup"
	worn_icon = 'icons/modules/projectiles/guns/generic.dmi'
	worn_state = "rifle2"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 10
	regex_this_caliber = /datum/caliber/a7_62mm
	slot_flags = SLOT_BACK
	encumbrance = ITEM_ENCUMBRANCE_GUN_LARGE

	use_magazines = TRUE
	magazine_type = /obj/item/ammo_magazine/m762
	recoil = GUN_RECOIL_HEAVY
	recoil_wielded_multiplier = GUN_RECOIL_MITIGATION_HIGH
	instability_draw = GUN_INSTABILITY_DRAW_HEAVY
	instability_wield = GUN_INSTABILITY_WIELD_MEDIUM
	instability_motion = GUN_INSTABILITY_MOTION_LIGHT

	magazine_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'

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
