/*
	Cyborg ClickOn()

	Cyborgs have no range restriction on attack_robot(), because it is basically an AI click.
	However, they do have a range restriction on item use, so they cannot do without the
	adjacency code.
*/

// todo: unify with normal click procs
/mob/living/silicon/robot/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlShiftClickOn(A)
			return
		if(LAZYACCESS(modifiers, MIDDLE_CLICK))
			ShiftMiddleClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, ALT_CLICK)) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		CtrlClickOn(A)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK) && !module_active)
		var/secondary_result = A.attack_robot_secondary(src, modifiers)
		if(secondary_result == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || secondary_result == SECONDARY_ATTACK_CONTINUE_CHAIN)
			return
		else if (secondary_result != SECONDARY_ATTACK_CALL_NORMAL)
			CRASH("attack_robot_secondary did not return a SECONDARY_ATTACK_* define.")

	if(stat || lockdown || weakened || stunned || paralysis)
		return

	if(next_move >= world.time)
		return

	face_atom(A) // change direction to face what you clicked on

	if(aiCamera.in_camera_mode)
		aiCamera.camera_mode_off()
		if(is_component_functioning("camera"))
			aiCamera.captureimage(A, usr)
		else
			to_chat(src, "<span class='userdanger'>Your camera isn't functional.</span>")
		return

	/*
	cyborg restrained() currently does nothing
	if(restrained())
		RestrainedClickOn(A)
		return
	*/

	//? Grab click semantics
	var/obj/item/I = get_active_held_item()

	//? Core cyborg code
	// Cyborgs have no range-checking unless there is item use
	if(!I)
		if(bolt && !bolt.malfunction && A.loc != module)
			return
		A.add_hiddenprint(src)
		A.attack_robot(src)
		return

	//? Handle special cases
	if(I == A)
		// attack_self
		I.attack_self(src)
		// todo: refactor
		trigger_aiming(TARGET_CAN_CLICK)
		return

	//? check if we can click from our current location
	var/ranged_generics_allowed = loc?.AllowClick(src, A, I)

	if(Reachability(A, null, I?.reach, I))
		//? attempt melee attack chain
		if(I)
			I.melee_attack_chain(A, src, CLICKCHAIN_HAS_PROXIMITY, modifiers)
		else
			melee_attack_chain(A, CLICKCHAIN_HAS_PROXIMITY, modifiers)
		// todo: refactor aiming
		trigger_aiming(TARGET_CAN_CLICK)
		return
	else if(ranged_generics_allowed)
		//? attempt ranged attack chain
		if(I)
			I.ranged_attack_chain(A, src, NONE, params)
		else
			ranged_attack_chain(A, NONE, modifiers)
		// todo: refactor aiming
		trigger_aiming(TARGET_CAN_CLICK)
		return

//Give cyborgs hotkey clicks without breaking existing uses of hotkey clicks
// for non-doors/apcs
/mob/living/silicon/robot/CtrlShiftClickOn(atom/A)
	A.BorgCtrlShiftClick(src)
/mob/living/silicon/robot/ShiftClickOn(atom/A)
	A.BorgShiftClick(src)
/mob/living/silicon/robot/CtrlClickOn(atom/A)
	A.BorgCtrlClick(src)
/mob/living/silicon/robot/AltClickOn(atom/A)
	A.BorgAltClick(src)

//Middle click cycles through selected modules.
/mob/living/silicon/robot/MiddleClickOn(var/atom/A)
	cycle_modules()
	return

/mob/living/silicon/robot/AltClickOn(var/atom/A)
	if(!A.AltClick(src))
		set_listed_turf(A)
	A.BorgAltClick(src)

/atom/proc/BorgCtrlShiftClick(mob/living/silicon/robot/user) //forward to human click if not overridden
	CtrlShiftClick(user)

/obj/machinery/door/airlock/BorgCtrlShiftClick(mob/living/silicon/robot/user) // Sets/Unsets Emergency Access Override Forwards to AI code.
	if(get_dist(src,user) <= user.interaction_range)
		AICtrlShiftClick()
	else
		..()


/atom/proc/BorgShiftClick(mob/living/silicon/robot/user) //forward to human click if not overridden
	ShiftClick(user)

/obj/machinery/door/airlock/BorgShiftClick(mob/living/silicon/robot/user)  // Opens and closes doors! Forwards to AI code.
	if(get_dist(src,user) <= user.interaction_range)
		AIShiftClick()
	else
		..()


/atom/proc/BorgCtrlClick(mob/living/silicon/robot/user) //forward to human click if not overridden
	CtrlClick(user)

/obj/machinery/door/airlock/BorgCtrlClick(mob/living/silicon/robot/user) // Bolts doors. Forwards to AI code.
	if(get_dist(src,user) <= user.interaction_range)
		AICtrlClick()
	else
		..()


/obj/machinery/power/apc/BorgCtrlClick(mob/living/silicon/robot/user) // turns off/on APCs. Forwards to AI code.
	if(get_dist(src,user) <= user.interaction_range)
		AICtrlClick()
	else
		..()


/obj/machinery/turretid/BorgCtrlClick(mob/living/silicon/robot/user) //turret control on/off. Forwards to AI code.
	if(get_dist(src,user) <= user.interaction_range)
		AICtrlClick()
	else
		..()


/atom/proc/BorgAltClick(mob/living/silicon/robot/user)
	AltClick(user)
	return


/obj/machinery/door/airlock/BorgAltClick(mob/living/silicon/robot/user) // Eletrifies doors. Forwards to AI code.
	if(get_dist(src,user) <= user.interaction_range)
		AIAltClick()
	else
		..()


/obj/machinery/turretid/BorgAltClick(mob/living/silicon/robot/user) //turret lethal on/off. Forwards to AI code.
	if(get_dist(src,user) <= user.interaction_range)
		AIAltClick()
	else
		..()

/**
 * As with AI, these are not used in click code,
 * because the code for robots is specific, not generic.
 *
 * If you would like to add advanced features to robot
 * clicks, you can do so here, but you will have to
 * change attack_robot() above to the proper function
 */
/mob/living/silicon/robot/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	// if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
	// 	return
	A.attack_robot(src)

/mob/living/silicon/robot/RangedAttack(atom/A)
	A.attack_robot(src)

/atom/proc/attack_robot(mob/user)
	attack_ai(user)
	return

/**
 * What happens when the cyborg without active module holds right-click on an item. Returns a SECONDARY_ATTACK_* value.
 *
 * Arguments:
 * * user The mob holding the right click
 * * modifiers The list of the custom click modifiers
 */
/atom/proc/attack_robot_secondary(mob/user, list/modifiers)
	return attack_ai_secondary(user, modifiers)
