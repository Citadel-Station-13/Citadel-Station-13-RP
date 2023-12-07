/obj/item/gun/projectile/ballistic/automatic/lmg/mg42
	name = "MG 42"
	desc = "The MG 42 is an antique Terran machine gun, and very few original platforms have survived to the modern day. The Schwarzlindt Arms LTD manufacturer's stamp on the body marks this as a Frontier reproduction. It is no less deadly."
	icon_state = "mg42closed50"
	item_state = "mg42closed"
	max_shells = 50
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1, TECH_ILLEGAL = 2)
	magazine_type = /obj/item/ammo_magazine/m762_mg42
	allowed_magazines = list(/obj/item/ammo_magazine/m762_mg42)
	one_handed_penalty = 100

/obj/item/gun/projectile/ballistic/automatic/lmg/mg42/update_icon_state()
	. = ..()
	icon_state = "mg42[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"]"
	item_state = "mg42[cover_open ? "open" : "closed"][ammo_magazine ? "" : "-empty"]"
