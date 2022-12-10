/**
 *! Click code
 */

// 1 decisecond click delay (above and beyond mob/next_move)
//This is mainly modified by click code, to modify click delays elsewhere, use next_move and changeNext_move()
/mob/var/next_click = 0

/**
 * Before anything else, defer these calls to a per-mobtype handler.  This allows us to
 * remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.
 *
 * Alternately, you could hardcode every mob's variation in a flat [/mob/proc/ClickOn] proc; however,
 * that's a lot of code duplication and is hard to maintain.
 *
 * Note that this proc can be overridden, and is in the case of screen objects.
 */
/atom/Click(location, control, params)
	if(flags & INITIALIZED)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)

		usr.ClickOn(src, params)

/atom/DblClick(location, control, params)
	if(flags & INITIALIZED)
		usr.DblClickOn(src,params)

/atom/MouseWheel(delta_x, delta_y, location, control, params)
	if(flags & INITIALIZED)
		usr.MouseWheelOn(src, delta_x, delta_y, params)


/**
 * Standard mob ClickOn()
 * Handles exceptions: Buildmode, middle click, modified clicks, mech actions
 *
 * After that, mostly just check your state, check whether you're holding an item,
 * check whether you're adjacent to the target, then pass off the click to whoever
 * is receiving it.
 * The most common are:
 * * [mob/proc/UnarmedAttack] (atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
 * * [atom/proc/attackby] (item,user) - used only when adjacent
 * * [obj/item/proc/afterattack] (atom,user,adjacent,params) - used both ranged and adjacent
 * * [mob/proc/RangedAttack] (atom,modifiers) - used only ranged, only used for tk and laser eyes but could be changed
 */
/mob/proc/ClickOn(atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)

	// if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, A, modifiers) & COMSIG_MOB_CANCEL_CLICKON)
	// 	return

	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		if(LAZYACCESS(modifiers, MIDDLE_CLICK))
			ShiftMiddleClickOn(A)
			return
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlShiftClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlMiddleClickOn(A)
		else
			MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, ALT_CLICK)) // alt and alt-gr (rightalt)
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			alt_click_on_secondary(A)
		else
			AltClickOn(A)
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		CtrlClickOn(A)
		return

	if(stat || paralysis || stunned || weakened)
		return

	face_atom(A) // change direction to face what you clicked on

	if(next_move > world.time) // in the year 2000...
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

	if(throw_mode_check())
		if(isturf(A) || isturf(A.loc))
			throw_active_held_item(A)
			// todo: pass in overhand arg so we aren't stuck using throw mode off AFTER the call
			throw_mode_off()
			return 1
		throw_mode_off()

	//? Grab click semantics
	var/obj/item/I = get_active_held_item()

	if(I == A) //? Handle special cases
		// TODO: Add Right Click support when we need it. @Zandario
		I.attack_self(src, modifiers)
		// update_held_items()
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

	// Can't reach anything else in lockers or other weirdness
	if(!loc.AllowClick())
		return

