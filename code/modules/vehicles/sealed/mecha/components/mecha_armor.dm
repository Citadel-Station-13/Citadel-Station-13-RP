/datum/armor/vehicle_plating/mecha_armor

/datum/armor/vehicle_plating_redirection/mecha_armor

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_armor
	name = "mecha plating"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "armor"
	w_class = WEIGHT_CLASS_HUGE
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 1000)

	integrity = 300
	integrity_max = 300
	integrity_failure = 200

	vehicle_encumbrance = 7.5
	start_damaged = FALSE
	internal_damage_flag = MECHA_INT_TEMP_CONTROL

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

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_armor/lightweight
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (lightweight)"
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

/**
 * * Acquirable from R&D / lathes
 */
/obj/item/vehicle_component/plating/mecha_armor/durable
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (reinforced)"
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

/obj/item/vehicle_component/plating/mecha_armor/durable/citadel
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (citadel)"

/obj/item/vehicle_component/plating/mecha_armor/advanced
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (advanced)"

/obj/item/vehicle_component/plating/mecha_armor/advanced/lightweight
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (advanced lightweight)"

/obj/item/vehicle_component/plating/mecha_armor/alien
	name = /obj/item/vehicle_component/plating/mecha_armor::name + " (???)"
	step_delay = 2
	damage_absorption = list(
		"brute"=0.7,
		"fire"=0.7,
		"bullet"=0.7,
		"laser"=0.7,
		"energy"=0.7,
		"bomb"=0.7
		)
