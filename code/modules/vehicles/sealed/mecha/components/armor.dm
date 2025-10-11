
/obj/item/vehicle_component/armor
	name = "mecha plating"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "armor"
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 1000)

	component_type = MECH_ARMOR

	start_damaged = FALSE

	emp_resistance = 4

	required_type = null	// List, if it exists. Exosuits meant to use the component.

	integrity_danger_mod = 0.4	// Multiplier for comparison to integrity_max before problems start.
	integrity_max = 120

	internal_damage_flag = MECHA_INT_TEMP_CONTROL

	step_delay = 1

	var/deflect_chance = 10
	var/list/damage_absorption = list(
		"brute"=	0.8,
		"fire"=		1.2,
		"bullet"=	0.9,
		"laser"=	1,
		"energy"=	1,
		"bomb"=		1,
		"bio"=		1,
		"rad"=		1
		)

	var/damage_minimum = 10
	var/minimum_penetration = 0
	var/fail_penetration_value = 0.66

/obj/item/vehicle_component/armor/mining
	name = "blast-resistant mecha plating"

	step_delay = 2
	integrity_max = 80

	damage_absorption = list(
									"brute"=0.8,
									"fire"=0.8,
									"bullet"=1.2,
									"laser"=1.2,
									"energy"=1,
									"bomb"=0.5,
									"bio"=1,
									"rad"=1
									)

/obj/item/vehicle_component/armor/lightweight
	name = "lightweight mecha plating"

	integrity_max = 50
	step_delay = 0

	damage_absorption = list(
									"brute"=1,
									"fire"=1.4,
									"bullet"=1.1,
									"laser"=1.2,
									"energy"=1,
									"bomb"=1,
									"bio"=1,
									"rad"=1
									)

/obj/item/vehicle_component/armor/reinforced
	name = "reinforced mecha plating"

	step_delay = 4

	integrity_max = 80

	minimum_penetration = 10

	damage_absorption = list(
		"brute"=0.7,
		"fire"=1,
		"bullet"=0.7,
		"laser"=0.85,
		"energy"=1,
		"bomb"=0.8
		)

/obj/item/vehicle_component/armor/military
	name = "military grade mecha plating"

	step_delay = 4

	integrity_max = 100

	emp_resistance = 2

	required_type = list(/obj/vehicle/sealed/mecha/combat)

	damage_minimum = 15
	minimum_penetration = 25

	damage_absorption = list(
		"brute"=0.5,
		"fire"=1.1,
		"bullet"=0.65,
		"laser"=0.85,
		"energy"=0.9,
		"bomb"=0.8
		)

/obj/item/vehicle_component/armor/military/attach(var/obj/vehicle/sealed/mecha/target, var/mob/living/user)
	. = ..()
	if(.)
		var/typepass = FALSE
		for(var/type in required_type)
			if(istype(chassis, type))
				typepass = TRUE

		if(typepass)
			step_delay = 0
		else
			step_delay = initial(step_delay)

/obj/item/vehicle_component/armor/marshal
	name = "marshal mecha plating"

	step_delay = 3

	integrity_max = 100

	emp_resistance = 3

	deflect_chance = 15

	minimum_penetration = 10

	required_type = list(/obj/vehicle/sealed/mecha/combat)

	damage_absorption = list(
		"brute"=0.75,
		"fire"=1,
		"bullet"=0.8,
		"laser"=0.7,
		"energy"=0.85,
		"bomb"=1
		)

/obj/item/vehicle_component/armor/marshal/attach(var/obj/vehicle/sealed/mecha/target, var/mob/living/user)
	. = ..()
	if(.)
		var/typepass = FALSE
		for(var/type in required_type)
			if(istype(chassis, type))
				typepass = TRUE

		if(typepass)
			step_delay = 2
		else
			step_delay = initial(step_delay)

/obj/item/vehicle_component/armor/marshal/reinforced
	name = "blackops mecha plating"

	step_delay = 5

	damage_absorption = list(
		"brute"=0.6,
		"fire"=0.8,
		"bullet"=0.6,
		"laser"=0.5,
		"energy"=0.65,
		"bomb"=0.8
		)

/obj/item/vehicle_component/armor/military/marauder
	name = "cutting edge mecha plating"

	step_delay = 4

	integrity_max = 150

	emp_resistance = 3

	required_type = list(/obj/vehicle/sealed/mecha/combat/marauder)

	deflect_chance = 25
	damage_minimum = 30
	minimum_penetration = 25

	damage_absorption = list(
		"brute"=0.5,
		"fire"=0.7,
		"bullet"=0.45,
		"laser"=0.6,
		"energy"=0.7,
		"bomb"=0.7
		)

/obj/item/vehicle_component/armor/military/marauder/attach(var/obj/vehicle/sealed/mecha/target, var/mob/living/user)
	. = ..()
	if(.)
		var/typepass = FALSE
		for(var/type in required_type)
			if(istype(chassis, type))
				typepass = TRUE

		if(typepass)
			step_delay = 1
		else
			step_delay = initial(step_delay)

/obj/item/vehicle_component/armor/alien
	name = "strange mecha plating"
	step_delay = 2
	damage_absorption = list(
		"brute"=0.7,
		"fire"=0.7,
		"bullet"=0.7,
		"laser"=0.7,
		"energy"=0.7,
		"bomb"=0.7
		)

/obj/item/vehicle_component/armor/alien/attach(var/obj/vehicle/sealed/mecha/target, var/mob/living/user)
	. = ..()
	if(.)
		if(istype(target, /obj/vehicle/sealed/mecha/combat/phazon/janus))
			step_delay = -1

		else if(istype(target, /obj/vehicle/sealed/mecha/combat/phazon))
			step_delay = -3

		else
			step_delay = initial(step_delay)

/obj/item/vehicle_component/armor/heavy_duty //Should only be avaliable for 3x3 mechs.
	name = "heavy duty mecha plating"

	step_delay = 4

	integrity_max = 3000

	emp_resistance = 5

	deflect_chance = 15

	minimum_penetration = 0

	//required_type = list(/obj/vehicle/sealed/mecha/combat/quasimodo) doesn't work for some reason.

	damage_absorption = list(
		"brute"=0.50,
		"fire"=0.9,
		"bullet"=0.65,
		"laser"=0.8,
		"energy"=0.85,
		"bomb"=0.5
		)

