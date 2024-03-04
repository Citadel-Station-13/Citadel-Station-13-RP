// Misc laptop frames
/obj/item/modular_computer/laptop/preset/Initialize(mapload)
	. = ..()
	// install_component(new /obj/item/computer_hardware/processor_unit/small)
	// install_component(new /obj/item/computer_hardware/battery(src, /obj/item/cell/computer))
	// install_component(new /obj/item/computer_hardware/hard_drive)
	// install_component(new /obj/item/computer_hardware/network_card)
	install_programs()

/obj/item/modular_computer/laptop/preset/proc/install_programs()
	return

// this is what tg has
/obj/item/modular_computer/laptop/preset/civilian
	desc = "A low-end laptop often used for personal recreation."

/obj/item/modular_computer/laptop/preset/civilian/Initialize(mapload)
	install_component(new /obj/item/computer_hardware/processor_unit/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/cell/computer))
	install_component(new /obj/item/computer_hardware/hard_drive)
	install_component(new /obj/item/computer_hardware/network_card)
	. = ..()

/obj/item/modular_computer/laptop/preset/civilian/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	hard_drive.store_file(new/datum/computer_file/program/chatclient())

// preload chatclient on cusotm loadout ones
/obj/item/modular_computer/laptop/preset/custom_loadout/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	hard_drive.store_file(new/datum/computer_file/program/chatclient())

/obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	desc = "A laptop often used for personal recreation."

/obj/item/modular_computer/laptop/preset/custom_loadout/cheap/Initialize(mapload)
	install_component(new /obj/item/computer_hardware/processor_unit/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/cell/computer))
	install_component(new /obj/item/computer_hardware/hard_drive)
	install_component(new /obj/item/computer_hardware/network_card)
	. = ..()

// t2 cpu, has charger; adv hdd; adv networking
/obj/item/modular_computer/laptop/preset/custom_loadout/advanced/Initialize(mapload)
	install_component(new /obj/item/computer_hardware/processor_unit/photonic/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/cell/computer/advanced))
	install_component(new /obj/item/computer_hardware/hard_drive/advanced)
	install_component(new /obj/item/computer_hardware/network_card/advanced)
	install_component(new /obj/item/computer_hardware/recharger/tesla_link)
	install_component(new /obj/item/computer_hardware/card_slot)
	install_component(new /obj/item/computer_hardware/nano_printer)
	. = ..()

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/Initialize(mapload)
	install_component(new /obj/item/computer_hardware/processor_unit/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/cell/computer/advanced))
	install_component(new /obj/item/computer_hardware/hard_drive)
	install_component(new /obj/item/computer_hardware/network_card)
	install_component(new /obj/item/computer_hardware/recharger/tesla_link)
	install_component(new /obj/item/computer_hardware/card_slot)
	. = ..()

/obj/item/modular_computer/laptop/preset/custom_loadout/elite
	icon_state_unpowered = "adv-laptop-open"
	icon_state = "adv-laptop-open"
	icon_state_closed = "adv-laptop-closed"

/obj/item/modular_computer/laptop/preset/custom_loadout/elite/Initialize(mapload)
	install_component(new /obj/item/computer_hardware/processor_unit/photonic/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/cell/computer/super))
	install_component(new /obj/item/computer_hardware/hard_drive/super)
	install_component(new /obj/item/computer_hardware/network_card/advanced)
	install_component(new /obj/item/computer_hardware/recharger/tesla_link)
	install_component(new /obj/item/computer_hardware/card_slot)
	install_component(new /obj/item/computer_hardware/nano_printer)
	. = ..()

/obj/item/modular_computer/laptop/preset/custom_loadout/rugged
	name = "rugged laptop computer"
	desc = "A rugged portable computer."
	icon = 'icons/obj/modular_laptop_vr.dmi'
	integrity = 300
	integrity_failure = 200

/obj/item/modular_computer/laptop/preset/custom_loadout/rugged/Initialize(mapload)
	install_component(new /obj/item/computer_hardware/processor_unit/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/cell/computer/super))
	install_component(new /obj/item/computer_hardware/hard_drive/advanced)
	install_component(new /obj/item/computer_hardware/network_card/advanced)
	install_component(new /obj/item/computer_hardware/recharger/tesla_link)
	install_component(new /obj/item/computer_hardware/card_slot)
	install_component(new /obj/item/computer_hardware/nano_printer)
	. = ..()

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security
	name = "\improper Security Officer's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	hard_drive.store_file(new /datum/computer_file/program/camera_monitor())
	#warn IMPLEMENT THESE APPS AGAIN
	// hard_drive.store_file(new /datum/computer_file/program/camera_monitor/sechelmet())
	// hard_drive.store_file(new /datum/computer_file/program/digitalwarrant())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/warden
	name = "\improper Warden's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/warden/install_programs()
	// var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	//hard_drive.store_file(new/datum/computer_file/program/warden()) This will hopefully have a working alert level shifter program that only has access to green, blue, and yellow.

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/hos
	name = "\improper Head of Security's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/security/hos/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	#warn IMPLEMENT THESE APPS AGAIN
	// hard_drive.store_file(new/datum/computer_file/program/comm())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/pathfinder
	name = "\improper Pathfinder's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/pathfinder/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	#warn IMPLEMENT THESE APPS AGAIN
	// hard_drive.store_file(new/datum/computer_file/program/camera_monitor/explohelmet())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/searchandrescue
	name = "\improper S&R's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/searchandrescue/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	#warn IMPLEMENT THESE APPS AGAIN
	// hard_drive.store_file(new/datum/computer_file/program/camera_monitor/explohelmet())
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors())
