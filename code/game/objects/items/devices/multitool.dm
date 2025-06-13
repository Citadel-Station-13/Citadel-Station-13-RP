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
	damage_force = 5.0
	w_class = WEIGHT_CLASS_SMALL
	throw_force = 5.0
	throw_range = 15
	throw_speed = 3
	drop_sound = 'sound/items/drop/multitool.ogg'
	pickup_sound = 'sound/items/pickup/multitool.ogg'

	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 20)

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
				add_overlay("multi_r")
			if ("green")
				add_overlay("multi_g")
			if ("yellow")
				return
		update_icon()

/obj/item/multitool/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
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

/obj/item/multitool/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(is_holosphere_shell(target) && clickchain.using_intent == INTENT_HELP)
		var/mob/living/simple_mob/holosphere_shell/shell = target
		// can't revive them if they are not dead
		if(shell.stat != DEAD)
			to_chat(clickchain.performer, SPAN_NOTICE("[target] does not need to be rebooted!"))
			return CLICKCHAIN_DID_SOMETHING
		// can't revive them if they are not full hp
		if(shell.health == shell.maxHealth)
			to_chat(clickchain.performer, SPAN_NOTICE("You begin rebooting [target] using \the [src]"))
			if(do_after(clickchain.performer, 10 SECONDS))
				// make sure they're still dead and full hp
				if(shell.stat != DEAD || shell.health != shell.maxHealth)
					to_chat(clickchain.performer, SPAN_NOTICE("[target] is no longer in a condition where you can reboot them."))
					return CLICKCHAIN_DID_SOMETHING
				// revive the holosphere shell
				visible_message(SPAN_NOTICE("[clickchain.performer] successfully reboots [target] using \the [src]."))
				shell.revive(TRUE, TRUE, restore_nutrition = FALSE)
				return CLICKCHAIN_DID_SOMETHING
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

/obj/item/multitool/clockwork
	name = "clockwork multitool"
	desc = "A slender brass device, adorned with three prongs pulsing with energy, a faintly glowing red gem, and a screen in the shape of an eye."
	icon = 'icons/obj/clockwork.dmi'
	icon_state = "multitool"
	tool_speed = 0.1
	colorable = 0

/obj/item/multitool/clockwork/examine(mob/user, dist)
	. = ..()
	. += SPAN_NZCRENTR("The multitool seems to flash and pulse with impatience, the 'eye' appearing to be both bored and frustrated.")

//Colored Variants
/obj/item/multitool/red
	color_overlay = "multi_r"

/obj/item/multitool/green
	color_overlay = "multi_g"

/obj/item/multitool/crystal
	name = "crystalline multitool"
	desc = "A crystalline energy patterning tool of an alien make."
	icon_state = "crystal_multitool"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	materials_base = list(MATERIAL_CRYSTAL = 1250)

/obj/item/multitool/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)
