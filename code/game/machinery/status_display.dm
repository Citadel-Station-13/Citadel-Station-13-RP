// Status display

#define MAX_STATIC_WIDTH 22
#define FONT_STYLE "12pt 'TinyUnicode'"
#define SCROLL_RATE (0.04 SECONDS) // time per pixel
#define SCROLL_PADDING 2 // how many pixels we chop to make a smooth loop
#define LINE1_X 1
#define LINE1_Y -4
#define LINE2_X 1
#define LINE2_Y -11
GLOBAL_DATUM_INIT(status_font, /datum/font, new /datum/font/tiny_unicode/size_12pt())

/// Status display which can show images and scrolling text.
/obj/machinery/status_display
	name = "status display"
	desc = null
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = TRUE
	density = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	circuit = /obj/item/circuitboard/status_display


	// We store overlays as keys, so multiple displays can use the same object safely
	/// String key we use to index the first effect overlay displayed on us
	var/message_key_1
	/// String key we use to index the second effect overlay displayed on us
	var/message_key_2
	var/current_picture	= ""
	var/current_mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = Alert picture
					// 4 = Supply shuttle timer
	var/message1 = ""	// Message line 1
	var/message2 = ""	// Message line 2


	/// Normal text color
	var/text_color = "#22ccff"
	/// Color for headers, eg. "- ETA -"
	var/header_text_color = "#5d5dfc"

	var/frequency = FREQ_STATUS_DISPLAYS	// Radio frequency

	var/friendc = FALSE
	var/last_picture  // For when Friend Computer mode is undone

	var/seclevel = "green"

// Register for radio system
/obj/machinery/status_display/Initialize(mapload, ndir, building)
	. = ..()
	update_appearance()
	if(radio_controller)
		radio_controller.add_object(src, frequency)

/obj/machinery/status_display/Destroy()
	remove_messages()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/status_display/attackby(I as obj, user as mob)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		attack_hand(user)
	return

/// Immediately change the display to the given picture.
/obj/machinery/status_display/proc/set_picture(state)
	if(state != current_picture)
		current_picture = state

	update_appearance()

/// Immediately change the display to the given two lines.
/obj/machinery/status_display/proc/set_messages(line1, line2)
	line1 = uppertext(line1)
	line2 = uppertext(line2)

	var/message_changed = FALSE
	if(line1 != message1)
		message1 = line1
		message_changed = TRUE

	if(line2 != message2)
		message2 = line2
		message_changed = TRUE

	if(message_changed)
		update_appearance()

/**
 * Remove both message objs and null the fields.
 * Don't call this in subclasses.
 */
/obj/machinery/status_display/proc/remove_messages()
	var/obj/effect/overlay/status_display_text/overlay_1 = get_status_text(message_key_1)
	message_key_1 = null
	overlay_1?.disown(src)
	var/obj/effect/overlay/status_display_text/overlay_2 = get_status_text(message_key_2)
	message_key_2 = null
	overlay_2?.disown(src)

// List in the form key -> status display that shows said key
GLOBAL_LIST_EMPTY(key_to_status_display)

/proc/generate_status_text(line_y, message, x_offset, text_color, header_text_color, line_pair)
	var/key = "[line_y]-[message]-[x_offset]-[text_color]-[header_text_color]-[line_pair]"
	var/obj/effect/overlay/status_display_text/new_overlay = GLOB.key_to_status_display[key]
	if(!new_overlay)
		new_overlay = new(null, line_y, message, text_color, header_text_color, x_offset, line_pair, key)
		GLOB.key_to_status_display[key] = new_overlay
	return new_overlay

/proc/get_status_text(key)
	return GLOB.key_to_status_display[key]

/**
 * Create/update message overlay.
 * They must be handled as real objects for the animation to run.
 * Don't call this in subclasses.
 * Arguments:
 * * overlay - the current /obj/effect/overlay/status_display_text instance
 * * line_y - The Y offset to render the text.
 * * x_offset - Used to offset the text on the X coordinates, not usually needed.
 * * message - the new message text.
 * Returns new /obj/effect/overlay/status_display_text or null if unchanged.
 */
/obj/machinery/status_display/proc/update_message(current_key, line_y, message, x_offset, line_pair)
	var/obj/effect/overlay/status_display_text/current_overlay = get_status_text(current_key)
	var/obj/effect/overlay/status_display_text/new_overlay = generate_status_text(line_y, message, x_offset, text_color, header_text_color, line_pair)

	if(current_overlay == new_overlay)
		return current_key

	current_overlay?.disown(src)
	new_overlay.own(src)
	return new_overlay.status_key

