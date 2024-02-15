/datum/firemode/energy/mindflayer
	charge_cost = 240
	projectile_type = /obj/projectile/beam/midnflayer

/obj/item/gun/projectile/energy/mindflayer
	name = "mind flayer"
	desc = "A custom-built weapon of some kind."
	icon_state = "xray"
	regex_this_firemodes = list(/datum/firemode/energy/mindflayer)
	one_handed_penalty = 15
