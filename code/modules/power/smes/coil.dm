/**
 * smes coils - used in buildable SMES to determine primary properties
 */
/obj/item/smes_coil
	name = "superconductive magnetic coil"
	desc = "The standard superconductive magnetic coil, with average capacity and I/O rating."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"			// Just few icons patched together. If someone wants to make better icon, feel free to do so!
	w_class = ITEMSIZE_LARGE 						// It's LARGE (backpack size)
	/// capacity in kWh
	var/charge_capacity = SMES_COIL_STORAGE_BASIC
	/// IO in kW
	var/flow_capacity = SMES_COIL_FLOW_BASIC

/obj/item/smes_coil/weak
	name = "basic superconductive magnetic coil"
	desc = "A cheaper model of superconductive magnetic coil. Its capacity and I/O rating are considerably lower."
	charge_capacity = SMES_COIL_STORAGE_WEAK
	flow_capacity = SMES_COIL_FLOW_WEAK

/obj/item/smes_coil/super_capacity
	name = "superconductive capacitance coil"
	desc = "A specialised type of superconductive magnetic coil with a significantly stronger containment field, allowing for larger power storage. Its IO rating is much lower, however."
	charge_capacity = SMES_COIL_STORAGE_CAPACITANCE
	flow_capacity = SMES_COIL_FLOW_CAPACITANCE

/obj/item/smes_coil/super_io
	name = "superconductive transmission coil"
	desc = "A specialised type of superconductive magnetic coil with reduced storage capabilites but vastly improved power transmission capabilities, making it useful in systems which require large throughput."
	charge_capacity = SMES_COIL_STORAGE_TRANSMISSION
	flow_capacity = SMES_COIL_FLOW_TRANSMISSION
