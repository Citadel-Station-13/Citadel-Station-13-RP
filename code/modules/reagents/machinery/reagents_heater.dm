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
	idle_power_usage = 2

	var/image/glow_icon
	var/image/beaker_icon
	var/image/on_icon

	var/heater_mode =          	HEATER_MODE_HEAT
	var/list/permitted_types = 	list(/obj/item/reagent_containers/glass)
	var/max_temperature =      	T0C + 1000
	var/min_temperature =      	TCMB
	var/current_temperature =	T20C
	var/target_temperature =   	T20C
	var/difference_t_to_c =		0
	var/obj/item/reagent_containers/container

/obj/machinery/reagent_temperature/examine(mob/user)
	. = ..()
	. += "<span class='notice'>\The [src] has its target set to [target_temperature] K.</span>"
	. += "<span class='notice'>The Temperature in \the [container] is currently at [current_temperature] K.</span>"

/obj/machinery/reagent_temperature/proc/eject_beaker(mob/user)
	if(!container)
		return
	container.reagents.temperature = T20C //Bandaid to just make sure we arent handing out superheated/cooled beakers
	var/obj/item/reagent_containers/B = container
	user.put_in_hands(B)
	container = null
	update_icon()

/obj/machinery/reagent_temperature/AltClick(mob/user)
	if(CanInteract(user, physical_state))
		eject_beaker(user)
	else
		..()

/obj/machinery/reagent_temperature/process(delta_time)
	..()

	if(stat & (NOPOWER|BROKEN) || !use_power)
		update_icon()
		return

	if(container && container.reagents)
		current_temperature = container.reagents.temperature
		if(current_temperature == target_temperature)
			difference_t_to_c = 0
			return
		if (difference_t_to_c != 0)
			container.reagents.temperature += difference_t_to_c / 10
		else
			difference_t_to_c = target_temperature - current_temperature



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
					current_temperature = container.reagents.temperature
					visible_message(SPAN_NOTICE("\The [user] places \the [container] on \the [src]."))
					update_icon()
				return
		to_chat(user, SPAN_WARNING("\The [src] cannot accept \the [thing]."))

/obj/machinery/reagent_temperature/update_icon()

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

/obj/machinery/reagent_temperature/verb/Set_Target()
	set name = "Set Target Temperature"
	set category = "Object"
	set src in oview(1)

	var/N = input("Target-temperature in K:","[src]") as text
	if(N)
		var/value = text2num(N)
		target_temperature = clamp(value, min_temperature, max_temperature)
		to_chat(usr, "You set the target Temperature to [target_temperature]")

#undef MINIMUM_GLOW_TEMPERATURE
#undef MINIMUM_GLOW_VALUE
#undef MAXIMUM_GLOW_VALUE
#undef HEATER_MODE_HEAT
#undef HEATER_MODE_COOL
