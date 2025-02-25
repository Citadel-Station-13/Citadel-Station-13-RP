/obj/item/vehicle_chassis/reticent
	name = "Reticent Chassis"

/obj/item/vehicle_chassis/reticent/New()
	..()
	construct = new /datum/construction/mecha/reticent_chassis(src)

/obj/item/vehicle_part/reticent_torso
	name="Reticent Torso"
	desc="A Reticent torso. The hull is augmented by a Silencium mosaic."
	icon_state = "reticent_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/reticent_head
	name="Reticent Head"
	desc="A Reticent head. The eyes stare dispassionately back at you."
	icon_state = "reticent_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_MAGNET = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/reticent_left_arm
	name="Reticent Left Arm"
	desc="A Reticent left arm. Data and power sockets are compatible with general weapons, and wickedly silent alternatives."
	icon_state = "reticent_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/reticent_right_arm
	name="Reticent Right Arm"
	desc="A Reticent right arm. Data and power sockets are compatible with general weapons, and wickedly silent alternatives."
	icon_state = "reticent_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/reticent_left_leg
	name="Reticent Left Leg"
	icon_state = "reticent_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/reticent_right_leg
	name="Reticent Right Leg"
	icon_state = "reticent_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/reticent_armour
	name="Reticent Armour Plates"
	icon_state = "reticent_armour"
	origin_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 5)
