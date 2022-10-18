/datum/asset/spritesheet/pipes
	name = "pipes"

/datum/asset/spritesheet/pipes/create_spritesheets()
	for(var/each in list('icons/obj/pipe-item.dmi', 'icons/obj/pipes/disposal.dmi'))
	////for (var/each in list('icons/machinery/atmospherics/pipes/pipe_item.dmi', 'icons/machinery/atmospherics/pipes/disposal.dmi', 'icons/machinery/atmospherics/pipes/transit_tube.dmi', 'icons/obj/plumbing/fluid_ducts.dmi'))
		InsertAll("", each, GLOB.alldirs)
