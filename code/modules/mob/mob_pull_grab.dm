/mob/living/start_pulling(atom/movable/AM, supress_message = FALSE)
	if(!AM || !src)
		return FALSE
	if(!(AM.can_be_pulled(src, state)))
		return FALSE
	if(throwing || restrained())// || !(mobility_flags & MOBILITY_PULL))
		return FALSE

	// vorecode start why isn't this move force
	if(ismob(AM))
		var/mob/M = AM

		if(!can_pull_mobs || !can_pull_size)
			to_chat(src, "<span class='warning'>They won't budge!</span>")
			return

		if((mob_size < M.mob_size) && (can_pull_mobs != MOB_PULL_LARGER))
			to_chat(src, "<span class='warning'>[M] is too large for you to move!</span>")
			return

		if((mob_size == M.mob_size) && (can_pull_mobs == MOB_PULL_SMALLER))
			to_chat(src, "<span class='warning'>[M] is too heavy for you to move!</span>")
			return

		// If your size is larger than theirs and you have some
		// kind of mob pull value AT ALL, you will be able to pull
		// them, so don't bother checking that explicitly.

		if(M.grabbed_by.len)
			// Only start pulling when nobody else has a grab on them
			. = 1
			for(var/obj/item/grab/G in M.grabbed_by)
				if(G.assailant != usr)
					. = 0
				else
					qdel(G)
			if(!.)
				to_chat(src, "<span class='warning'>Somebody has a grip on them!</span>")
				return

		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = usr

	else if(isobj(AM))
		var/obj/I = AM
		if(!can_pull_size || can_pull_size < I.w_class)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return
	// vorecode end

	AM.add_fingerprint(src)

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling)
		// Are we trying to pull something we are already pulling? Then just stop here, no need to continue.
		if(AM == pulling)
			return
		stop_pulling()

	changeNext_move(CLICK_CD_GRABBING)

	if(AM.pulledby)
		if(!supress_message)
			AM.visible_message("<span class='danger'>[src] pulls [AM] from [AM.pulledby]'s grip.</span>", \
							"<span class='danger'>[src] pulls you from [AM.pulledby]'s grip.</span>", null, null, src)
			to_chat(src, "<span class='notice'>You pull [AM] from [AM.pulledby]'s grip!</span>")
		log_combat(AM, AM.pulledby, "pulled from", src)
		AM.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.

	pulling = AM
	AM.pulledby = src

	SEND_SIGNAL(src, COMSIG_LIVING_START_PULL, AM, state, force)

	if(!supress_message)
		var/sound_to_play = 'sound/weapons/thudswoosh.ogg'
		/*
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(H.dna.species.grab_sound)
				sound_to_play = H.dna.species.grab_sound
			if(HAS_TRAIT(H, TRAIT_STRONG_GRABBER))
				sound_to_play = null
		*/
		playsound(src.loc, sound_to_play, 50, TRUE, -1)
	update_pull_hud_icon()

	if(ismob(AM))
		var/mob/M = AM

		log_combat(src, M, "grabbed", addition="passive grab")
		if(!supress_message && !(iscarbon(AM) && HAS_TRAIT(src, TRAIT_STRONG_GRABBER)))
			M.visible_message("<span class='warning'>[src] grabs [M] [(zone_selected == "l_arm" || zone_selected == "r_arm" && ishuman(M))? "by their hands":"passively"]!</span>", \
							"<span class='warning'>[src] grabs you [(zone_selected == "l_arm" || zone_selected == "r_arm" && ishuman(M))? "by your hands":"passively"]!</span>", null, null, src)
			to_chat(src, "<span class='notice'>You grab [M] [(zone_selected == "l_arm" || zone_selected == "r_arm" && ishuman(M))? "by their hands":"passively"]!</span>")
		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = usr
/*
		if(isliving(M))
			var/mob/living/L = M
			//Share diseases that are spread by touch
			for(var/thing in diseases)
				var/datum/disease/D = thing
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
					L.ContactContractDisease(D)

			for(var/thing in L.diseases)
				var/datum/disease/D = thing
				if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
					ContactContractDisease(D)
*/

			//update_pull_movespeed()

		// vorecode start
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.pull_damage())
				to_chat(src, "<font color='red'><B>Pulling \the [H] in their current condition would probably be a bad idea.</B></font>")
		pulled.inertia_dir = 0
		// vorecode end

/mob/verb/stop_pulling_verb()
	set name = "Stop Pulling"
	set category = "IC"
	stop_pulling()

/mob/stop_pulling()
	. = ..()
	update_pull_hud_icon()
