/////////////////////////////////////////////
//Laser cores
////////////////////////////////////////////

/obj/item/modularlaser/lasermedium
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/obj/projectile/beamtype = /obj/projectile/beam
	var/obj/projectile/scatterbeam = /obj/projectile/scatter/laser
	var/beamcost = 120
	var/firename = "pew"

/obj/item/modularlaser/lasermedium/stun
	name = "stun beam medium"
	desc = "Allows a modular energy gun to fire basic stun beams."
	beamtype = /obj/projectile/beam/stun
	scatterbeam = /obj/projectile/scatter/stun
	beamcost = 240
	firename = "stun"

/obj/item/modularlaser/lasermedium/stun/weak
	name = "low-power stun beam medium"
	desc = "Allows a modular energy gun to fire weak stun beams."
	beamtype = /obj/projectile/beam/stun/weak
	scatterbeam = /obj/projectile/scatter/stun/weak
	beamcost = 120
	firename = "weak stun"

/obj/item/modularlaser/lasermedium/net
	name = "entangling beam medium"
	desc = "Allows a modular energy gun to fire entangling net beams."
	beamtype = /obj/projectile/beam/energy_net
	scatterbeam = /obj/projectile/scatter/energy_net
	beamcost = 1200 //hefty cost.
	firename = "energy net"

/obj/item/modularlaser/lasermedium/electrode
	name = "electrode projector tube"
	desc = "Allows a modular energy gun to fire basic stunning electrodes."
	beamtype = /obj/projectile/energy/electrode/strong
	scatterbeam = /obj/projectile/scatter/stun/electrode
	beamcost = 240
	firename = "electrode stun"

/obj/item/modularlaser/lasermedium/laser
	name = "laser beam medium"
	desc = "Allows a modular energy gun to fire basic laser beams."
	beamtype = /obj/projectile/beam
	scatterbeam = /obj/projectile/scatter/laser
	beamcost = 240
	firename = "lethal"

/obj/item/modularlaser/lasermedium/laser/weak
	name = "low-power laser beam medium"
	desc = "Allows a modular energy gun to fire supressive laser beams."
	beamtype = /obj/projectile/beam/weaklaser
	scatterbeam = /obj/projectile/scatter/laser/weak
	beamcost = 60
	firename = "weak laser"

/obj/item/modularlaser/lasermedium/laser/sniper
	name = "focused laser beam medium"
	desc = "Allows a modular energy gun to fire extremely focused laser beams."
	beamtype = /obj/projectile/beam/sniper
	scatterbeam = /obj/projectile/beam/sniper //no shotgun snipers. you can have shotgun cannons though!
	beamcost = 300
	firename = "focused laser"

/obj/item/modularlaser/lasermedium/laser/heavy
	name = "robust beam medium"
	desc = "Allows a modular energy gun to fire heavy laser beams."
	beamtype = /obj/projectile/beam/heavylaser
	scatterbeam = /obj/projectile/scatter/laser/heavylaser
	beamcost = 600
	firename = "heavy laser"

/obj/item/modularlaser/lasermedium/laser/cannon
	name = "uranium-235 excited medium"
	desc = "Allows a modular energy gun to fire heavy laser cannon beams."
	beamtype = /obj/projectile/beam/heavylaser/cannon
	scatterbeam = /obj/projectile/scatter/laser/heavylaser/cannon
	beamcost = 800
	firename = "cannon beam"

/obj/item/modularlaser/lasermedium/laser/xray
	name = "xraser beam medium"
	desc = "Allows a modular energy gun to fire exotic x-ray beams."
	beamtype = /obj/projectile/beam/gamma
	scatterbeam = /obj/projectile/scatter/gamma
	firename = "xraser"

/obj/item/modularlaser/lasermedium/laser/pulse //Badmin only.
	name = "pulse beam medium"
	desc = "Allows a modular energy gun to fire pulse beams."
	beamtype = /obj/projectile/beam/pulse
	scatterbeam = /obj/projectile/scatter/laser/pulse //haha fuck
	beamcost = 240
	firename = "DESTROY"

/obj/item/modularlaser/lasermedium/dig
	name = "excavation beam medium"
	desc = "Allows a modular energy gun to fire excavation laser beams. Yours is the beam that will pierce the heavens!"
	beamtype = /obj/projectile/beam/excavation
	scatterbeam = /obj/projectile/scatter/excavation
	beamcost = 12
	firename = "excavate"

/obj/item/modularlaser/lasermedium/lightning
	name = "electric beam medium"
	desc = "Allows a modular energy gun to fire lightning!"
	beamtype = /obj/projectile/beam/shock
	scatterbeam = /obj/projectile/scatter/shock
	beamcost = 300
	firename = "tesla"

/obj/item/modularlaser/lasermedium/hook
	name = "energy grappler projection tube"
	desc = "Allows a modular energy gun to fire an energy grappler. "
	beamtype = /obj/projectile/energy/hook
	scatterbeam = /obj/projectile/energy/hook
	beamcost = 400
	firename = "graviton grapple"

/obj/item/modularlaser/lasermedium/phase
	name = "phase projection tube"
	desc = "Allows a modular energy gun to fire phase waves for killing wildlife. "
	beamtype = /obj/projectile/energy/phase/heavy
	scatterbeam = /obj/projectile/scatter/phase
	beamcost = 80
	firename = "phase"
