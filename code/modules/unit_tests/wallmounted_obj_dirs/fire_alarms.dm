/datum/unit_test/fire_alarm_direction/proc/Run()
	var/list/bad_alarms
	for(var/obj/machinery/firealarm/C in world)
		if((C.dir == NORTHWEST || SOUTHWEST || NORTHEAST || NORTHWEST) || (C.dir != NORTH||SOUTH||EAST||WEST))  //specifically checking for non NESW dirs..
			bad_alarms[C] = list("X"=C.x, "Y"=C.y, "Z"=C.z, "A"=C.loc.loc) // loc.loc is a lazy way of getting an area.
	if(length(bad_alarms))
		TEST_FAIL("One or more alarms had a non-cardinal direction!")
		for(var/obj/I in bad_alarms)
			TEST_FAIL("[I] at X [bad_alarms[I]["X"]] Y [bad_alarms[I]["Y"]] Z [bad_alarms[I]["Z"]] in area [bad_alarms[I]["A"]]")
		Fail("There were [length(bad_alarms)] alarms with non-cardinal directions.")
