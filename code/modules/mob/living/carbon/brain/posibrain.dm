/obj/item/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
	req_access = list(ACCESS_SCIENCE_ROBOTICS)

	/// Message sent to the user when polling ghosts
	var/begin_activation_message = SPAN_NOTICE("You carefully locate the manual activation switch and start the positronic brain's boot process.")
	/// Message sent as a visible message on success
	var/success_message = SPAN_NOTICE("The positronic brain pings, and its lights start flashing.  Success!")
	/// Message sent as a visible message on failure
	var/fail_message = SPAN_NOTICE("The positronic brain buzzes quietly, and the golden lights fade away.  Perhaps you could try again?")
	/// Visible message sent when a player possesses the brain
	var/new_mob_message = SPAN_NOTICE("The positronic brain chimes quietly.")
	/// Examine message when the posibrain has no mob
	var/dead_message = SPAN_DEADSAY("It appears to be completely inactive.  The reset light is blinking.")
	/// Examine message when the posibrain cannot poll ghosts due to cooldown
	var/recharge_message = SPAN_WARNING("The positronic brain isn't ready to activate again yet!  Give it some time to recharge.")

	/// Can be set to tell ghosts what the brain will be used for
	var/ask_role = ""
	/// Whether this positronic brain is currently looking for a ghost to enter it.
	var/searching = FALSE
	/// Delay after polling ghosts
	var/ask_delay = 60 SECONDS

/obj/item/mmi/digital/posibrain/Topic(href, href_list)
	if(href_list["activate"])
		var/mob/observer/dead/ghost = usr
		if(istype(ghost))
			question(ghost)

/obj/item/mmi/digital/posibrain/attack_self(mob/user)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		to_chat(user, SPAN_NOTICE("You carefully locate the manual activation switch and start the positronic brain's boot process."))
		icon_state = "posibrain-searching"
		searching = TRUE
		request_player()
		spawn(600)
			reset_search()

/obj/item/mmi/digital/posibrain/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	var/input_seed = tgui_input_text(user, "Enter a personality seed", "Enter seed", ask_role, MAX_NAME_LEN)
	if(isnull(input_seed))
		return
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE))
		return
	to_chat(user, SPAN_NOTICE("You set the personality seed to \"[input_seed]\"."))
	ask_role = input_seed
	update_appearance()

/obj/item/mmi/digital/posibrain/proc/request_player()
	for(var/mob/observer/dead/O in GLOB.player_list)
		if(!O.MayRespawn())
			continue
		if(jobban_isbanned(O, "AI") && jobban_isbanned(O, "Cyborg"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_AI)
				question(O)

/obj/item/mmi/digital/posibrain/proc/question(mob/user)
	if(QDELETED(brainmob))
		return
	var/response = tgui_alert(C, "Someone is requesting a personality for a positronic brain. Would you like to play as one?", "Positronic brain request", list("Yes", "No", "Never for this round"))
	if(response == "Yes")
		response = tgui_alert(C, "Are you sure you want to play as a positronic brain?", "Positronic brain request", list("Yes", "No"))
	if(!C || brainmob.key || 0 == searching)
		return //handle logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
	if(response == "Yes")
		transfer_personality(C.mob)
	else if (response == "Never for this round")
		C.prefs.be_special ^= BE_AI

/obj/item/mmi/digital/posibrain/transfer_identity(mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Positronic Brain"
	to_chat(brainmob, "<span class='notify'>You feel slightly disoriented. That's normal when you're just a metal cube.</span>")
	icon_state = "posibrain-occupied"
	return

/obj/item/mmi/digital/posibrain/proc/transfer_personality(mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are occupying a positronic brain now.")
	src.searching = 0
	src.brainmob.mind = candidate.mind
	src.brainmob.ckey = candidate.ckey
	src.brainmob.mind.reset()
	src.name = "positronic brain ([src.brainmob.name])"
	to_chat(src.brainmob, "<b>You are a positronic brain, brought into existence on [station_name()].</b>")
	to_chat(src.brainmob, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
	to_chat(src.brainmob, "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>")
	to_chat(src.brainmob, "<b>Use say #b to speak to other artificial intelligences.</b>")
	src.brainmob.mind.assigned_role = "Positronic Brain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("<font color=#4F49AF>The positronic brain beeps as it loads a personality.</font>")
	playsound(src, 'sound/misc/boobeebeep.ogg', 50, 1)
	icon_state = "posibrain-occupied"

/obj/item/mmi/digital/posibrain/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.

	if(src.brainmob && src.brainmob.key) return
	log_world("Resetting Posibrain: [brainmob][brainmob ? ", [brainmob.key]" : ""]")

	src.searching = 0
	icon_state = "posibrain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("<font color=#4F49AF>The positronic brain buzzes and beeps, and the golden lights fade away. Perhaps you could try again?</font>")
	playsound(src, 'sound/misc/buzzbeep.ogg', 50, 1)

/obj/item/mmi/digital/posibrain/examine(mob/user)
	. = ..()
	if(brainmob?.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				if(!brainmob.client)
					. += "It appears to be in stand-by mode." //afk
			if(DEAD)
				. += SPAN_DEADSAY("It appears to be completely inactive.")
	else
		. += "[dead_message]"
		if(ask_role)
			. += SPAN_NOTICE("Current consciousness seed: \"[ask_role]\"")
		. += SPAN_BOLDNOTICE("Alt-click to set a consciousness seed, specifying what [src] will be used for. This can help generate a personality interested in that role.")

/obj/item/mmi/digital/posibrain/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(5,10)
			if(4)
				src.brainmob.emp_damage += rand(0,5)
	..()

/obj/item/mmi/digital/posibrain/Initialize(mapload)
	. = ..()
	src.brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	src.brainmob.real_name = src.brainmob.name

///ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/item/mmi/digital/posibrain/attack_ghost(mob/user)
	question(user)
