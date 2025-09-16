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

// LEGACY PROC, STOP USING THIS
/atom/proc/CtrlClick(var/mob/user)
	. = "keep-going"

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pulling(src)
	else
		return ..()

/mob/proc/altclick_listed_turf(atom/A)
	var/turf/T = get_turf(A)
	if(!T)
		return FALSE
	if(!snowflake_ai_vision_adjacency(T))
		return FALSE
	if(!client)
		return FALSE
	if(T == client.tgui_stat?.byond_stat_turf)
		client.unlist_turf()
		return TRUE
	client.list_turf(T)
	return TRUE

/atom/proc/should_list_turf_on_alt_click(mob/user)
	return isturf(src) || isturf(loc)

// LEGACY PROC, STOP USING THIS
/atom/proc/AltClick(var/mob/user)
	if(isAI(user) && !isitem(src) && !isturf(src))
		return "keep-going"
	if(should_list_turf_on_alt_click(user) && user.altclick_listed_turf(src))
		return TRUE
	return "keep-going"

// todo: rework
/**
 * If you see me on git blame just know that it's a weird situation. This was TurfAdjacent()
 * but it was only used for AI cameras and statpanel
 * So, this is an IOU refactor and in the legacy file.
 */
/mob/proc/snowflake_ai_vision_adjacency(var/turf/T)
	return T.AdjacentQuick(src)

// LEGACY PROC, STOP USING THIS
/atom/proc/CtrlShiftClick(var/mob/user)
	return "keep-going"

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
