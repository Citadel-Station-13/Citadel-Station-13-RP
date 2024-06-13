/obj/item/gun/projectile/ballistic/as24
	name = "automatic shotgun"
	desc = "The AS-24 is a rugged looking automatic shotgun produced for the military by Gurov Projectile Weapons LLC. For very obvious reasons, it's illegal to own in many juristictions. Uses 12g rounds."
	icon_state = "ashot"
	item_state = "ashot"
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 10
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m12gdrum
	allowed_magazines = list(/obj/item/ammo_magazine/m12gdrum)
	projectile_type = /obj/projectile/bullet/shotgun
	heavy = TRUE
	one_handed_penalty = 30 //The AA12 can be fired one-handed fairly easily.
	magazine_insert_sound = 'sound/weapons/guns/interaction/lmg_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/lmg_magout.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="3-round bursts", burst=3, move_delay=6, burst_accuracy = list(60,40,30,25,15), dispersion = list(0.0, 0.6, 0.6)),
//		list(mode_name="6-round bursts", burst=6, move_delay=6, burst_accuracy = list(0,-15,-15,-30,-30, -30), dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2, 1.2)),
		list(mode_name="automatic", burst=1, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/projectile/ballistic/as24/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "ashot"
	else
		icon_state = "ashot-empty"

