/obj/item/vehicle_module/lazy/legacy/weapon/energy/microlaser
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted laser-carbine for light exosuits."
	equip_cooldown = 10 // same as the laser carbine
	name = "\improper WS-19 \"Torch\" laser carbine"'
	icon_state = "micromech_laser"
	energy_drain = 50
	projectile = /obj/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'
	module_class = VEHICLE_MODULE_CLASS_ALLOW_MICRO

/obj/item/vehicle_module/lazy/legacy/weapon/energy/laser/microheavy
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted laser cannon for light exosuits."
	equip_cooldown = 30 // same as portable
	name = "\improper PC-20 \"Lance\" light laser cannon"'
	icon_state = "micromech_lasercannon"
	energy_drain = 120
	projectile = /obj/projectile/beam/heavylaser
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	module_class = VEHICLE_MODULE_CLASS_ALLOW_MICRO

/obj/item/vehicle_module/lazy/legacy/weapon/energy/microtaser
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted taser for light exosuits."
	name = "\improper TS-12 \"Suppressor\" integrated taser"'
	icon_state = "micromech_taser"
	energy_drain = 40
	equip_cooldown = 10
	projectile = /obj/projectile/beam/stun
	fire_sound = 'sound/weapons/Taser.ogg'
	module_class = VEHICLE_MODULE_CLASS_ALLOW_MICRO

/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/microshotgun
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted combat shotgun with integrated ammo-lathe."
	name = "\improper Remington C-12 \"Boomstick\""'
	icon_state = "micromech_shotgun"
	equip_cooldown = 15
	var/mode = 0 //0 - buckshot, 1 - beanbag, 2 - slug.
	projectile = /obj/projectile/bullet/pellet/shotgun
	fire_sound = 'sound/weapons/Gunshot_shotgun.ogg'
	fire_volume = 80
	projectiles = 6
	projectiles_per_shot = 1
	deviation = 0.7
	projectile_energy_cost = 100
	module_class = VEHICLE_MODULE_CLASS_ALLOW_MICRO

/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/microshotgun/render_ui()
	..()
	var/selected
	switch(mode)
		if(0)
			selected = "Buckshot"
		if(1)
			selected = "Beanbag"
		if(2)
			selected = "Slug"
	l_ui_select("mode", "Select Mode", list("Buckshot", "Beanbag", "Slug"), selected)

/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/microshotgun/on_l_ui_select(datum/event_args/actor/actor, key, name)
	. = ..()
	if(.)
		return
	switch(key)
		if("mode")
			switch(name)
				if("Buckshot")
					mode = 0
					projectile = /obj/projectile/bullet/pellet/shotgun
				if("Beanbag")
					mode = 1
					projectile = /obj/projectile/bullet/shotgun/beanbag
				if("Slug")
					mode = 2
					projectile = /obj/projectile/bullet/shotgun
			vehicle_log_for_admins(actor, "switch-projectile-mode", list("mode" = name))
			vehicle_occupant_send_default_chat("Now firing [lowertext(name)].")

/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/grenade/microflashbang
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted grenade launcher for smaller mechs."
	name = "\improper FP-20 mounted grenade launcher"'
	icon_state = "micromech_launcher"
	projectiles = 1
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 30
	module_class = VEHICLE_MODULE_CLASS_ALLOW_MICRO

/obj/item/vehicle_module/lazy/legacy/tool/drill/micro
	w_class = WEIGHT_CLASS_BULKY
	name = "drill"
	desc = "This is the drill that'll sorta poke holes in the heavens!"'
	icon_state = "microdrill"
	equip_cooldown = 30
	energy_drain = 10
	damage_force = 15
	module_class = VEHICLE_MODULE_CLASS_ALLOW_MICRO

/obj/item/vehicle_module/lazy/legacy/tool/orescoop/micro
	w_class = WEIGHT_CLASS_BULKY
	name = "Mounted ore box"
	desc = "A mounted ore scoop and hopper, for gathering ores."'
	icon_state = "microscoop"
	equip_cooldown = 5
	energy_drain = 0
	module_class = VEHICLE_MODULE_CLASS_ALLOW_MICRO
