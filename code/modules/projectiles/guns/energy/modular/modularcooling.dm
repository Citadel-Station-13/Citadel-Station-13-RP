

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

/obj/item/modularlaser/cooling/lame
	name = "compact modular cooling system"
	desc = "A tiny air-cooling system for a modular energy weapon."
	delaymod = 1.1

/obj/item/modularlaser/cooling/lame/integral
	removable = FALSE

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
