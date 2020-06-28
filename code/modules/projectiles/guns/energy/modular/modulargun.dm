//modular weapons 2. shitcode ahead, be warned.

/obj/item/gun/energy/modular
	name = "the very concept of a modular weapon"
	desc = "An idea, given physical form? Contact your God, the Maker has made a mistake."
	icon_state = "mod_pistol"
	cell_type = /obj/item/cell/device/weapon
	charge_cost = 120
	projectile_type=/obj/item/projectile/beam//was this my issue the entire fucming time
	var/cores = 1//How many lasing cores can we support?
	var/assembled = 1 //Are we open?
	var/obj/item/modularlaser/lasermedium/primarycore //Lasing medium core.
	var/obj/item/modularlaser/lasermedium/secondarycore //Lasing medium core.
	var/obj/item/modularlaser/lasermedium/tertiarycore //Lasing medium core.
	var/obj/item/modularlaser/lens/laserlens //Lens. Dictates accuracy. Certain lenses change the projectiles to ENERGY SHOTGUN.
	var/obj/item/modularlaser/capacitor/lasercap
	var/obj/item/modularlaser/cooling/lasercooler
	var/obj/item/modularlaser/controller/circuit
	firemodes = list()
	var/emp_vuln = TRUE

/obj/item/gun/energy/modular/proc/generatefiremodes() //Accepts no args. Checks the gun's current components and generates projectile types, firemode costs and max burst. Should be called after changing parts or part values.
	if(!circuit)
		return
	if(!primarycore)
		return
	if(!laserlens)
		return
	if(!lasercooler)
		return
	if(!lasercap)
		return
	firemodes = list()
	var/burstmode = circuit.maxburst //Max burst controlled by the laser control circuit.
	//to_chat(world, "The modular weapon at [src.loc] has begun generating a firemode.")
	var/obj/item/projectile/beammode = primarycore.beamtype //Primary mode fire type.
	var/chargecost = primarycore.beamcost * lasercap.costmod //Cost for primary fire.
	chargecost += lasercooler.costadd //Cooler adds a flat amount post capacitor based on firedelay mod. Can be negative.
	var/scatter = laserlens.scatter //Does it scatter the beams?
	fire_delay = lasercap.firedelay * lasercooler.delaymod //Firedelay caculated by the capacitor and the laser cooler.
	burst_delay = circuit.burst_delay * lasercooler.delaymod //Ditto but with burst delay.
	accuracy = laserlens.accuracy
	var/chargecost_lethal = 120
	var/chargecost_special = 120
	var/obj/item/projectile/beammode_lethal
	var/obj/item/projectile/beammode_special
	if(cores > 1) //Secondary firemode
		beammode_lethal = secondarycore.beamtype
		chargecost_lethal = secondarycore.beamcost * lasercap.costmod
		chargecost_lethal += lasercooler.costadd
	if(cores == 3) //Tertiary firemodes
		beammode_special = tertiarycore.beamtype
		chargecost_special = tertiarycore.beamcost * lasercap.costmod
		chargecost_special += lasercooler.costadd
	var/maxburst = circuit.maxburst //Max burst.
	emp_vuln = circuit.robust //is the circuit strong enough to dissipate EMPs?
	//to_chat(world, "The modular weapon at [src.loc] has a max burst of [burstmode], a primary beam type of [beammode], a chargecost of [chargecost], a scatter of [scatter], a firedelay of [fire_delay], a burstdelay of [burst_delay], an accuracy of [accuracy], a chargecost of core 2 [chargecost_lethal], a beamtype of core 2 [beammode_lethal], a chargecost of core 3 [chargecost_special], a beamtype of core 3 [beammode_special]")
	switch(cores)
		if(1) //this makes me sick but ill ask if there's a better way to do this
			if(chargecost < 0)
				chargecost = 0
			if(scatter)
				beammode = primarycore.scatterbeam
				chargecost *= 2
			if(burstmode > 1)
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1)),
					new /datum/firemode(src, list("mode_name=[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst))
					)
				return TRUE
			else
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1))
					)
				return TRUE
		if(2)
			if(chargecost < 0)
				chargecost = 0
			if(chargecost_lethal < 0)
				chargecost_lethal = 0
			if(scatter)
				beammode = primarycore.scatterbeam
				beammode_lethal = secondarycore.scatterbeam
				chargecost *= 2
				chargecost_lethal *= 2
			if(burstmode > 1)
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = 1)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [secondarycore.firename]", projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = maxburst))
					)
				return TRUE
			else
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = 1))
					)
				return TRUE
		if(3)
			if(chargecost < 0)
				chargecost = 1
			if(chargecost_lethal < 0)
				chargecost_lethal = 1
			if(chargecost_special < 0)
				chargecost_special = 1
			if(scatter)
				beammode = primarycore.scatterbeam
				beammode_lethal = secondarycore.scatterbeam
				beammode_special = tertiarycore.scatterbeam
				chargecost *= 2
				chargecost_lethal *= 2
				chargecost_special *= 2
			if(burstmode > 1)
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = 1)),
					new /datum/firemode(src, list(mode_name=tertiarycore.firename, projectile_type=beammode_special, charge_cost = chargecost_special, burst = 1)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [secondarycore.firename]", projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [tertiarycore.firename]", projectile_type=beammode_special, charge_cost = chargecost_special, burst = maxburst))
					)
				return TRUE
			else
				firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1)),
				new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = 1)),
				new /datum/firemode(src, list(mode_name=tertiarycore.firename, projectile_type=beammode_special, charge_cost = chargecost_special, burst = 1)),
				)
				return TRUE

