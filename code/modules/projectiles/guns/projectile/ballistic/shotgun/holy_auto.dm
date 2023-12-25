/obj/item/gun/projectile/ballistic/holyshot
	name = "Holy automatic shotgun"
	desc = "Based off of an ancient design, this hand crafted weapon has been gilded with the gold of melted icons and inscribed with sacred runes and hexagrammic wards. Works best with blessed 12g rounds."
	icon_state = "holyshotgun"
	item_state = "holy_shot"
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	damage_force = 10
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/holyshot_mag
	allowed_magazines = list(/obj/item/ammo_magazine/holyshot_mag, /obj/item/ammo_magazine/holyshot_mag/stake)
	projectile_type = /obj/projectile/bullet/shotgun

	one_handed_penalty = 40

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="2-round burst", burst=2, move_delay=6, burst_accuracy = list(60,50,40,30,25), dispersion = list(0.0, 0.6, 0.6))
		)

/obj/item/gun/projectile/ballistic/holyshot/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "holyshotgun"
	else
		icon_state = "holyshotgun-empty"
