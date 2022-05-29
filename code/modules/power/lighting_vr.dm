//TODO: UHHHH NO PLEASE?

/obj/machinery/light_construct
	layer = BELOW_MOB_LAYER

/obj/machinery/light
	layer = BELOW_MOB_LAYER

// Overrides the New() proc further below, since this is a lamp.
/obj/machinery/light/flamp/Initialize(mapload, obj/machinery/light_construct/construct)
	. = ..()
	layer = initial(layer)

// create a new lighting fixture
/obj/machinery/light/Initialize(mapload, obj/machinery/light_construct/construct)
	. = ..()
	// So large mobs stop looking stupid in front of lights.
	if (dir == SOUTH) // Lights are backwards, SOUTH lights face north (they are on south wall)
		layer = ABOVE_MOB_LAYER
