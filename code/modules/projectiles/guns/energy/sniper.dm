/obj/item/gun/energy/sniper
	name = "antique mono-rifle"
	desc = "An old laser rifle. This one can only fire once before requiring recharging."
	description_fluff = "Modeled after ancient hunting rifles, this rifle was dubbed the 'Rainy Day Special' by some, due to its use as some barmens' fight-stopper of choice. One shot is all it takes, or so they say."
	icon_state = "eshotgun"
	item_state = "shotgun"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_POWER = 3)
	slot_flags = SLOT_BACK
	firemodes = /datum/firemode/energy/sniper/oneshot
	force = 8
	w_class = ITEMSIZE_LARGE
	var/scope_multiplier = 1.5

/obj/item/gun/energy/sniper/verb/sights()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = TRUE

	toggle_scope(scope_multiplier)

/obj/item/gun/energy/sniper/combat
	name = "combat mono-rifle"
	desc = "A modernized version of the mono-rifle. This one can fire twice before requiring recharging."
	description_fluff = "A modern design produced by a company once working from Saint Columbia, based on the antique mono-rifle 'Rainy Day Special' design."
	icon_state = "ecshotgun"
	item_state = "cshotgun"
	firemodes = /datum/firemode/energy/sniper/twoshot
	force = 12

/obj/item/gun/energy/sniper/marksman
	name = "marksman energy rifle"
	desc = "The HI DMR 9E is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful \
	ionized beams, this is a weapon to kill from a distance."
	icon_state = "sniper"
	item_state = "sniper"
	item_state_slots = list(slot_r_hand_str = "z8carbine", slot_l_hand_str = "z8carbine") //placeholder
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	slot_flags = SLOT_BACK
	removable_battery = FALSE
	firemodes = /datum/firemode/energy/sniper
	force = 10
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	scope_multiplier = 2
