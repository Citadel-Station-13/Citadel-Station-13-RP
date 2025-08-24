
#warn obliterate

/mob/proc/ClickOn(atom/A, params, clickchain_flags)
	if(istype(loc, /obj/vehicle/sealed/mecha))
		if(!locate(/turf) in list(A, A.loc)) // Prevents inventory from being drilled
			return
		var/obj/vehicle/sealed/mecha/M = loc
		return M.click_action(A, src, params)

	if(restrained())
		setClickCooldownLegacy(10)
		RestrainedClickOn(A)
		return 1

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

#warn deal with all of this
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
	if(!snowflake_ai_vision_adjacency(T))
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
/**
 * If you see me on git blame just know that it's a weird situation. This was TurfAdjacent()
 * but it was only used for AI cameras and statpanel
 * So, this is an IOU refactor and in the legacy file.
 */
/mob/proc/snowflake_ai_vision_adjacency(var/turf/T)
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

#warn obliterate
/// MouseWheelOn
/mob/proc/MouseWheelOn(atom/A, delta_x, delta_y, params)
	SEND_SIGNAL(src, COMSIG_MOUSE_SCROLL_ON, A, delta_x, delta_y, params)

//* Click Cooldown *//

/**
 * Prevents a mob from acting again until time has passed.
 * This is in legacy because at some point click cooldowns will be .. weird, with remote control
 * being a thing. But for now, let's not overcomplicate it.
 */
/mob/proc/apply_click_cooldown(time)
	next_move = max(world.time + time, next_move)
