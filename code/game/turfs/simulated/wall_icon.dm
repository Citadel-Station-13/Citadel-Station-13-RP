/**
 * generates damage overlays
 */

GLOBAL_LIST_INIT(neighbor_typecache, typecacheof(list(
	/obj/machinery/door/airlock,
	/obj/machinery/door/firedoor,
	/obj/machinery/door/blast,
	/obj/structure/filler_object,
	/obj/structure/window/reinforced/tinted/full,
	/obj/structure/window/reinforced/full,
	/obj/structure/window/phoronreinforced/full,
	/obj/structure/window/phoronbasic/full,
	/obj/structure/window/basic/full,
	/obj/structure/window/reinforced/polarized/full,
	/obj/structure/wall_frame,
	/obj/machinery/smartfridge,
	)))

GLOBAL_LIST_EMPTY(wall_overlays_cache)

/turf/simulated/wall/proc/generate_wall_damage_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls/damage_masks.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img


/turf/simulated/wall/proc/get_wall_icon()
	. = (istype(material) && material.icon_base) || 'icons/turf/walls/solid_wall.dmi'


/turf/simulated/wall/proc/apply_reinf_overlay()
	. = istype(reinf_material)


/turf/simulated/wall/update_appearance(updates)
	. = ..()
	if(!istype(material))
		return

	if(!color)
		color = material.icon_colour


/turf/simulated/wall/update_icon()
	. = ..()
	update_overlays()

/turf/simulated/wall/update_icon_state()
	. = ..()

	// handle fakewalls
	// TODO: MAKE FAKEWALLS NOT TURFS WTF
	if(!density)
		cached_wall_state = icon_state
		icon_state = "fwall_open"
	else if(icon_state == "fwall_open")
		icon_state = cached_wall_state

/turf/simulated/wall/proc/update_overlays_delayed()
	update_overlays()

/turf/simulated/wall/update_overlays()
	if (material == initial(material))
		addtimer(CALLBACK(src, /turf/simulated/wall/proc/update_overlays_delayed), 1 SECOND) //our material datum has not been instanced, so we'll runtime about 2 lines down.
		return
	icon = material.icon_base
	if(reinf_material)
		icon = material.icon_reinf
	var/plating_color = paint_color || material?.icon_colour || COLOR_WALL_GUNMETAL //fallback in case things are really fucked.
	stripe_color = stripe_color || paint_color || material.icon_colour

	var/neighbor_stripe = NONE
	for (var/cardinal = NORTH; cardinal <= WEST; cardinal *= 2) //No list copy please good sir
		var/turf/step_turf = get_step(src, cardinal)
		if(!can_area_smooth(step_turf))
			continue
		for(var/atom/movable/movable_thing as anything in step_turf)
			if(GLOB.neighbor_typecache[movable_thing.type])
				neighbor_stripe ^= cardinal
				break

	var/old_cache_key = cache_key
	cache_key = "[icon]:[smoothing_junction]:[plating_color]:[stripe_icon]:[stripe_color]:[neighbor_stripe]:[shiny_wall]:[shiny_stripe]:[construction_stage]"
	if(!(old_cache_key == cache_key))

		var/potential_overlays = GLOB.wall_overlays_cache[cache_key]
		if(potential_overlays)
			overlays = potential_overlays
			color = plating_color
		else
			color = plating_color
			//Updating the unmanaged wall overlays (unmanaged for optimisations)
			overlays.len = 0
			var/list/new_overlays = list()

			if(shiny_wall)
				var/image/shine = image(icon, "shine-[smoothing_junction]")
				shine.appearance_flags = RESET_COLOR
				new_overlays += shine

			var/image/smoothed_stripe = image(stripe_icon, icon_state)
			smoothed_stripe.appearance_flags = RESET_COLOR
			smoothed_stripe.color = stripe_color
			new_overlays += smoothed_stripe

			if(shiny_stripe)
				var/image/stripe_shine = image(stripe_icon, "shine-[smoothing_junction]")
				stripe_shine.appearance_flags = RESET_COLOR
				new_overlays += stripe_shine

			if(neighbor_stripe)
				var/image/neighb_stripe_overlay = image('icons/turf/walls/neighbor_stripe.dmi', "stripe-[neighbor_stripe]")
				neighb_stripe_overlay.appearance_flags = RESET_COLOR
				neighb_stripe_overlay.color = stripe_color
				new_overlays += neighb_stripe_overlay
				if(shiny_wall)
					var/image/shine = image('icons/turf/walls/neighbor_stripe.dmi', "shine-[neighbor_stripe]")
					shine.appearance_flags = RESET_COLOR
					new_overlays += shine
/*
			if(construction_stage != 6)
				var/image/decon_overlay = image('icons/turf/walls/decon_states.dmi', "[construction_stage]")
				decon_overlay.appearance_flags = RESET_COLOR
				new_overlays += decon_overlay
*/
			overlays = new_overlays
			GLOB.wall_overlays_cache[cache_key] = new_overlays

	//And letting anything else that may want to render on the wall to work (ie components)
	return ..()
