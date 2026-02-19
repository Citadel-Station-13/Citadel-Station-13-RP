// Magnetic attractor, creates variable magnetic fields and attraction.
// Can also be used to emit electron/proton beams to create a center of magnetism on another tile

// tl;dr: it's magnets lol
// This was created for firing ranges, but I suppose this could have other applications - Doohl

/obj/machinery/magnetic_module
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_magnet-f"
	name = "Electromagnetic Generator"
	desc = "A device that uses station power to create points of magnetic energy."
	plane = TURF_PLANE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	hides_underfloor = OBJ_UNDERFLOOR_UNLESS_PLACED_ONTOP
	hides_underfloor_update_icon = TRUE
	speed_process = TRUE

	/// Radio frequency.
	var/freq = 1449
	/// Intensity of the magnetic pull.
	var/electricity_level = 1
	/// The range of magnetic attraction.
	var/magnetic_field = 1
	/// Frequency code, they should be different unless you have a group of magnets working together or something.
	var/code = 0
	/// The center of magnetic attraction.
	var/turf/center
	var/on = FALSE
	var/pull_active = FALSE

	// x, y modifiers to the center turf; (0, 0) is centered on the magnet, whereas (1, -1) is one tile right, one tile down
	var/center_x = 0
	var/center_y = 0
	var/max_dist = 20 // absolute value of center_x,y cannot exceed this integer
	var/next_pull

/obj/machinery/magnetic_module/Initialize(mapload, newdir)
	. = ..()
	var/turf/T = loc
	center = T
	radio_controller.add_object(src, freq, RADIO_MAGNETS)

/obj/machinery/magnetic_module/Destroy()
	return ..()

// update the icon_state
/obj/machinery/magnetic_module/update_icon()
	. = ..()
	var/state="floor_magnet"
	var/onstate=""
	if(!on)
		onstate="0"

	if(invisibility)
		icon_state = "[state][onstate]-f"	// if invisible, set icon to faded version
											// in case of being revealed by T-scanner
	else
		icon_state = "[state][onstate]"

/obj/machinery/magnetic_module/receive_signal(datum/signal/signal)
	var/command = signal.data["command"]
	var/modifier = signal.data["modifier"]
	var/signal_code = signal.data["code"]
	if(command && (signal_code == code))

		Cmd(command, modifier)

/obj/machinery/magnetic_module/proc/Cmd(command, modifier)
	if(command)
		switch(command)
			if("set-electriclevel")
				if(modifier)	electricity_level = modifier
			if("set-magneticfield")
				if(modifier)	magnetic_field = modifier

			if("add-elec")
				electricity_level++
				if(electricity_level > 12)
					electricity_level = 12
			if("sub-elec")
				electricity_level--
				if(electricity_level <= 0)
					electricity_level = 1
			if("add-mag")
				magnetic_field++
				if(magnetic_field > 4)
					magnetic_field = 4
			if("sub-mag")
				magnetic_field--
				if(magnetic_field <= 0)
					magnetic_field = 1

			if("set-x")
				if(modifier)	center_x = modifier
			if("set-y")
				if(modifier)	center_y = modifier

			if("N") // NORTH
				center_y++
			if("S")	// SOUTH
				center_y--
			if("E") // EAST
				center_x++
			if("W") // WEST
				center_x--
			if("C") // CENTER
				center_x = 0
				center_y = 0
			if("R") // RANDOM
				center_x = rand(-max_dist, max_dist)
				center_y = rand(-max_dist, max_dist)

			if("set-code")
				if(modifier)	code = modifier
			if("toggle-power")
				on = !on

/obj/machinery/magnetic_module/process(delta_time)
	if(machine_stat & NOPOWER)
		on = FALSE

	// Sanity checks:
	if(electricity_level <= 0)
		electricity_level = 1
	if(magnetic_field <= 0)
		magnetic_field = 1

	// Limitations:
	if(abs(center_x) > max_dist)
		center_x = max_dist
	if(abs(center_y) > max_dist)
		center_y = max_dist
	if(magnetic_field > 4)
		magnetic_field = 4
	if(electricity_level > 12)
		electricity_level = 12

	// Update power usage:
	if(on)
		update_use_power(USE_POWER_ACTIVE)
		active_power_usage = electricity_level*15
	else
		update_use_power(USE_POWER_OFF)

	// Overload conditions:
	/* // Eeeehhh kinda stupid
	if(on)
		if(electricity_level > 11)
			if(prob(electricity_level))
				explosion(loc, 0, 1, 2, 3) // ooo dat shit EXPLODES son
				spawn(2)
					qdel(src)
	*/

	update_icon()

/obj/machinery/magnetic_module/proc/magnetic_process() // proc that actually does the pull_active
	if(pull_active)
		return
	if(!on)
		return
	if(world.time < next_pull)
		return

	pull_active = TRUE
	center = locate(x+center_x, y+center_y, z)
	if(center)
		for(var/obj/M in orange(magnetic_field, center))
			if(!M.anchored && !(M.atom_flags & NOCONDUCT))
				step_towards(M, center)

		for(var/mob/living/silicon/S in orange(magnetic_field, center))
			if(istype(S, /mob/living/silicon/ai))
				continue
			step_towards(S, center)

	use_power(electricity_level * 5)
	next_pull = world.time + max(0, 13 - electricity_level, 0)
	pull_active = FALSE

/obj/machinery/magnetic_module/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src, freq)
	..()
