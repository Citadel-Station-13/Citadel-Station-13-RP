/datum/firemode/energy/laser
	sound_text = "laser blast"
	name = "kill"
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(10)
	mode_icon_state = "kill"
	fire_delay = 8
	projectile_type = /obj/item/projectile/beam/laser

/datum/firemode/energy/laser/rifle
	projectile_type = /obj/item/projectile/beam/laser/medium

/datum/firemode/energy/laser/suppressive
	name = "suppression"
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(40)
	fire_delay = 4
	projectile_type = /obj/item/projectile/beam/laser/weak

/datum/firemode/energy/laser/egun
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(5)

/datum/firemode/energy/laser/xray
	name = "xray"
	projectile_type = /obj/item/projectile/beam/laser/xray
	mode_icon_state = null
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(12)

/datum/firemode/energy/laser/xray/battlering
	name = "battle"
	fire_delay = 8
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(2400/260)

/datum/firemode/energy/laser/pulse
	fire_delay = 5
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(20)

/datum/firemode/energy/laser/practice
	projectile_type = /obj/item/projectile/beam/laser/practice
	e_cost = 12

/datum/firemode/energy/laser/retro
	fire_delay = 10

/datum/firemode/energy/laser/alien
	projectile_type = /obj/item/projectile/beam/laser/cyan
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(5)
	fire_delay = 10
	fire_sound = 'sound/weapons/eLuger.ogg'
	mode_icon_state = null

/datum/firemode/energy/laser/captain
	projectile_type = /obj/item/projectile/beam/laser
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(5)
	fire_delay = 10
	mode_icon_state = null

/datum/firemode/energy/laser/cannon
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(4)
	projectile_type = /obj/item/projectile/beam/laser/heavy/cannon
	fire_delay = 20
	mode_icon_state = null

/datum/firemode/energy/laser/martin
	projectile_type = /obj/item/projectile/beam/laser
	fire_sound = 'sound/weapons/laser.ogg'
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(2)

/datum/firemode/energy/laser/dominator
	fire_sound = 'sound/weapons/gauss_shoot.ogg'

/datum/firemode/energy/laser/burstlaser
	burst_size = 3
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(12)
	projectile_type = /obj/item/projectile/beam/laser/burstlaser
	spread = 7
	fire_delay = 6

/datum/firemode/energy/laser/hos
	projectile_type = /obj/item/projectile/beam/laser
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(10)
