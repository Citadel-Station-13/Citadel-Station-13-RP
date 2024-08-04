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
	//? Global because all walls share the same damage overlays, and the len is constant.
	var/global/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls/damage_masks.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

/// Paints the wall with a new color.
/turf/simulated/wall/proc/paint_wall(new_paint)
	paint_color = new_paint
	update_appearance()

/turf/simulated/wall/proc/paint_stripe(new_paint)
	stripe_color = new_paint
	update_appearance()

/turf/simulated/wall/update_name(updates)
	if(material_reinf)
		name = "reinforced [material_outer.display_name] wall"
	else if(material_outer)
		name = "[material_outer.display_name] wall"
	else
		name = "wall"

	return ..()

/turf/simulated/wall/update_desc(updates)
	if(material_reinf)
		desc = "It seems to be a section of hull reinforced with [material_reinf.display_name] and plated with [material_outer.display_name]."
	else if(material_outer)
		desc = "It seems to be a section of hull plated with [material_outer.display_name]."
	else
		desc = "It seems to be a section of hull."

	return ..()

/turf/simulated/wall/update_icon_state()
	// handle fakewalls
	// TODO: MAKE FAKEWALLS NOT TURFS WTF
	if(!density)
		cached_wall_state = icon_state
		icon_state = "fwall_open"
	else if(icon_state == "fwall_open")
		icon_state = cached_wall_state

	return ..()

/turf/simulated/wall/update_overlays()
	var/wall_paint = paint_color || material_color
	var/stripe_paint = stripe_color || paint_color || material_color

	var/neighbor_stripe = NONE
	for (var/cardinal = NORTH; cardinal <= WEST; cardinal *= 2) //No list copy please good sir
		var/turf/step_turf = get_step(src, cardinal)
		var/can_area_smooth
		CAN_AREAS_SMOOTH(src, step_turf, can_area_smooth)
		if(isnull(can_area_smooth))
			continue
		for(var/atom/movable/movable_thing as anything in step_turf)
			if(GLOB.neighbor_typecache[movable_thing.type])
				neighbor_stripe ^= cardinal
				break

	var/old_cache_key = cache_key
	cache_key = "[icon]:[smoothing_junction]:[wall_paint]:[stripe_icon]:[stripe_paint]:[neighbor_stripe]:[shiny_wall]:[shiny_stripe]:[construction_stage]"
	if(!(old_cache_key == cache_key))

		color = wall_paint

		var/potential_overlays = GLOB.wall_overlays_cache[cache_key]
		if(potential_overlays)
			overlays = potential_overlays
		else
			//? Updating the unmanaged wall overlays (unmanaged for optimisations)
			overlays.len = 0
			var/list/new_overlays = list()

			if(shiny_wall)
				var/image/shine = image(icon, "shine-[smoothing_junction]")
				shine.appearance_flags = RESET_COLOR
				new_overlays += shine

			var/image/smoothed_stripe = image(stripe_icon, icon_state)
			smoothed_stripe.appearance_flags = RESET_COLOR
			smoothed_stripe.color = stripe_paint
			new_overlays += smoothed_stripe

			if(shiny_stripe)
				var/image/stripe_shine = image(stripe_icon, "shine-[smoothing_junction]")
				stripe_shine.appearance_flags = RESET_COLOR
				new_overlays += stripe_shine

			if(neighbor_stripe)
				var/image/neighb_stripe_overlay = image('icons/turf/walls/neighbor_stripe.dmi', "stripe-[neighbor_stripe]")
				neighb_stripe_overlay.appearance_flags = RESET_COLOR
				neighb_stripe_overlay.color = stripe_paint
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
