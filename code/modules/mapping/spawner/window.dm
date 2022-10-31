/obj/spawner/window
	icon = 'icons/mapping/spawners/windows.dmi'
	icon_state = "window_grille_pane"
	late = TRUE

	/// spawn full windows or panes on grille?
	var/full_window = FALSE
	/// spawn grille at all?
	var/spawn_grille = TRUE
	/// full window path
	var/window_full_path = /obj/structure/window/basic/full
	/// pane path
	var/window_pane_path = /obj/structure/window/basic
	/// found dirs
	var/found_dirs = NONE
	/// spawn firedoors? fulltile and non-hidden only for now
	var/firelocks = FALSE

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
		new /obj/structure/grille(loc)
	if(full_window)
		new window_full_path(loc)
	else
		// spawn in dirs not in found dirs
		var/obj/structure/window/W
		for(var/d in GLOB.cardinal)
			if(found_dirs & d)
				continue
			W = new window_pane_path(loc)
			W.setDir(d)
	if(firelocks)
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
