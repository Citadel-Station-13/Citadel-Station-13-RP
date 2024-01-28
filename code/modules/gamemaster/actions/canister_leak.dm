//
// This event chooses a random canister on player levels and breaks it, releasing its contents!
//

/datum/gm_action/canister_leak
	name = "Canister Leak"
	departments = list(DEPARTMENT_ENGINEERING)
	chaotic = 20

/datum/gm_action/canister_leak/get_weight()
	return metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 30

/datum/gm_action/canister_leak/start()
	..()
	// List of all non-destroyed canisters on station levels
	var/list/all_canisters = list()
	for(var/obj/machinery/portable_atmospherics/canister/C in GLOB.machines)
		if(!C.destroyed && (C.z in (LEGACY_MAP_DATUM).station_levels) && C.air_contents.total_moles >= CELL_MOLES)
			all_canisters += C
	var/obj/machinery/portable_atmospherics/canister/C = pick(all_canisters)
	log_debug(SPAN_DEBUGWARNING("canister_leak event: Canister [ADMIN_JMP(C)]) destroyed."))
	C.atom_break()
