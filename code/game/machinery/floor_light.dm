var/list/floor_light_cache = list()

/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	layer = TURF_LAYER+0.001
	anchored = FALSE
	use_power = USE_POWER_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT
	matter = list(MAT_STEEL = 2500, MAT_GLASS = 2750)

	var/on
	var/damaged
	var/default_light_range = 4
	var/default_light_power = 0.75
	var/default_light_colour = LIGHT_COLOR_INCANDESCENT_BULB
	var/newcolor

/obj/machinery/floor_light/prebuilt
	anchored = TRUE

/obj/machinery/floor_light/attackby(obj/item/W, mob/user)
	if(W.is_screwdriver())
		anchored = !anchored
		visible_message(SPAN_NOTICE("\The [user] has [anchored ? "attached" : "detached"] \the [src]."))
	else if(istype(W, /obj/item/weldingtool) && (damaged || (machine_stat & BROKEN)))
		var/obj/item/weldingtool/WT = W
		if(!WT.remove_fuel(0, user))
			to_chat(user, SPAN_WARNING("\The [src] must be on to complete this task."))
			return
		playsound(src.loc, WT.tool_sound, 50, TRUE)
		if(!do_after(user, 20 * WT.tool_speed))
			return
		if(!src || !WT.isOn())
			return
		visible_message(SPAN_NOTICE("\The [user] has repaired \the [src]."))
		machine_stat &= ~BROKEN
		damaged = null
		update_brightness()

	else if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/MT = W
		playsound(src.loc, MT.tool_sound, 50, TRUE)
		if(!on)
			to_chat(user, SPAN_WARNING("\The [src] must be on to complete this task."))
			return
		to_chat(user, "\ Enter the text name of the color. For example, green")
		to_chat(user, "Alternatively, enter the full hex code of your desired color. For example, #28FF01")
		var/newcolor = input("","Enter a new color.") as text|null //ask for text input of what the color should be e.g. green, blue, yellow, etc
		src.default_light_colour = newcolor
		src.color = newcolor
		src.light_color = newcolor
		update_brightness()
		visible_message(SPAN_NOTICE("\The [user] has changed \the [src] color."))
	else if(W.force && user.a_intent == "hurt")
		attack_hand(user)
	return

/obj/machinery/floor_light/attack_hand(mob/user)

	if(user.a_intent == INTENT_HARM && !issmall(user))
		if(!isnull(damaged) && !(machine_stat & BROKEN))
			visible_message(SPAN_DANGER("\The [user] smashes \the [src]!"))
			playsound(src, "shatter", 70, TRUE)
			machine_stat |= BROKEN
		else
			visible_message(SPAN_DANGER("\The [user] attacks \the [src]!"))
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, TRUE)
			if(isnull(damaged))
				damaged = FALSE
		update_brightness()
		return
	else

		if(!anchored)
			to_chat(user, SPAN_WARNING("\The [src] must be screwed down first."))
			return

		if(machine_stat & BROKEN)
			to_chat(user, SPAN_WARNING("\The [src] is too damaged to be functional."))
			return

		if(machine_stat & NOPOWER)
			to_chat(user, SPAN_WARNING("\The [src] is unpowered."))
			return

		on = !on
		if(on) update_use_power(USE_POWER_ACTIVE)
		update_brightness()
		return

/obj/machinery/floor_light/process(delta_time)
	..()
	var/need_update
	if((!anchored || broken()) && on)
		update_use_power(USE_POWER_OFF)
		on = FALSE
		need_update = TRUE
	else if(use_power && !on)
		update_use_power(USE_POWER_OFF)
		need_update = TRUE
	if(need_update)
		update_brightness()

/obj/machinery/floor_light/proc/update_brightness()
	if(on && use_power == USE_POWER_ACTIVE)
		if(light_range != default_light_range || light_power != default_light_power || light_color != default_light_colour)
			set_light(default_light_range, default_light_power, default_light_colour)
	else
		update_use_power(USE_POWER_OFF)
		if(light_range || light_power)
			set_light(0)

	active_power_usage = ((light_range + light_power) * 10)
	update_icon()

/obj/machinery/floor_light/update_icon()
	overlays.Cut()
	if(use_power && !broken())
		if(isnull(damaged))
			var/cache_key = "floorlight-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("on")
				I.color = default_light_colour
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]
		else
			if(damaged == 0) //Needs init.
				damaged = rand(1,4)
			var/cache_key = "floorlight-broken[damaged]-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("flicker[damaged]")
				I.color = default_light_colour
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]

/obj/machinery/floor_light/proc/broken()
	return (machine_stat & (BROKEN|NOPOWER))

/obj/machinery/floor_light/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)
			else if(prob(20))
				machine_stat |= BROKEN
			else
				if(isnull(damaged))
					damaged = FALSE
		if(3)
			if(prob(5))
				qdel(src)
			else if(isnull(damaged))
				damaged = FALSE
	return

/obj/machinery/floor_light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = FALSE
	. = ..()

/obj/machinery/floor_light/cultify()
	default_light_colour = "#FF0000"
	update_brightness()
