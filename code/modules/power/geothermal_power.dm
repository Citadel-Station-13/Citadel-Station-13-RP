/**
 * Idea: a solar esqu controller that has a HE pipe looking thing running out from it which runs over Lava
 * 			or any turf with special temp high enough.
 *
 *
 *
 */
// Admin editable variable for power gen

/obj/machinery/power/geothermal_controller
	name = "Akureyri Geothermal Power Controller"
	desc = "The Akureyri Geothermal Power Controller is the specialised geothermal Power solution offered to you by Frag Felix Storage."

	icon = 'icons/obj/machines/power/geothermal.dmi'
	icon_state = "controller_off"

	dir = NORTH
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_OFF
	idle_power_usage = 0
	active_power_usage = 0

	var/range = 7
	var/number_of_collectors = 0
	var/list/collectors = list()
	var/power_total = 0

/obj/machinery/power/geothermal_controller/can_drain_energy(datum/actor, flags)
	return FALSE

/obj/machinery/power/geothermal_controller/process(delta_time)//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(machine_stat & BROKEN)
		return
	update_icon()
	if(powernet)
		if(use_power)
			add_avail(power_total)


/obj/machinery/power/geothermal_controller/update_icon_state()
	switch(power_total)
		if(50 to 500 KILOWATTS)
			icon_state = "controller_low"
		if(500 KILOWATTS to 1 MEGAWATTS)
			icon_state = "controller_med"
		if(1 MEGAWATTS to 2 MEGAWATTS)
			icon_state = "controller_high"
		if(2 MEGAWATTS to INFINITY)
			icon_state = "controller_vhigh"
		else
			icon_state = "controller_idle"
	if(use_power == USE_POWER_OFF)
		icon_state = "controller_off"
	return ..()


/obj/machinery/power/geothermal_controller/Initialize(mapload)
	. = ..()
	for (var/obj/machinery/power/geothermal_collector/col in range(7, src))
		if(istype(col))
			number_of_collectors++
			power_total += col.power_provided
			LAZYADD(collectors, col)

/obj/machinery/power/geothermal_controller/examine(mob/user)
	. = ..()
	if(use_power == USE_POWER_OFF)
		. += "Use a multitool to set it up."

/obj/machinery/power/geothermal_controller/attackby(obj/item/W, mob/user)
	if(W.is_multitool())
		update_use_power(USE_POWER_IDLE)
		to_chat(user, "You set the [src.name] up to siphon geothermal power.")

/obj/machinery/power/geothermal_collector
	name = "Akureyri Geothermal Power Collector"
	desc = "The power collecting part of the Akureyri Geothermal Power system, built to withstand serious heat."

	icon = 'icons/obj/machines/power/geothermal.dmi'
	icon_state = "pipe"

	anchored = TRUE
	density = FALSE
	use_power = USE_POWER_OFF
	idle_power_usage = 0
	active_power_usage = 0

	var/local_special_temp
	var/power_provided = 0

/obj/machinery/power/geothermal_collector/Initialize(mapload)
	. = ..()
	var/turf/simulated/T = src.loc
	if(istype(T))
		local_special_temp = T.special_temperature
		power_provided = max(0, local_special_temp - 273) / 400
		if(local_special_temp > 500)
			var/icon_temperature = local_special_temp

			var/h_r = heat2colour_r(icon_temperature / 1.5)
			var/h_g = heat2colour_g(icon_temperature / 1.5)
			var/h_b = heat2colour_b(icon_temperature / 1.5)

			if(icon_temperature < 2000) //scale up overlay until 2000K
				var/scale = (icon_temperature - 500) / 1500
				h_r = 64 + (h_r - 64)*scale
				h_g = 64 + (h_g - 64)*scale
				h_b = 64 + (h_b - 64)*scale

			animate(src, color = rgb(h_r, h_g, h_b), time = 20, easing = SINE_EASING)

/obj/machinery/power/geothermal_collector/manifold
	icon_state = "manifold"

/obj/machinery/power/geothermal_collector/fourway
	icon_state = "fourway"
