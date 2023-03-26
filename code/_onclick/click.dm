/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click = 0

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/atom/Click(var/location, var/control, var/params) // This is their reaction to being clicked on (standard proc)
	if(!(atom_flags & ATOM_INITIALIZED))
		to_chat(usr, SPAN_WARNING("[type] initialization failure. Click dropped. Contact a coder or admin."))
		return
	if(src)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)
		usr.ClickOn(src, params)

/atom/DblClick(var/location, var/control, var/params)
	if(!(atom_flags & ATOM_INITIALIZED))
		to_chat(usr, SPAN_WARNING("[type] initialization failure. Click dropped. Contact a coder or admin."))
		return
	if(src)
		usr.DblClickOn(src, params)

/atom/MouseWheel(delta_x,delta_y,location,control,params)
	usr.MouseWheelOn(src, delta_x, delta_y, params)



/**
 * click handling entrypoint
 *
 * handles some intercepts (many of which will be potentially moved into other procs later)
 * handles root level intercepts like admin buildmode / panel
 *
 * ! Warning: Any custom calls to this must ensure 'params' argument adheres to BYOND specifications. !
 *
 * todo: better description
 * todo: accept params as string from BYOND or pre-built list
 *
 * @params
 * * A - /atom clicked on
 * * params - byond params list
 * * clickchain_flags - allows additional flags to be passed down from, say, the statpanel if this is a routed call.
 */
