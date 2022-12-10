/**
 * AI ClickOn()
 *
 * The AI can double click to move the camera (this was already true but is cleaner),
 * or double click a mob to track them.
 *
 * Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
 */
/mob/living/silicon/ai/DblClickOn(atom/A, params)
	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	if(control_disabled || stat)
		return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()


/mob/living/silicon/ai/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	if(stat)
		return

	var/list/modifiers = params2list(params)

	// if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, A, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
	// 	return

	if(!can_interact_with(A))
		return


	if(control_disabled || !canClick())
		return

	var/turf/pixel_turf = get_turf_pixel(A)
	if(isnull(pixel_turf))
		return
	if(!can_see(A))
		return

	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlShiftClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, ALT_CLICK)) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		CtrlClickOn(A)
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		var/secondary_result = A.attack_ai_secondary(src, modifiers)
		if(secondary_result == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || secondary_result == SECONDARY_ATTACK_CONTINUE_CHAIN)
			return
		else if(secondary_result != SECONDARY_ATTACK_CALL_NORMAL)
			CRASH("attack_ai_secondary did not return a SECONDARY_ATTACK_* define.")

	if(world.time <= next_move)
		return

	if(aiCamera.in_camera_mode)
		aiCamera.camera_mode_off()
		aiCamera.captureimage(A, usr)
		return

	A.attack_ai(src)

/**
 * AI has no need for the UnarmedAttack() and RangedAttack() procs,
 * because the AI code is not generic; attack_ai() is used instead.
 * The below is only really for safety, or you can alter the way
 * it functions and re-insert it above.
 */
/mob/living/silicon/ai/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	A.attack_ai(src)

/mob/living/silicon/ai/RangedAttack(atom/A)
	A.attack_ai(src)

/atom/proc/attack_ai(mob/user)
	return

/**
 * What happens when the AI holds right-click on an item. Returns a SECONDARY_ATTACK_* value.
 *
 * Arguments:
 * * user The mob holding the right click
 * * modifiers The list of the custom click modifiers
 */
/atom/proc/attack_ai_secondary(mob/user, list/modifiers)
	return SECONDARY_ATTACK_CALL_NORMAL


/*
	Since the AI handles shift, ctrl, and alt-click differently
	than anything else in the game, atoms have separate procs
	for AI shift, ctrl, and alt clicking.
*/

/mob/living/silicon/ai/CtrlShiftClickOn(atom/A)
	A.AICtrlShiftClick(src)
/mob/living/silicon/ai/ShiftClickOn(atom/A)
	A.AIShiftClick(src)
/mob/living/silicon/ai/CtrlClickOn(atom/A)
	A.AICtrlClick(src)
/mob/living/silicon/ai/AltClickOn(atom/A)
	A.AIAltClick(src)
/mob/living/silicon/ai/MiddleClickOn(atom/A)
	A.AIMiddleClick(src)


/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/
/* Questions: Instead of an Emag check on every function, can we not add to airlocks onclick if emag return? */

/* Atom Procs */
/atom/proc/AICtrlClick()
	return
/atom/proc/AIAltClick(mob/living/silicon/ai/user)
	AltClick(user)
	return
/atom/proc/AIShiftClick()
	return
/atom/proc/AICtrlShiftClick()
	return
/atom/proc/AIMiddleClick()
	return


/* Airlocks */
/obj/machinery/door/airlock/AICtrlClick() // Bolts doors
	if(obj_flags & EMAGGED)
		return

	toggle_bolt(usr)
	add_hiddenprint(usr)

/obj/machinery/door/airlock/AIAltClick() // Eletrifies doors.
	if(obj_flags & EMAGGED)
		return

	if(electrified_until)
		electrify(0, 1)
	else
		electrify(-1,1)
	// if(!secondsElectrified)
	// 	shock_perm(usr)
	// else
	// 	shock_restore(usr)

/obj/machinery/door/airlock/AIShiftClick()  // Opens and closes doors!
	if(obj_flags & EMAGGED)
		return

	user_toggle_open(usr)
	add_hiddenprint(usr)

// /obj/machinery/door/airlock/AICtrlShiftClick()  // Sets/Unsets Emergency Access Override
// 	if(obj_flags & EMAGGED)
// 		return

// 	toggle_emergency(usr)
// 	add_hiddenprint(usr)

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


/* APC */
/obj/machinery/power/apc/AICtrlClick(mob/user) // turns off/on APCs.
	add_hiddenprint(user)
	toggle_breaker(user)
	return TRUE


/* AI Turrets */
/obj/machinery/turretid/AICtrlClick(mob/user) //turns off/on Turrets
	add_hiddenprint(user)
	enabled = !enabled //toggles the turret on/off
	return TRUE

/obj/machinery/turretid/AIAltClick(mob/user) //toggles lethal on turrets
	add_hiddenprint(user)
	lethal = !lethal
	return TRUE


/// Override AdjacentQuick for AltClicking.
/mob/living/silicon/ai/TurfAdjacent(turf/T)
	return (GLOB.cameranet && GLOB.cameranet.checkTurfVis(T))
