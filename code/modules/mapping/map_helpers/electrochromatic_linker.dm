/obj/map_helper/electrochromatic_linker
	icon = 'icons/mapping/helpers/electrochromatic_helper.dmi'
	icon_state = "electrochromatic"
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
	qdel(src)
