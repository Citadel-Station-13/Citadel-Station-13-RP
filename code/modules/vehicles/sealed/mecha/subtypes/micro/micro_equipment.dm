//DO NOT ADD MECHA PARTS TO THE GAME WITH THE DEFAULT "SPRITE ME" SPRITE!

/////////////////////////////
////    WEAPONS BELOW    ////
/////////////////////////////

/obj/item/vehicle_module/weapon/energy/microlaser
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted laser-carbine for light exosuits."
	equip_cooldown = 10 // same as the laser carbine
	name = "\improper WS-19 \"Torch\" laser carbine"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_laser"
	energy_drain = 50
	projectile = /obj/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'
	equip_type = EQUIP_MICRO_WEAPON
	required_type = list(/obj/vehicle/sealed/mecha/micro/sec)

/obj/item/vehicle_module/weapon/energy/laser/microheavy
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted laser cannon for light exosuits."
	equip_cooldown = 30 // same as portable
	name = "\improper PC-20 \"Lance\" light laser cannon"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_lasercannon"
	energy_drain = 120
	projectile = /obj/projectile/beam/heavylaser
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	equip_type = EQUIP_MICRO_WEAPON
	required_type = list(/obj/vehicle/sealed/mecha/micro/sec)

/obj/item/vehicle_module/weapon/energy/microtaser
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted taser for light exosuits."
	name = "\improper TS-12 \"Suppressor\" integrated taser"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_taser"
	energy_drain = 40
	equip_cooldown = 10
	projectile = /obj/projectile/beam/stun
	fire_sound = 'sound/weapons/Taser.ogg'
	equip_type = EQUIP_MICRO_WEAPON
	required_type = list(/obj/vehicle/sealed/mecha/micro/sec)

/obj/item/vehicle_module/weapon/ballistic/microshotgun
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted combat shotgun with integrated ammo-lathe."
	name = "\improper Remington C-12 \"Boomstick\""
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
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
	equip_type = EQUIP_MICRO_WEAPON
	required_type = list(/obj/vehicle/sealed/mecha/micro/sec)

/obj/item/vehicle_module/weapon/ballistic/microshotgun/Topic(href,href_list)
	..()
	if(href_list["mode"])
		mode = text2num(href_list["mode"])
		switch(mode)
			if(0)
				occupant_message("Now firing buckshot.")
				projectile = /obj/projectile/bullet/pellet/shotgun
			if(1)
				occupant_message("Now firing beanbags.")
				projectile = /obj/projectile/bullet/shotgun/beanbag
			if(2)
				occupant_message("Now firing slugs.")
				projectile = /obj/projectile/bullet/shotgun

	return

/obj/item/vehicle_module/weapon/ballistic/microshotgun/get_equip_info()
	return "[..()] \[<a href='?src=\ref[src];mode=0'>BS</a>|<a href='?src=\ref[src];mode=1'>BB</a>|<a href='?src=\ref[src];mode=2'>S</a>\]"


/obj/item/vehicle_module/weapon/ballistic/missile_rack/grenade/microflashbang
	w_class = WEIGHT_CLASS_BULKY
	desc = "A mounted grenade launcher for smaller mechs."
	name = "\improper FP-20 mounted grenade launcher"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_launcher"
	projectiles = 1
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 30
	det_time = 15
	equip_type = EQUIP_MICRO_WEAPON
	required_type = list(/obj/vehicle/sealed/mecha/micro/sec)


/////////////////////////////
//// UTILITY TOOLS BELOW ////
/////////////////////////////

/obj/item/vehicle_module/tool/drill/micro
	w_class = WEIGHT_CLASS_BULKY
	name = "drill"
	desc = "This is the drill that'll sorta poke holes in the heavens!"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "microdrill"
	equip_cooldown = 30
	energy_drain = 10
	damage_force = 15
	equip_type = EQUIP_MICRO_UTILITY
	required_type = list(/obj/vehicle/sealed/mecha/micro/utility)

