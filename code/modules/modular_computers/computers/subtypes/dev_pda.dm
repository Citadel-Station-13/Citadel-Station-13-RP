/obj/item/modular_computer/pda
	name = "PDA"
	desc = "A microcomputer device intended to handle communications."
	icon = 'icons/obj/modular_computer/modular_pda.dmi'
	icon_state = "world"
	icon_state_unpowered = "world"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_ID | SLOT_BELT | SLOT_POCKET
	stores_pen = TRUE
	stored_pen = /obj/item/pen
	hardware_flag = PROGRAM_PDA
	default_hardware = list(
		/obj/item/stock_parts/computer/network_card,
		/obj/item/stock_parts/computer/hard_drive/small,
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/card_slot/broadcaster,
		/obj/item/stock_parts/computer/battery_module,
		/obj/item/stock_parts/computer/tesla_link,
	)

	default_programs = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
	)



