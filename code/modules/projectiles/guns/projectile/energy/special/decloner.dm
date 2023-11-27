/datum/firemode/energy/decloner
	name = "declone"
	charge_cost = 240
	projectile_type = /obj/projectile/energy/declone

/obj/item/gun/projectile/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	item_state = "decloner"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_POWER = 3)
	regex_this_firemodes = list(/datum/firemode/energy/decloner)
