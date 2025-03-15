/obj/item/gun/projectile/ballistic/garand
	name = "\improper M1 Garand"
	desc = "This is the vintage semi-automatic rifle that famously helped win the second World War on ancient Terra. Another Cybersun Industries reproduction, the blueprints have since proliferated through the exonet, with most back-alley flash-forges creating their own variations of the iconic rifle."
	icon_state = "garand"
	item_state = "boltaction"
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	caliber = /datum/ammo_caliber/a7_62mm
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	//fire_sound = 'sound/weapons/rifleshot.ogg'
	magazine_preload = /obj/item/ammo_magazine/a7_62mm/garand
	magazine_restrict = /obj/item/ammo_magazine/a7_62mm/garand
	magazine_auto_eject = TRUE
	magazine_auto_eject_sound = 'sound/weapons/garand_ping.ogg'
	one_handed_penalty = 15

/obj/item/gun/projectile/ballistic/garand/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/garand/sniper
	name = "M1A Garand"
	desc = "A reproduction of the rare MIA Garand rifle. Most likely, it was once a standard Cybersun reproduction, modified by a competant gunsmith into a proper M1A model."
	icon_state = "sgarand"
	pin = /obj/item/firing_pin/explorer
	magazine_preload = /obj/item/ammo_magazine/a7_62mm/garand/sniperhunter
	w_class = WEIGHT_CLASS_HUGE // We don't need this fitting in backpacks.
	accuracy = 70 //Forced missing fucking sucks ass
	scoped_accuracy = 100

/obj/item/gun/projectile/ballistic/garand/sniper/verb/scope()
	set category = VERB_CATEGORY_OBJECT
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

// todo: default-unloaded, add /loaded
/obj/item/gun/projectile/ballistic/apinae_stinger
	name = "\improper Apinae Stinger Rifle"
	desc = "A biotechnological marvel, this living rifle can grow its ammo when provided with liquified wax. It fires poisonous bolts of barbed chitin."
	icon_state = "apigun"
	item_state = "speargun"
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	caliber = /datum/ammo_caliber/biomatter/wax
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_BIO = 7)
	slot_flags = SLOT_BACK
	fire_sound = 'sound/weapons/rifleshot.ogg'
	magazine_preload = /obj/item/ammo_magazine/biovial
	magazine_restrict = /obj/item/ammo_magazine/biovial
	one_handed_penalty = 25

/obj/item/gun/projectile/ballistic/apinae_stinger/update_icon_state()
	. = ..()
	icon_state = "apigun-[magazine ? round(magazine.get_amount_remaining(), 2) : "e"]"

// todo: default-unloaded, add /loaded
/obj/item/gun/projectile/ballistic/reconrifle
	name = "Expeditionary Reconnaissance Rifle"
	desc = "A bullpup semi-automatic designated marksman's rifle outfitted with a 4x magnification scope. The purple stripe running the length of it's retro beige furniture indicates that this belongs to Nanotrasen Exploration personnel."
	icon_state = "reconrifle"
	item_state = "reconrifle"
	pin = /obj/item/firing_pin/explorer
	slot_flags = SLOT_BACK
	fire_sound = 'sound/weapons/Gunshot_heavy.ogg'
	caliber = /datum/ammo_caliber/a7_62mm
	magazine_preload = /obj/item/ammo_magazine/a7_62mm
	magazine_restrict = /obj/item/ammo_magazine/a7_62mm

	w_class = WEIGHT_CLASS_HUGE
	accuracy = 70
	scoped_accuracy = 100
	magazine_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	heavy = TRUE
	one_handed_penalty = 20

/obj/item/gun/projectile/ballistic/reconrifle/verb/scope()
	set category = VERB_CATEGORY_OBJECT
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

/obj/item/gun/projectile/ballistic/reconrifle/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"
