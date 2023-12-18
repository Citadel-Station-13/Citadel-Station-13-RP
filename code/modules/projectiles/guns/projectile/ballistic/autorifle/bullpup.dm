/obj/item/gun/projectile/ballistic/automatic/bullpup
	name = "bullpup rifle"
	desc = "The bullpup configured GP3000 is a battle rifle produced by Gurov Projectile Weapons LLC. It is sold almost exclusively to standing armies. Uses 7.62mm rounds."
	icon_state = "bullpup-small"
	item_state = "bullpup"
	w_class = ITEMSIZE_LARGE
	damage_force = 10
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m762
	allowed_magazines = list(/obj/item/ammo_magazine/m762, /obj/item/ammo_magazine/m762m)
	projectile_type = /obj/projectile/bullet/rifle/a762
	heavy = TRUE
	one_handed_penalty = 45
	magazine_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=6,    burst_accuracy=list(60,45), dispersion=list(0.0, 0.6))
		)

/obj/item/gun/projectile/ballistic/automatic/bullpup/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m762))
		icon_state = "bullpup-small"

/obj/item/gun/projectile/ballistic/automatic/bullpup/update_icon()
	. = ..()
	update_held_icon()
