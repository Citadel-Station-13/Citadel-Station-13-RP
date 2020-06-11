//modular weapons 2, lolman360 style. shitcode ahead, be warned.

/obj/item/gun/energy/modular
	name = "modular weapon"
	desc = "This object should never exist. Contact your God, the Maker has made a mistake."
	icon_state = "mod_pistol"
	cell_type = /obj/item/cell/device/weapon
	charge_cost = 120
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
	if(!circuit || !primarycore || !laserlens || !lasercap || !lasercooler)
		return FALSE //cannot work
	firemodes = list()
	var/burstmode = circuit.maxburst //Max burst controlled by the laser control circuit.
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
	if(cores == 3) //Tertiary firemode
		beammode_special = tertiarycore.beamtype
		chargecost_special = tertiarycore.beamcost * lasercap.costmod
		chargecost_special += lasercooler.costadd
	var/maxburst = circuit.maxburst //Max burst.
	emp_vuln = circuit.robust //is the circuit strong enough to dissipate EMPs?
	switch(cores)
		if(1) //this makes me sick but ill ask if there's a better way to do this
			if(chargecost < 0)
				chargecost = 0
			if(scatter)
				beammode = primarycore.scatterbeam
				chargecost *= 2
			if(burstmode > 1)
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
					new /datum/firemode(src, list("mode_name=[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst))
					)
				return TRUE
			else
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost))
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
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [secondarycore.firename]", projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = maxburst))
					)
				return TRUE
			else
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal))
					)
				return TRUE
		if(3)
			if(chargecost < 0)
				chargecost = 0
			if(chargecost_lethal < 0)
				chargecost_lethal = 0
			if(chargecost_special < 0)
				chargecost_special = 0
			if(scatter)
				beammode = primarycore.scatterbeam
				beammode_lethal = secondarycore.scatterbeam
				beammode_special = tertiarycore.scatterbeam
				chargecost *= 2
				chargecost_lethal *= 2
				chargecost_special *= 2
			if(burstmode > 1)
				firemodes = list(
					new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
					new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal)),
					new /datum/firemode(src, list(mode_name=tertiarycore.firename, projectile_type=beammode_special, charge_cost = chargecost_special)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost*maxburst, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [secondarycore.firename]", projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = maxburst)),
					new /datum/firemode(src, list(mode_name="[maxburst] shot [tertiarycore.firename]", projectile_type=beammode_special, charge_cost = chargecost_special, burst = maxburst))
					)
				return TRUE
			else
				firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost)),
				new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal)),
				new /datum/firemode(src, list(mode_name=tertiarycore.firename, projectile_type=beammode_special, charge_cost = chargecost_special)),
				)
				return TRUE

/obj/item/gun/energy/modular/emp_act(severity)
	if(!emp_vuln)
		return FALSE
	return ..()

/obj/item/gun/energy/modular/special_check(mob/user)
	..()
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

//parts
/obj/item/modularlaser
	name = "modular laser part"
	desc = "I shouldn't exist."
	icon = 'icons/obj/device.dmi'
	icon_state = "health"
	item_state = "healthanalyzer"
	var/removable = TRUE

/////////////////////////////////////////////
//Laser cores
////////////////////////////////////////////

/obj/item/modularlaser/lasermedium
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/obj/item/projectile/beamtype = /obj/item/projectile/beam
	var/obj/item/projectile/scatterbeam = /obj/item/projectile/scatter/laser
	var/beamcost = 120
	var/firename = "pew"

/obj/item/modularlaser/lasermedium/stun
	name = "stun beam medium"
	desc = "Allows a modular energy gun to fire basic stun beams."
	beamtype = /obj/item/projectile/beam/stun
	scatterbeam = /obj/item/projectile/scatter/stun
	beamcost = 240
	firename = "stun"

/obj/item/modularlaser/lasermedium/stun/weak
	name = "low-power stun beam medium"
	desc = "Allows a modular energy gun to fire weak stun beams."
	beamtype = /obj/item/projectile/beam/stun/weak
	scatterbeam = /obj/item/projectile/scatter/stun/weak
	beamcost = 120
	firename = "weak stun"

