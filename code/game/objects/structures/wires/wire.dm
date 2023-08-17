/obj/structure/wire
	name = "wirenet joint"
	desc = "the abstract concept of a network cable"

	/// our network
	var/datum/wirenet/network
	/// joined / attempt to have joined?
	var/joined = FALSE
	/// connections
	var/list/datum/wirenet_connection/connections
	/// are we a junction? mostly used on power cables
	var/is_junction = FALSE

/obj/structure/wire/Initialize(mapload)
	join()
	var/turf/T = src.loc // hide if turf is not intact
	if(level==1 && T)
		hide(!T.is_plating())
	return ..()

/obj/structure/wire/Destroy()
	leave()
	return ..()

/obj/structure/wire/examine(mob/user, dist)
	. = ..()
	if(isobserver(user))
		if(isnull(network))
			. += SPAN_WARNING("[src] is not connected to a wirenet. It may be rebuilding, or this might be a bug.")
		else
			. += SPAN_WARNING("[src] is connected to a wirenet with [length(network.segments)] wire objects and [length(network.connections)] connected entities.")
		. += SPAN_NOTICE("[src] has [length(connections)] entites directly connected to it on its (or a hopefully nearby) tile.")

/obj/structure/wire/setDir(dir)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE //! No.

/obj/structure/wire/proc/join()
	#warn impl

/obj/structure/wire/proc/leave()
	#warn impl

/obj/structure/wire/proc/set_junction(is_junction)
	if(is_junction == src.is_junction)
		return
	src.is_junction = is_junction
	#warn deal wtih connections

/obj/structure/wire/proc/adjacent_wires()
	return list()

/obj/structure/wire/proc/auto_rebuild()
	if(!isnull(network) || !joined)
		return
	rebuild()

/obj/structure/wire/proc/rebuild()
	CRASH("base rebuild called on wire")

/obj/structure/wire/hide(hiding)
	// todo: refactor underfloor hiding system
	if(hiding)
		invisibility = INVISIBILITY_MAXIMUM
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		alpha = 127
	else
		invisibility = INVISIBILITY_NONE
		mouse_opacity = MOUSE_OPACITY_ICON
		alpha = 255

/obj/structure/wire/hides_under_flooring()
	return TRUE
