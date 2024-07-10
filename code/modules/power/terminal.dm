/**
 * basically, a good way to interface with powernet
 * without connecting to a node under yourself
 *
 * works at /obj level
 *
 * todo: this shouldn't require adjacency to the machine for icon, we should be able to make terminal anywhere up to 2 tiles away
 */
/obj/machinery/power/terminal
	name = "terminal"
	icon_state = "term"
	desc = "It's an underfloor wiring terminal for power equipment."
	anchored = 1
	plane = TURF_PLANE
	layer = EXPOSED_WIRE_TERMINAL_LAYER
	hides_underfloor = OBJ_UNDERFLOOR_ALWAYS

	/// host machine
	var/obj/master

/obj/machinery/power/terminal/Initialize(mapload, new_dir, obj/master)
	. = ..()
	if(master)
		bind(master)

/obj/machinery/power/terminal/Destroy()
	unbind()
	return ..()

/obj/machinery/power/terminal/update_hiding_underfloor(new_value)
	. = ..()
	update_icon()

/obj/machinery/power/terminal/update_icon_state()
	if(is_probably_hidden_underfloor())
		icon_state = "term-f"
	else
		icon_state = "term"
	return ..()

/obj/machinery/power/terminal/proc/bind(obj/host)
	if(!isnull(master))
		unbind()
	if(!host)
		return
	master = host

/obj/machinery/power/terminal/proc/unbind()
	if(!master)
		return
	master = null

//* /obj API *//

/obj/proc/terminal_bound(obj/machinery/power/terminal/terminal)
	return

/obj/proc/terminal_unbound(obj/machinery/power/terminal/terminal)
	return