/mob/proc/setClickCooldown(var/timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/canClick()
	if(config_legacy.no_click_cooldown || next_move <= world.time)
		return 1
	return 0

/// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/A, params)
	return

/**
 * Translates into [atom/proc/attack_hand], etc.
 *
 * Note: proximity_flag here is used to distinguish between normal usage (flag=1),
 * and usage when clicking on things telekinetically (flag=0).  This proc will
 * not be called at ranged except with telekinesis.
 *
 * proximity_flag is not currently passed to attack_hand, and is instead used
 * in human click code to allow glove touches only at melee range.
 *
 * modifiers is a lazy list of click modifiers this attack had,
 * used for figuring out different properties of the click, mostly right vs left and such.
 */

/mob/proc/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	// if(ismob(A))
	// 	changeNext_move(CLICK_CD_MELEE)
	return

/mob/living/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	if(is_incorporeal())
		return FALSE

	if(stat)
		return FALSE

	return TRUE

/**
 * Ranged unarmed attack:
 *
 * This currently is just a default for all mobs, involving
 * laser eyes and telekinesis.  You could easily add exceptions
 * for things like ranged glove touches, spitting alien acid/neurotoxin,
 * animals lunging, etc.
 */
/mob/proc/RangedAttack(atom/A, proximity_flag, modifiers)
	if(SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED, A, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

/**
 * Ranged secondary attack
 *
 * If the same conditions are met to trigger RangedAttack but it is
 * instead initialized via a right click, this will trigger instead.
 * Useful for mobs that have their abilities mapped to right click.
 */
// /mob/proc/ranged_secondary_attack(atom/target, modifiers)
// 	if(SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED_SECONDARY, target, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
// 		return TRUE


/**
 * Restrained ClickOn
 *
 * Used when you are handcuffed and click things.
 * Not currently used by anything but could easily be.
 */
/mob/proc/RestrainedClickOn(atom/A)
	return


/**
 * Middle click
 * Mainly used for swapping hands
 */
/mob/proc/MiddleClickOn(atom/A, params)
	// . = SEND_SIGNAL(src, COMSIG_MOB_MIDDLECLICKON, A, params)
	// if(. & COMSIG_MOB_CANCEL_CLICKON)
	// 	return
	swap_hand()

// In case of use break glass
/*
/atom/proc/MiddleClick(var/mob/M as mob)
	return
*/


/**
 * Shift click
 * For most mobs, examine.
 * This is overridden in ai.dm
 */
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(mob/user)
	var/flags = SEND_SIGNAL(user, COMSIG_CLICK_SHIFT, src)
	if(user.client && (user.client.eye == user || user.client.eye == user.loc || flags & COMPONENT_ALLOW_EXAMINATE))
		user.examinate(src)
	return

/**
 * Ctrl click
 * For most objects, pull
 */
/mob/proc/CtrlClickOn(atom/A)
	A.CtrlClick(src)
	return

/atom/proc/CtrlClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL, user)
	// SEND_SIGNAL(user, COMSIG_MOB_CTRL_CLICKED, src)
	var/mob/living/ML = user
	if(istype(ML))
		ML.pulled(src)
	if(!can_interact(user))
		return FALSE

/atom/movable/CtrlClick(mob/user)
	if(Adjacent(user))
		user.start_pulling(src)
	return ..()

// TODO: tag_datum @Zandario
/mob/proc/CtrlMiddleClickOn(atom/A)
	// if(check_rights_for(client, R_ADMIN))
	// 	client.toggle_tag_datum(A)
	// else
	// 	A.CtrlClick(src)
	A.CtrlClick(src)
	return


/**
 * Alt click
 */
/mob/proc/AltClickOn(atom/A)
	// . = SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON, A)
	// if(. & COMSIG_MOB_CANCEL_CLICKON)
	// 	return
	A.AltClick(src)

/atom/proc/AltClick(mob/user)
	if(!user.can_interact_with(src))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_CLICK_ALT, user) & COMPONENT_CANCEL_CLICK_ALT)
		return
	var/turf/T = get_turf(src)
	if(T && (isturf(loc) || isturf(src)) && user.TurfAdjacent(T))
		user.set_listed_turf(T)

/// The base proc of when something is right clicked on when alt is held - generally use alt_click_secondary instead.
/atom/proc/alt_click_on_secondary(atom/A)
// 	. = SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON_SECONDARY, A)
// 	if(. & COMSIG_MOB_CANCEL_CLICKON)
// 		return
	// A.alt_click_secondary(src)
	return

/// The base proc of when something is right clicked on when alt is held.
// /atom/proc/alt_click_secondary(mob/user)
// 	if(!user.can_interact_with(src))
// 		return FALSE
// 	if(SEND_SIGNAL(src, COMSIG_CLICK_ALT_SECONDARY, user) & COMPONENT_CANCEL_CLICK_ALT_SECONDARY)
// 		return
	// TODO: tag_datum @Zandario
	// if(isobserver(user) && user.client && check_rights_for(user.client, R_DEBUG))
	// 	user.client.toggle_tag_datum(src)
	// 	return

/// Use this instead of [/mob/proc/AltClickOn] where you only want turf content listing without additional atom alt-click interaction
/atom/proc/AltClickNoInteract(mob/user, atom/A)
	var/turf/T = get_turf(A)
	if(T && user.TurfAdjacent(T))
		user.set_listed_turf(T)

/mob/proc/set_listed_turf(atom/A)
	var/turf/T = get_turf(A)
	if(T == A.loc || T == A)
		if(T == listed_turf)
			listed_turf = null
		else if(TurfAdjacent(T))
			listed_turf = T
			client.statpanel = T.name

/mob/proc/TurfAdjacent(turf/T)
	return T.AdjacentQuick(src)


/**
 * Control+Shift click
 */
/mob/proc/CtrlShiftClickOn(atom/A)
	A.CtrlShiftClick(src)
	return

/mob/proc/ShiftMiddleClickOn(atom/A)
	src.pointed(A)
	return

/atom/proc/CtrlShiftClick(mob/user)
	if(!can_interact(user))
		return FALSE
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL_SHIFT, user)
	return



/**
 *! Misc helpers
 *
 * face_atom: turns the mob towards what you clicked on
 */

/// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(atom/A)
	if( buckled || stat != CONSCIOUS || !A || !x || !y || !A.x || !A.y )
		return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) // Wall items are graphically shifted but on the floor
		if(A.pixel_y > 16)
			setDir(NORTH)
		else if(A.pixel_y < -16)
			setDir(SOUTH)
		else if(A.pixel_x > 16)
			setDir(EAST)
		else if(A.pixel_x < -16)
			setDir(WEST)
		return

	if(abs(dx) < abs(dy))
		if(dy > 0)
			setDir(NORTH)
		else
			setDir(SOUTH)
	else
		if(dx > 0)
			setDir(EAST)
		else
			setDir(WEST)

//debug
/atom/movable/screen/proc/scale_to(x1,y1)
	if(!y1)
		y1 = x1
	var/matrix/M = new
	M.Scale(x1,y1)
	transform = M

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
