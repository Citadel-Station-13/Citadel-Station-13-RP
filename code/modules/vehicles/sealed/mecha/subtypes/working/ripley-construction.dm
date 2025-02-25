/**
 * Contains:
 *
 * * Firefighter
 * * Geiger
 * * Ripley
 */


/obj/item/vehicle_chassis/ripley
	name = "Ripley Chassis"

/obj/item/vehicle_chassis/ripley/New()
	..()
	construct = new /datum/construction/mecha/ripley_chassis(src)

/obj/item/vehicle_part/ripley_torso
	name="Ripley Torso"
	desc="A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/ripley_left_arm
	name="Ripley Left Arm"
	desc="A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/ripley_right_arm
	name="Ripley Right Arm"
	desc="A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/ripley_left_leg
	name="Ripley Left Leg"
	desc="A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_part/ripley_right_leg
	name="Ripley Right Leg"
	desc="A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_chassis/firefighter
	name = "Firefighter Chassis"

/obj/item/vehicle_chassis/firefighter/New()
	..()
	construct = new /datum/construction/mecha/firefighter_chassis(src)

/obj/item/vehicle_chassis/geiger
	name = "Lightweight APLU Chassis"

/obj/item/vehicle_chassis/geiger/New()
	..()
	construct = new /datum/construction/mecha/geiger_chassis(src)

/obj/item/vehicle_part/geiger_torso
	name="Lightweight APLU Torso"
	icon_state = "ripley_harness"
