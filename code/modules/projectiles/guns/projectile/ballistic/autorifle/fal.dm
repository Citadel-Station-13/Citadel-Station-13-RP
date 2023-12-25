/obj/item/gun/projectile/ballistic/fal
	name = "FN-FAL"
	desc = "A 20th century Assault Rifle originally designed by Fabrique National. Famous for its use by mercs in grinding proxy wars in backwater nations. This reproduction was probably made for similar purposes."
	icon_state = "fal"
	item_state = "fal"
	w_class = ITEMSIZE_LARGE
	damage_force = 10
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m762
	allowed_magazines = list(/obj/item/ammo_magazine/m762, /obj/item/ammo_magazine/m762)
	heavy = TRUE
	projectile_type = /obj/projectile/bullet/rifle/a762
	magazine_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=6,    burst_accuracy=list(60,35), dispersion=list(0.0, 0.6))
		)

/obj/item/gun/projectile/ballistic/fal/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

