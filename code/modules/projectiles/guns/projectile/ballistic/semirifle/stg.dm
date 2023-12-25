/obj/item/gun/projectile/ballistic/stg
	name = "\improper Sturmgewehr"
	desc = "An STG-560 built by RauMauser. Experience the terror of the Siegfried line, redone for the 26th century! The Kaiser would be proud. Uses unique 7.92x33mm Kurz rounds."
	icon_state = "stg60"
	item_state = "arifle"
	w_class = ITEMSIZE_LARGE
	max_shells = 30
	caliber = "7.92x33mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 6)
	magazine_type = /obj/item/ammo_magazine/mtg
	allowed_magazines = list(/obj/item/ammo_magazine/mtg)
	load_method = MAGAZINE

/obj/item/gun/projectile/ballistic/stg/update_icon()
	. = ..()
	update_held_icon()

/obj/item/gun/projectile/ballistic/stg/update_icon_state()
	. = ..()
	icon_state = (ammo_magazine)? "stg60" : "stg60-e"
	item_state = (ammo_magazine)? "arifle" : "arifle-e"
