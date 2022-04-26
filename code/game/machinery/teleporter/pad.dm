/obj/machinery/tele_pad
	name = "teleporter pad"
	desc = "The teleporter pad handles all of the impossibly complex busywork required in instant matter transmission."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 10
	active_power_usage = 2000
	light_color = "#02d1c7"

	var/obj/machinery/computer/teleporter/computer


/obj/machinery/tele_pad/Destroy()
	if (computer)
		computer.lost_pad()
	clear_computer()
	. = ..()


/obj/machinery/tele_pad/proc/set_computer(obj/machinery/computer/teleporter/_computer)
	if (computer == _computer)
		return
	clear_computer()
	computer = _computer
	RegisterSignal(computer, COMSIG_PARENT_QDELETING, .proc/lost_computer)
	//GLOB.destroyed_event.register(computer, src, /obj/machinery/tele_pad/proc/lost_computer)


/obj/machinery/tele_pad/proc/clear_computer()
	if (!computer)
		return
	//GLOB.unregister(computer, src, /obj/machinery/tele_pad/proc/lost_computer)
	UnregisterSignal(computer, COMSIG_PARENT_QDELETING)
	computer = null


/obj/machinery/tele_pad/proc/lost_computer()
	clear_computer()
	update_icon()


/obj/machinery/tele_pad/Bumped(atom/movable/AM)
	if (!computer?.active)
		return
	var/turf/T = get_turf(computer.target)
	if (!T)
		return
	use_power_oneoff(5000)
	do_teleport(AM, T)


/obj/machinery/tele_pad/attack_ghost(mob/user)
	if (!computer?.active)
		return
	var/turf/T = get_turf(computer.target)
	if (!T)
		return
	user.forceMove(T)


/obj/machinery/tele_pad/power_change()
	. = ..()
	if (!.)
		return
	update_icon()


/obj/machinery/tele_pad/update_icon()
	overlays.Cut()
	if(computer?.active)
		update_use_power(USE_POWER_ACTIVE)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		overlays += I
		set_light(0.4, 1.2, 4, 10)
	else
		set_light(0)
		update_use_power(USE_POWER_IDLE)
		if(operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER
			overlays += I
