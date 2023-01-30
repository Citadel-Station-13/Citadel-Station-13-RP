// EYE
//
// A mob that another mob controls to look around the station with.
// It streams chunks as it moves around, which will show it what the controller can and cannot see.

/mob/observer/eye
	name = "Eye"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	alpha = 127

	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/owner_follows_eye = 0
	var/slowdown = 1			//people said this was too fast. meh.

	see_in_dark = 7
	status_flags = GODMODE
	plane = PLANE_AI_EYE

	var/mob/owner = null
	var/list/visibleChunks = list()

	var/ghostimage = null
	var/datum/visualnet/visualnet

/mob/observer/eye/Destroy()
	if(owner)
		if(owner.eyeobj == src)
			owner.eyeobj = null
		owner = null
	. = ..()

/mob/observer/eye/Move(n, direct)
	if(owner == src)
		return EyeMove(n, direct)
	return 0

/mob/observer/eye/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

/mob/observer/eye/examinate()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/observer/eye/pointed()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/observer/eye/examine(mob/user)
	return list(
		"An eye object belonging to [owner || "no one in particular."]"
	)

// Use this when setting the eye's location.
// It will also stream the chunk that the new loc is in.
/mob/observer/eye/proc/setLoc(var/T)
	if(owner)
		T = get_turf(T)
		if(T != loc)
			var/old = loc
			loc = T
			SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old, NONE, TRUE)
			visualnet.visibility(src)
			return 1
	return 0

/mob/observer/eye/proc/getLoc()
	if(owner)
		if(!isturf(owner.loc) || !owner.client)
			return
		return loc

/mob/observer/eye/make_perspective()
	var/datum/perspective/P = ..()
	// we see everything by default
	P.SetSight(SEE_TURFS | SEE_MOBS | SEE_OBJS)

/mob
	var/mob/observer/eye/eyeobj

/mob/proc/EyeMove(n, direct)
	if(!eyeobj)
		return

	if(eyeobj.slowdown)
		applyMoveCooldown(eyeobj.slowdown)

	return eyeobj.EyeMove(n, direct)

/mob/observer/eye/EyeMove(n, direct)
	var/initial = initial(sprint)
	var/max_sprint = 50

	if(cooldown && cooldown < world.timeofday)
		sprint = initial

	for(var/i = 0; i < max(sprint, initial); i += 20)
		var/turf/step = get_turf(get_step(src, direct))
		if(step)
			setLoc(step)

	cooldown = world.timeofday + 5
	if(acceleration)
		sprint = min(sprint + 0.5, max_sprint)
	else
		sprint = initial
	return 1
