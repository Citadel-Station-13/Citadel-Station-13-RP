/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)
	var/param = null
	var/datum/gender/T = GLOB.gender_datums[get_visible_gender()]
	if(istype(src, /mob/living/carbon/human/dummy))
		return
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	//if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
	//	act = copytext(act,1,length(act))

	var/muzzled = is_muzzled()
	//var/m_type = 1

	for(var/obj/item/organ/O in src.organs)
		for (var/obj/item/implant/I in O)
			if (I.implanted)
				I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	if(attempt_vr(src,"handle_emote_vr",list(act,m_type,message)))
		return // Custom Emote Handler
	switch(act)

		//Promethean-only emotes
		if("squish")
			if(species.bump_flag != SLIME) //This should definitely do it.
				to_chat(src, "<span class='warning'>You are not a slime thing!</span>")
				return
			playsound(src.loc, 'sound/effects/slime_squish.ogg', 50, 0) //Credit to DrMinky (freesound.org) for the sound.
			message = "squishes."
			m_type = 1

		// SHRIEK VOXXY ONLY
		if ("shriekloud")
			if(src.species.get_species_id() != SPECIES_ID_VOX)
				to_chat(src, "<span class='warning'>You aren't ear piercingly vocal enough!</span>")
				return
			playsound(src.loc, 'sound/voice/shrieksneeze.ogg', 50, 0)
			message = "gives a short sharp shriek!"
			m_type = 1

		if ("shriekshort")
			if(src.species.get_species_id() != SPECIES_ID_VOX)
				to_chat(src, "<span class='warning'>You aren't noisy enough!</span>")
				return
			playsound(src.loc, 'sound/voice/shriekcough.ogg', 50, 0)
			message = "gives a short, quieter shriek!"
			m_type = 1

		// SQUID GAMES
		if ("achime")
			if(src.species.get_species_id() != SPECIES_ID_ADHERENT)
				to_chat(src, "<span class='warning'>You aren't floaty enough!</span>")
				return
			playsound(src.loc, 'sound/machines/achime.ogg', 50, 0)
			message = "chimes!"
			m_type = 1

		//Xenomorph Hybrid
		if("xhiss")
			if(src.species.get_species_id() != SPECIES_ID_XENOHYBRID)
				to_chat(src, "<span class='warning'>You aren't alien enough!</span>")
				return
			playsound(src.loc, 'sound/voice/xenos/alien_hiss3.ogg', 50, 0)
			message = "hisses!"
			m_type = 2

		if("xroar")
			if(src.species.get_species_id() != SPECIES_ID_XENOHYBRID)
				to_chat(src, "<span class='warning'>You aren't alien enough!</span>")
				return
			playsound(src.loc, 'sound/voice/xenos/alien_roar1.ogg', 50, 0)
			message = "roars!"
			m_type = 2

		if("xgrowl")
			if(src.species.get_species_id() != SPECIES_ID_XENOHYBRID)
				to_chat(src, "<span class='warning'>You aren't alien enough!</span>")
				return
			playsound(src.loc, 'sound/voice/xenos/alien_growl1.ogg', 50, 0)
			message = "growls!"
			m_type = 2

		if("xkiss")
			if(src.species.get_species_id() != SPECIES_ID_XENOHYBRID)
				to_chat(src, "<span class='warning'>You aren't alien enough!</span>")
				return
			var/M = null
			if (param)
				for (var/mob/A in view(1,src.loc))
					if (param == A.name)
						M = A
						break
				if (!M)
					param = null

				if (param)
					message = "extends their inner jaw outwards giving [param] a kiss."
			m_type = 1

		if("cough", "coughs")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears to cough!"
				m_type = 1
			else
				if(!muzzled)
					var/robotic = 0
					m_type = 2
					if(should_have_organ(O_LUNGS))
						var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
						if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
							robotic = 1
					if(!robotic)
						message = "coughs!"
						if(get_gender() == FEMALE)
							if(species.female_cough_sounds)
								playsound(src, pick(species.female_cough_sounds), 120)
						else
							if(species.male_cough_sounds)
								playsound(src, pick(species.male_cough_sounds), 120)
					else
						message = "emits a robotic cough"
						var/use_sound
						if(get_gender() == FEMALE)
							use_sound = pick('sound/effects/mob_effects/f_machine_cougha.ogg','sound/effects/mob_effects/f_machine_coughb.ogg')
						else
							use_sound = pick('sound/effects/mob_effects/m_machine_cougha.ogg','sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg')
						playsound(src.loc, use_sound, 50, 0)
				else
					message = "makes a strong noise."
					m_type = 2

		if("bcough")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears to cough up blood!"
				m_type = 1
			else
				if(!muzzled)
					var/robotic = 0
					m_type = 2
					if(should_have_organ(O_LUNGS))
						var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
						if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
							robotic = 1
					if(!robotic)
						message = "coughs up a small amount of blood!"
						BloodyMouth()
						if(get_gender() == FEMALE)
							if(species.female_cough_sounds)
								playsound(src, pick(species.female_cough_sounds), 120)
						else
							if(species.male_cough_sounds)
								playsound(src, pick(species.male_cough_sounds), 120)

		if ("deathgasp")
			message = "[species.get_death_message()]"
			m_type = 1

		if("sneeze", "sneezes")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "sneezes."
				m_type = 1
			else
				if(!muzzled)
					var/robotic = 0
					m_type = 2
					if(should_have_organ(O_LUNGS))
						var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
						if(L && L.robotic == 2)	//Hard-coded to 2, incase we add lifelike robotic lungs
							robotic = 1
					if(!robotic)
						message = "sneezes."
						if(get_gender() == FEMALE)
							playsound(src, species.female_sneeze_sound, 70)
						else
							playsound(src, species.male_sneeze_sound, 70)
						m_type = 2
					else
						message = "emits a robotic sneeze"
						var/use_sound
						if(get_gender() == FEMALE)
							use_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
						else
							use_sound = 'sound/effects/mob_effects/f_machine_sneeze.ogg'
						playsound(src.loc, use_sound, 50, 0)
				else
					message = "makes a strange noise."
					m_type = 2

		if("aslap", "aslaps")
			m_type = 1
			var/mob/living/carbon/human/H = src
			var/obj/item/organ/external/L = H.get_organ("l_hand")
			var/obj/item/organ/external/R = H.get_organ("r_hand")
			var/left_hand_good = 0
			var/right_hand_good = 0
			if(L && (!(L.status & ORGAN_DESTROYED)) && (!(L.splinted)) && (!(L.status & ORGAN_BROKEN)))
				left_hand_good = 1
			if(R && (!(R.status & ORGAN_DESTROYED)) && (!(R.splinted)) && (!(R.status & ORGAN_BROKEN)))
				right_hand_good = 1

			if(!left_hand_good && !right_hand_good)
				to_chat(usr, "You need at least one hand in good working order to slap someone.")
				return
			if(!restrained())
				var/M = null
				if(param)
					for(var/mob/A in view(1, null))
						if(param == A.name)
							M = A
							break
				if(M)
					message = "<span class='danger'>slaps [M]'s butt.</span>"
					playsound(loc, 'sound/effects/snap.ogg', 50, 1)
					add_attack_logs(src,M,"Buttslap")
				else
					message = "<span class='danger'>slaps [T.his] own butt!</span>"
					playsound(loc, 'sound/effects/snap.ogg', 50, 1)
					add_attack_logs(src,src,"Slapped own butt")
					//adding damage for aslaps to stop the spam

		if("scream", "screams")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "acts out a scream!"
				m_type = 1
			else
				if(!muzzled)
					message = "[species.scream_verb]!"
					m_type = 2
					if(get_gender() == FEMALE)
						if(!spam_flag)
							playsound(loc, "[pick(species.female_scream_sound)]", 80, 1)
							spam_flag = TRUE
							addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)

					else
						if(!spam_flag)
							playsound(loc, "[pick(species.male_scream_sound)]", 80, 1) //default to male screams if no gender is present.
							spam_flag = TRUE
							addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)
				else
					message = "makes a very loud noise."
					m_type = 2

		if("snap", "snaps")
			m_type = 2
			var/mob/living/carbon/human/H = src
			var/obj/item/organ/external/L = H.get_organ("l_hand")
			var/obj/item/organ/external/R = H.get_organ("r_hand")
			var/left_hand_good = 0
			var/right_hand_good = 0
			if(L && (!(L.status & ORGAN_DESTROYED)) && (!(L.splinted)) && (!(L.status & ORGAN_BROKEN)))
				left_hand_good = 1
			if(R && (!(R.status & ORGAN_DESTROYED)) && (!(R.splinted)) && (!(R.status & ORGAN_BROKEN)))
				right_hand_good = 1

			if(!left_hand_good && !right_hand_good)
				to_chat(usr, "You need at least one hand in good working order to snap your fingers.")
				return

			message = "snaps [T.his] fingers."
			playsound(loc, 'sound/effects/fingersnap.ogg', 50, 1, -3)

		if ("help")
			to_chat(src, "nyaha, awoo, bark, blink, blink_r, blush, bow-(none)/mob, burp, chirp, choke, chuckle, clap, collapse, cough, cry, custom, deathgasp, drool, eyebrow, fastsway/qwag, \
					flip, frown, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hiss, hug-(none)/mob, laugh, look-(none)/mob, merp, moan, mumble, nod, nya, pale, peep, point-atom, \
					raise, roll, salute, fullsalute, scream, sneeze, shake, shiver, shrug, sigh, signal-#1-10, slap-(none)/mob, smile, sneeze, sniff, snore, stare-(none)/mob, stopsway/swag, squeak, sway/wag, swish, tremble, twitch, \
					twitch_v, vomit, weh, whimper, wink, yawn. Moth: mchitter, mlaugh, mscream, msqueak. Synthetics: beep, buzz, buzz2, chime, die, dwoop, error, honk, no, ping, rcough, rsneeze, scary, \
					shutdown, startup, warn, ye, yes. Vox: shriekshort, shriekloud")

		else
			..()

	if (message)
		custom_emote(m_type,message)





