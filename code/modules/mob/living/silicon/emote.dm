/mob/living/silicon/emote(var/act,var/m_type=1,var/message = null)
	. = ..()
	if(. == "stop")
		return
	var/param = null
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/atom/movable/emote_target
	if (param)
		for (var/atom/movable/viewed in view())
			if (!istype(viewed, /obj) && !ismob(viewed))
				continue
			if (viewed.invisibility > see_invisible || viewed.atom_flags & ATOM_ABSTRACT || !length(viewed.name))
				continue
			if (findtext(viewed.name, param) == 1)	// Prefix only.
				emote_target = viewed
				break

	switch(act)
		if ("flap")
			if (!src.restrained())
				message = "flaps its wings."
				m_type = 2

		if ("aflap")
			if (!src.restrained())
				message = "flaps its wings ANGRILY!"
				m_type = 2

		if ("deathgasp")
			message = "shudders violently for a moment, then becomes motionless, its eyes slowly darkening."
			m_type = 1

		if("spin")
			message = "spins!"
			m_type = 1
			if(has_buckled_mobs())
				for(var/mob/living/L in buckled_mobs)
					L.visible_message(SPAN_BOLDWARNING("[L] is hurled off of [src]!"))
					unbuckle_mob(L, BUCKLE_OP_FORCE)
					L.throw_at(get_edge_target_turf(get_turf(src), dir), 7, 1, THROW_AT_IS_GENTLE, src)
			spin(15, 1)
		if("flip")
			if(!CHECK_ALL_MOBILITY(src, MOBILITY_CAN_MOVE | MOBILITY_CAN_USE))
				to_chat(src, "<span class='warning'>You can't *flip in your current state!</span>")
			else
				src.SpinAnimation(7,1)
				m_type = 1

		if("law")
			var/mob/living/silicon/robot/R = src
			if (istype(R) && R.module.is_the_law)
				message = "shows its legal authorization barcode."

				playsound(src.loc, 'sound/voice/biamthelaw.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are not THE LAW, pal.")

		if("halt")
			var/mob/living/silicon/robot/R = src
			if (istype(R) && R.module.is_the_law)
				message = "<B>'s</B> speakers skreech, \"Halt! Security!\"."

				playsound(src.loc, 'sound/voice/halt.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are not security.")

		if("bark")
			var/mob/living/silicon/robot/R = src
			if (istype(R) && R.module.is_dog())
				if (emote_target)
					message = "barks at [emote_target]."
				else
					message = "barks."

				playsound(loc, 'sound/voice/bark2.ogg', 50, 1)
				m_type = 2
			else
				to_chat(src, "You're not a dog!")

		if("arfe")
			var/mob/living/silicon/robot/R = src
			if (istype(R) && R.module.is_dog())
				message = "lets out an A R F E."

				playsound(loc, 'sound/voice/arfe.ogg', 50, 1, -1)
				m_type = 2
			else
				to_chat(src, "You're not a dog!")

		if("gonk")
			if (emote_target)
				message = "gonks at [emote_target]."
			else
				message = "gonks."
			playsound(src.loc, 'sound/machines/gonk.ogg', 50, 0)
			m_type = 1

		if("mrrp")
			var/mob/living/silicon/robot/R = src
			if (istype(R) && R.module.is_cat())
				message = "mrrps."

				playsound(loc, 'sound/voice/mrrp.ogg', 50, 1, -1)
				m_type = 2
			else
				to_chat(src, "You're not a cat!")

		if("prbt")
			var/mob/living/silicon/robot/R = src
			if (istype(R) && R.module.is_cat())
				message = "prbts."

				playsound(loc, 'sound/misc/prbt.ogg', 50, 1, -1)
				m_type = 2
			else
				to_chat(src, "You're not a cat!")

		if("hiss")
			var/mob/living/silicon/robot/R = src
			if (istype(R) && R.module.is_cat())
				message = "lets out a hiss."

				playsound(loc, 'sound/voice/hiss.ogg', 50, 1, -1)
				m_type = 2
			else
				to_chat(src, "You're not a cat!")

		if("purr")
			var/mob/living/silicon/robot/R = src
			if (istype(R) && R.module.is_cat())
				message = "purrs softly."

				playsound(loc, 'sound/voice/purr.ogg', 50, 1, -1)
				m_type = 2
			else
				to_chat(src, "You're not a cat!")

		if ("help")
			to_chat(src, "salute, bow-(none)/mob, clap, flap, aflap, twitch, twitch_s, nod, deathgasp, glare-(none)/mob, stare-(none)/mob, look, beep, ping, \nbuzz, law, halt, yes, no")
		else
			to_chat(src, "<font color=#4F49AF>Unusable emote '[act]'. Say *help for a list.</font>")
