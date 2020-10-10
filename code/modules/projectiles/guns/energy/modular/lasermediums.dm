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
	beamtype = /obj/item/projectile/beam
	scatterbeam = /obj/item/projectile/scatter/laser
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
	beamcost = 12
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