/mob/proc/ClickOn(atom/A, params, clickchain_flags)
	if(world.time < next_click) // Hard check, before anything else, to avoid crashing
		return
	next_click = world.time + 1

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	// params are sent as a list directly to item procs
	// because WHY
	// would you do the work of list-allocing and unpacking and then send a
	// packed version things have to unpack a second or even third time
	// because they can't check the test version???
	var/list/unpacked_params = params2list(params)
	// todo: this is shitcode, entire click params system needs an overhaul to support stuff better.
	// notably we should stop relying on old button=1 params, as opposed to button=left/right/middle param.
	if(unpacked_params["shift"] && unpacked_params["ctrl"])
		CtrlShiftClickOn(A)
		return 1
	if(unpacked_params["shift"] && unpacked_params["middle"])
		ShiftMiddleClickOn(A)
		return 1
	if(unpacked_params["middle"])
		MiddleClickOn(A)
		return 1
	if(unpacked_params["shift"])
		ShiftClickOn(A)
		return 0
	if(unpacked_params["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return 1
	if(unpacked_params["ctrl"])
		CtrlClickOn(A)
		return 1
	switch(unpacked_params["button"])
		if("right")
		if("left")
		if("middle")
			MiddleClickOn(A)
			return 1

	if(!IS_CONSCIOUS(src))
		return

	face_atom(A) // change direction to face what you clicked on

	if(!canClick()) // in the year 2000...
		return

	if(istype(loc, /obj/mecha))
		if(!locate(/turf) in list(A, A.loc)) // Prevents inventory from being drilled
			return
		var/obj/mecha/M = loc
		return M.click_action(A, src, params)

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return 1

	if(!CHECK_MOBILITY(src, MOBILITY_USE))
		to_chat(src, SPAN_WARNING("You can't do that right now."))
		return

	if(throw_mode_check())
		if(isturf(A) || isturf(A.loc))
			throw_active_held_item(A)
			// todo: pass in overhand arg so we aren't stuck using throw mode off AFTER the call
			throw_mode_off()
			return 1
		throw_mode_off()

	//? Grab click semantics
	var/obj/item/I = get_active_held_item()

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
			I.melee_attack_chain(A, src, clickchain_flags | CLICKCHAIN_HAS_PROXIMITY, unpacked_params)
		else
			melee_attack_chain(A, clickchain_flags | CLICKCHAIN_HAS_PROXIMITY, unpacked_params)
		// todo: refactor aiming
		trigger_aiming(TARGET_CAN_CLICK)
		return
	else if(ranged_generics_allowed)
		//? attempt ranged attack chain
		if(I)
			I.ranged_attack_chain(A, src, clickchain_flags, unpacked_params)
		else
			ranged_attack_chain(A, clickchain_flags, unpacked_params)
		// todo: refactor aiming
		trigger_aiming(TARGET_CAN_CLICK)
		return

/mob/proc/setClickCooldown(var/timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/canClick()
	if(config_legacy.no_click_cooldown || next_move <= world.time)
		return 1
	return 0

// Default behavior: ignore double clicks, the second click that makes the doubleclick call already calls for a normal click
/mob/proc/DblClickOn(var/atom/A, var/params)
	return

/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(var/atom/A, var/proximity_flag)
	return

/mob/living/UnarmedAttack(var/atom/A, var/proximity_flag)
	if(is_incorporeal())
		return 0

	if(stat)
		return 0

	return 1

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(var/atom/A, var/params)
	if(!mutations.len) return
	if((MUTATION_LASER in mutations) && a_intent == INTENT_HARM)
		LaserEyes(A) // moved into a proc below
	else if(MUTATION_TELEKINESIS in mutations)
		if(get_dist(src, A) > tk_maxrange)
			return
		A.attack_tk(src)
/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(var/atom/A)
	swap_hand()
	return

// In case of use break glass
/*
/atom/proc/MiddleClick(var/mob/M as mob)
	return
*/

/*
	Shift middle click
	Used for pointing.
*/
/mob/proc/ShiftMiddleClickOn(atom/A)
	pointed(A)
	return

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(var/atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(var/mob/user)
	if(user.client && user.allow_examine(src))
		user.examinate(src)

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(var/atom/A)
	A.CtrlClick(src)
	return
/atom/proc/CtrlClick(var/mob/user)
	return

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pulling(src)

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(atom/A)
	if(!A.AltClick(src))
		altclick_listed_turf(A)

/mob/proc/altclick_listed_turf(atom/A)
	var/turf/T = get_turf(A)
	if(!T)
		return
	if(!TurfAdjacent(T))
		return
	if(!client)
		return
	if(T == client.statpanel_turf)
		client.unlist_turf()
		return
	client.list_turf(T)

/atom/proc/AltClick(var/mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_ALT, user)
	return FALSE

// todo: rework
/mob/proc/TurfAdjacent(var/turf/T)
	return T.AdjacentQuick(src)

/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(var/atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(var/mob/user)
	return

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A, params)
	return

/mob/living/LaserEyes(atom/A, params)
	setClickCooldown(4)
	var/turf/T = get_turf(src)

	var/obj/projectile/beam/LE = new (T)
	LE.icon = 'icons/effects/genetics.dmi'
	LE.icon_state = "eyelasers"
	playsound(usr.loc, 'sound/weapons/taser2.ogg', 75, 1)
	LE.firer = src
	LE.preparePixelProjectile(A, src, params)
	LE.fire()

/mob/living/carbon/human/LaserEyes(atom/A, params)
	if(nutrition>0)
		..()
		nutrition = max(nutrition - rand(1,5),0)
		handle_regular_hud_updates()
	else
		to_chat(src, "<span class='warning'>You're out of energy!  You need food!</span>")

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(var/atom/A)
	if(!A || !x || !y || !A.x || !A.y)
		return
	if(!CHECK_MOBILITY(src, MOBILITY_MOVE))
		return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy)
		return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)
			direction = NORTH
		else
			direction = SOUTH
	else
		if(dx > 0)
			direction = EAST
		else
			direction = WEST
	if(direction != dir)
		setDir(direction)

/atom/movable/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = 2
	screen_loc = "CENTER-7,CENTER-7"

/atom/movable/screen/click_catcher/proc/MakeGreed()
	. = list()
	for(var/i = 0, i<15, i++)
		for(var/j = 0, j<15, j++)
			var/atom/movable/screen/click_catcher/CC = new()
			CC.screen_loc = "NORTH-[i],EAST-[j]"
			. += CC

/atom/movable/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = screen_loc2turf(screen_loc, get_turf(usr))
		if(T)
			T.Click(location, control, params)
	. = 1

/// MouseWheelOn
/mob/proc/MouseWheelOn(atom/A, delta_x, delta_y, params)
	SEND_SIGNAL(src, COMSIG_MOUSE_SCROLL_ON, A, delta_x, delta_y, params)