/obj/machinery/status_display/update_appearance(updates=ALL)
	. = ..()
	if( \
		(machine_stat & (NOPOWER|BROKEN)) || \
		(current_mode == SD_BLANK) || \
		(current_mode != SD_PICTURE && message1 == "" && message2 == "") \
	)
		set_light(0)
		return
	set_light(1.5, 0.7, "#CAF0FF") // blue light

/obj/machinery/status_display/update_overlays(updates)
	. = ..()

	if(machine_stat & (NOPOWER|BROKEN))
		remove_messages()
		return

	switch(current_mode)
		if(SD_BLANK)
			remove_messages()
			// Turn off backlight.
			return
		if(SD_PICTURE)
			remove_messages()
			. += mutable_appearance('icons/obj/status_display.dmi', current_picture)
			if(current_picture == "ai_off") // If the thing's off, don't display the emissive yeah?
				return .
		else
			var/line1_metric
			var/line2_metric
			var/line_pair
			line1_metric = GLOB.status_font.get_metrics(message1)
			line2_metric = GLOB.status_font.get_metrics(message2)
			line_pair = (line1_metric > line2_metric ? line1_metric : line2_metric)

			message_key_1 = update_message(message_key_1, LINE1_Y, message1, LINE1_X, line_pair)
			message_key_2 = update_message(message_key_2, LINE2_Y, message2, LINE2_X, line_pair)

			// Turn off backlight if message is blank
			if(message1 == "" && message2 == "")
				return

	. += emissive_appearance(icon, "outline", src, alpha = src.alpha)

/obj/machinery/status_display/process()
	if(machine_stat & NOPOWER)
		// No power, no processing.
		update_appearance()

	if(friendc)
		current_mode = SD_PICTURE
		set_picture("ai_friend")
		return PROCESS_KILL

	switch(current_mode)
		if(SD_EMERGENCY)
			return display_escape_shuttle_status()

		if(SD_MESSAGE)
			return PROCESS_KILL

		if(SD_PICTURE)
			set_picture(last_picture)
			return PROCESS_KILL

		if(SD_TIME)
			// will be constantly updating
			set_messages("TIME", stationtime2text())
			return

	return PROCESS_KILL

/// Update the display and, if necessary, re-enable processing.
/obj/machinery/status_display/proc/update()
	if (process(SSobj.wait/10) != PROCESS_KILL)
		START_PROCESSING(SSobj, src)

/obj/machinery/status_display/power_change()
	. = ..()
	update()

/obj/machinery/status_display/emp_act(severity)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return
	current_mode = SD_PICTURE
	set_picture("ai_bsod")

/obj/machinery/status_display/examine(mob/user)
	. = ..()
	var/obj/effect/overlay/status_display_text/message1_overlay = get_status_text(message_key_1)
	var/obj/effect/overlay/status_display_text/message2_overlay = get_status_text(message_key_2)
	if (message1_overlay || message2_overlay)
		. += "The display says:"
		if (message1_overlay.message)
			. += "\t<tt>[html_encode(message1_overlay.message)]</tt>"
		if (message2_overlay.message)
			. += "\t<tt>[html_encode(message2_overlay.message)]</tt>"

// Helper procs.
/obj/machinery/status_display/proc/display_escape_shuttle_status()
	if(!SSemergencyshuttle.shuttle)
		// the shuttle is missing - no processing
		set_messages("shutl","not in service")
		return PROCESS_KILL
	else if(SSemergencyshuttle.waiting_to_leave() || SSemergencyshuttle.has_eta())
		var/line1 = SSemergencyshuttle.has_eta() ? "-ETA-" : "-ETD-"
		var/line2 = SSemergencyshuttle.has_eta() ? SSemergencyshuttle.estimate_arrival_time() : SSemergencyshuttle.estimate_launch_time()

		if (line2 < 0)
			line2 = "Now"
		else
			line2 = "[add_zero(num2text((line2 / 60) % 60),2)]:[add_zero(num2text(line2 % 60), 2)]"

		set_messages(line1, line2)
	else
		// don't kill processing, the timer might turn back on
		set_messages("", "")

