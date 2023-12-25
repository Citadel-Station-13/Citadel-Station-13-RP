/obj/item/gun/projectile/ballistic/sts35
	name = "assault rifle"
	desc = "The rugged STS-35 is a durable automatic weapon of a make popular on the frontier worlds. Uses 5.56mm rounds."
	icon_state = "arifle"
	item_state = "arifle"
	wielded_item_state = "arifle-wielded"
	item_state = null
	w_class = ITEMSIZE_LARGE
	damage_force = 10
	caliber = "5.56mm"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_insert_sound = 'sound/weapons/guns/interaction/ltrifle_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/ltrifle_magout.ogg'
	magazine_type = /obj/item/ammo_magazine/m556
	allowed_magazines = list(/obj/item/ammo_magazine/m556)
	projectile_type = /obj/projectile/bullet/rifle/a556
	heavy = TRUE
	one_handed_penalty = 30

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(60,50,45), dispersion=list(0.0, 0.6, 0.6))
//		list(mode_name="short bursts", 	burst=5, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-15,-30,-30,-45), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/ballistic/sts35/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m556/small))
		icon_state = "arifle-small" // If using the small magazines, use the small magazine sprite.

/obj/item/gun/projectile/ballistic/sts35/update_icon(ignore_inhands)
	. = ..()
	update_held_icon()
