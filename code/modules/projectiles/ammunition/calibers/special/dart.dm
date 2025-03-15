/datum/ammo_caliber/dart
	id = "dart"
	caliber = "dart"

//* Casings *//

/obj/item/ammo_casing/dart/chemdart
	name = "chemical dart"
	desc = "A casing containing a small hardened, hollow dart."
	icon_state = "dart"
	casing_caliber = /datum/ammo_caliber/dart
	projectile_type = /obj/projectile/bullet/chemdart

/obj/item/ammo_casing/dart/chemdart/small
	name = "short chemical dart"
	icon_state = "dartsmall"
	desc = "A casing containing a small hardened, hollow dart."
	projectile_type = /obj/projectile/bullet/chemdart/small

//* Magazines *//

/obj/item/ammo_magazine/chemdart
	name = "dart cartridge"
	desc = "A rack of hollow darts."

	icon = 'icons/modules/projectiles/magazines/darts.dmi'
	icon_state = "darts-5"
	base_icon_state = "darts"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5

	item_state = "rcdammo"
	origin_tech = list(TECH_MATERIAL = 2)
	magazine_type = MAGAZINE_TYPE_NORMAL
	ammo_caliber = /datum/ammo_caliber/dart
	ammo_preload = /obj/item/ammo_casing/dart/chemdart
	ammo_max = 5

/obj/item/ammo_magazine/chemdart/small
	name = "small dart cartridge"
	desc = "A rack of hollow darts."

	icon_state = "darts_small-5"
	base_icon_state = "darts_small"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 3

	origin_tech = list(TECH_MATERIAL = 2)
	ammo_preload = /obj/item/ammo_casing/dart/chemdart/small
	ammo_max = 3

//* Projectiles *//

/obj/projectile/bullet/chemdart
	name = "dart"
	icon_state = "dart"
	damage_force = 5
	var/reagent_amount = 15
	range = WORLD_ICON_SIZE * 15

	legacy_muzzle_type = null

/obj/projectile/bullet/chemdart/Initialize(mapload)
	. = ..()
	create_reagents(reagent_amount)

/obj/projectile/bullet/chemdart/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if((. & PROJECTILE_IMPACT_BLOCKED) || (efficiency < 0.95))
		return
	if(isliving(target))
		var/mob/living/L = target
		if(L.can_inject(target_zone=def_zone))
			reagents.trans_to_mob(L, reagent_amount, CHEM_INJECT)

/obj/projectile/bullet/chemdart/small
	reagent_amount = 10
