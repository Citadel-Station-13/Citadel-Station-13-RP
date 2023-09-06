/datum/firemode/energy/ion
	name = "ion"
	charge_cost = 240
	projectile_type = /obj/projectile/ion

/obj/item/gun/projectile/energy/ionrifle
	name = "ion rifle"
	desc = "The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. Not the best of its type."
	icon_state = "ionrifle"
	item_state = "ionrifle"
	wielded_item_state = "ionrifle-wielded"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)
	w_class = ITEMSIZE_LARGE
	damage_force = 10
	slot_flags = SLOT_BACK
	heavy = TRUE
	regex_this_firemodes = list(/datum/firemode/energy/ion)
	one_handed_penalty = 15

/obj/item/gun/projectile/energy/ionrifle/emp_act(severity)
	..(max(severity, 4)) //so it doesn't EMP itself, I guess

/datum/firemode/energy/ion/pistol
	charge_cost = 480
	projectile_type = /obj/projectile/ion/pistol

/obj/item/gun/projectile/energy/ionrifle/pistol
	name = "ion pistol"
	desc = "The NT Mk63 EW Pan is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. This model sacrifices capacity for portability."
	icon_state = "ionpistol"
	item_state = null
	w_class = ITEMSIZE_NORMAL
	damage_force = 5
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	heavy = FALSE
	regex_this_firemodes = list(/datum/firemode/energy/ion/pistol)

/datum/firemode/energy/ion/pistol/tyrmalin
	charge_cost = 1300

/obj/item/gun/projectile/energy/ionrifle/pistol/tyrmalin
	name = "botbuster pistol"
	desc = "These jury-rigged pistols are sometimes fielded by Tyrmalin facing sythetic pirates or faulty machinery. Capable of discharging a single ionized bolt before needing to recharge, they're often treated as holdout or ambush weapons."
	icon_state = "botbuster"
	regex_this_firemodes = list(/datum/firemode/energy/ion/pistol/tyrmalin)
