/obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/battery_module/advanced
	)

/obj/item/modular_computer/laptop/preset/custom_loadout/advanced
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive/advanced,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/battery_module/advanced
	)


/obj/item/modular_computer/laptop/preset/custom_loadout/standard/install_default_hardware()
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive/,
		/obj/item/stock_parts/computer/network_card/,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/battery_module/advanced
	)


/obj/item/modular_computer/laptop/preset/custom_loadout/elite
	icon_state_unpowered = "adv-laptop-open"
	icon_state = "adv-laptop-open"
	icon_state_closed = "adv-laptop-closed"
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive/super,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/battery_module/super
	)

/obj/item/modular_computer/laptop/preset/custom_loadout/rugged
	name = "rugged laptop computer"
	desc = "A rugged portable computer."
	icon = 'icons/obj/modular_computer/modular_laptop_vr.dmi'
	max_damage = 300
	broken_damage = 200
	default_hardware = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/tesla_link,
		/obj/item/stock_parts/computer/hard_drive/advanced,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/battery_module/super
	)

///////
//Roles
///////

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security
	name = "\improper Security Officer's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/sechelmet())
	hard_drive.store_file(new/datum/computer_file/program/digitalwarrant())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/warden
	name = "\improper Warden's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/warden/install_default_programs()
	..()
	//hard_drive.store_file(new/datum/computer_file/program/warden()) This will hopefully have a working alert level shifter program that only has access to green, blue, and yellow.

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/hos
	name = "\improper Head of Security's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/hos/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/comm())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/pathfinder
	name = "\improper Pathfinder's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/pathfinder/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/explohelmet())
