/obj/item/gun/projectile/ballistic/garand
	name = "\improper M1 Garand"
	desc = "This is the vintage semi-automatic rifle that famously helped win the second World War on ancient Terra. Another Cybersun Industries reproduction, the blueprints have since proliferated through the exonet, with most back-alley flash-forges creating their own variations of the iconic rifle."
	icon_state = "garand"
	item_state = "boltaction"
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	//fire_sound = 'sound/weapons/rifleshot.ogg'
	load_method = MAGAZINE // ToDo: Make it so MAGAZINE, SPEEDLOADER and SINGLE_CASING can all be used on the same gun.
	magazine_type = /obj/item/ammo_magazine/m762garand
	allowed_magazines = list(/obj/item/ammo_magazine/m762garand)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/garand_ping.ogg'
	one_handed_penalty = 15

/obj/item/gun/projectile/ballistic/garand/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/garand/sniper
	name = "M1A Garand"
	desc = "A reproduction of the rare MIA Garand rifle. Most likely, it was once a standard Cybersun reproduction, modified by a competant gunsmith into a proper M1A model."
	icon_state = "sgarand"
	pin = /obj/item/firing_pin/explorer
	magazine_type = /obj/item/ammo_magazine/m762garand/sniperhunter
	w_class = ITEMSIZE_HUGE // We don't need this fitting in backpacks.
	accuracy = 70 //Forced missing fucking sucks ass
	scoped_accuracy = 100

/obj/item/gun/projectile/ballistic/garand/sniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)
