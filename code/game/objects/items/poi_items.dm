
/obj/item/poi
	icon = 'icons/obj/objects.dmi'
	desc = "This is definitely something cool."

/obj/item/poi/pascalb
	icon_state = "pascalb"
	name = "misshapen manhole cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B - 1957'."

/obj/item/poi/pascalb/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/poi/pascalb/process(delta_time)
	radiation_pulse(src, RAD_INTENSITY_POI_MANHOLE_COVER)

/obj/item/poi/pascalb/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/closet/crate/oldreactor
	name = "fission reactor rack"
	desc = "Used in older models of nuclear reactors, essentially a cooling rack for high volumes of radioactive material."
	icon = 'icons/obj/objects.dmi'
	icon_state = "poireactor"
	icon_opened = "poireactor_open"
	icon_closed = "poireactor"

	starts_with = list(
		/obj/item/fuel_assembly/deuterium = 6)

/obj/item/poi/brokenoldreactor
	icon_state = "poireactor_broken"
	name = "ruptured fission reactor rack"
	desc = "This broken hunk of machinery looks extremely dangerous."

/obj/item/poi/brokenoldreactor/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/poi/brokenoldreactor/process(delta_time)
	radiation_pulse(src, RAD_INTENSITY_POI_REACTOR_RACK)

/obj/item/poi/brokenoldreactor/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

