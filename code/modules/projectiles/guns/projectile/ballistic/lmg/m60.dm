/obj/item/gun/projectile/ballistic/lmg/m60
	name = "M60"
	desc = "Affectionately dubbed 'The Pig' by the Old Earth soldiers assigned it, the M60 belt fed machine gun fell into disuse prior to the Final War, with no known original models surviving to the modern day. Several companies have since begun manufacturing faithful reproductions such as this one."
	icon_state = "M60closed75"
	item_state = "M60closed"
	max_shells = 75
	caliber = "7.62mm"
	magazine_type = /obj/item/ammo_magazine/m762_m60
	allowed_magazines = list(/obj/item/ammo_magazine/m762_m60)
	projectile_type = /obj/projectile/bullet/rifle/a762
	one_handed_penalty = 100

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 0),
		list(mode_name="automatic", burst=2, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/projectile/ballistic/lmg/m60/update_icon_state()
	. = ..()
	icon_state = "M60[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 15) : "-empty"]"
	item_state = "M60[cover_open ? "open" : "closed"][ammo_magazine ? "" : "-empty"]"
