/obj/item/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MAT_STEEL = 500, MAT_GLASS = 50)

	wires = WIRE_PULSE

	secured = FALSE

	drop_sound = 'sound/items/handling/component_drop.ogg'
	pickup_sound =  'sound/items/handling/component_pickup.ogg'
	var/timing = FALSE
	var/time = 10
	var/saved_time = 10
	var/loop = FALSE
	var/hearing_range = 3


/obj/item/assembly/timer/activate()
	if(!..())
		return FALSE //Cooldown check
	timing = !timing
	update_appearance()
	return TRUE

/obj/item/assembly/timer/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		timing = FALSE
		STOP_PROCESSING(SSobj, src)
	update_appearance()
	return secured

/obj/item/assembly/timer/proc/timer_end()
	if(!secured)
		return FALSE
	pulse(FALSE)
	audible_message(SPAN_INFOPLAIN("[icon2html(src, hearers(src))] *beep* *beep* *beep*"), null, hearing_range)
	for(var/mob/hearing_mob in get_hearers_in_view(hearing_range, src))
		hearing_mob.playsound_local(get_turf(src), 'sound/machines/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
	if(loop)
		timing = TRUE
	update_appearance()

/obj/item/assembly/timer/process(delta_time)
	if(!timing)
		return
	time -= delta_time
	if(time <= 0)
		timing = FALSE
		timer_end()
		time = saved_time

/obj/item/assembly/timer/update_appearance()
	. = ..()
	holder?.update_appearance()

/obj/item/assembly/timer/update_overlays()
	. = ..()
	attached_overlays = list()
	if(timing)
		. += "timer_timing"
		attached_overlays += "timer_timing"

/obj/item/assembly/timer/ui_interact(mob/user, datum/tgui/ui)
	if(!secured)
		to_chat(user, SPAN_WARNING("[src] is unsecured!"))
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AssemblyTimer", name)
		ui.open()

/obj/item/assembly/timer/ui_data(mob/user)
	var/list/data = ..()
	var/time_left = time
	data["seconds"] = round(time_left % 60)
	data["minutes"] = round((time_left - data["seconds"]) / 60)
	data["timing"] = timing
	data["loop"] = loop
	return data

/obj/item/assembly/timer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("time")
			timing = !timing
			//if(timing && istype(holder, /obj/item/transfer_valve))
				//log_bomber(usr, "activated a", src, "attachment on [holder]")
			update_appearance()
			. = TRUE
		if("repeat")
			loop = !loop
			. = TRUE
		if("input")
			var/value = text2num(params["adjust"])
			if(value)
				value = round(time + value)
				time = clamp(value, 1, 600)
				saved_time = time
				. = TRUE