/obj/item/modularlaser/lasermedium/net
	name = "entangling beam medium"
	desc = "Allows a modular energy gun to fire entangling net beams."
	beamtype = /obj/item/projectile/beam/energy_net
	scatterbeam = /obj/item/projectile/scatter/energy_net
	beamcost = 1200 //hefty cost.
	firename = "energy net"

/obj/item/modularlaser/lasermedium/electrode
	name = "electrode projector tube"
	desc = "Allows a modular energy gun to fire basic stunning electrodes."
	beamtype = /obj/item/projectile/energy/electrode/strong
	scatterbeam = /obj/item/projectile/scatter/stun/electrode
	beamcost = 240
	firename = "electrode stun"

/obj/item/modularlaser/lasermedium/laser
	name = "laser beam medium"
	desc = "Allows a modular energy gun to fire basic laser beams."
	beamtype = /obj/item/projectile/beam/stun
	scatterbeam = /obj/item/projectile/scatter/stun
	beamcost = 240
	firename = "lethal"

/obj/item/modularlaser/lasermedium/laser/weak
	name = "low-power laser beam medium"
	desc = "Allows a modular energy gun to fire supressive laser beams."
	beamtype = /obj/item/projectile/beam/weaklaser
	scatterbeam = /obj/item/projectile/scatter/laser/weak
	beamcost = 60
	firename = "weak laser"

/obj/item/modularlaser/lasermedium/laser/sniper
	name = "focused laser beam medium"
	desc = "Allows a modular energy gun to fire extremely focused laser beams."
	beamtype = /obj/item/projectile/beam/sniper
	scatterbeam = /obj/item/projectile/beam/sniper //no shotgun snipers. you can have shotgun cannons though!
	beamcost = 300
	firename = "focused laser"

/obj/item/modularlaser/lasermedium/laser/heavy
	name = "robust beam medium"
	desc = "Allows a modular energy gun to fire heavy laser beams."
	beamtype = /obj/item/projectile/beam/heavylaser
	scatterbeam = /obj/item/projectile/scatter/laser/heavylaser
	beamcost = 600
	firename = "heavy laser"

/obj/item/modularlaser/lasermedium/laser/cannon
	name = "uranium-235 excited medium"
	desc = "Allows a modular energy gun to fire heavy laser cannon beams."
	beamtype = /obj/item/projectile/beam/heavylaser/cannon
	scatterbeam = /obj/item/projectile/scatter/laser/heavylaser/cannon
	beamcost = 800
	firename = "cannon beam"

/obj/item/modularlaser/lasermedium/laser/xray
	name = "xraser beam medium"
	desc = "Allows a modular energy gun to fire exotic x-ray beams."
	beamtype = /obj/item/projectile/beam/gamma
	scatterbeam = /obj/item/projectile/scatter/gamma
	firename = "xraser"

/obj/item/modularlaser/lasermedium/laser/pulse //Badmin only.
	name = "pulse beam medium"
	desc = "Allows a modular energy gun to fire pulse beams."
	beamtype = /obj/item/projectile/beam/pulse
	scatterbeam = /obj/item/projectile/scatter/laser/pulse //haha fuck
	beamcost = 240
	firename = "DESTROY"

/obj/item/modularlaser/lasermedium/dig
	name = "excavation beam medium"
	desc = "Allows a modular energy gun to fire excavation laser beams. Yours is the beam that will pierce the heavens!"
	beamtype = /obj/item/projectile/beam/excavation
	scatterbeam = /obj/item/projectile/scatter/excavation
	beamcost = 480 //big cost. Going to want to bring this one down.
	firename = "excavate"

/obj/item/modularlaser/lasermedium/lightning
	name = "electric beam medium"
	desc = "Allows a modular energy gun to fire lightning!"
	beamtype = /obj/item/projectile/beam/shock
	scatterbeam = /obj/item/projectile/scatter/shock
	beamcost = 300
	firename = "tesla"

