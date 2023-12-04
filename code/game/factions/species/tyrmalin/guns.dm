/datum/firemode/energy/emitter_rifle
	projectile_type = /obj/projectile/beam/emitter
	charge_cost = 900
	fire_delay = 1 SECONDS

/obj/item/gun/energy/ermitter
	name = "Ermitter rifle"
	desc = "A industrial energy projector turned into a crude, portable weapon - the Tyrmalin answer to armored hardsuits used by pirates. What it lacks in precision, it makes up for in firepower. The 'Ermitter' rifle cell receptacle has been heavily modified."
	icon_state = "ermitter_gun"
	item_state = "pulse"
	firemodes = list(/datum/firemode/energy/emitter_rifle)
	cell_initial = /obj/item/cell
	accept_cell_initial = /obj/item/cell
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	one_handed_penalty = 50

/obj/item/gun/energy/ionrifle/pistol/tyrmalin
	name = "botbuster pistol"
	desc = "These jury-rigged pistols are sometimes fielded by Tyrmalin facing synthetic pirates or malfunctioning machinery. Capable of discharging a single ionized bolt before needing to recharge, they're often treated as holdout or ambush weapons."
	icon_state = "botbuster"

	#warn impl - sprites
