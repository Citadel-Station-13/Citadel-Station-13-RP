
/obj/machinery/chemical_dispenser
	var/_recharge_reagents = 1
	var/list/dispense_reagents = list()
	var/process_tick = 0

/obj/machinery/chemical_dispenser/process(delta_time)
	if(!_recharge_reagents)
		return
	if(machine_stat & (BROKEN|NOPOWER))
		return
	. = 0
	for(var/id in dispense_reagents)
		var/datum/reagent/R = SSchemistry.reagent_lookup[id]
		if(!R)
			stack_trace("[src] at [x],[y],[z] failed to find reagent '[id]'!")
			dispense_reagents -= id
			continue
		var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[R.name]
		if(C && C.reagents.total_volume < C.reagents.maximum_volume)
			var/to_restore = min(C.reagents.maximum_volume - C.reagents.total_volume, 1)
			use_power(to_restore * 200)
			C.reagents.add_reagent(id, to_restore)
			. = 1
	if(.)
		SStgui.update_uis(src)
