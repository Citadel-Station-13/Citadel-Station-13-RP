/mob/observer/dead/verb/nifjoin()
	set category = "Ghost"
	set name = "Join Into Soulcatcher"
	set desc = "Select a player with a working NIF + Soulcatcher NIFSoft to join into it."

	var/list/filtered = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.nif?.imp_check(NIF_SOULCATCHER))
			continue
		var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
		if(!SC.visibility_check(ckey))
			continue
		filtered += H

	var/picked = tgui_input_list(usr, "Pick a friend with NIF and Soulcatcher to join into. Harrass strangers, get banned. Not everyone has a NIF w/ Soulcatcher.","Select a player", filtered)

	//Didn't pick anyone or picked a null
	if(!picked)
		return

	//Good choice testing and some instance-grabbing
	if(!ishuman(picked))
		to_chat(src,SPAN_WARNING("[picked] isn't in a humanoid mob at the moment."))
		return

	var/mob/living/carbon/human/H = picked

	if(H.stat || !H.client)
		to_chat(src,SPAN_WARNING("[H] isn't awake/alive at the moment."))
		return

	if(!H.nif)
		to_chat(src,SPAN_WARNING("[H] doesn't have a NIF installed."))
		return

	var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
	if(!SC?.visibility_check(ckey))
		to_chat(src,SPAN_WARNING("[H] doesn't have the Soulcatcher NIFSoft installed, or their NIF is unpowered."))
		return

	//Fine fine, we can ask.
	var/obj/item/nif/nif = H.nif
	to_chat(src,SPAN_NOTICE("Request sent to [H]."))

	var/req_time = world.time
	nif.notify("Transient mindstate detected, analyzing...")
	sleep(15) //So if they are typing they get interrupted by sound and message, and don't type over the box
	var/response = tgui_alert(H,"[src] ([src.key]) wants to join into your Soulcatcher.","Soulcatcher Request",list("Deny","Allow"))

	if(response == "Deny")
		to_chat(src,SPAN_WARNING("[H] denied your request."))
		return

	if((world.time - req_time) > 1 MINUTES)
		to_chat(H,SPAN_WARNING("The request had already expired. (1 minute waiting max)"))
		return

	//Final check since we waited for input a couple times.
	if(H && src && src.key && !H.stat && nif && SC)
		if(!mind) //No mind yet, aka haven't played in this round.
			mind = new(key)

		mind.name = name
		mind.current = src
		mind.active = TRUE

		SC.catch_mob(src) //This will result in us being deleted so...

/mob/observer/dead/verb/backup_ping()
	set category = "Ghost"
	set name = "Notify Transcore"
	set desc = "If your past-due backup notification was missed or ignored, you can use this to send a new one."

	if(src.mind.name in SStranscore.backed_up)
		var/datum/transhuman/mind_record/record = SStranscore.backed_up[src.mind.name]
		if(!(record.dead_state == MR_DEAD))
			to_chat(src, SPAN_WARNING("Your backup is not past-due yet."))
		else if((world.time - record.last_notification) < 10 MINUTES)
			to_chat(src, SPAN_WARNING("Too little time has passed since your last notification."))
		else
			SStranscore.notify(record.mindname, TRUE)
			record.last_notification = world.time
			to_chat(src, SPAN_NOTICE("New notification has been sent."))
	else
		to_chat(src, SPAN_WARNING("No mind record found!"))
