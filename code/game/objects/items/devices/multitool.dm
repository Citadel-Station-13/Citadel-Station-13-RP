/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/multitool
	name = "multitool"
	desc = "Used for pulsing wires to test which to cut. Not recommended by doctors."
	description_info = "You can use this on airlocks or APCs to try to hack them without cutting wires."
	icon = 'icons/obj/device.dmi'
	icon_state = "multitool"
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throw_force = 5.0
	throw_range = 15
	throw_speed = 3
	drop_sound = 'sound/items/drop/multitool.ogg'
	pickup_sound = 'sound/items/pickup/multitool.ogg'

	matter = list(MAT_STEEL = 50, MAT_GLASS = 20)

	var/mode_index = 1
	var/toolmode = MULTITOOL_MODE_STANDARD
	var/list/modes = list(MULTITOOL_MODE_STANDARD, MULTITOOL_MODE_INTCIRCUITS)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	var/obj/machinery/telecomms/buffer // simple machine buffer for device linkage
	var/obj/machinery/clonepod/connecting //same for cryopod linkage
	var/obj/machinery/connectable	//Used to connect machinery.
	var/datum/weakref_wiring //Used to store weak references for integrated circuitry. This is now the Omnitool.
	var/colorable = 1
	var/color_overlay = null
	tool_speed = 1
	tool_behaviour = TOOL_MULTITOOL

/obj/item/multitool/Initialize(mapload)
	. = ..()
	if(colorable)
		switch(pick("red","green","yellow"))
			if ("red")
				overlays += "multi_r"
			if ("green")
				overlays += "multi_g"
			if ("yellow")
				return
		update_icon()

/obj/item/multitool/attack_self(mob/living/user)
	var/choice = alert("What do you want to do with \the [src]?","Multitool Menu", "Switch Mode", "Clear Buffers", "Cancel")
	switch(choice)
		if("Cancel")
			to_chat(user,"<span class='notice'>You lower \the [src].</span>")
			return
		if("Clear Buffers")
			to_chat(user,"<span class='notice'>You clear \the [src]'s memory.</span>")
			buffer = null
			connecting = null
			connectable = null
			weakref_wiring = null
			accepting_refs = 0
			if(toolmode == MULTITOOL_MODE_INTCIRCUITS)
				accepting_refs = 1
		if("Switch Mode")
			mode_switch(user)

	update_icon()

	return ..()

/obj/item/multitool/is_multitool()
	return TRUE

/obj/item/multitool/proc/mode_switch(mob/living/user)
	if(++mode_index > modes.len) mode_index = 1

	else
		mode_index++

	toolmode = modes[mode_index]
	to_chat(user,"<span class='notice'>\The [src] is now set to [toolmode].</span>")

	accepting_refs = (toolmode == MULTITOOL_MODE_INTCIRCUITS)

	return

/obj/item/multitool/cyborg
	name = "multitool"
	desc = "Optimised and stripped-down version of a regular multitool."
	tool_speed = 0.5
	colorable = 0

/datum/category_item/catalogue/anomalous/precursor_a/alien_multitool
	name = "Precursor Alpha Object - Pulse Tool"
	desc = "This ancient object appears to be an electrical tool. \
	It has a simple mechanism at the handle, which will cause a pulse of \
	energy to be emitted from the head of the tool. This can be used on a \
	conductive object such as a wire, in order to send a pulse signal through it.\
	<br><br>\
	These qualities make this object somewhat similar in purpose to the common \
	multitool, and can probably be used for tasks such as direct interfacing with \
	an airlock, if one knows how."
	value = CATALOGUER_REWARD_EASY

/obj/item/multitool/alien
	name = "alien multitool"
	desc = "An omni-technological interface."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_multitool)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "multitool"
	tool_speed = 0.1
	origin_tech = list(TECH_MAGNET = 5, TECH_ENGINEERING = 5)
	colorable = 0

//Colored Variants
/obj/item/multitool/red
	color_overlay = "multi_r"

/obj/item/multitool/green
	color_overlay = "multi_g"