/obj/machinery/status_display/proc/display_alert(newlevel)
	if(seclevel != newlevel)
		seclevel = newlevel
	set_picture("status_display_[seclevel]")
	switch(seclevel)
		if("green")	set_light(l_range = 2, l_power = 0.25, l_color = "#00ff00")
		if("yellow")	set_light(l_range = 2, l_power = 0.25, l_color = "#ffff00")
		if("violet")	set_light(l_range = 2, l_power = 0.25, l_color = "#9933ff")
		if("orange")	set_light(l_range = 2, l_power = 0.25, l_color = "#ff9900")
		if("blue")	set_light(l_range = 2, l_power = 0.25, l_color = "#1024A9")
		if("red")	set_light(l_range = 4, l_power = 0.9, l_color = "#ff0000")
		if("delta")	set_light(l_range = 4, l_power = 0.9, l_color = "#FF6633")

// TODO move me to cargo shuttle display
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
			current_mode = SD_BLANK
			update_appearance()

		if("shuttle")
			current_mode = SD_EMERGENCY
			update_appearance()

		if("message")
			current_mode = SD_MESSAGE
			set_messages(signal.data["msg1"], signal.data["msg2"])

		if("alert")
			current_mode = SD_PICTURE
			last_picture = signal.data["picture_state"]
			set_picture(last_picture)

		if("time")
			current_mode = SD_TIME

		if("friendcomputer")
			friendc = !friendc
	update()

/**
 * Nice overlay to make text smoothly scroll with no client updates after setup.
 */
/obj/effect/overlay/status_display_text
	icon = 'icons/obj/status_display.dmi'
	vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	// physically shift down to render correctly
	pixel_y = -32
	pixel_z = 32

	/// The message this overlay is displaying.
	var/message
	/// Amount of usage this overlay is getting
	var/use_count = 0
	/// The status key we represent
	var/status_key

	// If the line is short enough to not marquee, and it matches this, it's a header.
	var/static/regex/header_regex = regex("^-.*-$")

/obj/effect/overlay/status_display_text/Initialize(mapload, maptext_y, message, text_color, header_text_color, xoffset = 0, line_pair, status_key)
	. = ..()

	src.maptext_y = maptext_y
	src.message = message
	src.status_key = status_key

	var/line_width = GLOB.status_font.get_metrics(message)

	if(line_width > MAX_STATIC_WIDTH)
		// Marquee text
		var/marquee_message = "[message]    [message]    [message]"

		// Width of full content. Must of these is never revealed unless the user inputted a single character.
		var/full_marquee_width = GLOB.status_font.get_metrics("[marquee_message]    ")
		// We loop after only this much has passed.
		var/looping_marquee_width = (GLOB.status_font.get_metrics("[message]    ]") - SCROLL_PADDING)

		maptext = generate_text(marquee_message, center = FALSE, text_color = text_color)
		maptext_width = full_marquee_width
		maptext_x = 0

		// Mask off to fit in screen.
		add_filter("mask", 1, alpha_mask_filter(icon = icon(icon, "outline")))

		// Scroll.
		var/time = line_pair * SCROLL_RATE
		animate(src, maptext_x = (-looping_marquee_width) + MAX_STATIC_WIDTH, time = time, loop = -1)
		animate(maptext_x = MAX_STATIC_WIDTH, time = 0)
	else
		// Centered text
		var/color = header_regex.Find(message) ? header_text_color : text_color
		maptext = generate_text(message, center = TRUE, text_color = color)
		maptext_x = xoffset //Defaults to 0, this would be centered unless overided

/obj/effect/overlay/status_display_text/Destroy(force)
	GLOB.key_to_status_display -= status_key
	return ..()

/**
 * Generate the actual maptext.
 * Arguments:
 * * text - the text to display
 * * center - center the text if TRUE, otherwise right-align (the direction the text is coming from)
 * * text_color - the text color
 */
/obj/effect/overlay/status_display_text/proc/generate_text(text, center, text_color)
	return {"<div style="color:[text_color];font:[FONT_STYLE][center ? ";text-align:center" : "text-align:right"]" valign="top">[text]</div>"}

/// Status displays are static, shared by everyone who needs them
/// This marks us as being used by one more guy
/obj/effect/overlay/status_display_text/proc/own(atom/movable/owned_by)
	owned_by.vis_contents += src
	use_count += 1

/// Status displays are static, shared by everyone who needs them
/// This marks us as no longer being used by a guy
/obj/effect/overlay/status_display_text/proc/disown(atom/movable/disowned_by)
	disowned_by.vis_contents -= src
	use_count -= 1
	if(use_count <= 0)
		qdel(src)


#undef MAX_STATIC_WIDTH
#undef FONT_STYLE
#undef SCROLL_RATE
#undef LINE1_X
#undef LINE1_Y
#undef LINE2_X
#undef LINE2_Y
#undef SCROLL_PADDING
