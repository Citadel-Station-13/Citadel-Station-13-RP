// Radiation 'levels'. Used for the geiger counter, for visuals and sound. They are in different files so this goes here.

#define RAD_LEVEL_NORMAL 0.5 // Around the level at which radiation starts to become harmful
#define RAD_LEVEL_MODERATE 5 //0.05 factor, maths: 5/100 = 0.05
#define RAD_LEVEL_HIGH 20
#define RAD_LEVEL_VERY_HIGH 40
#define RAD_LEVEL_CRITICAL 70

#define RAD_MEASURE_SMOOTHING 5

#define RAD_GRACE_PERIOD 2
/obj/item/geiger
	name = "geiger counter"
	desc = "A handheld device used for detecting and measuring radiation in an area."
	icon = 'icons/obj/device.dmi'
	icon_state = "geiger_off"
	item_state = "multitool"
	w_class = ITEMSIZE_SMALL

	var/grace = RAD_GRACE_PERIOD
	var/datum/looping_sound/geiger/soundloop

	var/scanning = FALSE
	var/radiation_count = 0
	var/current_tick_amount = 0
	var/last_tick_amount = 0
	var/fail_to_receive = 0
	var/current_warning = 1

/obj/item/geiger/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

	soundloop = new(list(src), FALSE)

/obj/item/geiger/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(soundloop)
	return ..()

/obj/item/geiger/process()
	update_icon()
	update_sound()

	if(!scanning)
		current_tick_amount = 0
		return

	radiation_count -= radiation_count/RAD_MEASURE_SMOOTHING //no, linear bad
	radiation_count += current_tick_amount/RAD_MEASURE_SMOOTHING

	if(current_tick_amount)
		grace = RAD_GRACE_PERIOD
		last_tick_amount = current_tick_amount

	else // no mag acts yet! if(!(obj_flags & EMAGGED))
		grace--
		if(grace <= 0)
			radiation_count = 0

	current_tick_amount = 0
	// radiation_count = SSradiation.get_rads_at_turf(get_turf(src)) //not using this

/obj/item/geiger/examine(mob/user)
	. = ..()
	if(!scanning)
		return
	. += "<span class='info'>Alt-click it to clear stored radiation levels.</span>"
	// if(obj_flags & EMAGGED)
	// 	. += "<span class='warning'>The display seems to be incomprehensible.</span>"
	// 	return
	switch(radiation_count)
		if(-INFINITY to RAD_LEVEL_NORMAL)
			. += "<span class='notice'>Ambient radiation level count reports that all is well.</span>"
		if(RAD_LEVEL_NORMAL + 1 to RAD_LEVEL_MODERATE)
			. += "<span class='disarm'>Ambient radiation levels slightly above average.</span>"
		if(RAD_LEVEL_MODERATE + 1 to RAD_LEVEL_HIGH)
			. += "<span class='warning'>Ambient radiation levels above average.</span>"
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH)
			. += "<span class='danger'>Ambient radiation levels highly above average.</span>"
		if(RAD_LEVEL_VERY_HIGH + 1 to RAD_LEVEL_CRITICAL)
			. += "<span class='suicide'>Ambient radiation levels nearing critical level.</span>"
		if(RAD_LEVEL_CRITICAL + 1 to INFINITY)
			. += "<span class='boldannounce'>Ambient radiation levels above critical level!</span>"

	. += "<span class='notice'>The current radiation level is [radiation_count ? radiation_count : "0"]Bq. The last radiation amount detected was [last_tick_amount]Bq.</span>"

/obj/item/geiger/rad_act(amount)
	. = ..()
	if(amount <= 0 || !scanning) // <= RAD_BACKGROUND_RADIATION
		return
	current_tick_amount += amount // the current rads
	update_icon()

/obj/item/geiger/proc/update_sound()
	var/datum/looping_sound/geiger/loop = soundloop
	if(!scanning)
		loop.stop()
		return
	if(!radiation_count)
		loop.stop()
		return
	loop.last_radiation = radiation_count
	loop.start()

/obj/item/geiger/attack_self(mob/user)
	scanning = !scanning
	update_icon()
	to_chat(user, "<span class='notice'>[icon2html(src, user)] You switch [scanning ? "on" : "off"] [src].</span>")

/obj/item/geiger/afterattack(atom/target, mob/user)
	. = ..()
	if(user.a_intent == INTENT_HELP)
		if(TRUE) // it will never go to else unless something goes wrong!(obj_flags & EMAGGED))
			user.visible_message("<span class='notice'>[user] scans [target] with [src].</span>", "<span class='notice'>You scan [target]'s radiation levels with [src]...</span>")
			addtimer(CALLBACK(src, .proc/scan, target, user), 20, TIMER_UNIQUE) // Let's not have spamming GetAllContents
		else
			user.visible_message("<span class='notice'>[user] scans [target] with [src].</span>", "<span class='danger'>You project [src]'s stored radiation into [target]!</span>")
			// target.rad_act(radiation_count)
			radiation_count = 0
		return TRUE

/obj/item/geiger/proc/scan(atom/A, mob/user)
	var/rad_strength = 0
	// for(var/i in get_rad_contents(A)) // Yes it's intentional that you can't detect radioactive things under rad protection. Gives traitors a way to hide their glowing green rocks.
	// 	var/atom/thing = i
	// 	if(!thing)
	// 		continue
	// 	var/datum/radioactive/radiation = thing.GetComponent(/datum/component/radioactive)
	// 	if(radiation)
	// 		rad_strength += radiation.strength
	if(!ismob(A))
		to_chat(user, "<span class='notice'>[icon2html(src, user)] ERROR: Cannot detect radiation level of the object! (OOC: Yes, this is NOT an issue, if radiation gets componentualized, this will be fixed.)</span>")
		return

	var/mob/M = A
	rad_strength += M.radiation //component based W H E N
	if(isliving(A))
		var/mob/living/L = A
		if(!M.radiation)
			to_chat(user, "<span class='notice'>[icon2html(src, user)] Radiation levels within normal boundaries.</span>")
		else
			to_chat(user, "<span class='boldannounce'>[icon2html(src, user)] Subject is irradiated. Radiation levels: [L.radiation] rad.</span>")

	if(rad_strength)
		to_chat(user, "<span class='boldannounce'>[icon2html(src, user)] Target contains radioactive contamination. Radioactive strength: [rad_strength]</span>")
	else
		to_chat(user, "<span class='notice'>[icon2html(src, user)] Target is free of radioactive contamination.</span>")

/obj/item/geiger/AltClick(mob/living/user)
	. = ..()
	if(!istype(user) && (in_range(user, src) < 1)) // || !user.canUseTopic(src, BE_CLOSE))
		return
	if(!scanning)
		to_chat(usr, "<span class='warning'>[src] must be on to reset its radiation level!</span>")
		return TRUE
	radiation_count = 0
	to_chat(usr, "<span class='notice'>You flush [src]'s radiation counts, resetting it to normal.</span>")
	update_icon()
	return TRUE

/obj/item/geiger/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
	//else if(obj_flags & EMAGGED)
	//	icon_state = "geiger_on_emag"
	else
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
