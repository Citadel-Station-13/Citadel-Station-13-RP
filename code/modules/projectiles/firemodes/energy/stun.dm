/datum/firemode/energy/stun/taser
	name = "stun"
	projectile_type = /obj/item/projectile/beam/stun
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(15)
	mode_icon_state = "stun"

/datum/firemode/energy/stun/stunrevolver
	name = "stun"
	projectile_type = /obj/item/projectile/energy/electrode/stun
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(6)

/datum/firemode/energy/disable
	name = "disable"
	projectile_type = /obj/item/projectile/beam/disable
	mode_icon_state = "disable"
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(24)

/datum/firemode/energy/disable/hos
	burst_size = 3

/datum/firemode/energy/stun/egun
	name = "stun"
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(10)

/datum/firemode/energy/stun/pulse
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(20)

/datum/firemode/energy/stun/martin
	fire_sound = 'sound/weapons/taser.ogg'
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(4)

//Xeno taser
/datum/firemode/energy/stun/xeno
	projectile_type = /obj/item/projectile/beam/stun/xeno
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(10)
	fire_sound = 'sound/weapons/taser2.ogg'

/datum/firemode/energy/stun/xeno/security
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(5)
	projectile_type = /obj/item/projectile/beam/stun/xeno/weak

/datum/firemode/energy/stun/burstlaser
	burst_size = 3
	projectile_type = /obj/item/projectile/beam/stun/weak
	spread = 7
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(24)
	fire_delay = 6

/datum/firemode/energy/stun/hos
	projectile_type = /obj/item/projectile/energy/electrode/goldenbolt
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(5)

/datum/firemode/energy/stun/netgun
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(10)
	projectile_type = /obj/item/projectile/beam/stun/blue
