/obj/item/vehicle_chassis/fighter/pinnace
	name = "\improper Pinnace Chassis"
	icon_state = "pinnace_chassis"

	origin_tech = list(TECH_MATERIAL = 2)

/obj/item/vehicle_chassis/fighter/pinnace/New()
	..()
	construct = new /datum/construction/mecha/fighter/pinnace_chassis(src)


/obj/item/vehicle_chassis/part/pinnace_core
	name="\improper Pinnace Core"
	icon_state = "pinnace_core"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_chassis/part/pinnace_cockpit
	name="\improper Pinnace Cockpit"
	icon_state = "pinnace_cockpit"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_chassis/part/pinnace_left_wing
	name="\improper Pinnace Left Wing"
	icon_state = "pinnace_l_wing"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_chassis/part/pinnace_right_wing
	name="\improper Pinnace Right Wing"
	icon_state = "pinnace_r_wing"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_chassis/part/pinnace_main_engine
	name="\improper Pinnace Main Engine"
	icon_state = "pinnace_m_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_chassis/part/pinnace_left_engine
	name="\improper Pinnace Left Engine"
	icon_state = "pinnace_l_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/vehicle_chassis/part/pinnace_right_engine
	name="\improper Pinnace Right Engine"
	icon_state = "pinnace_r_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
