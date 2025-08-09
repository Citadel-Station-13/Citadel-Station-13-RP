/datum/wires/hardsuit
	randomize = TRUE
	holder_type = /obj/item/hardsuit
	wire_count = 5

/datum/wires/hardsuit/New(atom/_holder)
	wires = list(WIRE_RIG_SECURITY, WIRE_RIG_AI_OVERRIDE, WIRE_RIG_SYSTEM_CONTROL, WIRE_RIG_INTERFACE_LOCK, WIRE_RIG_INTERFACE_SHOCK)
	return ..()
/*
 * hardsuit security can be snipped to disable ID access checks on hardsuit.
 * hardsuit AI override can be pulsed to toggle whether or not the AI can take control of the suit.
 * System control can be pulsed to toggle some malfunctions.
 * Interface lock can be pulsed to toggle whether or not the interface can be accessed.
 */

/datum/wires/hardsuit/on_cut(wire, mend)
	var/obj/item/hardsuit/hardsuit = holder
	switch(wire)
		if(WIRE_RIG_SECURITY)
			if(mend)
				hardsuit.req_access = initial(hardsuit.req_access)
				hardsuit.req_one_access = initial(hardsuit.req_one_access)
		if(WIRE_RIG_SYSTEM_CONTROL)
			if(!mend)
				hardsuit.shock(usr,100) // Intended to keep players from trying to mend in the middle of combat. Second way of getting shocked as pulsing this wire ALSO shocks you.
			else if(mend)
				hardsuit.malfunctioning = 0
				hardsuit.malfunction_delay = 0
		if(WIRE_RIG_INTERFACE_SHOCK)
			hardsuit.electrified = mend ? 0 : -1
			hardsuit.shock(usr,100)

/datum/wires/hardsuit/on_pulse(wire)
	var/obj/item/hardsuit/hardsuit = holder
	switch(wire)
		if(WIRE_RIG_SECURITY)
			hardsuit.security_check_enabled = !hardsuit.security_check_enabled
			hardsuit.visible_message("\The [hardsuit] twitches as several suit locks [hardsuit.security_check_enabled?"close":"open"].")
		if(WIRE_RIG_AI_OVERRIDE)
			hardsuit.ai_override_enabled = !hardsuit.ai_override_enabled
			hardsuit.visible_message("A small red light on [hardsuit] [hardsuit.ai_override_enabled?"goes dead":"flickers on"].")
		if(WIRE_RIG_SYSTEM_CONTROL)
			hardsuit.malfunctioning += 10
			if(hardsuit.malfunction_delay <= 0)
				hardsuit.malfunction_delay = 20
			hardsuit.shock(usr,100)
			hardsuit.visible_message("\The [hardsuit] beeps stridently as a surge of power runs through it.") // Hints to the fact that if you pulse this while wearing it you get zappoed.
		if(WIRE_RIG_INTERFACE_LOCK)
			hardsuit.interface_locked = !hardsuit.interface_locked
			hardsuit.visible_message("\The [hardsuit] clicks audibly as the software interface [hardsuit.interface_locked?"darkens":"brightens"].")
		if(WIRE_RIG_INTERFACE_SHOCK)
			if(hardsuit.electrified != -1)
				hardsuit.electrified = 30
			hardsuit.shock(usr,100)

/datum/wires/hardsuit/interactable(mob/user)
	var/obj/item/hardsuit/hardsuit = holder
	if(hardsuit.open)
		return TRUE
	return FALSE
