/obj/item/vehicle_chassis/honker
	name = "H.O.N.K. Chassis"

/obj/item/vehicle_chassis/honker/New()
	..()
	construct = new /datum/construction/mecha/honker_chassis(src)

/obj/item/vehicle_part/honker_torso
	name="H.O.N.K. Torso"
	desc="A H.O.N.K. torso. The lining requires a distressing amount of rubber."
	icon_state = "honker_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_head
	name="H.O.N.K. Head"
	desc="A H.O.N.K. head. Houses advanced slip prediction sensors and a squeezable nose."
	icon_state = "honker_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_left_arm
	name="H.O.N.K. Left Arm"
	desc="A H.O.N.K. left arm. Data and power sockets are compatible with the most hilarious tools and weapons."
	icon_state = "honker_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_right_arm
	name="H.O.N.K. Right Arm"
	desc="A H.O.N.K. right arm. Data and power sockets are compatible with the most hilarious tools and weapons."
	icon_state = "honker_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_left_leg
	name="H.O.N.K. Left Leg"
	icon_state = "honker_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_right_leg
	name="H.O.N.K. Right Leg"
	icon_state = "honker_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/vehicle_part/honker_armour
	name="H.O.N.K. Armour Plates"
	icon_state = "honker_armour"
	origin_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 5)
