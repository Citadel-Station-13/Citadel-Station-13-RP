/*
	Cyborg ClickOn()

	Cyborgs have no range restriction on attack_robot(), because it is basically an AI click.
	However, they do have a range restriction on item use, so they cannot do without the
	adjacency code.
*/

// todo: unify with normal click procs
/mob/living/silicon/robot/ClickOn(var/atom/A, var/params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	var/list/unpacked_params = params2list(params)
	if(unpacked_params["shift"] && unpacked_params["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(unpacked_params["shift"] && unpacked_params["middle"])
		ShiftMiddleClickOn(A)
		return
	if(unpacked_params["middle"])
		MiddleClickOn(A)
		return
	if(unpacked_params["shift"])
		ShiftClickOn(A)
		return
	if(unpacked_params["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(unpacked_params["ctrl"])
		CtrlClickOn(A)
		return

	if(stat || lockdown || weakened || stunned || paralysis)
		return

	if(!canClick())
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
			I.melee_attack_chain(A, src, CLICKCHAIN_HAS_PROXIMITY, unpacked_params)
		else
			melee_attack_chain(A, CLICKCHAIN_HAS_PROXIMITY, unpacked_params)
		// todo: refactor aiming
		trigger_aiming(TARGET_CAN_CLICK)
		return
	else if(ranged_generics_allowed)
		//? attempt ranged attack chain
		if(I)
			I.ranged_attack_chain(A, src, NONE, params)
		else
			ranged_attack_chain(A, NONE, unpacked_params)
		// todo: refactor aiming
		trigger_aiming(TARGET_CAN_CLICK)
		return

//Middle click cycles through selected modules.
/mob/living/silicon/robot/MiddleClickOn(var/atom/A)
	cycle_modules()
	return

//Give cyborgs hotkey clicks without breaking existing uses of hotkey clicks
// for non-doors/apcs
/mob/living/silicon/robot/CtrlShiftClickOn(var/atom/A)
	A.BorgCtrlShiftClick(src)

/mob/living/silicon/robot/ShiftClickOn(var/atom/A)
	A.BorgShiftClick(src)

/mob/living/silicon/robot/CtrlClickOn(var/atom/A)
	A.BorgCtrlClick(src)

/mob/living/silicon/robot/AltClickOn(var/atom/A)
	if(!A.AltClick(src))
		altclick_listed_turf(A)
	A.BorgAltClick(src)

/atom/proc/BorgCtrlShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	CtrlShiftClick(user)

/obj/machinery/door/airlock/BorgCtrlShiftClick(mob/living/silicon/robot/user)
	if(user.bolt && !user.bolt.malfunction)
		return
	AICtrlShiftClick(user)

/atom/proc/BorgShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	ShiftClick(user)

/obj/machinery/door/airlock/BorgShiftClick(mob/living/silicon/robot/user) // Opens and closes doors! Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return
	AIShiftClick(user)

/atom/proc/BorgCtrlClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	CtrlClick(user)

/obj/machinery/door/airlock/BorgCtrlClick(mob/living/silicon/robot/user) // Bolts doors. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return
	AICtrlClick(user)

/obj/machinery/power/apc/BorgCtrlClick(mob/living/silicon/robot/user) // turns off/on APCs. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return
	AICtrlClick(user)

/obj/machinery/turretid/BorgCtrlClick(mob/living/silicon/robot/user) //turret control on/off. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return
	AICtrlClick(user)

/atom/proc/BorgAltClick(var/mob/living/silicon/robot/user)
	return

/obj/machinery/door/airlock/BorgAltClick(mob/living/silicon/robot/user) // Eletrifies doors. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return
	AIAltClick(user)

/obj/machinery/turretid/BorgAltClick(mob/living/silicon/robot/user) //turret lethal on/off. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return
	AIAltClick(user)

/*
	As with AI, these are not used in click code,
	because the code for robots is specific, not generic.

	If you would like to add advanced features to robot
	clicks, you can do so here, but you will have to
	change attack_robot() above to the proper function
*/
/mob/living/silicon/robot/UnarmedAttack(atom/A)
	A.attack_robot(src)
/mob/living/silicon/robot/RangedAttack(atom/A)
	A.attack_robot(src)

/atom/proc/attack_robot(mob/user as mob)
	attack_ai(user)
	return
