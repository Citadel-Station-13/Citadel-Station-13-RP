/obj/machinery/computer/shuttle_control/mining
	name = "mining shuttle control console"
	shuttle_tag = "Mining"
	//req_access = list(ACCESS_SUPPLY_MINE)
	circuit = /obj/item/circuitboard/mining_shuttle

/obj/machinery/computer/shuttle_control/engineering
	name = "engineering shuttle control console"
	shuttle_tag = "Engineering"
	//req_one_access = list(ACCESS_ENGINEERING_ENGINE,ACCESS_ENGINEERING_ATMOS)
	circuit = /obj/item/circuitboard/engineering_shuttle

/obj/machinery/computer/shuttle_control/research
	name = "research shuttle control console"
	shuttle_tag = "Research"
	//req_access = list(ACCESS_SCIENCE_MAIN)
	circuit = /obj/item/circuitboard/research_shuttle
