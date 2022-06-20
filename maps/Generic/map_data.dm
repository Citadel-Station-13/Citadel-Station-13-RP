// These specify how many z levels are in a map. Consoladating them here for map compiling ease - Bloop

// Tether
/obj/landmark/map_data/virgo3b
    height = 6

/obj/effect/overmap/visitable/sector/virgo3b // Just a placeholder for when the map isnt loaded

// Triumph
/obj/landmark/map_data/triumph
	height = 4

// Lythios
/obj/landmark/map_data/lythios43c
    height = 6

/obj/landmark/map_data/west_plains
    height = 4

// See beach.dm for more details on this. Placeholder for now to stop compiling issues -Bloop
/obj/away_mission_init/beachcave
	name = "away mission initializer - beachcave"




// Gonna go ahead and add a copy of this here since I've seen it used on both stations so far. Might as well keep a copy of it, will have to as silicon if
// we should just put this in the supermatter's dm file

/*
// Our map is small, if the supermatter is ejected lets not have it just blow up somewhere else
/obj/machinery/power/supermatter/touch_map_edge()
	qdel(src)
*/
