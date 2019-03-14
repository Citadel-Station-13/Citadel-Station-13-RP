/obj/item/weapon/gun/energy/temperature
	name = "temperature gun"
	icon_state = "freezegun"
	desc = "A gun that can add or remove heat from entities it hits.  In other words, it can fire 'cold', and 'hot' beams."
	charge_cost = 240
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	slot_flags = SLOT_BELT|SLOT_BACK

	firemodes = list(/datum/firemode/energy/tempgun/cold, /datum/firemode/energy/tempgun/hot)
