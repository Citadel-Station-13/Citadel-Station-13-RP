/obj/item/gun/projectile/ballistic/SVD
	name = "\improper Dragunov"
	desc = "The SVD, also known as the Dragunov, is mass produced with an Optical Sniper Sight so simple that even Ivan can use it. Too bad for you that the inscriptions are written in Russian. Uses 7.62mm rounds."
	icon_state = "SVD"
	item_state = "SVD"
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	damage_force = 10
	slot_flags = SLOT_BACK // Needs a sprite.
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = "7.62mm"
	load_method = MAGAZINE
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 95
	heavy = TRUE
//	requires_two_hands = 1
	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	fire_sound = 'sound/weapons/Gunshot_SVD.ogg' // Has a very unique sound.
	magazine_type = /obj/item/ammo_magazine/m762svd
	allowed_magazines = list(/obj/item/ammo_magazine/m762svd)

/obj/item/gun/projectile/ballistic/SVD/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "SVD"
	else
		icon_state = "SVD-empty"

/obj/item/gun/projectile/ballistic/SVD/verb/scope()
	set category = VERB_CATEGORY_OBJECT
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)
