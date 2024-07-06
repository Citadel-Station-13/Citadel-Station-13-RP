/datum/firemode/energy/meteor
	charge_cost = 100
	projectile_type = /obj/projectile/meteor

/obj/item/gun/projectile/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "riotgun"
	item_state = "c20r"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	regex_this_firemodes = list(/datum/firemode/energy/meteor)
	cell_initial = /obj/item/cell/potato
	self_charging = 1
	recharge_time = 5 //Time it takes for shots to recharge (in ticks)
	charge_meter = 0
	one_handed_penalty = 20

/obj/item/gun/projectile/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	w_class = ITEMSIZE_TINY
	heavy = FALSE
	slot_flags = SLOT_BELT
	one_handed_penalty = 0
