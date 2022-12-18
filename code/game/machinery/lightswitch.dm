// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "light1"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	power_channel = LIGHT
	mz_flags = ZMM_MANGLE_PLANES

	var/on = TRUE
	var/area/area = null
	var/otherarea = null
	var/image/overlay

/obj/machinery/light_switch/Initialize(mapload, newdir)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/light_switch/LateInitialize()
	. = ..()
	area = get_area(src)

	if(otherarea)
		area = locate(text2path("/area/[otherarea]"))

	if(!name)
		name = "light switch ([area.name])"

	on = area.lightswitch
	updateicon()

/obj/machinery/light_switch/proc/updateicon()
	if(!overlay)
		overlay = image(icon, "light1-overlay")
		overlay.plane = ABOVE_LIGHTING_PLANE

	cut_overlays()
	if(machine_stat & NOPOWER)
		icon_state = "light-p"
		set_light(0)
	else
		icon_state = "light[on]"
		overlay.icon_state = "light[on]-overlay"
		add_overlay(overlay)
		set_light(2, 0.1, on ? "#82FF4C" : "#F86060")

/obj/machinery/light_switch/examine(mob/user)
	. += SPAN_NOTICE("A light switch. It is [on? "on" : "off"].")

/obj/machinery/light_switch/attack_hand(mob/user)

	on = !on

	area.lightswitch = on
	area.updateicon()
	playsound(src, 'sound/machines/button.ogg', 100, TRUE, 0)

	for(var/obj/machinery/light_switch/L in area)
		L.on = on
		L.updateicon()

	area.power_change()

/obj/machinery/light_switch/power_change()
	if(!otherarea)
		if(powered(LIGHT))
			machine_stat &= ~NOPOWER
		else
			machine_stat |= NOPOWER

		updateicon()

/obj/machinery/light_switch/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		..(severity)
		return
	power_change()
	..(severity)
