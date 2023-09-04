
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

/obj/item/modularlaser/capacitor/cannon
	firedelay = 3
	removable = FALSE
