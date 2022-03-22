/datum/wires/mines
	randomize = TRUE
	wire_count = 6
	holder_type = /obj/effect/mine
	proper_name = "Explosive Wires"

/datum/wires/mines/New(atom/_holder)
	wires = list(WIRE_EXPLODE, WIRE_EXPLODE_DELAY, WIRE_DISARM, WIRE_BADDISARM)
	return ..()

/datum/wires/mines/get_status()
	. = ..()
	. += "\[Warning: detonation may occur even with proper equipment.]"

/datum/wires/mines/proc/explode()
	return

/datum/wires/mines/on_cut(wire, mend)
	var/obj/effect/mine/C = holder

	switch(wire)
		if(WIRE_EXPLODE)
			C.visible_message("[icon2html(thing = C, target = world)] *BEEE-*", "[icon2html(thing = C, target = world)] *BEEE-*")
			C.explode()

		if(WIRE_EXPLODE_DELAY)
			C.visible_message("[icon2html(thing = C, target = world)] *BEEE-*", "[icon2html(thing = C, target = world)] *BEEE-*")
			C.explode()

		if(WIRE_DISARM)
			C.visible_message("[icon2html(thing = C, target = world)] *click!*", "[icon2html(thing = C, target = world)] *click!*")
			new C.mineitemtype(get_turf(C))
			spawn(0)
				qdel(C)

		if(WIRE_BADDISARM)
			C.visible_message("[icon2html(thing = C, target = world)] *BEEPBEEPBEEP*", "[icon2html(thing = C, target = world)] *BEEPBEEPBEEP*")
			spawn(20)
				C.explode()
	..()

/datum/wires/mines/on_pulse(wire)
	var/obj/effect/mine/C = holder
	if(is_cut(wire))
		return
	switch(wire)
		if(WIRE_EXPLODE)
			C.visible_message("[icon2html(thing = C, target = world)] *beep*", "[icon2html(thing = C, target = world)] *beep*")

		if(WIRE_EXPLODE_DELAY)
			C.visible_message("[icon2html(thing = C, target = world)] *BEEPBEEPBEEP*", "[icon2html(thing = C, target = world)] *BEEPBEEPBEEP*")
			spawn(20)
				C.explode()

		if(WIRE_DISARM)
			C.visible_message("[icon2html(thing = C, target = world)] *ping*", "[icon2html(thing = C, target = world)] *ping*")

		if(WIRE_BADDISARM)
			C.visible_message("[icon2html(thing = C, target = world)] *ping*", "[icon2html(thing = C, target = world)] *ping*")
	..()

/datum/wires/mines/interactable(mob/user)
	var/obj/effect/mine/M = holder
	return M.panel_open
