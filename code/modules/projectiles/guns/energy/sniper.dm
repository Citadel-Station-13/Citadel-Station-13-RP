/obj/item/gun/energy/sniperrifle
	name = "marksman energy rifle"
	desc = "The HI DMR 9E is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful \
	ionized beams, this is a weapon to kill from a distance."
	icon_state = "sniper"
	item_state = "sniper"
	item_state_slots = list(slot_r_hand_str = "z8carbine", slot_l_hand_str = "z8carbine") //placeholder
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	battery_lock = 1
	charge_cost = 600
	fire_delay = 35
	force = 10
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 0
//	requires_two_hands = 1
//	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.

/obj/item/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

/obj/item/gun/energy/monorifle
	name = "antique mono-rifle"
	desc = "An old laser rifle. This one can only fire once before requiring recharging."
	description_fluff = "Modeled after ancient hunting rifles, this rifle was dubbed the 'Rainy Day Special' by some, due to its use as some barmens' fight-stopper of choice. One shot is all it takes, or so they say."
	icon_state = "eshotgun"
	item_state = "shotgun"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_POWER = 3)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 1300
	fire_delay = 20
	force = 8
	w_class = ITEMSIZE_LARGE
	accuracy = 10
	scoped_accuracy = 15
	var/scope_multiplier = 1.5

/obj/item/gun/energy/monorifle/verb/sights()
	set category = "Object"
	set name = "Aim Down Sights"
	set popup_menu = 1

	toggle_scope(scope_multiplier)

/obj/item/gun/energy/monorifle/combat
	name = "combat mono-rifle"
	desc = "A modernized version of the mono-rifle. This one can fire twice before requiring recharging."
	description_fluff = "A modern design produced by a company once working from Saint Columbia, based on the antique mono-rifle 'Rainy Day Special' design."
	icon_state = "ecshotgun"
	item_state = "cshotgun"
	charge_cost = 1000
	force = 12
	accuracy = 0
	scoped_accuracy = 20
