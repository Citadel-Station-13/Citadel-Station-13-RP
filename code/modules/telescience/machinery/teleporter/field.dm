/obj/effect/bluespace_field
	name = "bluespace translation field"
	desc = "A projected energy field partially bridging local space with another dimension. Usually used by teleportation machinery."
	#warn sprite

	/// radius from center, starting at 1 for 1x1.
	var/radius = 1
	/// containment mode?
	var/containment = FALSE

#warn impl

/obj/effect/bluespace_field/proc/relevant_contents()
	. = list()
	for(var/atom/movable/AM as anything in range(radius, src))
		if(AM.atom_flags & ATOM_ABSTRACT)
			continue
		. += AM

/obj/effect/bluespace_field/proc/translocate()
	#warn args, finish

/obj/effect/bluespace_field/CheckExit(atom/movable/AM, atom/newLoc)
	. = ..()

/obj/effect/bluespace_field/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()

/obj/effect/bluespace_field/proc/enable_containment()

/obj/effect/bluespace_field/proc/disable_containment()
