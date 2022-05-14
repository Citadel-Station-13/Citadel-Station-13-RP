// this system is shit change it asap // KEVINZ000 COMMENT

/turf/Entered(atom/movable/AM)
	. = ..()
	if(SSopenspace.initialized && !AM.invisibility && isobj(AM))
		var/turf/T = GetAbove(src)
		if(isopenturf(T))
			// log_debug("[T] ([T.x],[T.y],[T.z]) queued for update for [src].Entered([AM])")
			SSopenspace.add_turf(T, 1)

/turf/Exited(atom/movable/AM)
	..()
	if(SSopenspace.initialized && !AM.invisibility && isobj(AM))
		var/turf/T = GetAbove(src)
		if(isopenturf(T))
			// log_debug("[T] ([T.x],[T.y],[T.z]) queued for update for [src].Exited([AM])")
			SSopenspace.add_turf(T, 1)

///Updates the icon of the obj
/obj/update_icon()
	. = ..()
	if(SSopenspace.initialized && !invisibility && isturf(loc))
		var/turf/T = GetAbove(src)
		if(isopenturf(T))
			// log_debug("[T] ([T.x],[T.y],[T.z]) queued for update for [src].update_icon()")
			SSopenspace.add_turf(T, 1)

///Just as New() we probably should hook Destroy() If we can think of something more efficient, lets hear it.
/obj/Destroy()
	if(SSopenspace.initialized && !invisibility && isturf(loc))
		var/turf/T = GetAbove(src)
		if(isopenturf(T))
			SSopenspace.add_turf(T, 1)
	. = ..() // Important that this be at the bottom, or we will have been moved to nullspace.
