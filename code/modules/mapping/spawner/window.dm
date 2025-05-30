/obj/spawner/window
	icon = 'icons/mapping/spawners/windows.dmi'
	icon_state = "window_grille_pane"
	layer = WINDOW_LAYER

	/// found dirs
	var/found_dirs = NONE

	/// spawn full windows or panes on grille?
	var/full_window = FALSE
	/// full window path
	var/window_full_path = /obj/structure/window/basic/full
	/// pane path
	var/window_pane_path = /obj/structure/window/basic

	/// spawn grille at all?
	var/spawn_grille = TRUE

	/// spawn low wall?
	/// * requires full window
	var/spawn_low_wall = FALSE
	/// low wall path
	var/low_wall_path = /obj/structure/wall_frame/prepainted
	/// low-wall stripe color
	/// * if non-null, will override stripe color on the low-wall
	var/low_wall_stripe_color

	/// spawn firedoors? fulltile and non-hidden only for now
	var/firelocks = FALSE
	/// spawn glass firedoors?
	var/firelocks_use_glass = FALSE

	/// id tag for electrochromics
	/// todo: rename to electrochromatic_id
	var/id

/obj/spawner/window/Initialize(mapload)
	if(!full_window)
		find_dirs()
	return ..()

/obj/spawner/window/proc/find_dirs()
	for(var/d in GLOB.cardinal)
		var/obj/spawner/window/WS = locate() in get_step(src, d)
		if(WS)
			found_dirs |= d

/obj/spawner/window/Spawn()
	// no more mercy, if you fuck up your spawner placement on purpose
	// this will just tear a hole in your map so you notice faster
	if(locate(/obj/structure/window) in loc)
		CRASH("Window spawner at [audit_loc()] on turf with existing window.")
	if(spawn_grille)
		if(locate(/obj/structure/grille) in loc)
			CRASH("Window spawner at [audit_loc()] is set to spawn a grille, but found one already in it's loc.")
		new /obj/structure/grille(loc)
	if(full_window)
		if (spawn_low_wall)
			if(locate(/obj/structure/wall_frame) in loc)
				CRASH("Window spawner at [audit_loc()] is set to spawn low wall but found one already in turf")
			var/obj/structure/wall_frame/low_wall = new low_wall_path(loc)
			if(!isnull(low_wall_stripe_color))
				low_wall.stripe_color = low_wall_stripe_color

		var/new_window = new window_full_path(loc)
		if(id && istype(new_window, /obj/structure/window/reinforced/polarized))
			var/obj/structure/window/reinforced/polarized/P = new_window
			P.id = id
	else
		// spawn in dirs not in found dirs
		for(var/d in GLOB.cardinal)
			if(found_dirs & d)
				continue
			new window_pane_path(loc, d)
	if(firelocks)
		if(locate(/obj/machinery/door/firedoor) in loc)
			CRASH("Window spawner at X [audit_loc()] is set to spawn firelocks, but found one already in it's loc.")
		new /obj/machinery/door/firedoor(loc)

/obj/spawner/window/firelocks
	icon_state = "window_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/full
	full_window = TRUE
	icon_state = "window_grille_full"

/obj/spawner/window/full/firelocks
	icon_state = "window_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/full/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/reinforced
	icon_state = "rwindow_grille_pane"
	window_pane_path = /obj/structure/window/reinforced
	window_full_path = /obj/structure/window/reinforced/full

/obj/spawner/window/reinforced/firelocks
	icon_state = "rwindow_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/reinforced/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/reinforced/full
	icon_state = "rwindow_grille_full"
	full_window = TRUE

/obj/spawner/window/reinforced/full/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/reinforced/full/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/reinforced/tinted
	icon_state = "rwindow_grille_pane"
	window_pane_path = /obj/structure/window/reinforced/tinted
	window_full_path = /obj/structure/window/reinforced/tinted/full

/obj/spawner/window/reinforced/tinted/firelocks
	icon_state = "rwindow_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/reinforced/tinted/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/reinforced/tinted/full
	icon_state = "rwindow_grille_full"
	full_window = TRUE

/obj/spawner/window/reinforced/tinted/full/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/reinforced/tinted/full/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/borosillicate
	icon_state = "phoron_grille_pane"
	window_pane_path = /obj/structure/window/phoronbasic
	window_full_path = /obj/structure/window/phoronbasic/full

/obj/spawner/window/borosillicate/firelocks
	icon_state = "phoron_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/borosillicate/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/borosillicate/full
	icon_state = "phoron_grille_full"
	full_window = TRUE

/obj/spawner/window/borosillicate/full/firelocks
	firelocks = TRUE

/obj/spawner/window/borosillicate/full/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/borosillicate/reinforced
	icon_state = "rphoron_grille_pane"
	window_pane_path = /obj/structure/window/phoronreinforced
	window_full_path = /obj/structure/window/phoronreinforced/full

/obj/spawner/window/borosillicate/reinforced/firelocks
	icon_state = "rphoron_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/borosillicate/reinforced/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/borosillicate/reinforced/full
	icon_state = "rphoron_grille_full"
	full_window = TRUE

/obj/spawner/window/borosillicate/reinforced/full/firelocks
	icon_state = "rphoron_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/borosillicate/reinforced/full/firelocks/transparent
	firelocks_use_glass = TRUE

/**
 * * Implicitly full windows
 */
/obj/spawner/window/low_wall
	spawn_low_wall = TRUE
	full_window = TRUE

/obj/spawner/window/low_wall/borosillicate
	icon_state = "phoron_grille_full"
	window_full_path = /obj/structure/window/phoronbasic/full

/obj/spawner/window/low_wall/borosillicate/firelocks
	firelocks = TRUE

/obj/spawner/window/low_wall/borosillicate/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/low_wall/borosillicate/reinforced
	icon_state = "rphoron_grille_full"
	window_full_path = /obj/structure/window/phoronreinforced/full

/obj/spawner/window/low_wall/borosillicate/reinforced/firelocks
	icon_state = "rphoron_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/borosillicate/reinforced/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/low_wall/reinforced
	icon_state = "rwindow_grille_full"
	window_full_path = /obj/structure/window/reinforced/full

/obj/spawner/window/low_wall/reinforced/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/reinforced/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/low_wall/reinforced/tinted
	icon_state = "rwindow_grille_full"
	full_window = TRUE
	window_full_path = /obj/structure/window/reinforced/tinted/full

/obj/spawner/window/low_wall/reinforced/tinted/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/reinforced/tinted/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/low_wall/reinforced/electrochromic
	icon_state = "rwindow_grille_full"
	window_pane_path = /obj/structure/window/reinforced/polarized
	window_full_path = /obj/structure/window/reinforced/polarized/full

/obj/spawner/window/low_wall/reinforced/electrochromic/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/reinforced/electrochromic/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/low_wall
	icon_state = "window_grille_full"

/obj/spawner/window/low_wall/firelocks
	icon_state = "window_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/firelocks/transparent
	firelocks_use_glass = TRUE

/obj/spawner/window/low_wall/nogrille/firelocks
	icon_state = "window_grille_full"
	spawn_grille = FALSE
	firelocks = TRUE

/obj/spawner/window/low_wall/nogrille/firelocks/transparent
	firelocks_use_glass = TRUE
