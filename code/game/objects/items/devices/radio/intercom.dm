CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/item/radio/intercom, 28)
/obj/item/radio/intercom
	name = "station intercom (General)"
	desc = "Talk through this."
	icon = 'icons/obj/intercom.dmi'
	icon_state = "intercom"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = 1
	w_class = WEIGHT_CLASS_BULKY
	canhear_range = 2
	atom_flags = NOBLOODY
	var/circuit = /obj/item/circuitboard/intercom
	var/number = 0
	var/last_tick //used to delay the powercheck
	var/wiresexposed = 0
	var/overlay_color = PIPE_COLOR_GREEN

/obj/item/radio/intercom/setDir(ndir)
	. = ..()
	base_pixel_x = 0
	base_pixel_y = 0
	switch(dir)
		if(NORTH)
			base_pixel_y = -28
		if(SOUTH)
			base_pixel_y = 28
		if(WEST)
			base_pixel_x = 28
		if(EAST)
			base_pixel_x = -28
	reset_pixel_offsets()

/obj/item/radio/intercom/update_icon(updates)
	cut_overlays()
	. = ..()
	if(!on)
		icon_state = "intercom-p"
	else
		icon_state = "intercom_[broadcasting][listening]"
		var/image/I = image(icon, "intercom_overlay")
		I.color = overlay_color
		add_overlay(I)

/obj/item/radio/intercom/custom
	name = "station intercom (Custom)"
	broadcasting = 0
	listening = 0

/obj/item/radio/intercom/interrogation
	name = "station intercom (Interrogation)"
	frequency  = 1449

/obj/item/radio/intercom/private
	name = "station intercom (Private)"
	frequency = FREQ_AI_PRIVATE

/obj/item/radio/intercom/specops
	name = "\improper Spec Ops intercom"
	frequency = FREQ_ERT
	subspace_transmission = 1
	centcom = 1

/obj/item/radio/intercom/department
	canhear_range = 5
	broadcasting = 0
	listening = 1

/obj/item/radio/intercom/department/medbay
	name = "station intercom (Medbay)"
	frequency = FREQ_MEDICAL_INTERNAL
	overlay_color = COLOR_TEAL

/obj/item/radio/intercom/department/security
	name = "station intercom (Security)"
	frequency = FREQ_SECURITY_INTERNAL
	overlay_color = COLOR_MAROON

/obj/item/radio/intercom/entertainment
	name = "entertainment intercom"
	frequency = FREQ_ENTERTAINMENT

/obj/item/radio/intercom/entertainment/laptop
	icon = 'icons/obj/computer.dmi'
	icon_state = "laptop"
	anchored = FALSE
	broadcasting = FALSE
	listening = TRUE
	name = "Radio Computer"
	desc = "A laptop with a mic, connected to the entertainement frequency."
	frequency = FREQ_ENTERTAINMENT
	anchored = TRUE
	can_be_unanchored = TRUE
	canhear_range = 5
	broadcasting = 1
	listening = 0
	plane = TURF_PLANE
	layer = PLANT_LAYER


/obj/item/radio/intercom/omni
	name = "global announcer"

/obj/item/radio/intercom/omni/Initialize(mapload)
	channels = radiochannels.Copy()
	return ..()

/obj/item/radio/intercom/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	circuit = new circuit(src)

/obj/item/radio/intercom/department/medbay/Initialize(mapload)
	. = ..()
	internal_channels = GLOB.default_medbay_channels.Copy()

/obj/item/radio/intercom/department/security/Initialize(mapload)
	. = ..()
	internal_channels = list(
		num2text(FREQ_COMMON) = list(),
		num2text(FREQ_SECURITY_INTERNAL) = list(ACCESS_SECURITY_EQUIPMENT)
	)

/obj/item/radio/intercom/entertainment/Initialize(mapload)
	. = ..()
	internal_channels = list(
		num2text(FREQ_COMMON) = list(),
		num2text(FREQ_ENTERTAINMENT) = list()
	)

/obj/item/radio/intercom/syndicate
	name = "illicit intercom"
	desc = "Talk through this. Evilly"
	frequency = FREQ_SYNDICATE
	subspace_transmission = 1
	syndie = 1

/obj/item/radio/intercom/syndicate/Initialize(mapload)
	. = ..()
	internal_channels[num2text(FREQ_SYNDICATE)] = list(ACCESS_FACTION_SYNDICATE)

/obj/item/radio/intercom/raider
	name = "illicit intercom"
	desc = "Pirate radio, but not in the usual sense of the word."
	frequency = FREQ_RAIDER
	subspace_transmission = 0
	syndie = 0

/obj/item/radio/intercom/raider/Initialize(mapload)
	. = ..()
	internal_channels[num2text(FREQ_RAIDER)] = list(ACCESS_FACTION_PIRATE)

/obj/item/radio/intercom/trader
	name = "commercial intercom"
	desc = "Good luck finding a 'Skip Advertisements' button here."
	frequency = FREQ_TRADER
	subspace_transmission = 0
	syndie = 0

/obj/item/radio/intercom/trader/Initialize(mapload)
	. = ..()
	internal_channels[num2text(FREQ_TRADER)] = list(ACCESS_FACTION_TRADER)

/obj/item/radio/intercom/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/radio/intercom/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/radio/intercom/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/radio/intercom/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(W.is_screwdriver())  // Opening the intercom up.
		wiresexposed = !wiresexposed
		to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
		playsound(src, W.tool_sound, 50, 1)
		if(wiresexposed)
			if(!on)
				icon_state = "intercom-p_open"
			else
				icon_state = "intercom_open"
		else
			icon_state = "intercom"
		return
	if(wiresexposed && W.is_wirecutter())
		user.visible_message("<span class='warning'>[user] has cut the wires inside \the [src]!</span>", "You have cut the wires inside \the [src].")
		playsound(src, W.tool_sound, 50, 1)
		new/obj/item/stack/cable_coil(get_turf(src), 5)
		var/obj/structure/frame/A = new /obj/structure/frame(src.loc)
		var/obj/item/circuitboard/M = circuit
		A.frame_type = M.board_type
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y
		A.circuit = M
		A.setDir(dir)
		A.anchored = 1
		A.state = 2
		A.update_icon()
		M.after_deconstruct(src)
		qdel(src)
	else
		src.attack_hand(user)
	return

/obj/item/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range

/obj/item/radio/intercom/process(delta_time)
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday

		if(!src.loc)
			on = 0
		else
			var/area/A = get_area(src)
			if(!A)
				on = 0
			else
				on = A.powered(EQUIP) // set "on" to the power status

		update_icon()

/obj/item/radio/intercom/locked
    var/locked_frequency

/obj/item/radio/intercom/locked/set_frequency(var/frequency)
	if(frequency == locked_frequency)
		..(locked_frequency)

/obj/item/radio/intercom/locked/list_channels()
	return ""

/obj/item/radio/intercom/locked/ai_private
	name = "\improper AI intercom"
	frequency = FREQ_AI_PRIVATE
	broadcasting = 1
	listening = 1

/obj/item/radio/intercom/locked/confessional
	name = "confessional intercom"
	frequency = 1480
