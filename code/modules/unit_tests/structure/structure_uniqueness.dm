
/datum/unit_test/orphan_uniqueness/Run()
	var/list/solitary_objects = list( //Some objects should never have more than one of their kind in a tile.
	/obj/structure/window, //special case: the check for this one should check xyz.fulltile because panes exist.
	/obj/structure/grille,
	/obj/machinery/door/firedoor,
	/obj/machinery/door/airlock,
	)
	var/list/failed_tiles = list()
	var/list/init_string_list = list()
	for(var/obj/C in world)
		if((!C.type in solitary_objects))
			continue
		var/test_type = C
		var/turf/test_loc = get_turf(C)
		var/amt_in_turf = 0
		for(var/obj/O in test_loc.contents)
			if(istype(O.type,/obj/structure/window))
				var/obj/structure/window/W = O
				if(W.fulltile)
					amt_in_turf++
				else
					continue
			if(O.type == test_type)
				amt_in_turf++
			if(amt_in_turf >= 1)
				TEST_FAIL("The [test_loc] at X [test_loc.x] Y [test_loc.y] Z [test_loc.z] contained multiple solitary objects of the same type.")
				if(!(test_loc in failed_tiles))
					failed_tiles[test_loc] = list()
				if(!(C in failed_tiles[test_loc]))
					failed_tiles[test_loc] += C
				failed_tiles[test_loc][C] = amt_in_turf

	for(var/turf/T in failed_tiles)
		init_string_list += "Tile [T] at [T.x] Y [T.y] Z [T.z] had"
		for(var/obj/M in failed_tiles[T])
			init_string_list += "[failed_tiles[T][M]] [M.name](s)"
		TEST_FAIL(jointext(init_string_list, ","))