/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	var/datum/gender/T = GLOB.gender_datums[get_visible_gender()]

	pose =  sanitize(input(usr, "This is [src]. [T.he]...", "Pose", null)  as text)

	visible_emote("adjusts [T.his] posture.")

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	src << browse(HTML, "window=flavor_changes;size=430x300")

/mob/living/carbon/human/proc/handle_emote_vr(var/act,var/m_type=1,var/message = null)

	switch(act)
		if ("vwag")
			if(toggle_tail_vr(message = 1))
				m_type = 1
				message = "[wagging ? "starts" : "stops"] wagging their tail."
			else
				return 1
		if ("vflap")
			if(toggle_wing_vr(message = 1))
				m_type = 1
				message = "[flapping ? "starts" : "stops"] flapping their wings."
			else
				return 1
		if ("vspread")
			if(toggle_wing_spread(message = 1))
				m_type = 1
				message = "[spread ? "extends" : "retracts"] their wings."
			else
				return 1
		if ("mlem")
			message = "mlems [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] tongue up over [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] nose. Mlem."
			m_type = 1
///////////////////////// EMOTES PORTED FROM MAIN START
		if ("awoo")
			m_type = 2
			message = "lets out an awoo."
			playsound(loc, 'sound/voice/awoo.ogg', 50, 1, -1)
		if ("nya")
			message = "lets out a nya."
			m_type = 2
			var/use_sound
			use_sound = pick('sound/voice/nya.ogg')
			playsound(src.loc, use_sound, 50, 0)
		if ("nyaha")
			if(!spam_flag)
				var/list/catlaugh = list('sound/voice/catpeople/nyaha.ogg', 'sound/voice/catpeople/nyahaha1.ogg', 'sound/voice/catpeople/nyahaha2.ogg', 'sound/voice/catpeople/nyahehe.ogg')
				playsound(loc, pick(catlaugh), 50, 1, -1)
				spam_flag = TRUE
				addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)
			var/list/laughs = list("laughs deviously.", "lets out a catty laugh.", "nya ha ha's.")
			message = "[pick(laughs)]"
			m_type = 2
		if ("peep")
			message = "peeps like a bird."
			m_type = 2
			playsound(loc, 'sound/voice/peep.ogg', 50, 1, -1)
		if("chirp")
			message = "chirps!"
			playsound(src.loc, 'sound/misc/nymphchirp.ogg', 50, 0)
			m_type = 2
		if("prbt")
			message = "prbts."
			playsound(src.loc, 'sound/misc/prbt.ogg', 50, 1, -1)
			m_type = 2
		if ("mrrp")
			message = "mrrps"
			m_type = 2
			playsound(src.loc, "sound/voice/mrrp.ogg", 50, 1, -1)
		if ("weh")
			message = "lets out a weh."
			m_type = 2
			playsound(loc, 'sound/voice/weh.ogg', 50, 1, -1)
		if ("merp")
			message = "lets out a merp."
			m_type = 2
			playsound(loc, 'sound/voice/merp.ogg', 50, 1, -1)
		if ("bark")
			message = "lets out a bark."
			m_type = 2
			playsound(loc, 'sound/voice/bark2.ogg', 50, 1, -1)
		if ("hiss")
			message = "lets out a hiss."
			m_type = 2
			playsound(loc, 'sound/voice/hiss.ogg', 50, 1, -1)
		if ("squeak")
			message = "lets out a squeak."
			m_type = 2
			playsound(loc, 'sound/effects/mouse_squeak.ogg', 50, 1, -1)
		if("mar")
			message = "lets out a mar."
			m_type = 2
			playsound(loc, 'sound/voice/mar.ogg', 50, 1, -1)	
		if ("nsay")
			nsay()
			return TRUE
		if ("nme")
			nme()
			return TRUE
		if ("mchitter")
			message = "chitters."
			m_type = 2
			playsound(loc, 'sound/voice/moth/mothchitter.ogg', 50, 1, -1)
		if ("mlaugh")
			message = "laughs."
			m_type = 2
			playsound(loc, 'sound/voice/moth/mothlaugh.ogg', 50, 1, -1)
		if ("mscream")
			message = "screams!"
			m_type = 2
			playsound(loc, 'sound/voice/moth/scream_moth.ogg', 50, 1, -1)
		if ("msqueak")
			message = "lets out a squeak."
			m_type = 2
			playsound(loc, 'sound/voice/moth/mothsqueak.ogg', 50, 1, -1)
		if ("flip")
			var/list/involved_parts = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
			//Check if they are physically capable
			if(!CHECK_MOBILITY(src, MOBILITY_CAN_MOVE) || involved_parts.len < 2)
				to_chat(src, "<span class='warning'>You can't *flip in your current state!</span>")
				return 1
			else
				m_type = 1
				if(!spam_flag)
					src.SpinAnimation(7,1)
					message = "does a flip!"
					spam_flag = TRUE
					addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)
				else
					if(prob(30)) // Little known fact: HRP is /tg/ + 10
						src.afflict_paralyze(20 * 2)
						if(prob(50))
							src.adjustBruteLoss(1)
							message = "attempts to do a flip and falls on their face. Ouch!"
						else
							message = "attempts to do a flip and falls over, what a doofus!"
					else
						src.SpinAnimation(7,1)
						message = "lands another flip. Smooth!"
						spam_flag = TRUE
						addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)

