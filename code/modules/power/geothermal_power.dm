/**
 * Idea: a solar esqu controller that has a HE pipe looking thing running out from it which runs over Lava
 * 			or any turf with special temp high enough.
 */
// Admin editable variable for power gen

/obj/machinery/power/geothermal_controller
	name = "Akureyri Geothermal Power Controller"
	desc = "The Akureyri Geothermal Power Controller is the specialised geothermal Power solution offered to you by Frag Felix Storage."

	icon = 'icons/obj/machines/power/geothermal.dmi'
	icon_state = "controller_idle"

	dir = NORTH
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_OFF
	idle_power_usage = 0
	active_power_usage = 0

	var/obj/item/scanning_array/scanner
	var/power_factor = 400 //number by which the power_total is divided before adding it to the grid
	var/active_for = -1
	var/power_total = 0

/obj/machinery/power/geothermal_controller/can_drain_energy(datum/actor, flags)
	return FALSE

/obj/machinery/power/geothermal_controller/process(delta_time)
	if(machine_stat & BROKEN)
		return
	update_icon()
	if(active_for > 0)
		active_for -= delta_time
		if(active_for <= 0)
			active_for = 0
			scan_for_collectors(0)
	if(powernet)
		if(power_total > 0)
			add_avail(power_total/power_factor)


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
	return ..()


/obj/machinery/power/geothermal_controller/proc/scan_for_collectors(var/ran)
	power_total = 0
	for (var/obj/machinery/power/geothermal_collector/col in range(ran, src))
		if(istype(col))
			//number_of_collectors++
			power_total += col.power_provided
			//LAZYADD(collectors, col)

/obj/machinery/power/geothermal_controller/attackby(obj/item/W, mob/user)
	if(scanner && istype(scanner))
		if(W.is_multitool())
			//update_use_power(USE_POWER_IDLE)
			to_chat(user, "The [scanner] allows the Controller to gather [power_total/power_factor] kW from Collectors up to [scanner.range] meters away.")
		if(W.is_screwdriver())
			update_use_power(USE_POWER_OFF)
			to_chat(user, "You remove the [scanner] from [src]")
			scanner.force_move(src.loc)
			scanner = null
			scan_for_collectors()
	else
		if(W.is_multitool())
			to_chat(user, "No scanning array detected, unable to gather power.")
		if(W.is_screwdriver())
			to_chat(user, "No scanning array present, unable to remove scanning array.")
		if(istype(W, /obj/item/scanning_array))
			to_chat(user, "You install the [W].")
			scanner = W
			W.force_move(src)
			scan_for_collectors(scanner.range)
	update_icon_state()

/obj/machinery/power/geothermal_controller/attack_robot(mob/user)
	if (scanner)
		to_chat(user, "There is a scanner array already present, nothing left to do.")
	else
		if (get_dist(user, src) <= 1)
			to_chat(user, "You allow [src] to use your sensors as a sensor array. It can keep on working for the next 30 minutes.")
			scan_for_collectors(5)//scan with default part range
			active_for = 1800

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
		power_provided = local_special_temp
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

/obj/item/scanning_array
	name = "Scanning array"
	desc = "An array of scanning modules, used by the Akureyri Geothermal Power Controller to locate collectors and establish a connection with them"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "scan_module"
	var/range = 5

/obj/item/scanning_array/adv
	name = "Advanced Scanning array"
	desc = "An array of scanning modules, used by the Akureyri Geothermal Power Controller to locate collectors and establish a connection with them"
	icon_state = "scan_module_adv"
	range = 11

/obj/item/scanning_array/phasic
	name = "Phasic Scanning array"
	desc = "An array of scanning modules, used by the Akureyri Geothermal Power Controller to locate collectors and establish a connection with them"
	icon_state = "scan_module_phasic"
	range = 17