/obj/item/modularlaser/lasermedium/hook
	name = "energy grappler projection tube"
	desc = "Allows a modular energy gun to fire an energy grappler. "
	beamtype = /obj/item/projectile/energy/hook
	scatterbeam = /obj/item/projectile/energy/hook
	beamcost = 400
	firename = "graviton grapple"

/obj/item/modularlaser/lasermedium/phase
	name = "phase projection tube"
	desc = "Allows a modular energy gun to fire phase waves for killing wildlife. "
	beamtype = /obj/item/projectile/energy/phase/heavy
	scatterbeam = /obj/item/projectile/scatter/phase
	beamcost = 80
	firename = "phase"

//////////////////////////////////////////////////
//Lenses
///////////////////////////////////////////////////

/obj/item/modularlaser/lens
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/scatter = FALSE
	var/accuracy = 0

/obj/item/modularlaser/lens/basic
	name = "basic modular lens"
	desc = "A basic lens with no drawbacks or upsides."

/obj/item/modularlaser/lens/advanced
	name = "advanced modular lens"
	desc = "An advanced metamaterial lens that focuses beams more accurately."
	accuracy = 15 //1 tile closer

/obj/item/modularlaser/lens/super
	name = "metamaterial modular lens"
	desc = "An advanced metamaterial lens that focuses beams extremely accurately."
	accuracy = 30 //2 tiles closer

/obj/item/modularlaser/lens/admin //badmin only
	name = "nanomachined modular lens"
	desc = "A swarm of transparent nanites that causes your beams to hit always, 100% of time time or your money back."
	accuracy = 225 //you shouldn't miss

/obj/item/modularlaser/lens/scatter
	name = "refracting modular lens"
	desc = "A simple glass lens that splits beams on contact. Very hard to aim with."
	scatter = TRUE
	accuracy = -60 //4 tiles further

/obj/item/modularlaser/lens/scatter/adv
	name = "advanced refracting modular lens"
	desc = "A well-machined glass lens that splits beams on contact. Hard to aim with."
	accuracy = -45 //3 tiles further

/obj/item/modularlaser/lens/scatter/super
	name = "metamaterial refracting modular lens"
	desc = "An advanced metamaterial lens that splits beams. Somewhat hard to aim with."
	accuracy = -15 //1 tile further

/obj/item/modularlaser/lens/scatter/hyper //VERY expensive. Precursor tech only.
	name = "supermaterial refracting modular lens"
	desc = "A bleeding-edge metamaterial lens that splits beams."
	accuracy = 0

/obj/item/modularlaser/lens/scatter/admin
	name = "nanomachined refracting modular lens"
	desc = "An advanced nanomachined lens that splits beams."
	accuracy = 225 //100% of shots should land.

///////////////////////////////////////////
//Power supplies
////////////////////////////////////////////
/obj/item/modularlaser/capacitor
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/costmod = 1.0
	var/firedelay = 6 //im 99% sure these are in deciseconds

/obj/item/modularlaser/capacitor/basic
	name = "weapon power handler"
	desc = "A garden-variety power handling unit for a modular energy weapon."

/obj/item/modularlaser/capacitor/simple
	name = "simple weapon power handler"
	desc = "A simplistic power handling unit for a modular energy weapon."
	firedelay = 10

/obj/item/modularlaser/capacitor/simple/integral //meant to be unremoveable
	name = "integrated compact weapon power handler"
	desc = "A compact energy weapon power handling system. Unable to be removed from the weapon it is mounted in, normally."
	removable = FALSE

/obj/item/modularlaser/capacitor/eco
	name = "efficient weapon power handler"
	desc = "An energy handler for a modular energy weapon that recoups some of the energy used, at the cost of longer delay between shots."
	costmod = 0.9
	firedelay = 12 //twice as long

/obj/item/modularlaser/capacitor/eco/super
	name = "advanced energy-recovery weapon power handler"
	desc = "A power handler for a modular energy weapon that recoups a significant amount of the energy used, at the cost of a significant delay between shots."
	costmod = 0.75
	firedelay = 20

/obj/item/modularlaser/capacitor/eco/hyper
	name = "bleeding-edge energy-recovery weapon power handler"
	desc = "A power handler for a modular energy weapon that recoups half of the energy used, at the cost of a crippling delay between shots."
	costmod = 0.5
	firedelay = 40

