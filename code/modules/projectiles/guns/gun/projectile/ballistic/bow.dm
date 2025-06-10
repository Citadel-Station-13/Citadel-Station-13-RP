/obj/item/gun/projectile/ballistic/bow
	name = "wooden bow"
	desc = "Some sort of primitive projectile weapon. Used to fire arrows."
	icon_state = "bow"
	item_state = "bow"
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 5
	caliber = /datum/ammo_caliber/arrow
	fire_sound = 'sound/weapons/bowfire.wav'
	slot_flags = SLOT_BACK
	pin = null
	no_pin_required = TRUE
	safety_state = GUN_SAFETY_OFF
	internal_magazine = TRUE
	internal_magazine_size = 1
	chamber_manual_cycle_sound = 'sound/weapons/bowdraw.wav'

/obj/item/gun/projectile/ballistic/bow/update_icon_state()
	. = ..()
	if(chamber)
		icon_state = "[initial(icon_state)]_firing"
	else if(get_ammo_remaining())
		icon_state = "[initial(icon_state)]_loaded"
	else
		icon_state = initial(icon_state)

/obj/item/gun/projectile/ballistic/bow/ashen
	name = "bone bow"
	desc = "Some sort of primitive projectile weapon made of bone and sinew. Used to fire arrows."
	icon_state = "bow_ashen"
	item_state = "bow_ashen"
	damage_force = 8

/obj/item/gun/projectile/ballistic/bow/pipe
	name = "pipe bow"
	desc = "Some sort of pipe-based projectile weapon made of string and lots of bending. Used to fire arrows."
	icon_state = "bow_pipe"
	item_state = "bow_pipe"
	damage_force = 2
