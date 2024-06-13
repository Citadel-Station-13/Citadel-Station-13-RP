/datum/firemode/energy/phoron
	charge_cost = 240
	projectile_type = /obj/projectile/energy/phoron

/obj/item/gun/projectile/energy/toxgun
	name = "phoron pistol"
	desc = "A failed experiment in anti-personnel weaponry from the onset of the Syndicate Wars. The Mk.1 NT-P uses an internal resevoir of phoron gas, excited into a photonic state with a standard weapon cell, to fire lethal bolts of phoron-based plasma."
	icon_state = "toxgun"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	regex_this_firemodes = list(/datum/firemode/energy/phoron)

#warn above
