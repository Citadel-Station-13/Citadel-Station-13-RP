/obj/item/gun/projectile/ballistic/shotgun/flare
	name = "Emergency Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'Warning: Possession is prohibited outside of emergency situations'."
	icon_state = "flareg"
	item_state = "flareg"
	load_method = SINGLE_CASING
	handle_casings = CYCLE_CASINGS
	max_shells = 1
	w_class = ITEMSIZE_SMALL
	damage_force = 5
	slot_flags = SLOT_BELT
	caliber = "12g"
	accuracy = -15 //Its a flaregun and you expected accuracy?
	ammo_type = /obj/item/ammo_casing/a12g/flare
	projectile_type = /obj/projectile/energy/flash
	one_handed_penalty = 0

/obj/item/gun/projectile/ballistic/shotgun/flare/paramed
	name = "Paramedic Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'For use by emergency medical services only.'"
	icon_state = "flareg-para"


/obj/item/gun/projectile/ballistic/shotgun/flare/explo
	name = "Exploration Flare Gun"
	desc = "A common mass produced emergency flare gun capable of shooting a single flare great distances for signalling air and ground forces alike. As it loads 12g flare shells it can also function as improvised 12g shotgun. On it a description reads: 'For use on extraplanetary excursions only.'"
	icon_state = "flareg-explo"

/obj/item/gun/projectile/ballistic/shotgun/flare/holy
	name = "Brass Flare Gun"
	desc = "A Brass Flare Gun far more exspensuve and well made then the plastic ones mass produced for signalling. It fires using an odd clockwork mechanism. Loads using 12g"
	icon_state = "flareg-holy"
	accuracy = 50 //Strong Gun Better Accuracy
