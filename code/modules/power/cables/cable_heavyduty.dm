/obj/item/stack/cable_coil/heavyduty
	name = "heavy cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire"

/obj/structure/cable/heavyduty
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	plane = TURF_PLANE

	#ifndef IN_MAP_EDITOR
	layer = HEAVYDUTY_WIRE_LAYER //Just below pipes
	#else
	layer = ABOVE_TURF_LAYER
	#endif

	color = null

/obj/structure/cable/heavyduty/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(!T.is_plating())
		return

	if(W.is_wirecutter())
		to_chat(usr, "<font color=#4F49AF>These cables are too tough to be cut with those [W.name].</font>")
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		to_chat(usr, "<font color=#4F49AF>You will need heavier cables to connect to these.</font>")
		return
	else
		..()

/obj/structure/cable/heavyduty/cableColor(var/colorC)
	return