/obj/item/modularlaser/capacitor/eco/admin //admin only.
	name = "zero-point energy-recovery weapon power handler"
	desc = "A power handler for a modular energy weapon that recoups almost all of the energy used, at the cost of a delay between shots."
	costmod = 0.01
	firedelay = 10

/obj/item/modularlaser/capacitor/speed
	name = "throughput-calibrated weapon power handler"
	desc = "A power handler for a modular energy weapon that is less efficient, but has half the delay between shots."
	costmod = 1.2
	firedelay = 3

/obj/item/modularlaser/capacitor/speed/advanced
	name = "throughput-focused weapon power handler"
	desc = "A power handler for a modular energy weapon that is inefficient, but has less than half the delay between shots."
	costmod = 1.5
	firedelay = 1

/obj/item/modularlaser/capacitor/speed/admin
	name = "superconductive weapon power handler"
	desc = "A power handler for a modular energy weapon that is efficient, and has no delay between shots."
	costmod = 1
	firedelay = 0

///////////////////////////////////////////////////////
//Cooling
///////////////////////////////////////////////////////
/obj/item/modularlaser/cooling
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/delaymod = 1.0
	var/costadd = 0

/obj/item/modularlaser/cooling/basic
	name = "basic modular cooling system"
	desc = "A basic air-cooling system for a modular energy weapon."

/obj/item/modularlaser/cooling/efficient
	name = "heat recovery cooling system"
	desc = "A cooling system that uses heat from firing to generate some power. Needs time between shots to work."
	delaymod = 1.5
	costadd = -10

/obj/item/modularlaser/cooling/efficient/super
	name = "advanced heat recovery cooling system"
	desc = "A cooling system that uses heat from firing to generate a good amount of power. Needs a lot of time between shots to work."
	delaymod = 2
	costadd = -20

/obj/item/modularlaser/cooling/speed
	name = "active cooling system"
	desc = "A cooling system that uses more energy to reduce the time needed between shots."
	delaymod = 0.75
	costadd = 10

/obj/item/modularlaser/cooling/speed/adv
	name = "superradiative cooling system"
	desc = "A cooling system that forces heat from firing into the air around it extremely quickly, reducing the delay between shots. Uses a good amount of power."
	delaymod = 0.3
	costadd = 20

/////////////////////////////////////////////////////
//Burst controller
////////////////////////////////////////////////////
/obj/item/modularlaser/controller
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/maxburst = 1
	var/burst_delay = 3
	var/robust = FALSE

/obj/item/modularlaser/controller/basic
	name = "weapon fire control unit"
	desc = "A basic weapon firing system. Controls the power supply and energy emitter in order to make the gun go pew."

/obj/item/modularlaser/controller/twoburst
	name = "AN-94 burst controller"
	desc = "A modular energy weapon firing controller that allows single-shot and two-shot bursts."
	maxburst = 2
	burst_delay = 0.5

/obj/item/modularlaser/controller/threeburst
	name = "burst weapon fire control unit"
	desc = "A modular weapon firing unit that allows single-shot and triple-shot bursts."
	maxburst = 3

/obj/item/modularlaser/controller/fiveburst
	name = "quintuple-burst fire control unit"
	desc = "Can fire a burst of five shots, or in single-shot mode."
	maxburst = 5
	burst_delay = 4

/obj/item/modularlaser/controller/supressive
	name = "supressive fire control unit"
	desc = "A weapon firing controller that adds a supressive fire burst mode, unleashing a large amount of inaccurate, supressive beams at a moderate delay."
	maxburst = 8
	burst_delay = 7

/obj/item/modularlaser/controller/robust
	name = "simple weapon fire control unit"
	desc = "An incredibly robust weapon firing control unit, with minimal shielded electronics. Harmlessly dissipates electro-magnetic pulses."
	robust = TRUE

/obj/item/modularlaser/controller/robust/roburst //this is just for the pun, yes
	name = "simple burst fire control unit"
	maxburst = 3
