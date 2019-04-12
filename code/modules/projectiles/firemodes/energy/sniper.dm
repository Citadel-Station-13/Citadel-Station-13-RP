/datum/firemode/energy/sniper
	projectile_type = /obj/item/projectile/beam/laser/sniper
	fire_delay = 35
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(4)
	one_handed_penalty = 20
	unscoped_penalty = 20
	fire_sound = 'sound/weapons/gauss_shoot.ogg'

/datum/firemode/energy/sniper/oneshot
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(1.3)
	fire_delay = 20
	one_handed_penalty = 25
	unscoped_penalty = 20

/datum/firemode/energy/sniper/twoshot
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(2.4)