// New emotes below this line
		if ("purr")
			message = "purrs softly."
			m_type = 2
			playsound(loc, 'sound/voice/purr.ogg', 50, 1, -1)
		if ("clak")
			if(!spam_flag)
				var/msg = list("<font color='grey' size='2'>CLAKS!</font>", "claks!")
				message = "[pick(msg)]"
				playsound(loc, 'sound/spooky/boneclak.ogg', 50, 1, 1)
				spam_flag = TRUE
				addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)
			m_type = 2
	if (message)
		custom_emote(m_type,message)
		return 1

	return 0

/mob/living/carbon/human/proc/toggle_tail_vr(var/setting,var/message = 0)
	if(!tail_style || !tail_style.ani_state)
		if(message)
			to_chat(src, "<span class='warning'>You don't have a tail that supports this.</span>")
		return 0

	var/new_wagging = isnull(setting) ? !wagging : setting
	if(new_wagging != wagging)
		wagging = new_wagging
		update_tail_showing()
	return 1

/mob/living/carbon/human/proc/toggle_wing_vr(var/setting,var/message = 0)
	if(!wing_style || !wing_style.ani_state)
		if(message)
			to_chat(src, "<span class='warning'>You don't have wings that support this.</span>")
		return 0

	var/new_flapping = isnull(setting) ? !flapping : setting
	if(new_flapping != flapping)
		flapping = setting
		if(flapping)
			spread = FALSE
		update_wing_showing()
	return 1

/mob/living/carbon/human/proc/toggle_wing_spread(var/folded,var/message = 0)
	if(!wing_style)
		if(message)
			to_chat(src, "<span class='warning'>You don't have wings!</span>")
		return 0

	if(!wing_style.spr_state)
		if(message)
			to_chat(src, "<span class='warning'>You don't have wings that support this.</span>")
		return 0

	var/new_spread = isnull(folded) ? !spread : folded
	if(new_spread != spread)
		spread = new_spread
		if(spread)
			flapping = FALSE
		update_wing_showing()
	return 1

/mob/living/carbon/human/verb/toggle_gender_identity_vr()
	set name = "Set Gender Identity"
	set desc = "Sets the pronouns when examined and performing an emote."
	set category = "IC"
	var/new_gender_identity = input("Please select a gender Identity.") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL, HERM)
	if(!new_gender_identity)
		return 0
	change_gender_identity(new_gender_identity)
	return 1

/mob/living/carbon/human/verb/switch_tail_layer()
	set name = "Switch tail layer"
	set category = "IC"
	set desc = "Switch tail layer on top."
	tail_alt = !tail_alt
	update_tail_showing()
