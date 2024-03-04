
/obj/machinery/modular_computer/console/telescreen/preset/Initialize(mapload)
	. = ..()
	if(!cpu)
		return
	cpu.install_component(new /obj/item/computer_hardware/processor_unit)
	var/obj/item/computer_hardware/hard_drive/hard_drive = cpu.all_components[MC_HDD]

	hard_drive.store_file(new /datum/computer_file/program/alarm_monitor())
	hard_drive.store_file(new /datum/computer_file/program/camera_monitor())
	// set_autorun("cammon")
