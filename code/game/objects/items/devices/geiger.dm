#define RAD_LEVEL_NORMAL 9
#define RAD_LEVEL_MODERATE 100
#define RAD_LEVEL_HIGH 400
#define RAD_LEVEL_VERY_HIGH 800
#define RAD_LEVEL_CRITICAL 1500

#define RAD_MEASURE_SMOOTHING 5

#define RAD_GRACE_PERIOD 2

/obj/item/geiger_counter
	name = "geiger counter"
	desc = "A handheld device used for detecting and measuring radiation in an area."
	icon = 'icons/obj/device.dmi'
	icon_state = "geiger_off"
	item_state = "multitool"
	w_class = ITEMSIZE_SMALL
	rad_flags = RAD_NO_CONTAMINATE | RAD_BLOCK_CONTENTS
	materials = list(MAT_STEEL = 200, MAT_GLASS = 100)

	var/grace = RAD_GRACE_PERIOD
	var/datum/looping_sound/geiger/soundloop

	var/scanning = FALSE
	var/radiation_count = 0
	var/current_tick_amount = 0
	var/last_tick_amount = 0
	var/fail_to_receive = 0
	var/current_warning = 1

/obj/item/geiger_counter/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/z_radiation_listener)
	AddComponent(/datum/component/radiation_listener)
	soundloop = new(list(src))
	if(scanning)
		START_PROCESSING(SSobj, src)

/obj/item/geiger_counter/Destroy()
	if(scanning)
		scanning = FALSE
		STOP_PROCESSING(SSobj, src)
	if(soundloop)
		QDEL_NULL(soundloop)
	return ..()

/obj/item/geiger_counter/process(delta_time)
	if(!scanning)
		current_tick_amount = 0
		return PROCESS_KILL

	radiation_count -= radiation_count/RAD_MEASURE_SMOOTHING
	radiation_count += current_tick_amount/RAD_MEASURE_SMOOTHING

	if(current_tick_amount)
		grace = RAD_GRACE_PERIOD
		last_tick_amount = current_tick_amount

	else if(!(obj_flags & EMAGGED))
		grace--
		if(grace <= 0)
			radiation_count = 0

	current_tick_amount = 0

	update_appearance()
	update_sound()

/obj/item/geiger_counter/examine(mob/user, dist)
	. = ..()
	if(!scanning)
		return
	. += SPAN_INFO("Alt-click it to clear stored radiation levels.")
	if(obj_flags & EMAGGED)
		. += SPAN_WARNING("The display seems to be incomprehensible.")
		return
	switch(radiation_count)
		if(-INFINITY to RAD_LEVEL_NORMAL)
			. += SPAN_NOTICE("Ambient radiation level count reports that all is well.")
		if(RAD_LEVEL_NORMAL + 1 to RAD_LEVEL_MODERATE)
			. += SPAN_ALERT("Ambient radiation levels slightly above average.")
		if(RAD_LEVEL_MODERATE + 1 to RAD_LEVEL_HIGH)
			. += SPAN_WARNING("Ambient radiation levels above average.")
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH)
			. += SPAN_DANGER("Ambient radiation levels highly above average.")
		if(RAD_LEVEL_VERY_HIGH + 1 to RAD_LEVEL_CRITICAL)
			. += SPAN_SUICIDE("Ambient radiation levels nearing critical level.")
		if(RAD_LEVEL_CRITICAL + 1 to INFINITY)
			. += SPAN_BOLDWARNING("Ambient radiation levels above critical level!")

	. += SPAN_NOTICE("The last radiation amount detected was [last_tick_amount]")

/obj/item/geiger_counter/update_icon_state()
	if(!scanning)
		icon_state = "geiger_off"
		return ..()
	if(obj_flags & EMAGGED)
		icon_state = "geiger_on_emag"
		return ..()

	switch(radiation_count)
		if(-INFINITY to RAD_LEVEL_NORMAL)
			icon_state = "geiger_on_1"
		if(RAD_LEVEL_NORMAL + 1 to RAD_LEVEL_MODERATE)
			icon_state = "geiger_on_2"
		if(RAD_LEVEL_MODERATE + 1 to RAD_LEVEL_HIGH)
			icon_state = "geiger_on_3"
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH)
			icon_state = "geiger_on_4"
		if(RAD_LEVEL_VERY_HIGH + 1 to RAD_LEVEL_CRITICAL)
			icon_state = "geiger_on_4"
		if(RAD_LEVEL_CRITICAL + 1 to INFINITY)
			icon_state = "geiger_on_5"
	return ..()

/obj/item/geiger_counter/proc/update_sound()
	var/datum/looping_sound/geiger/loop = soundloop
	if(!scanning)
		loop.stop()
		return
	if(!radiation_count)
		loop.stop()
		return
	loop.last_radiation = radiation_count
	loop.start()

/obj/item/geiger_counter/rad_act(amount)
	. = ..()
	if(amount <= RAD_BACKGROUND_RADIATION || !scanning)
		return
	current_tick_amount += amount
	update_appearance()

