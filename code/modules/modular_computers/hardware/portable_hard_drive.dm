// These are basically USB data sticks and may be used to transfer files between devices
/obj/item/computer_hardware/hard_drive/portable
	name = "basic data crystal"
	desc = "Small crystal with imprinted photonic circuits that can be used to store data. Its capacity is 16 GQ."
	power_usage = 10
	icon_state = "flashdrive_basic"
	origin_tech = list(TECH_DATA = 1)
	w_class = WEIGHT_CLASS_TINY
	critical = FALSE
	max_capacity = 16
	device_type = MC_SDD

/obj/item/computer_hardware/hard_drive/portable/on_remove(obj/item/modular_computer/MC, mob/user)
	return //this is a floppy disk, let's not shut the computer down when it gets pulled out.

/obj/item/computer_hardware/hard_drive/portable/install_default_programs()
	return // Empty by default

/obj/item/computer_hardware/hard_drive/portable/advanced
	name = "advanced data crystal"
	desc = "Small crystal with imprinted high-density photonic circuits that can be used to store data. Its capacity is 64 GQ."
	power_usage = 20
	icon_state = "flashdrive_advanced"
	max_capacity = 64
	origin_tech = list(TECH_DATA = 2)

/obj/item/computer_hardware/hard_drive/portable/super
	name = "super data crystal"
	desc = "Small crystal with imprinted ultra-density photonic circuits that can be used to store data. Its capacity is 256 GQ."
	power_usage = 40
	icon_state = "flashdrive_super"
	max_capacity = 256
	origin_tech = list(TECH_DATA = 4)
