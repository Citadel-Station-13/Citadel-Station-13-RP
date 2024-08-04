/obj/item/modular_computer/laptop/preset/custom_loadout/cheap/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit/small(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive/(src)
	network_card = new/obj/item/computer_hardware/network_card/(src)
	nano_printer = new/obj/item/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/computer_hardware/card_slot(src)
	battery_module = new/obj/item/computer_hardware/battery_module/advanced(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/laptop/preset/custom_loadout/advanced/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive/advanced(src)
	network_card = new/obj/item/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/computer_hardware/card_slot(src)
	battery_module = new/obj/item/computer_hardware/battery_module/advanced(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive/(src)
	network_card = new/obj/item/computer_hardware/network_card/(src)
	nano_printer = new/obj/item/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/computer_hardware/card_slot(src)
	battery_module = new/obj/item/computer_hardware/battery_module/advanced(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/laptop/preset/custom_loadout/elite
	icon_state_unpowered = "adv-laptop-open"
	icon_state = "adv-laptop-open"
	icon_state_closed = "adv-laptop-closed"

/obj/item/modular_computer/laptop/preset/custom_loadout/elite/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive/super(src)
	network_card = new/obj/item/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/computer_hardware/card_slot(src)
	battery_module = new/obj/item/computer_hardware/battery_module/super(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/laptop/preset/custom_loadout/rugged
	name = "rugged laptop computer"
	desc = "A rugged portable computer."
	icon = 'icons/obj/modular_laptop_vr.dmi'
	max_damage = 300
	broken_damage = 200

/obj/item/modular_computer/laptop/preset/custom_loadout/rugged/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit/small(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive/advanced(src)
	network_card = new/obj/item/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/computer_hardware/card_slot(src)
	battery_module = new/obj/item/computer_hardware/battery_module/super(src)
	battery_module.charge_to_full()

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

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/searchandrescue
	name = "\improper S&R's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/searchandrescue/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/explohelmet())
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors())
