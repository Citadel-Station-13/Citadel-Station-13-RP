/obj/item/robot_module/robot/security
	name = "security robot module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)

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

/obj/item/robot_module/robot/security/general/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/melee/baton/robot(src)
	src.modules += new /obj/item/gun/energy/taser/mounted/cyborg(src)
	src.modules += new /obj/item/barrier_tape_roll/police(src)
	src.modules += new /obj/item/reagent_containers/spray/pepper(src)
	src.modules += new /obj/item/gripper/security(src)
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

/obj/item/robot_module/robot/security/combat/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/flash(src)
	//src.modules += new /obj/item/borg/sight/thermal(src)
	src.modules += new /obj/item/gun/energy/laser/mounted(src)
	src.modules += new /obj/item/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/borg/combat/shield(src)
	src.modules += new /obj/item/borg/combat/mobility(src)
	src.emag = new /obj/item/gun/energy/lasercannon/mounted(src)

/obj/item/robot_module/robot/quad_sec
	name = "SecuriQuad module"
	sprites = list(
					"K9 hound" = "k9",
					"K9 Alternative" = "k92",
					"Secborg model V-2" = "secborg",
					"Borgi" = "borgi-sec",
					"Otieborg" = "oties",
					"F3-LINE" = "FELI-Security"
					)
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0

/obj/item/robot_module/robot/quad_sec/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/R = loc

	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)

	src.modules += new /obj/item/handcuffs/cyborg(src) //You need cuffs to be a proper sec borg!
	src.modules += new /obj/item/dogborg/jaws/big(src) //In case there's some kind of hostile mob.
	src.modules += new /obj/item/melee/baton/robot(src) //Since the pounce module refused to work, they get a stunbaton instead.
	src.modules += new /obj/item/dogborg/boop_module(src) //Boop people on the nose.
	src.modules += new /obj/item/barrier_tape_roll/police(src) //Block out crime scenes.
	src.modules += new /obj/item/gun/energy/taser/mounted/cyborg(src) //They /are/ a security borg, after all.
	src.modules += new /obj/item/dogborg/pounce(src) //Pounce
	src.emag 	 = new /obj/item/gun/energy/laser/mounted(src) //Emag. Not a big problem.

	var/datum/matter_synth/water = new /datum/matter_synth(500) //Starts full and has a max of 500
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/dogborg/sleeper/K9/B = new /obj/item/dogborg/sleeper/K9(src) //Eat criminals. Bring them to the brig.
	B.water = water
	src.modules += B

	R.icon = 'icons/mob/robots_wide.dmi'
	R.set_base_pixel_x(-16)
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.icon_dimension_x = 64
	add_verb(R, /mob/living/silicon/robot/proc/ex_reserve_refill)
	add_verb(R, /mob/living/proc/shred_limb)
	add_verb(R, /mob/living/silicon/robot/proc/rest_style)

	if(R.client && (R.client.ckey in list("nezuli")))
		sprites += "Alina"
		sprites["Alina"] = "alina-sec"
		. = ..()

/obj/item/robot_module/robot/quad_sec/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
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

/obj/item/robot_module/robot/ert
	name = "Emergency Responce module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0
	sprites = list(
					"Standard" = "ert",
					"Borgi" = "borgi",
					"F3-LINE" = "FELI-Combat"
					)

/obj/item/robot_module/robot/ert/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/R = loc
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/dogborg/jaws/big(src)
	src.modules += new /obj/item/melee/baton/robot(src)
	src.modules += new /obj/item/barrier_tape_roll/police(src)
	src.modules += new /obj/item/gun/energy/taser/mounted/cyborg/ertgun(src)
	src.modules += new /obj/item/dogborg/swordtail(src)
	src.emag     = new /obj/item/gun/energy/laser/mounted(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/dogborg/sleeper/K9/B = new /obj/item/dogborg/sleeper/K9(src)
	B.water = water
	src.modules += B

	R.icon = 'icons/mob/64x64robot_vr.dmi'
	R.set_base_pixel_x(-16)
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.icon_dimension_x = 64
	add_verb(R, /mob/living/silicon/robot/proc/ex_reserve_refill)
	add_verb(R, /mob/living/proc/shred_limb)
	add_verb(R, /mob/living/silicon/robot/proc/rest_style)