/obj/item/geiger_counter/attack_self(mob/user, datum/event_args/clickchain/e_args)
	. = ..()
	if(.)
		return
	scanning = !scanning
	if(scanning)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	update_appearance()
	to_chat(user, SPAN_NOTICE("[icon2html(src, user)] You switch [scanning ? "on" : "off"] [src]."))

/obj/item/geiger_counter/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	. = ..()
	if(user.a_intent == INTENT_HELP)
		if(!(obj_flags & EMAGGED))
			user.visible_message(SPAN_NOTICE("[user] scans [target] with [src]."), SPAN_NOTICE("You scan [target]'s radiation levels with [src]..."))
			addtimer(CALLBACK(src, .proc/scan, target, user), 20, TIMER_UNIQUE) // Let's not have spamming GetAllContents
		else
			user.visible_message(SPAN_NOTICE("[user] scans [target] with [src]."), SPAN_DANGER("You project [src]'s stored radiation into [target]!"))
			target.rad_act(radiation_count / get_dist(user, target))	// yeah let's NOT have infinite range killbeams
			radiation_count = 0
		return TRUE

/obj/item/geiger_counter/proc/scan(atom/A, mob/user)
	var/rad_strength = 0
	for(var/i in get_rad_contents(A)) // Yes it's intentional that you can't detect radioactive things under rad protection. Gives traitors a way to hide their glowing green rocks.
		var/atom/thing = i
		if(!thing)
			continue
		var/datum/component/radioactive/radiation = thing.GetComponent(/datum/component/radioactive)
		if(radiation)
			rad_strength += radiation.strength

	if(isliving(A))
		var/mob/living/M = A
		if(!M.radiation)
			to_chat(user, SPAN_NOTICE("[icon2html(src, user)] Radiation levels within normal boundaries."))
		else
			to_chat(user, SPAN_BOLDWARNING("[icon2html(src, user)] Subject is irradiated. Radiation levels: [M.radiation]."))

	if(rad_strength)
		to_chat(user, SPAN_BOLDWARNING("[icon2html(src, user)] Target contains radioactive contamination. Radioactive strength: [rad_strength]"))
	else
		to_chat(user, SPAN_NOTICE("[icon2html(src, user)] Target is free of radioactive contamination."))

/obj/item/geiger_counter/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_SCREWDRIVER && (obj_flags & EMAGGED))
		if(scanning)
			to_chat(user, SPAN_WARNING("Turn off [src] before you perform this action!"))
			return FALSE
		user.visible_message(SPAN_NOTICE("[user] unscrews [src]'s maintenance panel and begins fiddling with its innards..."), SPAN_NOTICE("You begin resetting [src]..."))
		if(!I.use_tool(src, user, 4 SECONDS, volume = 40))
			return FALSE
		user.visible_message(SPAN_NOTICE("[user] refastens [src]'s maintenance panel!"), SPAN_NOTICE("You reset [src] to its factory settings!"))
		obj_flags &= ~EMAGGED
		radiation_count = 0
		update_appearance()
		return TRUE
	else
		return ..()

/obj/item/geiger_counter/AltClick(mob/living/user)
	if(!istype(user) || !user.default_can_use_topic(src))
		return ..()
	if(!scanning)
		to_chat(usr, SPAN_WARNING("[src] must be on to reset its radiation level!"))
		return
	radiation_count = 0
	to_chat(usr, SPAN_NOTICE("You flush [src]'s radiation counts, resetting it to normal."))
	update_appearance()

/obj/item/geiger_counter/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	if(scanning)
		to_chat(user, SPAN_WARNING("Turn off [src] before you perform this action!"))
		return
	to_chat(user, SPAN_WARNING("You override [src]'s radiation storing protocols. It will now generate small doses of radiation, and stored rads are now projected into creatures you scan."))
	obj_flags |= EMAGGED
	return TRUE

/obj/item/geiger_counter/cyborg
	var/mob/listeningTo

/obj/item/geiger_counter/cyborg/unequipped(mob/user, slot, flags)
	. = ..()
	if(!scanning)
		return
	scanning = FALSE
	update_appearance()

/obj/item/geiger_counter/cyborg/equipped(mob/user, slot, flags)
	. = ..()
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_ATOM_RAD_ACT)
	RegisterSignal(user, COMSIG_ATOM_RAD_ACT, .proc/redirect_rad_act)
	listeningTo = user

/obj/item/geiger_counter/cyborg/proc/redirect_rad_act(datum/source, amount)
	SIGNAL_HANDLER
	rad_act(amount)

/obj/item/geiger_counter/cyborg/dropped(mob/user)
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_ATOM_RAD_ACT)
	listeningTo = null

#undef RAD_MEASURE_SMOOTHING
#undef RAD_GRACE_PERIOD

#undef RAD_LEVEL_NORMAL
#undef RAD_LEVEL_MODERATE
#undef RAD_LEVEL_HIGH
#undef RAD_LEVEL_VERY_HIGH
#undef RAD_LEVEL_CRITICAL
