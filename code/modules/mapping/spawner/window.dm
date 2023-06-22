/obj/spawner/window
	icon = 'icons/mapping/spawners/windows.dmi'
	icon_state = "window_grille_pane"
	late = TRUE

	/// spawn full windows or panes on grille?
	var/full_window = FALSE
	/// spawn grille at all?
	var/spawn_grille = TRUE
	/// spawn low wall?
	var/spawn_low_wall = FALSE
	/// full window path
	var/window_full_path = /obj/structure/window/basic/full
	/// pane path
	var/window_pane_path = /obj/structure/window/basic
	/// low wall path
	var/low_wall_path = /obj/structure/wall_frame/prepainted
	/// found dirs
	var/found_dirs = NONE
	/// spawn firedoors? fulltile and non-hidden only for now
	var/firelocks = FALSE
	/// id tag for electrochromics
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
	if(spawn_grille)
		if(locate(/obj/structure/grille) in loc)
			warning("Window spawner at X [x] Y [y] Z [z] is set to spawn a grille, but found one already in it's loc.")
		else
			new /obj/structure/grille(loc)
	if(full_window)
		var/new_window = new window_full_path(loc)
		if (spawn_low_wall)
			new low_wall_path(loc)
		if(id && istype(window_full_path, /obj/structure/window/reinforced/polarized))
			var/obj/structure/window/reinforced/polarized/P = new_window
			P.id = id
	else
		// spawn in dirs not in found dirs
		var/obj/structure/window/W
		for(var/d in GLOB.cardinal)
			if(found_dirs & d)
				continue
			W = new window_pane_path(loc)
			W.setDir(d)
	if(firelocks)
		if(locate(/obj/machinery/door/firedoor) in loc)
			warning("Window spawner at X [x] Y [y] Z [z] is set to spawn firelocks, but found one already in it's loc.")
		else
			new /obj/machinery/door/firedoor(loc)

/obj/spawner/window/firelocks
	icon_state = "window_grille_pane_fire"

/obj/spawner/window/full
	full_window = TRUE
	icon_state = "window_grille_full"

/obj/spawner/window/full/firelocks
	icon_state = "window_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/reinforced
	icon_state = "rwindow_grille_pane"
	window_pane_path = /obj/structure/window/reinforced
	window_full_path = /obj/structure/window/reinforced/full

/obj/spawner/window/reinforced/firelocks
	icon_state = "rwindow_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/reinforced/full
	icon_state = "rwindow_grille_full"
	full_window = TRUE

/obj/spawner/window/reinforced/full/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/reinforced/tinted
	icon_state = "rwindow_grille_pane"
	window_pane_path = /obj/structure/window/reinforced/tinted
	window_full_path = /obj/structure/window/reinforced/tinted/full

/obj/spawner/window/reinforced/tinted/firelocks
	icon_state = "rwindow_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/reinforced/tinted/full
	icon_state = "rwindow_grille_full"
	full_window = TRUE

/obj/spawner/window/reinforced/tinted/full/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE


/obj/spawner/window/borosillicate
	icon_state = "phoron_grille_pane"
	window_pane_path = /obj/structure/window/phoronbasic
	window_full_path = /obj/structure/window/phoronbasic/full

/obj/spawner/window/borosillicate/firelocks
	icon_state = "phoron_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/borosillicate/full
	icon_state = "phoron_grille_full"
	full_window = TRUE

/obj/spawner/window/borosillicate/full/firelocks
	icon_state = "phoron_grille_full"
	firelocks = TRUE

/obj/spawner/window/borosillicate/reinforced
	icon_state = "rphoron_grille_pane"
	window_pane_path = /obj/structure/window/phoronreinforced
	window_full_path = /obj/structure/window/phoronreinforced/full

/obj/spawner/window/borosillicate/reinforced/firelocks
	icon_state = "rphoron_grille_pane_fire"
	firelocks = TRUE

/obj/spawner/window/borosillicate/reinforced/full
	icon_state = "rphoron_grille_full"
	full_window = TRUE

/obj/spawner/window/borosillicate/reinforced/full/firelocks
	icon_state = "rphoron_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall
	spawn_low_wall = TRUE

/obj/spawner/window/low_wall/borosillicate/full
	icon_state = "phoron_grille_full"
	full_window = TRUE
	window_pane_path = /obj/structure/window/phoronbasic
	window_full_path = /obj/structure/window/phoronbasic/full

/obj/spawner/window/low_wall/borosillicate/full/firelocks
	icon_state = "phoron_grille_full"
	firelocks = TRUE

/obj/spawner/window/low_wall/borosillicate/reinforced/full
	icon_state = "rphoron_grille_full"
	full_window = TRUE
	window_pane_path = /obj/structure/window/phoronreinforced
	window_full_path = /obj/structure/window/phoronreinforced/full

/obj/spawner/window/low_wall/borosillicate/reinforced/full/firelocks
	icon_state = "rphoron_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/reinforced/full
	icon_state = "rwindow_grille_full"
	full_window = TRUE
	window_pane_path = /obj/structure/window/reinforced
	window_full_path = /obj/structure/window/reinforced/full

/obj/spawner/window/low_wall/reinforced/full/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/reinforced/tinted/full
	icon_state = "rwindow_grille_full"
	full_window = TRUE
	window_pane_path = /obj/structure/window/reinforced/tinted
	window_full_path = /obj/structure/window/reinforced/tinted/full

/obj/spawner/window/low_wall/reinforced/tinted/full/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/reinforced/electrochromic/full
	icon_state = "rwindow_grille_full"
	full_window = TRUE
	window_pane_path = /obj/structure/window/reinforced/polarized
	window_full_path = /obj/structure/window/reinforced/polarized/full

/obj/spawner/window/low_wall/reinforced/electrochromic/full/firelocks
	icon_state = "rwindow_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/full
	full_window = TRUE
	icon_state = "window_grille_full"

/obj/spawner/window/low_wall/full/firelocks
	icon_state = "window_grille_full_fire"
	firelocks = TRUE

/obj/spawner/window/low_wall/full/nogrille/firelocks
	full_window = TRUE
	icon_state = "window_grille_full"
	spawn_grille = FALSE
	firelocks = TRUE

/obj/spawner/window/low_wall/full/firelocks/nogrille
	icon_state = "window_grille_full"
	firelocks = TRUE
	spawn_grille = FALSE



