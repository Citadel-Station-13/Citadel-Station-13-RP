/*
	Cyborg ClickOn()

	Cyborgs have no range restriction on attack_robot(), because it is basically an AI click.
	However, they do have a range restriction on item use, so they cannot do without the
	adjacency code.
*/

/mob/living/silicon/robot/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	// if(check_click_intercept(params,A))
	// 	return

	if(stat || lockdown || weakened || stunned || paralysis)
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, "shift"))
		if(LAZYACCESS(modifiers, "ctrl"))
			CtrlShiftClickOn(A)
			return
		if(LAZYACCESS(modifiers, "middle"))
			ShiftMiddleClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, "middle"))
		MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, "alt")) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(LAZYACCESS(modifiers, "ctrl"))
		CtrlClickOn(A)
		return

	if(!canClick())
		return

	face_atom(A) // change direction to face what you clicked on

	if(aiCamera.in_camera_mode) //Cyborg picture taking
		aiCamera.camera_mode_off()
		if(is_component_functioning("camera"))
			aiCamera.captureimage(A, usr)
		else
			to_chat(src, "<span class='userdanger'>Your camera isn't functional.</span>")
		return

	var/obj/item/W = get_active_hand()

	if(!W && get_dist(src,A) <= 7)
		A.add_hiddenprint(src) // this makes no fucking sense but ok.
		A.attack_robot(src)
		return

	if(W)
		if(incapacitated())
			return

		//while buckled, you can still connect to and control things like doors, but you can't use your modules
		// if(buckled)
		// 	to_chat(src, "<span class='warning'>You can't use modules while buckled to [buckled]!</span>")
		// 	return

		if(W == A)
			W.attack_self(src)
			return

		// cyborgs are prohibited from using storage items so we can I think safely remove (A.loc in contents)
		if(A == loc || (A in loc) || (A in contents))
		var/resolved = A.attackby(W, src, 1)
		if(!resolved && A && W)
			W.afterattack(A,src,1,params)
			return

		if(!isturf(loc))
			return

		// cyborgs are prohibited from using storage items so we can I think safely remove (A.loc && isturf(A.loc.loc))
		if(isturf(A) || isturf(A.loc))
			if(A.Adjacent(src)) // see adjacent.dm
			var/resolved = A.attackby(W, src, 1)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params)
				return
			else
				W.afterattack(A, src, 0, params)
				return

//Middle click cycles through selected modules.
/mob/living/silicon/robot/MiddleClickOn(atom/A)
	cycle_modules()
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

/atom/proc/BorgCtrlShiftClick(mob/living/silicon/robot/user) //forward to human click if not overridden
	CtrlShiftClick(user)

/obj/machinery/door/airlock/BorgCtrlShiftClick(mob/living/silicon/robot/user) // Sets/Unsets Emergency Access Override Forwards to AI code.
	if(get_dist(src,user) <= 7)
		AICtrlShiftClick()
	else
		..()


/atom/proc/BorgShiftClick(mob/living/silicon/robot/user) //forward to human click if not overridden
	ShiftClick(user)

/obj/machinery/door/airlock/BorgShiftClick(mob/living/silicon/robot/user)  // Opens and closes doors! Forwards to AI code.
	if(get_dist(src,user) <= 7)
		AIShiftClick()
	else
		..()


/atom/proc/BorgCtrlClick(mob/living/silicon/robot/user) //forward to human click if not overridden
	CtrlClick(user)

/obj/machinery/door/airlock/BorgCtrlClick(mob/living/silicon/robot/user) // Bolts doors. Forwards to AI code.
	if(get_dist(src,user) <= 7)
		AICtrlClick()
	else
		..()

/obj/machinery/power/apc/BorgCtrlClick(mob/living/silicon/robot/user) // turns off/on APCs. Forwards to AI code.
	if(get_dist(src,user) <= 7)
		AICtrlClick()
	else
		..()

/obj/machinery/turretid/BorgCtrlClick(mob/living/silicon/robot/user) //turret control on/off. Forwards to AI code.
	if(get_dist(src,user) <= 7)
		AICtrlClick()
	else
		..()

/atom/proc/BorgAltClick(mob/living/silicon/robot/user)
	AltClick(user)
	return

/obj/machinery/door/airlock/BorgAltClick(mob/living/silicon/robot/user) // Eletrifies doors. Forwards to AI code.
	if(get_dist(src,user) <= 7)
		AIAltClick()
	else
		..()

/obj/machinery/turretid/BorgAltClick(mob/living/silicon/robot/user) //turret lethal on/off. Forwards to AI code.
	if(get_dist(src,user) <= 7)
		AIAltClick()
	else
		..()

/*
	As with AI, these are not used in click code,
	because the code for robots is specific, not generic.

	If you would like to add advanced features to robot
	clicks, you can do so here, but you will have to
	change attack_robot() above to the proper function
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
