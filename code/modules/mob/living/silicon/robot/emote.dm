/mob/living/silicon/robot/emote(var/act,var/m_type=1,var/message = null)
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
		if ("me")
			if (src.client)
				if(client.prefs.muted & MUTE_IC)
					to_chat(src, "You cannot send IC messages (muted).")
					return
			if (stat)
				return
			if(!(message))
				return
			else
				return custom_emote(m_type, message)

		if ("custom")
			return custom_emote(m_type, message)

		if ("salute")
			if (!src.buckled)
				if (emote_target)
					message = "salutes to [emote_target]."
				else
					message = "salutes."
			m_type = 1
		if ("bow")
			if (!src.buckled)
				if (emote_target)
					message = "bows to [emote_target]."
				else
					message = "bows."
			m_type = 1

		if ("clap")
			if (!src.restrained())
				message = "claps."
				m_type = 2
		if ("flap")
			if (!src.restrained())
				message = "flaps its wings."
				m_type = 2

		if ("aflap")
			if (!src.restrained())
				message = "flaps its wings ANGRILY!"
				m_type = 2

		if ("twitch")
			message = "twitches."
			m_type = 1

		if ("twitch_v")
			message = "twitches violently."
			m_type = 1

		if ("nod")
			message = "nods."
			m_type = 1

		if ("deathgasp")
			message = "shudders violently for a moment, then becomes motionless, its eyes slowly darkening."
			m_type = 1

		if ("glare")
			if (emote_target)
				message = "glares at [emote_target]."
			else
				message = "glares."

		if ("stare")
			if (emote_target)
				message = "stares at [emote_target]."
			else
				message = "stares."

		if ("look")
			if (emote_target)
				message = "looks at [emote_target]."
			else
				message = "looks."
			m_type = 1

		if("beep")
			if (emote_target)
				message = "beeps at [emote_target]."
			else
				message = "beeps."
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)
			m_type = 1

		if("ping")
			if (emote_target)
				message = "pings at [emote_target]."
			else
				message = "pings."
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
			m_type = 1

		if("buzz")
			if (emote_target)
				message = "buzzes at [emote_target]."
			else
				message = "buzzes."
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
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

		if("yes", "ye")
			if (emote_target)
				message = "emits an affirmative blip at [emote_target]."
			else
				message = "emits an affirmative blip."
			playsound(src, 'sound/machines/synth_yes.ogg', 50, 0)
			m_type = 1

		if("no")
			if (emote_target)
				message = "emits a negative blip at [emote_target]."
			else
				message = "emits a negative blip."
			playsound(src.loc, 'sound/machines/synth_no.ogg', 50, 0)
			m_type = 1

		if("scary")
			if (emote_target)
				message = "emits a disconcerting tone at [emote_target]."
			else
				message = "emits a disconcerting tone."
			playsound(src.loc, 'sound/machines/synth_scary.ogg', 50, 0)
			m_type = 1

		if("dwoop")
			if (emote_target)
				message = "chirps happily at [emote_target]."
			else
				message = "chirps happily."
			playsound(src.loc, 'sound/machines/dwoop.ogg', 50, 0)
			m_type = 1

		if("startup")
			message = "chimes to life."
			playsound(src.loc, 'sound/machines/synth_startup.ogg', 50)
			m_type = 1

		if("shutdown")
			message = "emits a nostalgic tone as they fall silent."
			playsound(src.loc, 'sound/machines/synth_shutdown.ogg', 50)
			m_type = 1

		if("error")
			message = "experiences a system error."
			playsound(src.loc, 'sound/machines/synth_error.ogg', 50)
			m_type = 1

		if("die")
			message = "crumples, their chassis colder and more lifeless than usual."
			playsound(src.loc, 'sound/machines/synth_gameover.ogg', 50)
			m_type = 1

		if("flip")
			if(!CHECK_ALL_MOBILITY(src, MOBILITY_MOVE | MOBILITY_USE))
				to_chat(src, "<span class='warning'>You can't *flip in your current state!</span>")
			else
				src.SpinAnimation(7,1)
				m_type = 1

		if("law")
			if (module.is_the_law)
				message = "shows its legal authorization barcode."

				playsound(src.loc, 'sound/voice/biamthelaw.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are not THE LAW, pal.")

		if("halt")
			if (module.is_the_law)
				message = "<B>'s</B> speakers skreech, \"Halt! Security!\"."

				playsound(src.loc, 'sound/voice/halt.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are not security.")

		if("bark")
			if (module.is_dog())
				if (emote_target)
					message = "barks at [emote_target]."
				else
					message = "barks."

				playsound(loc, 'sound/voice/bark2.ogg', 50, 1)
				m_type = 2
			else
				to_chat(src, "You're not a dog!")

		if("arfe")
			if (module.is_dog())
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

		if ("help")
			to_chat(src, "salute, bow-(none)/mob, clap, flap, aflap, twitch, twitch_s, nod, deathgasp, glare-(none)/mob, stare-(none)/mob, look, beep, ping, \nbuzz, law, halt, yes, no")
		else
			to_chat(src, "<font color=#4F49AF>Unusable emote '[act]'. Say *help for a list.</font>")

	if ((message && src.stat == 0))
		custom_emote(m_type,message)

	return
