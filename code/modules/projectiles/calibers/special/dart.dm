/datum/caliber/dart
	caliber = "dart"

//* Casings *//

/obj/item/ammo_casing/dart/chemdart
	name = "chemical dart"
	desc = "A casing containing a small hardened, hollow dart."
	icon_state = "dartcasing"
	regex_this_caliber = /datum/caliber/dart
	projectile_type = /obj/projectile/bullet/chemdart

/obj/item/ammo_casing/dart/chemdart/small
	name = "short chemical dart"
	desc = "A casing containing a small hardened, hollow dart."
	projectile_type = /obj/projectile/bullet/chemdart/small

//* Magazines *//

/obj/item/ammo_magazine/chemdart
	name = "dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts"
	item_state = "rcdammo"
	origin_tech = list(TECH_MATERIAL = 2)
	magazine_type = MAGAZINE_TYPE_NORMAL
	ammo_caliber = /datum/caliber/dart
	ammo_type = /obj/item/ammo_casing/dart/chemdart
	ammo_max = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/chemdart/small
	name = "small dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts_small"
	item_state = "rcdammo"
	origin_tech = list(TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/dart/chemdart/small
	ammo_max = 3
	multiple_sprites = 1

//* Projectiles *//

/obj/projectile/bullet/chemdart
	name = "dart"
	icon_state = "dart"
	damage = 5
	var/reagent_amount = 15
	range = WORLD_ICON_SIZE * 15

	muzzle_type = null

/obj/projectile/bullet/chemdart/Initialize(mapload)
	. = ..()
	create_reagents(reagent_amount)

/obj/projectile/bullet/chemdart/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked < 2 && isliving(target))
		var/mob/living/L = target
		if(L.can_inject(target_zone=def_zone))
			reagents.trans_to_mob(L, reagent_amount, CHEM_INJECT)

/obj/projectile/bullet/chemdart/small
	reagent_amount = 10
