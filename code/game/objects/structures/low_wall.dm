GLOBAL_LIST_INIT(wallframe_typecache, typecacheof(list(
	/obj/structure/window/reinforced/tinted/full,
	/obj/structure/window/reinforced/full,
	/obj/structure/window/phoronreinforced/full,
	/obj/structure/window/phoronbasic/full,
	/obj/structure/window/basic/full,
	/obj/structure/window/reinforced/polarized/full,
	/obj/machinery/door/airlock,
	/obj/structure/grille,
	/obj/machinery/smartfridge,
	/turf/simulated/wall,
	)))

/obj/structure/wall_frame
	name = "low wall"
	desc = "A low wall, with space to mount windows or grilles on top of it."
	icon = 'icons/obj/structures/low_wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	color = "#57575c" //To display in mapping softwares
	density = TRUE
	anchored = TRUE
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_THROWN
	layer = LOW_WALL_LAYER
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_LOW_WALL)
	canSmoothWith = (SMOOTH_GROUP_AIRLOCK+SMOOTH_GROUP_LOW_WALL+SMOOTH_GROUP_WALLS)
	depth_projected = TRUE
	depth_level = 8
	climb_allowed = TRUE
	climb_delay = 2.0 SECONDS
	plane = OBJ_PLANE
	material_parts = /datum/material/steel
	material_primary = MATERIAL_PART_DEFAULT
	material_costs = SHEET_MATERIAL_AMOUNT * 2

	var/paint_color
	var/stripe_color
	var/str
	var/static/list/airlock_typecache
	var/shiny_stripe
	var/health
	var/max_health
	var/material_color = TRUE

/obj/structure/wall_frame/prepainted
	paint_color = COLOR_WALL_GUNMETAL
	stripe_color = COLOR_WALL_GUNMETAL

/obj/structure/wall_frame/Initialize(mapload, material)
	if(!isnull(material))
		set_primary_material(SSmaterials.resolve_material(material))
	. = ..()
	update_overlays()

/obj/structure/wall_frame/update_material_single(datum/material/material)
	. = ..()
	name = "[material.display_name] [initial(name)]"
	set_multiplied_integrity(material.relative_integrity)

/obj/structure/wall_frame/update_overlays()
	cut_overlays()

	var/datum/material/const_material = get_primary_material()
	color = const_material.icon_colour

	var/image/smoothed_stripe = image(const_material.wall_stripe_icon, icon_state, layer = ABOVE_WINDOW_LAYER)
	smoothed_stripe.appearance_flags = RESET_COLOR
	smoothed_stripe.color = stripe_color || const_material.icon_colour
	add_overlay(smoothed_stripe)

	if(!GLOB.wallframe_typecache)
		GLOB.wallframe_typecache = typecacheof(list(/obj/machinery/door/airlock))
	var/neighbor_stripe = NONE
	for(var/cardinal in GLOB.cardinal)
		var/turf/step_turf = get_step(src, cardinal)
		var/obj/structure/wall_frame/neighbor = locate() in step_turf
		if(neighbor)
			continue
		if(!can_area_smooth(step_turf))
			continue
		for(var/atom/movable/movable_thing as anything in step_turf)
			if(GLOB.wallframe_typecache[movable_thing.type])
				neighbor_stripe ^= cardinal
				break
		if(GLOB.wallframe_typecache[step_turf.type])
			neighbor_stripe ^= cardinal

	if(neighbor_stripe)
		var/image/neighb_stripe_overlay = new ('icons/turf/walls/neighbor_stripe.dmi', "stripe-[neighbor_stripe]", layer = ABOVE_WINDOW_LAYER)
		neighb_stripe_overlay.appearance_flags = RESET_COLOR
		neighb_stripe_overlay.color = stripe_color || const_material.icon_colour
		add_overlay(neighb_stripe_overlay)
		if(shiny_stripe)
			var/image/shine = image('icons/turf/walls/neighbor_stripe.dmi', "shine-[smoothing_junction]")
			shine.appearance_flags = RESET_COLOR
			add_overlay(shine)

	return ..()

/obj/structure/wall_frame/CanAllowThrough(atom/movable/mover, turf/target)
	if(istype(mover,/obj/projectile))
		return TRUE
	if(istype(mover) && mover.check_pass_flags(ATOM_PASS_TABLE))
		return TRUE

/obj/structure/wall_frame/attackby(var/obj/item/I, var/mob/user)

	. = ..()
	if(!.)
		//grille placing
		if(istype(I, /obj/item/stack/rods))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == get_dir(src, user))
					to_chat(user, SPAN_WARNING("There is a window in the way."))
					return TRUE
			place_grille(user, loc, I)
			return TRUE

		//window placing
		if(istype(I,/obj/item/stack/material/glass))
			var/obj/item/stack/material/ST = I
			if(ST.material.opacity <= 0.7)
				place_window(user, loc, ST, TRUE, TRUE)
			return TRUE

		if(I.is_wrench())
			if(do_after(user,40 * I.tool_speed))
				playsound(src, I.tool_sound, 100, 1)
				deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)

/obj/structure/wall_frame/drop_products(method, atom/where)
	. = ..()
	var/datum/material/made_of = get_primary_material()
	made_of?.place_sheet(where, 2)