/obj/item/gun/energy/modular/emp_act(severity)
	if(!emp_vuln)
		return FALSE
	return ..()

/obj/item/gun/energy/modular/special_check(mob/user)
	. = ..()
	if(!circuit || !primarycore || !laserlens || !lasercap || !lasercooler)
		return FALSE //cannot work
		to_chat(user, "<span class='warning'>The gun is missing parts!</span>")
	if(!assembled)
		to_chat(user, "<span class='warning'>The gun is open!</span>")
		return FALSE

/obj/item/gun/energy/modular/attackby(obj/item/O, mob/user)
	if(O.is_screwdriver())
		to_chat(user, "<span class='notice'>You [assembled ? "disassemble" : "assemble"] the gun.</span>")
		assembled = !assembled
		playsound(src, O.usesound, 50, 1)
		return
	if(O.is_crowbar())
		if(assembled == TRUE)
			to_chat(user, "<span class='warning'>Open the [src] first!</span>")
			return
		var/turf/T = get_turf(src)
		if(primarycore && primarycore.removable == TRUE)
			primarycore.forceMove(T)
			primarycore = null
		if(secondarycore && secondarycore.removable == TRUE)
			secondarycore.forceMove(T)
			secondarycore = null
		if(tertiarycore && tertiarycore.removable == TRUE)
			tertiarycore.forceMove(T)
			tertiarycore = null
		if(laserlens && laserlens.removable == TRUE)
			laserlens.forceMove(T)
			laserlens = null
		if(lasercap && lasercap.removable == TRUE)
			lasercap.forceMove(T)
			lasercap = null
		if(lasercooler && lasercooler.removable == TRUE)
			lasercooler.forceMove(T)
			lasercooler = null
		if(circuit && circuit.removable == TRUE)
			circuit.forceMove(T)
			circuit = null
		generatefiremodes()
	if(istype(O, /obj/item/modularlaser))
		if(assembled == TRUE)
			to_chat(user, "<span class='warning'>Open the [src] first!</span>")
			return
		var/obj/item/modularlaser/ML = O
		if(istype(ML,/obj/item/modularlaser/lasermedium))
			var/obj/item/modularlaser/lasermedium/med = ML
			if(!primarycore && cores >= 1)
				primarycore = med
				user.drop_item()
				med.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [med.name] in the primary core slot.</span>")
				generatefiremodes()
				return
			if(!secondarycore && cores >= 2)
				secondarycore = med
				user.drop_item()
				med.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [med.name] in the secondary core slot.</span>")
				generatefiremodes()
				return
			if(!tertiarycore && cores == 3)
				tertiarycore = med
				user.drop_item()
				med.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [med.name] in the tertiary core slot.</span>")
				generatefiremodes()
				return
		if(istype(ML, /obj/item/modularlaser/lens))
			var/obj/item/modularlaser/lens/L = ML
			if(!laserlens)
				laserlens = L
				user.drop_item()
				L.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [L.name] in the lens holder.</span>")
				generatefiremodes()
				return
		if(istype(ML, /obj/item/modularlaser/capacitor))
			var/obj/item/modularlaser/capacitor/C = ML
			if(!lasercap)
				lasercap = C
				user.drop_item()
				C.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [C.name] in the power supply slot.</span>")
				generatefiremodes()
				return
		if(istype(ML, /obj/item/modularlaser/cooling))
			var/obj/item/modularlaser/cooling/CO = ML
			if(!lasercooler)
				lasercooler = CO
				user.drop_item()
				CO.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [CO.name] in the cooling system mount.</span>")
				generatefiremodes()
				return
		if(istype(ML, /obj/item/modularlaser/controller))
			var/obj/item/modularlaser/controller/CON = ML
			if(!circuit)
				circuit = CON
				user.drop_item()
				CON.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [CON.name] in the fire control unit mount and connect it.</span>")
				generatefiremodes()
				return
	..()

//these are debug ones.
/obj/item/gun/energy/modular/twocore
	name = "bicore modular weapon"
	cores = 2

/obj/item/gun/energy/modular/threecore
	name = "tricore modular weapon"
	cores = 3



//parts
/obj/item/modularlaser
	name = "modular laser part"
	desc = "I shouldn't exist."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "modkit"
	var/removable = TRUE
