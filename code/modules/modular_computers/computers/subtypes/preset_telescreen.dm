/obj/item/modular_computer/telescreen/preset/install_default_hardware()
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card
	)


/obj/item/modular_computer/telescreen/preset/generic/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	set_autorun("cammon")
