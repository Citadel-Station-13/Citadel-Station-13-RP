/obj/machinery/bluespace_beacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "Bluespace Gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	layer = UNDER_JUNK_LAYER
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	var/obj/item/radio/beacon/Beacon

/obj/machinery/bluespace_beacon/Initialize(mapload, newdir)
	. = ..()
	var/turf/T = loc
	Beacon = new(T)
	Beacon.invisibility = INVISIBILITY_MAXIMUM

	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

/obj/machinery/bluespace_beacon/Destroy()
	QDEL_NULL(Beacon)
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
