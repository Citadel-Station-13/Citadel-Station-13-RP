/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgunstun"
	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = 8 //looks heavier than a pistol
	w_class = ITEMSIZE_LARGE	//Looks bigger than a pistol, too.
	fire_delay = 6	//This one's not a handgun, it should have the same fire delay as everything else
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	battery_lock = 1
	modifystate = null

//	requires_two_hands = 1
//	one_handed_penalty = 15 // It's rather bulky, so holding it in one hand is a little harder than with two, however it's not 'required'.

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="nucgunstun", charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="nucgunkill", charge_cost = 480),
		)
