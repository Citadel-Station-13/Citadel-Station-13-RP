/datum/unit_test/camera_direction/Run()
	var/list/bad_cameras
	for(var/obj/machinery/camera/C in world)
		if((C.dir == NORTHWEST || SOUTHWEST || NORTHEAST || NORTHWEST) || (C.dir != NORTH||SOUTH||EAST||WEST)) //specifically checking for non NESW dirs..
			bad_cameras[C] = list("X"=C.x, "Y"=C.y, "Z"=C.z, "A"=C.loc.loc) // loc.loc is a lazy way of getting an area.
	if(length(bad_cameras))
		TEST_FAIL("One or more cameras had a non-cardinal direction!")
		for(var/obj/I in bad_cameras)
			TEST_FAIL("[I] at X [bad_cameras[I]["X"]] Y [bad_cameras[I]["Y"]] Z [bad_cameras[I]["Z"]] in area [bad_cameras[I]["A"]]")
		Fail("There were [length(bad_cameras)] cameras with non-cardinal directions.")
