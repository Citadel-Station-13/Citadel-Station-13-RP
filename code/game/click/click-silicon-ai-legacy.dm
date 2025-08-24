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

/mob/living/silicon/ai/ClickOn(var/atom/A, params)
#warn obliterate
	if(aiCamera.in_camera_mode)
		aiCamera.camera_mode_off()
		aiCamera.captureimage(A, usr)
		return

	A.add_hiddenprint(src)
	A.attack_ai(src)

/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/UnarmedAttack(atom/A)
	A.attack_ai(src)
/mob/living/silicon/ai/RangedAttack(atom/A)
	A.attack_ai(src)

/atom/proc/attack_ai(mob/user as mob)
	return

/obj/machinery/door/airlock/AIShiftClick(mob/user)  // Opens and closes doors!
	add_hiddenprint(user)
	toggle_open(user)//instead of topic() procs
	return TRUE

/obj/machinery/door/airlock/AICtrlClick(mob/user) // Bolts doors
	add_hiddenprint(user)
	toggle_bolt(user)//apparently this is better than the topic function
	return TRUE

/obj/machinery/door/airlock/AIMiddleClick(mob/user) // Toggles door bolt lights.
	if(..())
		return
	add_hiddenprint(user)
	if(wires.is_cut(WIRE_BOLT_LIGHT))
		to_chat(user, "The lights are not responsive to your command.")
		return
	lights = !lights
	to_chat(user, SPAN_NOTICE("Lights are now [lights ? "enabled." : "disabled."]"))
	update_icon()
	return TRUE

/obj/machinery/door/airlock/AIAltClick(mob/user) // Electrifies doors.
	if(electrified_until)
		electrify(0, 1)
	else
		electrify(-1,1)
	return TRUE

/obj/machinery/power/apc/AICtrlClick(mob/user) // turns off/on APCs.
	add_hiddenprint(user)
	toggle_breaker(user)
	return TRUE

/obj/machinery/turretid/AICtrlClick(mob/user) //turns off/on Turrets
	add_hiddenprint(user)
	enabled = !enabled //toggles the turret on/off
	return TRUE

/obj/machinery/turretid/AIAltClick(mob/user) //toggles lethal on turrets
	add_hiddenprint(user)
	lethal = !lethal
	return TRUE

#warn what the fuck this is for alt click listed turf it shouldn't override base turf adjacent!!
/mob/living/silicon/ai/snowflake_ai_vision_adjacency(var/turf/T)
	return (GLOB.cameranet && GLOB.cameranet.checkTurfVis(T))
