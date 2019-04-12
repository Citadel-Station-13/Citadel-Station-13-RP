/obj/item/gun/energy/e_gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgunstun"
	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = 8 //looks heavier than a pistol
	w_class = ITEMSIZE_LARGE	//Looks bigger than a pistol, too.
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	removable_battery = FALSE

	firemodes = list(
		/datum/firemode/energy/stun/egun,
		/datum/firemode/energy/laser/egun
		)
