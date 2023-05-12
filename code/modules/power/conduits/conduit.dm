
/***
 * Conduits
 * Comes in 2, 3, 4 way's.
 * 2 way: Atmos-pipe-like, normalized towards 1 direction, if diagonal, is bend in that direction.
 * 3 way: the direction is the direction where they have no connection
 * 4 way: No directions, normalized
 * Junction: 1 cardinal direction.
 */
/obj/structure/wire/conduit
	name = "plasma conduit"
	desc = "Ooh, shiny. Better hope this doesn't break."
	#warn icon

	/// stored volume during network rebuild
	var/rebuilding_volume
	/// stored temperature during network rebuild
	var/rebuilding_temperature
	/// stored materials during network rebuild
	var/list/rebuilding_materials

/obj/structure/wire/conduit/proc/vis_key()
	return

/obj/structure/wire/conduit/proc/
