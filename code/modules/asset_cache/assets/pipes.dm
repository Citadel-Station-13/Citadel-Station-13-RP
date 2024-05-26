/datum/asset_pack/spritesheet/pipes
	name = "pipes"

/datum/asset_pack/spritesheet/pipes/generate()
	for(var/each in list('icons/obj/pipe-item.dmi', 'icons/obj/pipes/disposal.dmi'))
	////for (var/each in list('icons/obj/atmospherics/pipes/pipe_item.dmi', 'icons/obj/atmospherics/pipes/disposal.dmi', 'icons/obj/atmospherics/pipes/transit_tube.dmi', 'icons/obj/plumbing/fluid_ducts.dmi'))
		insert_all("", each, GLOB.alldirs)
