GLOBAL_LIST_BOILERPLATE(vehicle_tracking_beacons, /obj/item/vehicle_tracking_beacon)

// todo: this is neither a component nor a module and it's weird, deal with it somehow
/obj/item/vehicle_tracking_beacon
	name = "Exosuit tracking beacon"
	desc = "Device used to transmit exosuit data."
	icon = 'icons/obj/device.dmi'
	icon_state = "motion2"
	origin_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)

/obj/item/vehicle_tracking_beacon/ui_data(mob/user, datum/tgui/ui)
	var/list/data = ..()
	if(!in_mecha())
		return FALSE

	// TODO: just vehicle
	var/obj/vehicle/sealed/mecha/M = loc
	data["ref"] = REF(src)
	data["charge"] = M.get_charge()
	data["name"] = M.name
	data["integrity"] = M.integrity
	data["maxHealth"] = initial(M.integrity)
	data["cell"] = M.power_cell
	if(M.power_cell)
		data["cellCharge"] = M.power_cell.charge
		data["cellMaxCharge"] = M.power_cell.charge
	data["airtank"] = M.return_pressure()
	data["pilot"] = M.occupant_legacy
	data["location"] = get_area(M)
	data["active"] = M.module_active_click
	data["cargoUsed"] = length(M.cargo_held)
	data["cargoMax"] = M.cargo_capacity

	return data

/obj/item/vehicle_tracking_beacon/emp_act()
	qdel(src)

/obj/item/vehicle_tracking_beacon/legacy_ex_act()
	qdel(src)

/obj/item/vehicle_tracking_beacon/proc/in_mecha()
	if(istype(loc, /obj/vehicle/sealed/mecha))
		return loc
	return 0

/obj/item/vehicle_tracking_beacon/proc/shock()
	var/obj/vehicle/sealed/mecha/M = in_mecha()
	if(M)
		M.emp_act(4)
	qdel(src)

/obj/item/vehicle_tracking_beacon/proc/get_mecha_log()
	if(!in_mecha())
		return list()
	var/obj/vehicle/sealed/mecha/M = loc
	return list()

/obj/item/storage/box/mechabeacons
	name = "Exosuit Tracking Beacons"

/obj/item/storage/box/mechabeacons/legacy_spawn_contents()
	new /obj/item/vehicle_tracking_beacon(src)
	new /obj/item/vehicle_tracking_beacon(src)
	new /obj/item/vehicle_tracking_beacon(src)
	new /obj/item/vehicle_tracking_beacon(src)
	new /obj/item/vehicle_tracking_beacon(src)
	new /obj/item/vehicle_tracking_beacon(src)
	new /obj/item/vehicle_tracking_beacon(src)
