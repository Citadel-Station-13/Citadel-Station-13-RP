/obj/structure/table/bench
	name = "bench frame"
	desc = "It's a bench, for putting things on. Or standing on, if you really want to."
	icon = 'icons/obj/structures/benches/_previews.dmi'
	icon_state = "plain_preview"
	density = FALSE
	can_reinforce = FALSE
	flipped = -1

/obj/structure/table/bench/update_desc()
	if(material)
		name = "[material.display_name] bench"
	else
		name = "bench frame"

/obj/structure/table/bench/CanAllowThrough(atom/movable/mover)
	return 1


//! DELETE THIS SHIT ASAP
//! I literally just copied and modified the shitcode from tables until I do full baked smoothing.
/obj/structure/table/bench/update_appearance()
	. = ..()

	if(flipped != 1)
		icon_state = "blank"
		cut_overlays()

		// Base frame shape. Mostly done for glass/diamond tables, where this is visible.
		for(var/i = 1 to 4)
			var/image/I = get_table_image('icons/obj/structures/benches/frame.dmi', "frame_[connections[i]]", 1<<(i-1))
			add_overlay(I)

		// Standard bench image
		if(material)
			for(var/i = 1 to 4)
				var/image/I = get_table_image(material.bench_icon, "bench_[connections[i]]", 1<<(i-1), material.color, 255 * material.opacity)
				add_overlay(I)

		// Reinforcements
		//! Benches don't have reinforced sprites
		// if(reinforced)
		// 	for(var/i = 1 to 4)
		// 		var/image/I = get_table_image('icons/obj/structures/benches/padding.dmi', "pad_[connections[i]]", 1<<(i-1), reinforced.color, 255 * reinforced.opacity)
		// 		add_overlay(I)

		if(carpeted)
			for(var/i = 1 to 4)
				var/image/I = get_table_image('icons/obj/structures/benches/padding.dmi', "pad_[connections[i]]", 1<<(i-1))
				add_overlay(I)

// set propagate if you're updating a table that should update tables around it too, for example if it's a new table or something important has changed (like material).
/obj/structure/table/bench/update_connections(propagate=0)
	if(!material)
		connections = list("0", "0", "0", "0")
		if(propagate)
			for(var/obj/structure/table/bench/T in orange(src, 1))
				T.update_connections()
				T.update_appearance()
		return

	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in get_turf(src))
		if(W.is_fulltile())
			connections = list("0", "0", "0", "0")
			return
		blocked_dirs |= W.dir

	for(var/D in list(NORTH, SOUTH, EAST, WEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir == GLOB.reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir & GLOB.reverse_dir[D])
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with tables.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()

	for(var/obj/structure/table/bench/T in orange(src, 1))
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs)
			continue
		if(material && T.material && material.name == T.material.name && flipped == T.flipped)
			connection_dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections()
				T.update_appearance()

	connections = dirs_to_corner_states(connection_dirs)
