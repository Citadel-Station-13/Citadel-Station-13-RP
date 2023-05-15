/obj/effect/vortex_magic
	/// magic holder
	var/datum/vortex_magic/parent

/obj/effect/vortex_magic/Initialize(mapload, datum/vortex_magic/parent)
	src.parent = parent
	return ..()

/obj/effect/vortex_magic/Destroy()
	parent = null
	return ..()
