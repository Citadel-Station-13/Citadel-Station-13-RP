//DO NOT ADD MORE TO THIS FILE.
//Use vv_do_topic() for datums!
/client/proc/view_var_Topic(href, href_list, hsrc)
	if( (usr.client != src) || !src.holder || !holder.CheckAdminHref(href, href_list))
		return
	var/target = GET_VV_TARGET
	vv_do_basic(target, href_list, href)
	if(istype(target, /datum))
		var/datum/D = target
		D.vv_do_topic(href_list)
	else if(islist(target))
		vv_do_list(target, href_list)
	if(href_list["Vars"])
		debug_variables(locate(href_list["Vars"]))

	//~CARN: for renaming mobs (updates their name, real_name, mind.name, their ID/PDA and datacore records).
	else if(href_list["rename"])
		if(!check_rights(R_VAREDIT))	return

		var/mob/M = locate(href_list["rename"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/new_name = sanitize(input(usr,"What would you like to name this mob?","Input a name",M.real_name) as text|null, MAX_NAME_LEN)
		if( !new_name || !M )	return

		message_admins("Admin [key_name_admin(usr)] renamed [key_name_admin(M)] to [new_name].")
		M.fully_replace_character_name(M.real_name,new_name)
		href_list["datumrefresh"] = href_list["rename"]

	else if(href_list["varnameedit"] && href_list["datumedit"])
		if(!check_rights(R_VAREDIT))	return

		var/D = locate(href_list["datumedit"])
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list["varnameedit"], 1)

	else if(href_list["varnamechange"] && href_list["datumchange"])
		if(!check_rights(R_VAREDIT))	return

		var/D = locate(href_list["datumchange"])
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list["varnamechange"], 0)

	else if(href_list["varnamemass"] && href_list["datummass"])
		if(!check_rights(R_VAREDIT))	return

		var/atom/A = locate(href_list["datummass"])
		if(!istype(A))
			to_chat(usr, "This can only be used on instances of type /atom")
			return

		cmd_mass_modify_object_variables(A, href_list["varnamemass"])

	else if(href_list["mob_player_panel"])
		if(!check_rights(0))	return

		var/mob/M = locate(href_list["mob_player_panel"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.holder.show_player_panel(M)
		href_list["datumrefresh"] = href_list["mob_player_panel"]

	else if(href_list["give_spell"])
		if(!check_rights(R_ADMIN|R_FUN))	return

		var/mob/M = locate(href_list["give_spell"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.give_spell(M)
		href_list["datumrefresh"] = href_list["give_spell"]

	else if(href_list["give_modifier"])
		if(!check_rights(R_ADMIN|R_FUN|R_DEBUG))
			return

		var/mob/living/M = locate(href_list["give_modifier"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob/living")
			return

		src.admin_give_modifier(M)
		href_list["datumrefresh"] = href_list["give_modifier"]

	else if(href_list["give_disease2"])
		if(!check_rights(R_ADMIN|R_FUN))	return

		var/mob/M = locate(href_list["give_disease2"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.give_disease2(M)
		href_list["datumrefresh"] = href_list["give_spell"]

	else if(href_list["godmode"])
		if(!check_rights(R_REJUVINATE))	return

		var/mob/M = locate(href_list["godmode"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.cmd_admin_godmode(M)
		href_list["datumrefresh"] = href_list["godmode"]

	else if(href_list["gib"])
		if(!check_rights(0))	return

		var/mob/M = locate(href_list["gib"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.cmd_admin_gib(M)

	else if(href_list["build_mode"])
		if(!check_rights(R_BUILDMODE))	return

		var/mob/M = locate(href_list["build_mode"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		togglebuildmode(M)
		href_list["datumrefresh"] = href_list["build_mode"]

	else if(href_list["drop_everything"])
		if(!check_rights(R_DEBUG|R_ADMIN))	return

		var/mob/M = locate(href_list["drop_everything"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_admin_drop_everything(M)

	else if(href_list["direct_control"])
		if(!check_rights(0))	return

		var/mob/M = locate(href_list["direct_control"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_assume_direct_control(M)

	else if(href_list["make_skeleton"])
		if(!check_rights(R_FUN))	return

		var/mob/living/carbon/human/H = locate(href_list["make_skeleton"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		H.ChangeToSkeleton()
		href_list["datumrefresh"] = href_list["make_skeleton"]

	else if(href_list["delall"])
		if(!check_rights(R_DEBUG|R_SERVER))	return

		var/obj/O = locate(href_list["delall"])
		if(!isobj(O))
			to_chat(usr, "This can only be used on instances of type /obj")
			return

		var/action_type = alert(usr, "Strict type ([O.type]) or type and all subtypes?","Type Selection", "Strict type","Type and subtypes","Cancel")
		if(action_type == "Cancel" || !action_type)
			return

		if(alert(usr, "Are you really sure you want to delete all objects of type [O.type]?","Delete All?", "Yes","No") != "Yes")
			return

		if(alert(usr, "Second confirmation required. Delete?","REALLY?", "Yes", "No") != "Yes")
			return

		var/O_type = O.type
		switch(action_type)
			if("Strict type")
				var/i = 0
				for(var/obj/Obj in world)
					if(Obj.type == O_type)
						i++
						qdel(Obj)
				if(!i)
					to_chat(usr, "No objects of this type exist")
					return
				log_admin("[key_name(usr)] deleted all objects of type [O_type] ([i] objects deleted)")
				message_admins("<span class='notice'>[key_name(usr)] deleted all objects of type [O_type] ([i] objects deleted)</span>")
			if("Type and subtypes")
				var/i = 0
				for(var/obj/Obj in world)
					if(istype(Obj,O_type))
						i++
						qdel(Obj)
				if(!i)
					to_chat(usr, "No objects of this type exist")
					return
				log_admin("[key_name(usr)] deleted all objects of type or subtype of [O_type] ([i] objects deleted)")
				message_admins("<span class='notice'>[key_name(usr)] deleted all objects of type or subtype of [O_type] ([i] objects deleted)</span>")

	else if(href_list["explode"])
		if(!check_rights(R_DEBUG|R_FUN))	return

		var/atom/A = locate(href_list["explode"])
		if(!isobj(A) && !ismob(A) && !isturf(A))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		src.cmd_admin_explosion(A)
		href_list["datumrefresh"] = href_list["explode"]

	else if(href_list["emp"])
		if(!check_rights(R_DEBUG|R_FUN))	return

		var/atom/A = locate(href_list["emp"])
		if(!isobj(A) && !ismob(A) && !isturf(A))
			to_chat(usr, "This can only be done to instances of type /obj, /mob and /turf")
			return

		src.cmd_admin_emp(A)
		href_list["datumrefresh"] = href_list["emp"]

	else if(href_list["mark_object"])
		if(!check_rights(0))	return

		var/datum/D = locate(href_list["mark_object"])
		if(!istype(D))
			to_chat(usr, "This can only be done to instances of type /datum")
			return

		src.holder.marked_datum = D
		href_list["datumrefresh"] = href_list["mark_object"]

	else if(href_list["rotatedatum"])
		if(!check_rights(0))	return

		var/atom/A = locate(href_list["rotatedatum"])
		if(!istype(A))
			to_chat(usr, "This can only be done to instances of type /atom")
			return

		switch(href_list["rotatedir"])
			if("right")	A.setDir(turn(A.dir, -45))
			if("left")	A.setDir(turn(A.dir, 45))
		href_list["datumrefresh"] = href_list["rotatedatum"]

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

		var/mob/living/L = locate(href_list["mobToDamage"])
		if(!istype(L)) return

		var/Text = href_list["adjustDamage"]

		var/amount =  input(usr, "Deal how much damage to mob? (Negative values here heal)","Adjust [Text]loss",0) as num

		if(!L)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		switch(Text)
			if("brute")	amount > 0? L.take_overall_damage(brute = amount) : L.heal_overall_damage(brute = -amount)
			if("fire")	amount > 0? L.take_overall_damage(burn = amount) : L.heal_overall_damage(burn = -amount)
			if("toxin")	L.adjustToxLoss(amount)
			if("oxygen")L.adjustOxyLoss(amount)
			if("brain")	L.adjustBrainLoss(amount)
			if("clone")	L.adjustCloneLoss(amount)
			else
				to_chat(usr, "You caused an error. DEBUG: Text:[Text] Mob:[L]")
				return

		if(amount != 0)
			log_admin("[key_name(usr)] dealt [amount] amount of [Text] damage to [L]")
			message_admins("<span class='notice'>[key_name(usr)] dealt [amount] amount of [Text] damage to [L]</span>")
			href_list["datumrefresh"] = href_list["mobToDamage"]

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
			to_chat(usr, SPAN_WARNING("The object you tried to expose to [C] no longer exists (GC'd)"))
			return
		message_admins("[key_name_admin(usr)] Showed [key_name_admin(C)] a <a href='?_src_=vars;datumrefresh=\ref[thing]'>VV window</a>")
		log_admin("Admin [key_name(usr)] Showed [key_name(C)] a VV window of a [src]")
		to_chat(C, "[is_under_stealthmin() ? "an Administrator" : "[usr.client.key]"] has granted you access to view a View Variables window")
		C.debug_variables(thing)

	if(href_list["datumrefresh"])
		var/datum/DAT = locate(href_list["datumrefresh"])
		if(istype(DAT, /datum) || istype(DAT, /client) || islist(DAT))
			debug_variables(DAT)
