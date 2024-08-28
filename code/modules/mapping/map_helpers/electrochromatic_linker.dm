/obj/map_helper/electrochromatic_linker
	icon = 'icons/mapping/helpers/access_helpers.dmi'
	icon_state = "science"
	early = FALSE
	late = TRUE
	/**
	* the ID to bind electrochromatic objects on our tile to
	*/
	var/id

/obj/map_helper/electrochromatic_linker/LateInitialize()
	for(var/obj/structure/window/reinforced/polarized/chromatic_window in loc)
		chromatic_window.id = id
	/**
	 * Same behaviour needs to be applied to polarised airlocks, currently unable too
	 */
	return qdel(src)
