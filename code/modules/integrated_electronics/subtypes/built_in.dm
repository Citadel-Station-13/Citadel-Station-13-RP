/obj/item/integrated_circuit/built_in
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/integrated_electronics/electronic_setups.dmi'
	icon_state = "template"
	size = -1
	w_class = ITEMSIZE_TINY
	removable = FALSE

/obj/item/integrated_circuit/built_in/device_input
	name = "assembly input"
	desc = "A built in chip for handling pulses from attached assembly items."
	complexity = 0
	activators = list("on pulsed" = IC_PINTYPE_PULSE_OUT)

/obj/item/integrated_circuit/built_in/device_input/do_work()
	activate_pin(1)

/obj/item/integrated_circuit/built_in/device_output
	name = "assembly out"
	desc = "A built in chip for pulsing attached assembly items."
	complexity = 0
	activators = list("pulse attached" = IC_PINTYPE_PULSE_IN)

/obj/item/integrated_circuit/built_in/device_output/do_work()
	if(istype(assembly, /obj/item/electronic_assembly/device))
		var/obj/item/electronic_assembly/device/device = assembly
		device.holder.pulse()

// Triggered when clothing assembly's hud button is clicked (or used inhand).
/obj/item/integrated_circuit/built_in/action_button
	name = "external trigger circuit"
	desc = "A built in chip that outputs a pulse when an external control event occurs."
	extended_desc = "This outputs a pulse if the assembly's HUD button is clicked while the assembly is closed."
	complexity = 0
	activators = list("on activation" = IC_PINTYPE_PULSE_OUT)

/obj/item/integrated_circuit/built_in/action_button/do_work()
	activate_pin(1)

/obj/item/integrated_circuit/built_in/self_sensor
	name = "self sensor"
	desc = "This chip identifies the user."
	extended_desc = "An integrated sensor that allows integrated circuitry to directly interfere with the wearer of the device."
	complexity = 0
	outputs = list("user" = IC_PINTYPE_REF)
	activators = list("set" = IC_PINTYPE_PULSE_IN, "on activation" = IC_PINTYPE_PULSE_OUT)

/obj/item/integrated_circuit/built_in/self_sensor/do_work()
	set_pin_data(IC_OUTPUT, 1, assembly.loc.loc)
	push_data()
	activate_pin(2)
	. = ..()

