/datum/firemode/energy/phase
	projectile_type = /obj/item/projectile/energy/phase
	cost = SCALE_ENERGY_WEAPON_NORMAL(10)
	name = "phase"
	fire_delay = 4

/datum/firemode/energy/phase/pistol
	cost = SCALE_ENERGY_WEAPON_NORMAL(8)
	projectile_type = /obj/item/projectile/energy/phase/light

/datum/firemode/energy/phase/rifle
	cost = SCALE_ENERGY_WEAPON_NORMAL(16)
	projectile_type = /obj/item/projectile/energy/phase/heavy
	one_handed_penalty = 25

/datum/firemode/energy/phase/cannon
	cost = SCALE_ENERGY_WEAPON_NORMAL(24)
	projectile_type = /obj/item/projectile/energy/phase/heavy/cannon
	one_handed_penalty = 45
