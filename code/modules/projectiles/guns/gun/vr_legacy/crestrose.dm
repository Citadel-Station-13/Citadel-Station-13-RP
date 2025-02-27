/obj/item/gun/projectile/ballistic/automatic/fluff/crestrose
	name = "Crescent Rose"
	desc = "Can you match my resolve? If so then you will succeed. I believe that the human spirit is indomitable. Keep Moving Forward. Uses 7.62mm rounds."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "crestrose_fold"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "laser" //placeholder

	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 4)
	slot_flags = null
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	damage_force = 3
	recoil = 2
	magazine_auto_eject = TRUE
	attack_sound = null
	caliber = /datum/ammo_caliber/a7_62mm
	magazine_preload = /obj/item/ammo_magazine/a7_62mm
	magazine_restrict = /obj/item/ammo_magazine/a7_62mm

	firemodes = list(
	list(mode_name="fold", icon_state="crestrose_fold",item_state = "laser",damage_force=3),
	list(mode_name="scythe", icon_state="crestrose",item_state = "crestrose",damage_force=15),
	)

// todo: uhh we can fix it later maybe idfk
// /obj/item/gun/projectile/ballistic/automatic/fluff/crestrose/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
// 	if(default_parry_check(user, attacker, damage_source) && prob(50))
// 		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
// 		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
// 		return 1
// 	return 0
