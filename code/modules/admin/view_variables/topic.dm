//DO NOT ADD MORE TO THIS FILE.
//Use vv_do_topic() for datums!
/client/proc/view_var_Topic(href, href_list, hsrc)
	if(!check_rights_for(src, R_VAREDIT) || !holder.CheckAdminHref(href, href_list))
		return
	var/target = GET_VV_TARGET
	vv_do_basic(target, href_list, href)
	if(isdatum(target))
		var/datum/D = target
		D.vv_do_topic(href_list)
	else if(islist(target))
		vv_do_list(target, href_list)
	if(href_list["Vars"])
		var/datum/vars_target = locate(href_list["Vars"])
		if(href_list["special_varname"]) // Some special vars can't be located even if you have their ref, you have to use this instead
			vars_target = vars_target.vars[href_list["special_varname"]]
		debug_variables(vars_target)

	//~CARN: for renaming mobs (updates their name, real_name, mind.name, their ID/PDA and datacore records).
	else if(href_list["rename"])
		var/mob/M = locate(href_list["rename"]) in GLOB.mob_list
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob", confidential = TRUE)
			return

		var/new_name = stripped_input(usr,"What would you like to name this mob?","Input a name",M.real_name,MAX_NAME_LEN)

		if( !new_name || !M )
			return

		message_admins("Admin [key_name_admin(usr)] renamed [key_name_admin(M)] to [new_name].")
		M.fully_replace_character_name(M.real_name,new_name)
		vv_update_display(M, "name", new_name)
		vv_update_display(M, "real_name", M.real_name || "No real name")

	else if(href_list["rotatedatum"])

		var/atom/A = locate(href_list["rotatedatum"])
		if(!istype(A))
			to_chat(usr, "This can only be done to instances of type /atom", confidential = TRUE)
			return

		switch(href_list["rotatedir"])
			if("right")
				A.setDir(turn(A.dir, -45))
			if("left")
				A.setDir(turn(A.dir, 45))
		vv_update_display(A, "dir", dir2text(A.dir))

	else if(href_list["varnameedit"] && href_list["datumedit"])
		if(!check_rights(R_VAREDIT))	return

		var/D = locate(href_list["datumedit"])
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list["varnameedit"], 1)

	else if(href_list["give_modifier"])
		if(!check_rights(R_ADMIN|R_FUN|R_DEBUG))
			return

		var/mob/living/M = locate(href_list["give_modifier"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob/living")
			return

		src.admin_give_modifier(M)
		href_list["datumrefresh"] = href_list["give_modifier"]

	else if(href_list["make_skeleton"])
		if(!check_rights(R_FUN))	return

		var/mob/living/carbon/human/H = locate(href_list["make_skeleton"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		H.ChangeToSkeleton()
		href_list["datumrefresh"] = href_list["make_skeleton"]

	else if(href_list["makemonkey"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makemonkey"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(tgui_alert(usr, "Confirm mob type change?","Confirm",list("Transform","Cancel")) != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("monkeyone"=href_list["makemonkey"]))

	else if(href_list["makerobot"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makerobot"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(tgui_alert(usr, "Confirm mob type change?","Confirm",list("Transform","Cancel")) != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("makerobot"=href_list["makerobot"]))

	else if(href_list["makealien"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makealien"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(tgui_alert(usr, "Confirm mob type change?","Confirm",list("Transform","Cancel")) != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("makealien"=href_list["makealien"]))

	else if(href_list["makeai"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makeai"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(tgui_alert(usr, "Confirm mob type change?","Confirm",list("Transform","Cancel")) != "Transform")	return
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		holder.Topic(href, list("makeai"=href_list["makeai"]))

	else if(href_list["setspecies"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["setspecies"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/new_species = tgui_input_list(usr, "Please choose a new species.","Species", SScharacters.all_species_names())

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.set_species(new_species, force = TRUE))
			to_chat(usr, "Set species of [H] to [H.species].")
		else
			to_chat(usr, "Failed! Something went wrong.")

	else if(href_list["addlanguage"])
		if(!check_rights(R_SPAWN))	return

		var/mob/H = locate(href_list["addlanguage"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		var/new_language = tgui_input_list(usr, "Please choose a language to add.","Language", RSlanguages.legacy_sorted_all_language_names())

		if(!new_language)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.add_language(new_language))
			to_chat(usr, "Added [new_language] to [H].")
		else
			to_chat(usr, "Mob already knows that language.")

	else if(href_list["remlanguage"])
		if(!check_rights(R_SPAWN))	return

		var/mob/H = locate(href_list["remlanguage"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return

		if(!H.languages.len)
			to_chat(usr, "This mob knows no languages.")
			return

		var/datum/prototype/language/rem_language = tgui_input_list(usr, "Please choose a language to remove.","Language", H.languages)

		if(!rem_language)
			return

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(H.remove_language(rem_language.name))
			to_chat(usr, "Removed [rem_language] from [H].")
		else
			to_chat(usr, "Mob doesn't know that language.")

	else if(href_list["addverb"])
		if(!check_rights(R_DEBUG))      return

		var/mob/living/H = locate(href_list["addverb"])

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living")
			return
		var/list/possibleverbs = list()
		possibleverbs += "Cancel" // One for the top...
		possibleverbs += typesof(/mob/proc,/mob/verb,/mob/living/proc,/mob/living/verb)
		if(istype(H,/mob/living/carbon/human))
			possibleverbs += typesof(/mob/living/carbon/proc,/mob/living/carbon/verb,/mob/living/carbon/human/verb,/mob/living/carbon/human/proc)
		if(istype(H,/mob/living/silicon/robot))
			possibleverbs += typesof(/mob/living/silicon/proc,/mob/living/silicon/robot/proc,/mob/living/silicon/robot/verb)
		if(istype(H,/mob/living/silicon/ai))
			possibleverbs += typesof(/mob/living/silicon/proc,/mob/living/silicon/ai/proc,/mob/living/silicon/ai/verb)
		if(istype(H,/mob/living/simple_mob))
			possibleverbs += typesof(/mob/living/simple_mob/proc)
		possibleverbs -= H.verbs
		possibleverbs += "Cancel" // ...And one for the bottom

		var/verb = tgui_input_list(usr, "Select a verb!", "Verbs", possibleverbs)
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb || verb == "Cancel")
			return
		else
			add_verb(H, verb)

	else if(href_list["remverb"])
		if(!check_rights(R_DEBUG))      return

		var/mob/H = locate(href_list["remverb"])

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		var/verb = tgui_input_list(usr, "Please choose a verb to remove.","Verbs", H.verbs)
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb)
			return
		else
			remove_verb(H, verb)

	else if(href_list["addorgan"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/M = locate(href_list["addorgan"])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/new_organ = tgui_input_list(usr, "Please choose an organ to add.","Organ", subtypesof(/obj/item/organ))
		if(!new_organ) return

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(locate(new_organ) in M.internal_organs)
			to_chat(usr, "Mob already has that organ.")
			return

		new new_organ(M)


	else if(href_list["remorgan"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/M = locate(href_list["remorgan"])
		if(!istype(M))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/obj/item/organ/rem_organ = tgui_input_list(usr, "Please choose an organ to remove.","Organ", M.internal_organs)

		if(!M)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(!(locate(rem_organ) in M.internal_organs))
			to_chat(usr, "Mob does not have that organ.")
			return

		to_chat(usr, "Removed [rem_organ] from [M].")
		rem_organ.removed()
		qdel(rem_organ)

	else if(href_list["regenerateicons"])
		if(!check_rights(0))	return

		var/mob/M = locate(href_list["regenerateicons"])
		if(!ismob(M))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		M.regenerate_icons()

	else if(href_list["adjustDamage"] && href_list["mobToDamage"])
		if(!check_rights(R_DEBUG|R_ADMIN|R_FUN|R_EVENT))	return

		var/mob/living/L = locate(href_list["mobToDamage"]) in GLOB.mob_list
		if(!istype(L))
			return

		var/Text = href_list["adjustDamage"]

		var/amount = input("Deal how much damage to mob? (Negative values here heal)","Adjust [Text]loss",0) as num|null

		if (isnull(amount))
			return

		if(!L)
			to_chat(usr, "Mob doesn't exist anymore", confidential = TRUE)
			return

		var/newamt
		switch(Text)
			if("brute")
				L.adjustBruteLoss(amount)
				newamt = L.getBruteLoss()
			if("fire")
				L.adjustFireLoss(amount)
				newamt = L.getFireLoss()
			if("toxin")
				L.adjustToxLoss(amount)
				newamt = L.getToxLoss()
			if("oxygen")
				L.adjustOxyLoss(amount)
				newamt = L.getOxyLoss()
			if("brain")
				L.adjustBrainLoss(amount)
				newamt = L.getBrainLoss()
			if("clone")
				L.adjustCloneLoss(amount)
				newamt = L.getCloneLoss()
			else
				to_chat(usr, "You caused an error. DEBUG: Text:[Text] Mob:[L]", confidential = TRUE)
				return

		if(amount != 0)
			var/log_msg = "[key_name(usr)] dealt [amount] amount of [Text] damage to [key_name(L)]"
			message_admins("[key_name(usr)] dealt [amount] amount of [Text] damage to [ADMIN_LOOKUPFLW(L)]")
			log_admin(log_msg)
			admin_ticket_log(L, "<font color='blue'>[log_msg]</font>")
			vv_update_display(L, Text, "[newamt]")

	else if(href_list["expose"])
		if(!check_rights(R_ADMIN, FALSE))
			return
		var/thing = locate(href_list["expose"])
		if(!thing)		//Do NOT QDELETED check!
			return
		var/value = vv_get_value(VV_CLIENT)
		if (value["class"] != VV_CLIENT)
			return
		var/client/C = value["value"]
		if (!C)
			return
		var/prompt = tgui_alert(usr, "Do you want to grant [C] access to view this VV window? (they will not be able to edit or change anysrc nor open nested vv windows unless they themselves are an admin)", "Confirm", list("Yes", "No"))
		if (prompt != "Yes")
			return
		if(!thing)
			to_chat(usr, span_warning("The object you tried to expose to [C] no longer exists (GC'd)"))
			return
		message_admins("[key_name_admin(usr)] Showed [key_name_admin(C)] a <a href='?_src_=vars;datumrefresh=\ref[thing]'>VV window</a>")
		log_admin("Admin [key_name(usr)] Showed [key_name(C)] a VV window of a [src]")
		to_chat(C, "[is_under_stealthmin() ? "an Administrator" : "[usr.client.key]"] has granted you access to view a View Variables window")
		C.debug_variables(thing)

	//Finally, refresh if something modified the list.
	if(href_list["datumrefresh"])
		var/datum/DAT = locate(href_list["datumrefresh"])
		if(isdatum(DAT) || istype(DAT, /client) || islist(DAT))
			debug_variables(DAT)
