/**
 * Backend clickcode.
 *
 * * Things in this file are **not** part of the clickchain, instead being the machinery that initiates the clickchain.
 */

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/atom/DblClick(var/location, var/control, var/params)
	if(!(atom_flags & ATOM_INITIALIZED))
		to_chat(usr, SPAN_WARNING("[type] initialization failure. Click dropped. Contact a coder or admin."))
		return
	usr.DblClickOn(src, params)

/atom/MouseWheel(delta_x,delta_y,location,control,params)
	usr.MouseWheelOn(src, delta_x, delta_y, params)

/mob/proc/legacy_click_on(atom/target, location, control, params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, target)
		return TRUE
	return FALSE

#warn obliterate

/mob/proc/ClickOn(atom/A, params, clickchain_flags)
	if(!IS_CONSCIOUS(src))
		return

	if(!canClick()) // in the year 2000...
		return

	if(istype(loc, /obj/vehicle/sealed/mecha))
		if(!locate(/turf) in list(A, A.loc)) // Prevents inventory from being drilled
			return
		var/obj/vehicle/sealed/mecha/M = loc
		return M.click_action(A, src, params)

	if(restrained())
		setClickCooldownLegacy(10)
		RestrainedClickOn(A)
		return 1

	if(!CHECK_MOBILITY(src, MOBILITY_CAN_USE))
		to_chat(src, SPAN_WARNING("You can't do that right now."))
		return

	if(throw_mode_check())
		if(isturf(A) || isturf(A.loc))
			throw_active_held_item(A)
			// todo: pass in overhand arg so we aren't stuck using throw mode off AFTER the call
			throw_mode_off()
			return 1
		throw_mode_off()

// todo: this is legacy because majority of calls to it are unaudited and unnecessary; new system
//       handles melee cooldown at clickcode level.
/mob/proc/setClickCooldownLegacy(var/timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/canClick()
	if(next_move <= world.time)
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

/mob/proc/MiddleClickOn(var/atom/A)
	swap_hand()

/mob/proc/ShiftMiddleClickOn(atom/A)
	pointed(A)

/mob/proc/ShiftClickOn(var/atom/A)
	A.ShiftClick(src)

/atom/proc/ShiftClick(var/mob/user)
	if(user.client && user.allow_examine(src))
		user.examinate(src)

/mob/proc/CtrlClickOn(var/atom/A)
	A.CtrlClick(src)

/atom/proc/CtrlClick(var/mob/user)

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pulling(src)

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
	if(T == client.tgui_stat?.byond_stat_turf)
		client.unlist_turf()
		return
	client.list_turf(T)

/atom/proc/AltClick(var/mob/user)
	if(open_context_menu(new /datum/event_args/actor(user)))
		return TRUE
	return FALSE

// todo: rework
/mob/proc/TurfAdjacent(var/turf/T)
	return T.AdjacentQuick(src)

/mob/proc/CtrlShiftClickOn(var/atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(var/mob/user)
	return

/mob/proc/LaserEyes(atom/A, params)
	return

/mob/living/LaserEyes(atom/A, params)
	setClickCooldownLegacy(4)
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

/// Simple helper to face what you clicked on, in case it should be needed in more than one place.
/mob/proc/face_atom(var/atom/atom_to_face)
	if(buckled || stat != CONSCIOUS || !atom_to_face || !x || !y || !atom_to_face.x || !atom_to_face.y)
		return
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_MOVE))
		return

	var/dx = atom_to_face.x - x
	var/dy = atom_to_face.y - y
	if(!dx && !dy) // Wall items are graphically shifted but on the floor
		if(atom_to_face.pixel_y > 16)
			setDir(NORTH)
		else if(atom_to_face.pixel_y < -16)
			setDir(SOUTH)
		else if(atom_to_face.pixel_x > 16)
			setDir(EAST)
		else if(atom_to_face.pixel_x < -16)
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

/// MouseWheelOn
/mob/proc/MouseWheelOn(atom/A, delta_x, delta_y, params)
	SEND_SIGNAL(src, COMSIG_MOUSE_SCROLL_ON, A, delta_x, delta_y, params)

//* Click Cooldown *//

/**
 * Prevents a mob from acting again until time has passed.
 */
/mob/proc/apply_click_cooldown(time)
	next_move = max(world.time + time, next_move)
