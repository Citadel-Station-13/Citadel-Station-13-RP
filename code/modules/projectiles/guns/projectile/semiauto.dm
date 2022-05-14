/obj/item/gun/projectile/garand
	name = "\improper M1 Garand"
	desc = "This is the vintage semi-automatic rifle that famously helped win the second World War. What the hell it's doing aboard a space station in the 26th century, you can only imagine. Uses 7.62mm rounds."
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

/obj/item/gun/projectile/garand/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/garand/sniper
	name = "M1A Garand"
	desc = "A reproduction model of the rare M1A Garand rifle. This one seems to have been modified by a gun smith."
	icon_state = "sgarand"
	pin = /obj/item/firing_pin/explorer
	magazine_type = /obj/item/ammo_magazine/m762garand/sniperhunter
	w_class = ITEMSIZE_HUGE // We don't need this fitting in backpacks.
	accuracy = 70 //Forced missing fucking sucks ass
	scoped_accuracy = 100

/obj/item/gun/projectile/garand/sniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

/obj/item/gun/projectile/apinae_stinger
	name = "\improper Apinae Stinger Rifle"
	desc = "A biotechnological marvel, this living rifle can grow its ammo when provided with liquified wax. It fires poisonous bolts of barbed chitin."
	icon_state = "apigun"
	item_state = "speargun"
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	caliber = "apidean"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_BIO = 7)
	slot_flags = SLOT_BACK
	fire_sound = 'sound/weapons/rifleshot.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/biovial
	allowed_magazines = list(/obj/item/ammo_magazine/biovial)
	projectile_type = /obj/item/projectile/bullet/organic/stinger
	one_handed_penalty = 25

/obj/item/gun/projectile/apinae_stinger/update_icon_state()
	. = ..()
	icon_state = "apigun-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "empty"]"