/obj/item/vehicle_module/tool/drill/micro/action(atom/target)
	if(!action_checks(target))
		return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='danger'>[chassis] starts to drill [target]</span>", "<span class='warning'>You hear the drill.</span>")
	occupant_message("<span class='danger'>You start to drill [target]</span>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			if(istype(target, /turf/simulated/wall))
				var/turf/simulated/wall/W = target
				if(W.material_reinf)
					occupant_message("<span class='warning'>[target] is too durable to drill through.</span>")
				else
					log_message("Drilled through [target]")
					LEGACY_EX_ACT(target, 2, null)
			else if(istype(target, /turf/simulated/mineral))
				for(var/turf/simulated/mineral/M in range(chassis,1))
					if(get_dir(chassis,M)&chassis.dir)
						M.GetDrilled()
				log_message("Drilled through [target]")
				var/obj/item/vehicle_module/tool/micro/orescoop/ore_box = (locate(/obj/item/vehicle_module/tool/micro/orescoop) in chassis.equipment)
				if(ore_box)
					for(var/obj/item/stack/ore/ore in range(chassis,1))
						if(get_dir(chassis,ore)&chassis.dir)
							if (ore_box.contents.len >= ore_box.orecapacity)
								occupant_message("<span class='warning'>The ore compartment is full.</span>")
								return 1
							else
								ore.forceMove(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				LEGACY_EX_ACT(target, 2, null)
	return 1


/obj/item/vehicle_module/tool/micro/orescoop
	w_class = WEIGHT_CLASS_BULKY
	name = "Mounted ore box"
	desc = "A mounted ore scoop and hopper, for gathering ores."
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "microscoop"
	equip_cooldown = 5
	energy_drain = 0
	equip_type = EQUIP_MICRO_UTILITY
	required_type = list(/obj/vehicle/sealed/mecha/micro/utility)
	var/orecapacity = 500

/obj/item/vehicle_module/tool/micro/orescoop/action(atom/target)
	if(!action_checks(target))
		return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='info'>[chassis] sweeps around with its ore scoop.</span>")
	occupant_message("<span class='info'>You sweep around the area with the scoop.</span>")
	var/T = chassis.loc
	//var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			for(var/obj/item/stack/ore/ore in range(chassis,1))
				if(get_dir(chassis,ore)&chassis.dir)
					if (contents.len >= orecapacity)
						occupant_message("<span class='warning'>The ore compartment is full.</span>")
						return 1
					else
						ore.forceMove(src)
	return 1

/obj/item/vehicle_module/tool/micro/orescoop/Topic(href,href_list)
	..()
	if (href_list["empty_box"])
		if(contents.len < 1)
			occupant_message("The ore compartment is empty.")
			return
		for (var/obj/item/stack/ore/O in contents)
			contents -= O
			O.loc = chassis.loc
		occupant_message("Ore compartment emptied.")

/obj/item/vehicle_module/tool/micro/orescoop/get_equip_info()
	return "[..()] <br /><a href='?src=\ref[src];empty_box=1'>Empty ore compartment</a>"

/obj/item/vehicle_module/tool/orescoop/verb/empty_box() //so you can still get the ore out if someone detaches it from the mech
	set name = "Empty Ore compartment"
	set category = VERB_CATEGORY_OBJECT
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human)) //Only living, intelligent creatures with hands can empty ore boxes.
		to_chat(usr, "<span class='warning'>You are physically incapable of emptying the ore box.</span>")
		return

	if( usr.stat || usr.restrained() )
		return

	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
		to_chat(usr, "You cannot reach the ore box.")
		return

	add_fingerprint(usr)

	if(contents.len < 1)
		to_chat(usr, "<span class='warning'>The ore box is empty</span>")
		return

	for (var/obj/item/stack/ore/O in contents)
		contents -= O
		O.loc = src.loc
	to_chat(usr, "<span class='info'>You empty the ore box</span>")

	return
