/obj/effect/falling_effect
	name = "you should not see this"
	desc = "no data"
	invisibility = 101
	anchored = TRUE
	density = FALSE
	unacidable = TRUE
	var/falling_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	var/crushing = TRUE

/obj/effect/falling_effect/Initialize(mapload)
	. = ..()
	new falling_type(src)
	var/atom/movable/dropped = pick(contents) // Stupid, but allows to get spawn result without efforts if it is other type(Or if it was randomly generated).
	dropped.loc = get_turf(src)
	var/initial_x = dropped.pixel_x
	var/initial_y = dropped.pixel_y
	dropped.plane = 1
	dropped.pixel_x = rand(-150, 150)
	dropped.pixel_y = 500 // When you think that pixel_z is height but you are wrong
	dropped.density = FALSE
	dropped.opacity = FALSE
	animate(dropped, pixel_y = initial_y, pixel_x = initial_x , time = 7)
	addtimer(CALLBACK(dropped, /atom/movable.proc/end_fall), 7)
	return INITIALIZE_HINT_QDEL

/atom/movable/proc/end_fall(var/crushing = FALSE)
	if(crushing)
		for(var/atom/movable/AM in loc)
			if(AM != src)
				LEGACY_EX_ACT(AM, 1, null)
				explosion(src.loc, 0, 0, 1, 1, 0)

	for(var/mob/living/M in oviewers(3, src))
		shake_camera(M, 2, 2)

	playsound(src, 'sound/effects/meteorimpact.ogg', 50, 1)
	density = initial(density)
	opacity = initial(opacity)
	plane = initial(plane)

/obj/effect/falling_effect/singularity_act()
	return

/obj/effect/falling_effect/singularity_pull()
	return

/obj/effect/falling_effect/legacy_ex_act()
	return
