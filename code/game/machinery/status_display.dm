#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Small Fonts"
#define SCROLL_SPEED 2

// Status display
// (formerly Countdown timer display)

// Use to show shuttle ETA/ETD times
// Alert status
// And arbitrary messages set by comms computer
/obj/machinery/status_display
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	name = "status display"
	anchored = TRUE
	density = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	circuit = /obj/item/circuitboard/status_display
	var/mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = Alert picture
					// 4 = Supply shuttle timer

	var/picture_state	// Icon_state of alert picture
	var/message1 = ""	// Message line 1
	var/message2 = ""	// Message line 2
	var/index1			// Display index for scrolling messages or 0 if non-scrolling
	var/index2
	var/picture = null

	var/frequency = 1435	// Radio frequency

	var/friendc = 0			// Track if Friend Computer mode
	var/ignore_friendc = 0

	maptext_height = 26
	maptext_width = 32
	maptext_y = -1

	var/const/CHARS_PER_LINE = 5
	var/const/STATUS_DISPLAY_BLANK = 0
	var/const/STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME = 1
	var/const/STATUS_DISPLAY_MESSAGE = 2
	var/const/STATUS_DISPLAY_ALERT = 3
	var/const/STATUS_DISPLAY_TIME = 4
	var/const/STATUS_DISPLAY_CUSTOM = 99

	var/seclevel = "green"

/obj/machinery/status_display/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/status_display/attackby(I as obj, user as mob)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		attack_hand(user)
	return

// Register for radio system
/obj/machinery/status_display/Initialize(mapload)
	. = ..()
	if(radio_controller)
		radio_controller.add_object(src, frequency)

// Timed process
/obj/machinery/status_display/process(delta_time)
	if(machine_stat & NOPOWER)
		remove_display()
		return
	update()

/obj/machinery/status_display/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		..(severity)
		return
	set_picture("ai_bsod")
	..(severity)

// Set what is displayed
/obj/machinery/status_display/proc/update()
	remove_display()
	if(friendc && !ignore_friendc)
		set_picture("ai_friend")
		return 1

	switch(mode)
		if(STATUS_DISPLAY_BLANK)	// Blank
			return 1
		if(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)	// Emergency shuttle timer
			if(!SSemergencyshuttle)
				message1 = "-ETA-"
				message2 = "Never"	// You're here forever.
				return 1
			if(SSemergencyshuttle.waiting_to_leave())
				message1 = "-ETD-"
				if(SSemergencyshuttle.shuttle.is_launching())
					message2 = "Launch"
				else
					message2 = get_shuttle_timer_departure()
					if(length(message2) > CHARS_PER_LINE)
						message2 = "Error"
				update_display(message1, message2)
			else if(SSemergencyshuttle.has_eta())
				message1 = "-ETA-"
				message2 = get_shuttle_timer_arrival()
				if(length(message2) > CHARS_PER_LINE)
					message2 = "Error"
				update_display(message1, message2)
			return 1
		if(STATUS_DISPLAY_MESSAGE)	// Custom messages
			var/line1
			var/line2

			if(!index1)
				line1 = message1
			else
				line1 = copytext(message1+"|"+message1, index1, index1+CHARS_PER_LINE)
				var/message1_len = length(message1)
				index1 += SCROLL_SPEED
				if(index1 > message1_len)
					index1 -= message1_len

			if(!index2)
				line2 = message2
			else
				line2 = copytext(message2+"|"+message2, index2, index2+CHARS_PER_LINE)
				var/message2_len = length(message2)
				index2 += SCROLL_SPEED
				if(index2 > message2_len)
					index2 -= message2_len
			update_display(line1, line2)
			return 1
		if(STATUS_DISPLAY_ALERT)
			display_alert(seclevel)
			return 1
		if(STATUS_DISPLAY_TIME)
			message1 = "TIME"
			message2 = stationtime2text()
			update_display(message1, message2)
			return 1
	return 0

/obj/machinery/status_display/examine(mob/user)
	. = ..(user)
	if(mode != STATUS_DISPLAY_BLANK && mode != STATUS_DISPLAY_ALERT)
		to_chat(user, "The display says:<br>\t[sanitize(message1)]<br>\t[sanitize(message2)]")

/obj/machinery/status_display/proc/set_message(m1, m2)
	if(m1)
		index1 = (length(m1) > CHARS_PER_LINE)
		message1 = m1
	else
		message1 = ""
		index1 = 0

	if(m2)
		index2 = (length(m2) > CHARS_PER_LINE)
		message2 = m2
	else
		message2 = ""
		index2 = 0

/obj/machinery/status_display/proc/display_alert(newlevel)
	remove_display()
	if(seclevel != newlevel)
		seclevel = newlevel
	switch(seclevel)
		if("green")	set_light(l_range = 2, l_power = 0.25, l_color = "#00ff00")
		if("yellow")	set_light(l_range = 2, l_power = 0.25, l_color = "#ffff00")
		if("violet")	set_light(l_range = 2, l_power = 0.25, l_color = "#9933ff")
		if("orange")	set_light(l_range = 2, l_power = 0.25, l_color = "#ff9900")
		if("blue")	set_light(l_range = 2, l_power = 0.25, l_color = "#1024A9")
		if("red")	set_light(l_range = 4, l_power = 0.9, l_color = "#ff0000")
		if("delta")	set_light(l_range = 4, l_power = 0.9, l_color = "#FF6633")
	set_picture("status_display_[seclevel]")

/obj/machinery/status_display/proc/set_picture(state)
	remove_display()
	if(!picture || picture_state != state)
		picture_state = state
		picture = image('icons/obj/status_display.dmi', icon_state=picture_state)
	add_overlay(picture)

/obj/machinery/status_display/proc/update_display(line1, line2)
	line1 = uppertext(line1)
	line2 = uppertext(line2)
	var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/machinery/status_display/proc/get_shuttle_timer_arrival()
	if(!SSemergencyshuttle)
		return "Error"
	var/timeleft = SSemergencyshuttle.estimate_arrival_time()
	if(timeleft < 0)
		return ""
	return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"

/obj/machinery/status_display/proc/get_shuttle_timer_departure()
	if(!SSemergencyshuttle)
		return "Error"
	var/timeleft = SSemergencyshuttle.estimate_launch_time()
	if(timeleft < 0)
		return ""
	return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"

/obj/machinery/status_display/proc/get_supply_shuttle_timer()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if(!shuttle)
		return "Error"

	if(shuttle.has_arrive_time())
		var/timeleft = round((shuttle.arrive_time - world.time) / 10,1)
		if(timeleft < 0)
			return "Late"
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/obj/machinery/status_display/proc/remove_display()
	if(overlays.len)
		cut_overlays()
	if(maptext)
		maptext = ""

/obj/machinery/status_display/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("blank")
			mode = STATUS_DISPLAY_BLANK

		if("shuttle")
			mode = STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME

		if("message")
			mode = STATUS_DISPLAY_MESSAGE
			set_message(signal.data["msg1"], signal.data["msg2"])

		if("alert")
			mode = STATUS_DISPLAY_ALERT
			set_picture(signal.data["picture_state"])

		if("time")
			mode = STATUS_DISPLAY_TIME
	update()

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED
