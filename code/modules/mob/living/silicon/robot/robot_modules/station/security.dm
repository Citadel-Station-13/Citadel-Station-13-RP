/obj/item/robot_module/robot/security
	name = "security robot module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)
	is_the_law = TRUE

/obj/item/robot_module/robot/security/general
	sprites = list(
		"M-USE NanoTrasen" = "robotSecy",
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

/obj/item/robot_module/robot/security/general/get_modules()
	. = ..()
	. |= list(
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/robot,
		/obj/item/gun/energy/taser/mounted/cyborg,
		/obj/item/barrier_tape_roll/police,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/gripper/security
	)

/obj/item/robot_module/robot/security/general/handle_special_module_init(mapload)
	. = ..()
	src.emag = new /obj/item/gun/energy/laser/mounted(src)

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

/obj/item/robot_module/robot/security/combat
	name = "combat robot module"
	hide_on_manifest = 1
	sprites = list(
		"Haruka" = "marinaCB",
		"Cabeiri" = "eyebot-combat",
		"Combat Android" = "droid-combat",
		"Insekt" = "insekt-Combat",
		"Acheron" = "mechoid-Combat",
		"ZOOM-BA" = "zoomba-combat"
	)

/obj/item/robot_module/robot/security/combat/get_modules()
	. = ..()
	. |= list(
		/obj/item/flash,
		// /obj/item/borg/sight/thermal,
		/obj/item/gun/energy/laser/mounted,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility,
	)

/obj/item/robot_module/robot/security/combat/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/gun/energy/lasercannon/mounted(src)

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
	is_the_law = TRUE
	can_shred = TRUE
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)

/obj/item/robot_module/robot/quad/sec/get_modules()
	. = ..()
	. |= list(
		/obj/item/handcuffs/cyborg, //You need cuffs to be a proper sec borg!
		/obj/item/dogborg/jaws/big, //In case there's some kind of hostile mob.
		/obj/item/melee/baton/robot, //Since the pounce module refused to work, they get a stunbaton instead.
		/obj/item/barrier_tape_roll/police, //Block out crime scenes.
		/obj/item/gun/energy/taser/mounted/cyborg, //They /are/ a security borg, after all.
		/obj/item/dogborg/pounce //Pounce
	)

/obj/item/robot_module/robot/quad/sec/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/gun/energy/laser/mounted(src) //Emag. Not a big problem.

	var/obj/item/dogborg/sleeper/K9/B = new /obj/item/dogborg/sleeper/K9(src) //Eat criminals. Bring them to the brig.
	B.water = synths_by_kind[MATSYN_WATER]
	src.modules += B

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
	/*var/obj/item/melee/baton/robot/B = locate() in src.modules //Borg baton uses borg cell.
	if(B && B.bcell)
		B.bcell.give(amount)*/

/obj/item/robot_module/robot/quad/ert
	name = "Emergency Response module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0
	sprites = list(
		"Standard" = "ert",
		"Borgi" = "borgi",
		"F3-LINE" = "FELI-Combat"
	)

	can_shred = TRUE

/obj/item/robot_module/robot/quad/ert/get_modules()
	. = ..()
	. |= list(
		/obj/item/handcuffs/cyborg,
		/obj/item/dogborg/jaws/big,
		/obj/item/melee/baton/robot,
		/obj/item/barrier_tape_roll/police,
		/obj/item/gun/energy/taser/mounted/cyborg/ertgun,
		/obj/item/dogborg/swordtail
	)

/obj/item/robot_module/robot/quad/ert/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	src.emag = new /obj/item/gun/energy/laser/mounted(src)

	var/obj/item/dogborg/sleeper/K9/B = new /obj/item/dogborg/sleeper/K9(src)
	B.water = synths_by_kind[MATSYN_WATER]
	. += B
