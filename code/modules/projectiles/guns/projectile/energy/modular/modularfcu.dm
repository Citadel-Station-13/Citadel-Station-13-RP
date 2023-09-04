

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

/obj/item/modularlaser/controller/basic/integral
	name = "integral fire control unit"
	desc = "A basic weapon firing system. Controls the power supply and energy emitter in order to make the gun go pew. Should not be able to be removed."
	removable = FALSE

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
