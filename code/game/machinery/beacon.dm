/obj/machinery/bluespace_beacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "Bluespace Gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	hides_underfloor = OBJ_UNDERFLOOR_UNLESS_CREATED_ONTOP
	hides_underfloor_update_icon = TRUE
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

/obj/machinery/bluespace_beacon/Destroy()
	if(Beacon)
		qdel(Beacon)
	..()

// update the icon_state
/obj/machinery/bluespace_beacon/update_icon_state()
	var/state = "floor_beacon"

	if(invisibility)
		icon_state = "[state]f"
	else
		icon_state = "[state]"
	return ..()

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
