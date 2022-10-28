/mob/living/silicon/robot/emote(var/act,var/m_type=1,var/message = null)
	var/param = null
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

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
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "salutes to [param]."
				else
					message = "salutes."
			m_type = 1
		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "bows to [param]."
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
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "glares at [param]."
			else
				message = "glares."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "stares at [param]."
			else
				message = "stares."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "looks at [param]."
			else
				message = "looks."
			m_type = 1

		if("beep")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "beeps at [param]."
			else
				message = "beeps."
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)
			m_type = 1

		if("ping")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "pings at [param]."
			else
				message = "pings."
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
			m_type = 1

		if("buzz")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "buzzes at [param]."
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
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "emits an affirmative blip at [param]."
			else
				message = "emits an affirmative blip."
			playsound(src, 'sound/machines/synth_yes.ogg', 50, 0)
			m_type = 1

		if("no")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "emits a negative blip at [param]."
			else
				message = "emits a negative blip."
			playsound(src.loc, 'sound/machines/synth_no.ogg', 50, 0)
			m_type = 1

		if("scary")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "emits a disconcerting tone at [param]."
			else
				message = "emits a disconcerting tone."
			playsound(src.loc, 'sound/machines/synth_scary.ogg', 50, 0)
			m_type = 1

		if("dwoop")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "chirps happily at [param]."
			else
				message = "chirps happily."
			playsound(src.loc, 'sound/machines/dwoop.ogg', 50, 0)
			m_type = 1

		if("startup")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "chimes to life."
			else
				message = "chimes to life."
			playsound(src.loc, 'sound/machines/synth_startup.ogg')
			m_type = 1

		if("shutdown")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "emits a nostalgic tone as they fall silent."
			else
				message = "emits a nostalgic tone as they fall silent."
			playsound(src.loc, 'sound/machines/synth_shutdown.ogg')
			m_type = 1

		if("error")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "experiences a system error."
			else
				message = "experiences a system error."
			playsound(src.loc, 'sound/machines/synth_error.ogg')
			m_type = 1

		if("die")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "crumples, their chassis colder and more lifeless than usual."
			else
				message = "crumples, their chassis colder and more lifeless than usual."
			playsound(src.loc, 'sound/machines/synth_gameover.ogg')
			m_type = 1

		if("flip")
			if(src.sleeping || src.resting || src.buckled || src.weakened || src.restrained())
				to_chat(src, "<span class='warning'>You can't *flip in your current state!</span>")
			else
				src.SpinAnimation(7,1)
				m_type = 1

		if("law")
			if (istype(module,/obj/item/robot_module/robot/security) || istype(module,/obj/item/robot_module/robot/quad_sec))
				message = "shows its legal authorization barcode."

				playsound(src.loc, 'sound/voice/biamthelaw.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are not THE LAW, pal.")

		if("halt")
			if (istype(module,/obj/item/robot_module/robot/security) || istype(module,/obj/item/robot_module/robot/quad_sec))
				message = "<B>'s</B> speakers skreech, \"Halt! Security!\"."

				playsound(src.loc, 'sound/voice/halt.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are not security.")

		if("bark")
			if (istype(module,/obj/item/robot_module/robot/quad_sec) || istype(module,/obj/item/robot_module/robot/quad_medi) || istype(module,/obj/item/robot_module/robot/quad_jani) || istype(module,/obj/item/robot_module/robot/ert) || istype(module,/obj/item/robot_module/robot/quad_sci) || istype(module,/obj/item/robot_module/robot/quad_engi) || istype(module,/obj/item/robot_module/robot/clerical/quad_serv) || istype(module,/obj/item/robot_module/robot/quad_basic) || istype(module,/obj/item/robot_module/robot/quad_miner))
				message = "lets out a bark."

				playsound(loc, 'sound/voice/bark2.ogg', 50, 1, -1)
				m_type = 2
			else
				to_chat(src, "You're not a dog!")
		if("arfe")
			if (istype(module,/obj/item/robot_module/robot/quad_sec) || istype(module,/obj/item/robot_module/robot/quad_medi) || istype(module,/obj/item/robot_module/robot/quad_jani) || istype(module,/obj/item/robot_module/robot/ert) || istype(module,/obj/item/robot_module/robot/quad_sci) || istype(module,/obj/item/robot_module/robot/quad_engi) || istype(module,/obj/item/robot_module/robot/clerical/quad_serv) || istype(module,/obj/item/robot_module/robot/quad_basic) || istype(module,/obj/item/robot_module/robot/quad_miner))
				message = "lets out an A R F E."

				playsound(loc, 'sound/voice/arfe.ogg', 50, 1, -1)
				m_type = 2
			else
				to_chat(src, "You're not a dog!")

		if("gonk")
			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if (param)
				message = "gonks at [param]."
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
