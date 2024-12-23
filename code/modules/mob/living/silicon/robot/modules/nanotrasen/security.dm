/datum/prototype/robot_module/nanotrasen/security
	use_robot_module_path = /obj/item/robot_module/robot/security
	allowed_frames = list(
	)

/datum/prototype/robot_module/nanotrasen/security/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/handcuffs/cyborg,
			/obj/item/melee/baton/robot,
			/obj/item/gun/energy/taser/mounted/cyborg,
			/obj/item/barrier_tape_roll/police,
			/obj/item/reagent_containers/spray/pepper,
			/obj/item/gripper/security,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/gun/energy/laser/mounted,
		)

#warn translate chassis below

/obj/item/robot_module/robot/security
	name = "security robot module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)

/obj/item/robot_module/robot/security/general
	sprites = list(
		"M-USE Nanotrasen" = "robotSecy",
		"Cabeiri" = "eyebot-security",
		"Cerberus" = "bloodhound",
		"Cerberus - Treaded" = "treadhound",
		"Haruka" = "marinaSC",
		"Usagi" = "tallred",
		"Telemachus" = "toiletbotsecurity",
		"WTOperator" = "sleeksecurity",
		"XI-GUS" = "spidersec",
		"XI-ALP" = "heavySec",
		"Basic" = "secborg",
		"Black Knight" = "securityrobot",
		"Drone" = "drone-sec",
		"Insekt" = "insekt-Sec",
		"Misato" = "tall2security",
		"L3P1-D0T" = "Glitterfly-Security",
		"Miss M" = "miss-security",
		"Coffcurity" = "coffin-Combat",
		"Handy" = "handy-sec",
		"Acheron" = "mechoid-Security",
		"Shellguard Noble" = "Noble-SEC",
		"ZOOM-BA" = "zoomba-security",
		"W02M" = "worm-security"
	)

/obj/item/robot_module/robot/security/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost * amount)
		T.update_icon()
	else
		T.charge_tick = 0

/obj/item/robot_module/robot/quad/sec
	name = "SecuriQuad module"
	sprites = list(
		"K9 hound" = "k9",
		"K9 Alternative" = "k92",
		"Secborg model V-2" = "secborg",
		"Borgi" = "borgi-sec",
		"Otieborg" = "oties",
		"F3-LINE" = "FELI-Security",
		"Drake" = "drakesec"
	)
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0
	can_shred = TRUE
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)

/obj/item/robot_module/robot/quad/sec/get_modules()
	. = ..()
	. |= list(
		/obj/item/robot_builtin/dog_pounce //Pounce
	)

/obj/item/robot_module/robot/quad/sec/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost * amount)
		T.update_icon()
	else
		T.charge_tick = 0
