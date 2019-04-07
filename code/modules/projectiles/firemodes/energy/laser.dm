/datum/firemode/energy/laser
	sound_text = "laser blast"
	name = "kill"
	cost = SCALE_ENERGY_WEAPON_NORMAL(10)
	mode_icon_state = "kill"
	fire_delay = 8
	projectile_type = /obj/item/projectile/beam/laser

/datum/firemode/energy/laser/suppressive
	name = "suppression"
	cost = SCALE_ENERGY_WEAPON_NORMAL(40)
	fire_delay = 4
	projectile_type = /obj/item/projectile/beam/laser/weak

/datum/firemode/energy/laser/egun
	cost = SCALE_ENERGY_WEAPON_NORMAL(5)

/datum/firemode/energy/laser/xray
	name = "xray"
	projectile_type = /obj/item/projectile/beam/xray

/datum/firemode/energy/laser/xray/battlering
	name = "battle"
	fire_delay = 8
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(2400/260)

/datum/firemode/energy/laser/pulse
	fire_delay = 5
	e_cost = SCALE_ENERGY_WEAPON_NORMAL(20)
