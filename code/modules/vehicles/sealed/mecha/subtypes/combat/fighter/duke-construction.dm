/obj/item/vehicle_chassis/fighter/duke
	name = "\improper Duke Chassis"
	icon_state = "duke_chassis"

	origin_tech = list(TECH_MATERIAL = 2)

/obj/item/vehicle_chassis/fighter/duke/New()
	..()
	construct = new /datum/construction/mecha/fighter/duke_chassis(src)


/obj/item/vehicle_chassis/part/duke_core
	name="\improper Duke Core"
	icon_state = "duke_core"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/duke_cockpit
	name="\improper Duke Cockpit"
	icon_state = "duke_cockpit"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/duke_left_wing
	name="\improper Duke Left Wing"
	icon_state = "duke_l_wing"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/duke_right_wing
	name="\improper Duke Right Wing"
	icon_state = "duke_r_wing"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/duke_main_engine
	name="\improper Duke Main Engine"
	icon_state = "duke_m_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/duke_left_engine
	name="\improper Duke Left Engine"
	icon_state = "duke_l_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/duke_right_engine
	name="\improper Duke Right Engine"
	icon_state = "duke_r_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
