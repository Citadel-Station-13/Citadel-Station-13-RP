/mob/observer/dead/verb/nifjoin()
	set category = "Ghost"
	set name = "Join Into Soulcatcher"
	set desc = "Select a player with a working NIF + Soulcatcher NIFSoft to join into it."

	var/list/filtered_list = player_list.Copy()
	for(var/i in filtered_list)
		var/mob/living/carbon/human/H = i
		if(!istype(H))
			filtered_list -= i
			continue
		if(!H.nif)
			filtered_list -= i
			continue
		if(!H.nif.imp_check(NIF_SOULCATCHER))
			filtered_list -= i
			continue
	var/picked = input("Pick a friend with NIF and Soulcatcher to join into. Harrass strangers, get banned. Not everyone has a NIF w/ Soulcatcher (you can't see them in this list if so).","Select a player") as null|anything in filtered_list

	//Didn't pick anyone or picked a null
	if(!picked)
		return

	//Good choice testing and some instance-grabbing
	if(!ishuman(picked))
		to_chat(src,"<span class='warning'>[picked] isn't in a humanoid mob at the moment.</span>")
		return

	var/mob/living/carbon/human/H = picked

	if(H.stat || !H.client)
		to_chat(src,"<span class='warning'>[H] isn't awake/alive at the moment.</span>")
		return

	if(!H.nif)
		to_chat(src,"<span class='warning'>[H] doesn't have a NIF installed.</span>")
		return

	var/datum/nifsoft/soulcatcher/SC = H.nif.imp_check(NIF_SOULCATCHER)
	if(!SC)
		to_chat(src,"<span class='warning'>[H] doesn't have the Soulcatcher NIFSoft installed, or their NIF is unpowered.</span>")
		return

	//Fine fine, we can ask.
	var/obj/item/nif/nif = H.nif
	to_chat(src,"<span class='notice'>Request sent to [H].</span>")

	var/req_time = world.time
	nif.notify("Transient mindstate detected, analyzing...")
	sleep(15) //So if they are typing they get interrupted by sound and message, and don't type over the box
	var/response = alert(H,"[src] ([src.key]) wants to join into your Soulcatcher.","Soulcatcher Request","Deny","Allow")

	if(response == "Deny")
		to_chat(src,"<span class='warning'>[H] denied your request.</span>")
		return

	if((world.time - req_time) > 1 MINUTES)
		to_chat(H,"<span class='warning'>The request had already expired. (1 minute waiting max)</span>")
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

	if(!mind)
		to_chat(src,"<span class='warning'>Your ghost is missing game values that allow this functionality, sorry.</span>")
		return
	var/datum/transcore_db/db = SStranscore.db_by_mind_name(mind.name)
	if(db)
		var/datum/transhuman/mind_record/record = db.backed_up[src.mind.name]
		if(!(record.dead_state == MR_DEAD))
			to_chat(src, "<span class='warning'>Your backup is not past-due yet.</span>")
		else if((world.time - record.last_notification) < 10 MINUTES)
			to_chat(src, "<span class='warning'>Too little time has passed since your last notification.</span>")
		else
			db.notify(record.mindname, TRUE)
			record.last_notification = world.time
			to_chat(src, "<span class='notice'>New notification has been sent.</span>")
	else
		to_chat(src,"<span class='warning'>No backup record could be found, sorry.</span>")
