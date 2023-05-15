/obj/structure/wire
	name = "wirenet joint"
	desc = "the abstract concept of a network cable"

	/// our network
	var/datum/wirenet/network
	/// joined / attempt to have joined?
	var/joined = FALSE
	/// connections
	var/list/datum/wirenet_connection/connections
	/// are we a junction?
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

/obj/structure/wire/setDir(dir)
	return FALSE //! No.

/obj/structure/wire/proc/join()

/obj/structure/wire/proc/leave()

/obj/structure/wire/proc/adjacent_wires()
	return list()

/obj/structure/wire/proc/auto_rebuild()
	if(!isnull(network))
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
