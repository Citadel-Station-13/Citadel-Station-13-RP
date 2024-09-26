// todo: /obj/machinery/stargate
/obj/machinery/gateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands.  It allows for faster than light travel to far-flung locations and even alternate realities."
	icon = 'icons/obj/machines/gateway.dmi'
	// todo: temporary, as this is unbuildable
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	icon_state = "off"
	density = 1
	anchored = 1
	var/active = 0


/obj/machinery/gateway/Initialize(mapload)
	update_icon()
	if(dir == SOUTH)
		density = 0
	. = ..()

/obj/machinery/gateway/update_icon()
	if(active)
		icon_state = "on"
		return
	icon_state = "off"
