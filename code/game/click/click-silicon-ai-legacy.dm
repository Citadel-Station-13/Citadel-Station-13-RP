/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/living/silicon/ai/DblClickOn(var/atom/A, params)
	#warn obliterate
	if(control_disabled || stat) return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()

/obj/machinery/door/airlock/AIShiftClick(mob/user)  // Opens and closes doors!
	add_hiddenprint(user)
	toggle_open(user)//instead of topic() procs
	return TRUE

/obj/machinery/door/airlock/AICtrlClick(mob/user) // Bolts doors
	add_hiddenprint(user)
	toggle_bolt(user)//apparently this is better than the topic function
	return TRUE

/obj/machinery/door/airlock/AIAltClick(mob/user) // Electrifies doors.
	if(electrified_until)
		electrify(0, 1)
	else
		electrify(-1,1)
	return TRUE

/mob/living/silicon/ai/snowflake_ai_vision_adjacency(var/turf/T)
	return (GLOB.cameranet && GLOB.cameranet.checkTurfVis(T))
