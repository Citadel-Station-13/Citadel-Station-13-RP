/obj/machinery/smuggling/input
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	name = "Input area"
	density = FALSE
	anchored = TRUE

/obj/machinery/smuggling/input/Initialize(mapload)
	icon_state = "blank"
	. = ..()
