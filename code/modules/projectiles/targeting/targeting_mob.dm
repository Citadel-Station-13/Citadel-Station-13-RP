/mob/living/var/obj/aiming_overlay/aiming
/mob/living/var/list/aimed = list()

/mob/verb/toggle_gun_mode()
	set name = "Toggle Gun Mode"
	set desc = "Begin or stop aiming."
	set category = "IC"

	if(isliving(src))
		var/mob/living/M = src
		if(!M.aiming)
			M.aiming = new(src)
		M.aiming.toggle_active()
	else
		to_chat(src, "<span class='warning'>This verb may only be used by living mobs, sorry.</span>")
	return

/mob/living/proc/stop_aiming(obj/item/thing, no_message = FALSE)
	if(!aiming)
		aiming = new(src)
	if(thing && aiming.aiming_with != thing)
		return
	aiming.cancel_aiming(no_message)

/mob/living/death(gibbed,deathmessage="seizes up and falls limp...")
	if(..())
		stop_aiming(no_message=1)

/mob/living/update_canmove()
	..()
	if(lying)
		stop_aiming(no_message=1)

/mob/living/Weaken(amount)
	stop_aiming(no_message=1)
	..()

/mob/living/Destroy()
	if(aiming)
		QDEL_NULL(aiming)
	aimed.Cut()
	return ..()

/turf/Enter(mob/living/mover)
	. = ..()
	if(istype(mover))
		if(mover.aiming && mover.aiming.aiming_at)
			mover.aiming.update_aiming()
		if(mover.aimed.len)
			mover.trigger_aiming(TARGET_CAN_MOVE)

/mob/living/forceMove(atom/destination)
	. = ..()
	if(aiming && aiming.aiming_at)
		aiming.update_aiming()
	if(aimed.len)
		trigger_aiming(TARGET_CAN_MOVE)

/mob/living/proc/set_m_intent(intent)
	if (intent != "walk" && intent != "run")
		return 0
	m_intent = intent
	if(hud_used)
		if (hud_used.move_intent)
			hud_used.move_intent.icon_state = intent == "walk" ? "walking" : "running"
