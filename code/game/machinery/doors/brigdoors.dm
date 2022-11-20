#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Small Fonts"
#define MAX_TIMER 36000

#define PRESET_SHORT 1 MINUTES
#define PRESET_MEDIUM 5 MINUTES
#define PRESET_LONG 10 MINUTES

///////////////////////////////////////////////////////////////////////////////////////////////
// Brig Door control displays.
//  Description: This is a controls the timer for the brig doors, displays the timer on itself and
//               has a popup window when used, allowing to set the timer.
//  Code Notes: Combination of old brigdoor.dm code from rev4407 and the status_display.dm code
//  Date: 01/September/2010
//  Programmer: Veryinky
/////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/door_timer
	name = "Door Timer"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	desc = "A remote control for a door."
	req_access = list(access_brig)
	anchored = TRUE //Can't pick it up
	density = FALSE //Can walk through it.
	var/id = null   //Id of door it controls.

	var/activation_time = 0
	var/timer_duration = 0

	var/timing = FALSE //Is the timer ticking or not.
	///List of weakrefs to nearby doors
	var/list/doors = list()
	///List of weakrefs to nearby flashers
	var/list/flashers = list()
	///List of weakrefs to nearby closets
	var/list/closets = list()

	maptext_height = 26
	maptext_width = 32
	maptext_y = -1

/obj/machinery/door_timer/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/door_timer/LateInitialize()
	. = ..()
	if(id != null)
		for(var/obj/machinery/door/window/brigdoor/M in urange(20, src))
			if (M.id == id)
				doors += WEAKREF(M)

		for(var/obj/machinery/flasher/F in urange(20, src))
			if(F.id == id)
				flashers += WEAKREF(F)

		for(var/obj/structure/closet/secure_closet/brig/C in urange(20, src))
			if(C.id == id)
				closets += WEAKREF(C)

	if(!length(doors) && !length(flashers) && length(closets))
		machine_stat |= BROKEN
	update_appearance()

//Main door timer loop, if it's timing and time is >0 reduce time by 1.
// if it's less than 0, open door, reset timer
// update the door_timer window and the icon
/obj/machinery/door_timer/process(delta_time)
	if(machine_stat & (NOPOWER|BROKEN))
		return

	if(timing)
		if(REALTIMEOFDAY - activation_time >= timer_duration)
			timer_end() //Open doors, reset timer, clear status screen
		update_icon()

// open/closedoor checks if door_timer has power, if so it checks if the
// linked door is open/closed (by density) then opens it/closes it.
/obj/machinery/door_timer/proc/timer_start()
	if(machine_stat & (NOPOWER|BROKEN))
		return FALSE

	activation_time = REALTIMEOFDAY
	timing = TRUE

	for(var/datum/weakref/door_ref as anything in doors)
		var/obj/machinery/door/window/brigdoor/door = door_ref.resolve()
		if(!door)
			doors -= door_ref
			continue
		if(door.density)
			continue
		INVOKE_ASYNC(door, /obj/machinery/door/window/brigdoor.proc/close)

	for(var/datum/weakref/closet_ref as anything in closets)
		var/obj/structure/closet/secure_closet/brig/closet = closet_ref.resolve()
		if(!closet)
			closets -= closet_ref
			continue
		if(closet.broken)
			continue
		if(closet.opened && !closet.close())
			continue
		closet.locked = TRUE
		closet.update_appearance()
	return TRUE

///Opens and unlocks doors, power check
/obj/machinery/door_timer/proc/timer_end(forced = FALSE)
	if(machine_stat & (NOPOWER|BROKEN))
		return FALSE

	if(!forced)
		GLOB.global_announcer.autosay("Timer has expired. Releasing prisoner.", "[src.name]", "Security")

	timing = FALSE
	activation_time = null
	set_timer(0)
	update_icon()

	for(var/datum/weakref/door_ref as anything in doors)
		var/obj/machinery/door/window/brigdoor/door = door_ref.resolve()
		if(!door)
			doors -=  door_ref
			continue
		if(!door.density)
			continue
		INVOKE_ASYNC(door, /obj/machinery/door/window/brigdoor.proc/open)

	for(var/datum/weakref/closet_ref as anything in closets)
		var/obj/structure/closet/secure_closet/brig/closet = closet_ref.resolve()
		if(!closet)
			closets -= closet_ref
			continue
		if(closet.broken)
			continue
		if(closet.opened)
			continue
		closet.locked = FALSE
		closet.update_appearance()

	return TRUE

/obj/machinery/door_timer/proc/time_left(seconds = FALSE)
	. = max(0, timer_duration - (activation_time ? (REALTIMEOFDAY - activation_time) : 0))
	if(seconds)
		. /= 10

/obj/machinery/door_timer/proc/set_timer(value)
	var/new_time = clamp(value, 0, MAX_TIMER)
	. = new_time == timer_duration //return 1 on no change
	timer_duration = new_time
	if(timer_duration && activation_time && timing) // Setting it while active will reset the activation time
		activation_time = REALTIMEOFDAY

/obj/machinery/door_timer/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/door_timer/attack_hand(mob/user)
	if(..())
		return TRUE
	ui_interact(user)

