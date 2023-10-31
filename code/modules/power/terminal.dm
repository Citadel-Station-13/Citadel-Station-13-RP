/obj/machinery/power/terminal
	name = "terminal"
	icon_state = "term"
	desc = "It's an underfloor wiring terminal for power equipment."
	level = 1
	anchored = 1
	plane = TURF_PLANE
	layer = EXPOSED_WIRE_TERMINAL_LAYER

	/// host machine
	var/obj/machinery/master

/obj/machinery/power/terminal/Initialize(mapload, newdir, obj/machinery/master)
	. = ..()
	setDir(newdir)
	src.master = master
	var/turf/T = src.loc
	if(level==1)
		hide(!T.is_plating())

/obj/machinery/power/terminal/Destroy()
	if(!isnull(master))
		master.terminal_destroyed(src)
		master = null
	return ..()

/obj/machinery/power/terminal/hide(var/i)
	invisibility = i ? 101 : 0
	icon_state = i ? "term-f" : "term"

/obj/machinery/power/terminal/hides_under_flooring()
	return 1

// Needed so terminals are not removed from machines list.
// Powernet rebuilds need this to work properly.
/obj/machinery/power/terminal/process(delta_time)
	return 1

#warn impl all

/obj/machinery/power/terminal/overload(var/obj/machinery/power/source)
	if(master)
		master.overload(source)

/obj/machinery/power/terminal/proc/bind(obj/machinery/host)
	if(!isnull(master))
		unbind()
	master = host

/obj/machinery/power/terminal/proc/unbind(obj/machinery/host)
	master = null

//? machinery-side API

/obj/machinery/proc/terminal_destroyed(obj/machinery/power/terminal/terminal)
	return
