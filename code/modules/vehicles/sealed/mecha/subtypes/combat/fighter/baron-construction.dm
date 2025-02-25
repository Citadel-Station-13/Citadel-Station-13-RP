/obj/item/vehicle_chassis/fighter/baron
	name = "\improper Baron Chassis"
	icon_state = "baron_chassis"

	origin_tech = list(TECH_MATERIAL = 2)

/obj/item/vehicle_chassis/fighter/baron/New()
	..()
	construct = new /datum/construction/mecha/fighter/baron_chassis(src)


/obj/item/vehicle_chassis/part/baron_core
	name="\improper Baron Core"
	icon_state = "baron_core"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/baron_cockpit
	name="\improper Baron Cockpit"
	icon_state = "baron_cockpit"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/baron_left_wing
	name="\improper Baron Left Wing"
	icon_state = "baron_l_wing"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/baron_right_wing
	name="\improper Baron Right Wing"
	icon_state = "baron_r_wing"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/baron_main_engine
	name="\improper Baron Main Engine"
	icon_state = "baron_m_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/baron_left_engine
	name="\improper Baron Left Engine"
	icon_state = "baron_l_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)

/obj/item/vehicle_chassis/part/baron_right_engine
	name="\improper Baron Right Engine"
	icon_state = "baron_r_engine"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
