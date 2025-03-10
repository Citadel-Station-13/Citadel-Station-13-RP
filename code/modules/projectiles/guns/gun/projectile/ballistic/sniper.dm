/obj/item/gun/projectile/ballistic/heavysniper
	name = "anti-materiel rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 12.7mm shells."
	icon_state = "heavysniper"
	item_state = "heavysniper"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "l6closed-empty", SLOT_ID_LEFT_HAND = "l6closed-empty") // placeholder
	w_class = WEIGHT_CLASS_HUGE // So it can't fit in a backpack.
	damage_force = 10
	heavy = TRUE
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = /datum/ammo_caliber/a12_7mm
	recoil = 5 //extra kickback
	chamber_preload_ammo = /obj/item/ammo_casing/a12_7mm
	internal_magazine = TRUE
	bolt_simulation = TRUE
	bolt_auto_eject_on_open = FALSE
	chamber_cycle_after_fire = FALSE
	single_load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	accuracy = -45
	scoped_accuracy = 95
	one_handed_penalty = 90

/obj/item/gun/projectile/ballistic/heavysniper/update_icon()
	if(bolt_closed)
		icon_state = "heavysniper"
	else
		icon_state = "heavysniper-open"

/obj/item/gun/projectile/ballistic/heavysniper/verb/scope()
	set category = VERB_CATEGORY_OBJECT
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

/obj/item/gun/projectile/ballistic/SVD
	name = "\improper Dragunov"
	desc = "The SVD, also known as the Dragunov, is mass produced with an Optical Sniper Sight so simple that even Ivan can use it. Too bad for you that the inscriptions are written in Russian. Uses 7.62mm rounds."
	icon_state = "SVD"
	item_state = "SVD"
	w_class = WEIGHT_CLASS_HUGE // So it can't fit in a backpack.
	damage_force = 10
	slot_flags = SLOT_BACK // Needs a sprite.
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = /datum/ammo_caliber/a7_62mm
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 95
	heavy = TRUE
//	requires_two_hands = 1
	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	fire_sound = 'sound/weapons/Gunshot_SVD.ogg' // Has a very unique sound.
	magazine_preload = /obj/item/ammo_magazine/a7_62mm/svd
	magazine_restrict = /obj/item/ammo_magazine/a7_62mm/svd

/obj/item/gun/projectile/ballistic/SVD/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = "SVD"
	else
		icon_state = "SVD-empty"

/obj/item/gun/projectile/ballistic/SVD/verb/scope()
	set category = VERB_CATEGORY_OBJECT
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)
