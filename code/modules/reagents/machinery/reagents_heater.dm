#define MINIMUM_GLOW_TEMPERATURE 323
#define MINIMUM_GLOW_VALUE       25
#define MAXIMUM_GLOW_VALUE       255
#define HEATER_MODE_HEAT         "heat"
#define HEATER_MODE_COOL         "cool"

/obj/machinery/reagent_temperature
	name = "Chemical Temperature Adjustment Unit"
	desc = "A machine used to heat up or cool down the contents of beakers"
	density = 1
	anchored = 1
	icon = 'icons/obj/machines/heat_sources.dmi'
	icon_state = "hotplate"
	//circuit = /obj/item/circuitboard/chem_master
	use_power = USE_POWER_IDLE
	idle_power_usage = 20

	var/image/glow_icon
	var/image/beaker_icon
	var/image/on_icon

	var/heater_mode =          HEATER_MODE_HEAT
	var/list/permitted_types = list(/obj/item/reagent_containers/glass)
	var/max_temperature =      T0C + 1000
	var/min_temperature =      TCMB
	var/heating_power =        10 // K
	var/last_temperature
	var/target_temperature
	var/obj/item/reagent_containers/container

/obj/machinery/reagent_temperature/proc/eject_beaker(mob/user)
	if(!container)
		return
	var/obj/item/reagent_containers/B = container
	user.put_in_hands(B)
	container = null
	update_icon()

/obj/machinery/reagent_temperature/AltClick(mob/user)
	if(CanInteract(user, user.physical_state))
		eject_beaker(user)
	else
		..()

/obj/machinery/reagent_temperature/process(delta_time)
	..()

	if(stat & (NOPOWER|BROKEN) || !use_power)
		update_icon()
		return

	if(container && container.reagents)
		var/needed_energy = container.energy_to_temperature(target_temperature)
		if(needed_energy == 0)
			return
		else if(needed_energy > 0)
			container.alternate_temperature(max(heating_power, needed_energy))
		else if(needed_energy < 1)
			container.alternate_temperature(min(-heating_power, needed_energy))


/obj/machinery/reagent_temperature/attackby(var/obj/item/thing, var/mob/user)
	if(default_unfasten_wrench(user, thing, 20))
		return

	if(thing.reagents)
		for(var/checktype in permitted_types)
			if(istype(thing, checktype))
				if(container)
					to_chat(user, SPAN_WARNING("\The [src] is already holding \the [container]."))
				else if(user.unEquip(thing))
					thing.forceMove(src)
					container = thing
					visible_message(SPAN_NOTICE("\The [user] places \the [container] on \the [src]."))
					update_icon()
				return
		to_chat(user, SPAN_WARNING("\The [src] cannot accept \the [thing]."))

/obj/machinery/reagent_temperature/on_update_icon()

	var/list/adding_overlays

	if(use_power >= USE_POWER_ACTIVE)
		if(!on_icon)
			on_icon = image(icon, "[icon_state]-on")
		LAZYADD(adding_overlays, on_icon)
		if(target_temperature > MINIMUM_GLOW_TEMPERATURE) // 50C
			if(!glow_icon)
				glow_icon = image(icon, "[icon_state]-glow")
			glow_icon.alpha = clamp(target_temperature - MINIMUM_GLOW_TEMPERATURE, MINIMUM_GLOW_VALUE, MAXIMUM_GLOW_VALUE)
			LAZYADD(adding_overlays, glow_icon)
			set_light(0.2, 0.1, 1, l_color = COLOR_RED)
		else
			set_light(0)
	else
		set_light(0)

	if(container)
		if(!beaker_icon)
			beaker_icon = image(icon, "[icon_state]-beaker")
		LAZYADD(adding_overlays, beaker_icon)

	overlays = adding_overlays

/obj/machinery/reagent_temperature/interact(var/mob/user)

	var/dat = list()
	dat += "<table>"
	dat += "<tr><td>Target temperature:</td><td>"

	if(target_temperature > min_temperature)
		dat += "<a href='?src=\ref[src];adjust_temperature=-[heating_power]'>-</a> "

	dat += "[target_temperature - T0C]C"

	if(target_temperature < max_temperature)
		dat += " <a href='?src=\ref[src];adjust_temperature=[heating_power]'>+</a>"

	dat += "</td></tr>"

	dat += "<tr><td>Current temperature:</td><td>[min(target_temperature - T0C)]C</td></tr>"

	dat += "<tr><td>Loaded container:</td>"
	dat += "<td>[container ? "[container.name] ([min(container.reagents.temperature - T0C)]C) <a href='?src=\ref[src];remove_container=1'>Remove</a>" : "None."]</td></tr>"

	dat += "<tr><td>Switched:</td><td><a href='?src=\ref[src];toggle_power=1'>[use_power == USE_POWER_ACTIVE ? "On" : "Off"]</a></td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "\ref[src]-reagent_temperature_window", "[capitalize(name)]")
	popup.set_content(jointext(dat, null))
	popup.open()

/obj/machinery/reagent_temperature/CanUseTopic(var/mob/user, var/state, var/href_list)
	if(href_list && href_list["remove_container"])
		. = ..(user, GLOB.physical_state, href_list)
		if(. == UI_CLOSE)
			to_chat(user, SPAN_WARNING("You are too far away."))
		return
	return ..()

/obj/machinery/reagent_temperature/proc/ToggleUsePower()

	if(stat & (BROKEN|NOPOWER))
		return TOPIC_HANDLED

	update_use_power(use_power <= USE_POWER_IDLE ? USE_POWER_IDLE : USE_POWER_IDLE)
	update_icon()

	return TOPIC_REFRESH

/obj/machinery/reagent_temperature/OnTopic(var/mob/user, var/href_list)

	if(href_list["adjust_temperature"])
		target_temperature = clamp(target_temperature + text2num(href_list["adjust_temperature"]), min_temperature, max_temperature)
		. = TOPIC_REFRESH

	if(href_list["toggle_power"])
		. = ToggleUsePower()
		if(. != TOPIC_REFRESH)
			to_chat(user, SPAN_WARNING("The button clicks, but nothing happens."))

	if(href_list["remove_container"])
		eject_beaker(user)
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

#undef MINIMUM_GLOW_TEMPERATURE
#undef MINIMUM_GLOW_VALUE
#undef MAXIMUM_GLOW_VALUE
#undef HEATER_MODE_HEAT
#undef HEATER_MODE_COOL