//icon update function
// if NOPOWER, display blank
// if BROKEN, display blue screen of death icon AI uses
// if timing=true, run update display function
/obj/machinery/door_timer/update_icon()
	. = ..()
	if(machine_stat & (NOPOWER))
		return

	if(machine_stat & (BROKEN))
		set_picture("ai_bsod")
		return

	if(timing)
		var/disp1 = id
		var/time_left = time_left(seconds = TRUE)
		var/disp2 = "[add_leading(num2text((time_left / 60) % 60), 2, "0")]:[add_leading(num2text(time_left % 60), 2, "0")]"
		if(length(disp2) > CHARS_PER_LINE)
			disp2 = "Error"
		update_display(disp1, disp2)
	else
		if(maptext)
			maptext = ""
	return

///Adds an icon in case the screen is broken/off, stolen from status_display.dm
/obj/machinery/door_timer/proc/set_picture(state)
	if(maptext)
		maptext = ""
	cut_overlays()
	add_overlay(mutable_appearance('icons/obj/status_display.dmi', state))

//Checks to see if there's 1 line or 2, adds text-icons-numbers/letters over display
// Stolen from status_display
/obj/machinery/door_timer/proc/update_display(line1, line2)
	line1 = uppertext(line1)
	line2 = uppertext(line2)
	var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/machinery/door_timer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BrigTimer", name)
		ui.open()

/obj/machinery/door_timer/ui_data()
	var/list/data = list()
	var/time_left = time_left(seconds = TRUE)
	data["seconds"] = round(time_left % 60)
	data["minutes"] = round((time_left - data["seconds"]) / 60)
	data["timing"] = timing
	data["flash_charging"] = FALSE
	for(var/datum/weakref/flash_ref as anything in flashers)
		var/obj/machinery/flasher/flasher = flash_ref.resolve()
		if(!flasher)
			flashers -= flash_ref
			continue
		if(flasher.last_flash && (flasher.last_flash + 15 SECONDS) > world.time)
			data["flash_charging"] = TRUE
			break
	return data

/obj/machinery/door_timer/ui_act(action, params)
	if(..())
		return

	. = TRUE

	if(!allowed(usr))
		to_chat(usr, SPAN_WARNING("Access denied."))
		return FALSE

	switch(action)
		if("time")
			var/value = text2num(params["adjust"])
			if(value)
				. = set_timer(time_left()+value)
				investigate_log("[key_name(usr)] modified the timer by [value/10] seconds for cell [id], currently [time_left(seconds = TRUE)]", INVESTIGATE_RECORDS)
				log_attack("[src] modified the timer by [value/10] seconds for cell [id], currently [time_left(seconds = TRUE)]")
		if("start")
			timer_start()
			investigate_log("[key_name(usr)] has started [id]'s timer of [time_left(seconds = TRUE)] seconds", INVESTIGATE_RECORDS)
			log_attack("has started [id]'s timer of [time_left(seconds = TRUE)] seconds")
		if("stop")
			timer_end(forced = TRUE)
			investigate_log("[key_name(usr)] has stopped [id]'s timer of [time_left(seconds = TRUE)] seconds", INVESTIGATE_RECORDS)
			log_attack("[key_name(usr)] has stopped [id]'s timer of [time_left(seconds = TRUE)] seconds")
		if("flash")
			investigate_log("[key_name(usr)] has flashed cell [id]", INVESTIGATE_RECORDS)
			log_attack("[key_name(usr)] has flashed cell [id]")
			for(var/datum/weakref/flash_ref as anything in flashers)
				var/obj/machinery/flasher/flasher = flash_ref.resolve()
				if(!flasher)
					flashers -= flash_ref
					continue
				flasher.flash()
		if("preset")
			var/preset = params["preset"]
			var/preset_time = time_left()
			switch(preset)
				if("short")
					preset_time = PRESET_SHORT
				if("medium")
					preset_time = PRESET_MEDIUM
				if("long")
					preset_time = PRESET_LONG
			. = set_timer(preset_time)
			investigate_log("[key_name(usr)] set cell [id]'s timer to [preset_time/10] seconds", INVESTIGATE_RECORDS)
			log_attack("set cell [id]'s timer to [preset_time/10] seconds")
			if(timing)
				activation_time = REALTIMEOFDAY
		else
			. = FALSE


/obj/machinery/door_timer/cell_1
	name = "Cell 1"
	id = "Cell 1"

/obj/machinery/door_timer/cell_2
	name = "Cell 2"
	id = "Cell 2"

/obj/machinery/door_timer/cell_3
	name = "Cell 3"
	id = "Cell 3"

/obj/machinery/door_timer/cell_4
	name = "Cell 4"
	id = "Cell 4"

/obj/machinery/door_timer/cell_5
	name = "Cell 5"
	id = "Cell 5"

/obj/machinery/door_timer/cell_6
	name = "Cell 6"
	id = "Cell 6"

/obj/machinery/door_timer/tactical_pet_storage
	name = "Tactical Pet Storage"
	id = "tactical_pet_storage"
	desc = "Opens and Closes on a timer. This one seals away a tactical boost in morale."

#undef PRESET_SHORT
#undef PRESET_MEDIUM
#undef PRESET_LONG

#undef MAX_TIMER
#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef CHARS_PER_LINE
