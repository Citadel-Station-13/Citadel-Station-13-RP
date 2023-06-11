/obj/machinery/bluespace_beacon
	#warn name, desc, icon, icon state

	allow_deconstruct = TRUE
	allow_unanchor = TRUE

	/// our internal, actual beacon. this saves us needing to duplicate code.
	var/obj/item/bluespace_beacon/beacon

#warn circuit

/obj/machinery/bluespace_beacon
	name = "bluespace gigabeacon"
	desc = "A beacon that draws a large amount of energy to create a pinhole into bluespace and transmit tracking data to nearby receivers. As unwieldly as this is, this piece of technology is still the backbone of modern translocation technology."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	level = 1		// underfloor
	layer = UNDER_JUNK_LAYER
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	var/obj/item/radio/beacon/Beacon

/obj/machinery/bluespace_beacon/Initialize(mapload, newdir)
	. = ..()
	var/turf/T = src.loc
	Beacon = new /obj/item/radio/beacon
	Beacon.invisibility = INVISIBILITY_MAXIMUM
	Beacon.loc = T

	hide(!T.is_plating())

/obj/machinery/bluespace_beacon/Destroy()
	if(Beacon)
		qdel(Beacon)
	..()

// update the invisibility and icon
/obj/machinery/bluespace_beacon/hide(intact)
	invisibility = intact ? 101 : 0
	update_icon()

// update the icon_state
/obj/machinery/bluespace_beacon/update_icon()
	var/state = "floor_beacon"

	if(invisibility)
		icon_state = "[state]f"
	else
		icon_state = "[state]"

/obj/machinery/bluespace_beacon/process(delta_time)
	if(!Beacon)
		var/turf/T = src.loc
		Beacon = new /obj/item/radio/beacon
		Beacon.invisibility = INVISIBILITY_MAXIMUM
		Beacon.loc = T
	if(Beacon)
		if(Beacon.loc != src.loc)
			Beacon.loc = src.loc

	update_icon()

#warn circuit

/obj/machinery/bluespace_beacon/pylon
	name = "experimental lensing beacon"
	desc = "An unreasonably expensive and fragile piece of technology used to act as a passive locator signal. While most teleportation beacons are powered, this one instead reflects pulses sent by specialized mahcinery to provide locking information."
