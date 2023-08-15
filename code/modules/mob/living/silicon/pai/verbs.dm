/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"

	// see pai/mobility.dm
	// we don't check mobility here because while folded up, you can't move
	if(!can_action())
		return
	// to fold out we need to be in the shell
	if(src.loc != shell)
		return

	open_up()

/mob/living/silicon/pai/verb/fold_up()
	set category = "pAI Commands"
	set name = "Collapse Chassis"

	// we check mobility here to stop people folding up if they currently cannot move
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_MOVE))
		return
	if(!can_action())
		return
	// to fold up we need to not be in the card already
	if(src.loc == shell)
		return

	close_up()

/mob/living/silicon/pai/proc/choose_chassis()
	set category = "pAI Commands"
	set name = "Choose Chassis"

	var/original_chassis = chassis
	var/choice
	var/finalized = "No"
	while(finalized == "No" && src.client)

		choice = input(usr,"What would you like to use for your mobile chassis icon?") as null|anything in (list("-- LOAD CHARACTER SLOT --") + possible_chassis)
		if(!choice)
			chassis = original_chassis
			return

		if(choice == "-- LOAD CHARACTER SLOT --")
			last_rendered_hologram_icon = render_hologram_icon(usr.client.prefs.render_to_appearance(PREF_COPY_TO_FOR_RENDER | PREF_COPY_TO_NO_CHECK_SPECIES | PREF_COPY_TO_UNRESTRICTED_LOADOUT), 210)
			card.cached_holo_image = null
			card.get_holo_image()
			icon = last_rendered_hologram_icon
			chassis = possible_chassis[choice]
			update_icon(FALSE)
		else
			icon = 'icons/mob/pai_vr.dmi'
			chassis = possible_chassis[choice]
			update_icon(FALSE)

		finalized = alert("Look at your sprite. Is this what you wish to use?",,"No","Yes")

	add_verb(src, /mob/living/proc/hide)
	update_icon(FALSE)

/mob/living/silicon/pai/proc/choose_verbs()
	set category = "pAI Commands"
	set name = "Choose Speech Verbs"

	var/choice = input(usr,"What theme would you like to use for your speech verbs?") as null|anything in possible_say_verbs
	if(!choice) return

	var/list/sayverbs = possible_say_verbs[choice]
	speak_statement = sayverbs[1]
	speak_exclamation = sayverbs[(sayverbs.len>1 ? 2 : sayverbs.len)]
	speak_query = sayverbs[(sayverbs.len>2 ? 3 : sayverbs.len)]

/mob/living/silicon/pai/lay_down()
	set name = "Rest"
	set category = "IC"

	// Pass lying down or getting up to our pet human, if we're in a hardsuit.
	if(src.loc == shell)
		set_resting(FALSE)
		var/obj/item/hardsuit/hardsuit = src.get_hardsuit()
		if(istype(hardsuit))
			hardsuit.force_rest(src)
	else
		toggle_intentionally_resting(TRUE)
		to_chat(src, SPAN_NOTICE("You are now [resting ? "resting" : "getting up"]"))

	update_mobility()

/mob/living/silicon/pai/update_lying()
	. = ..()
	icon_state = resting ? "[chassis]_rest" : "[chassis]"

/mob/living/silicon/pai/verb/allowmodification()
	set name = "Change Access Modifcation Permission"
	set category = "pAI Commands"
	set desc = "Allows people to modify your access or block people from modifying your access."

	if(idaccessible == 0)
		idaccessible = 1
		to_chat(src, "<span class='notice'>You allow access modifications.</span>")

	else
		idaccessible = 0
		to_chat(src, "<span class='notice'>You block access modfications.</span>")

/mob/living/silicon/pai/verb/wipe_software()
	set name = "Wipe Software"
	set category = "OOC"
	set desc = "Wipe your software. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	// Make sure people don't kill themselves accidentally
	if(alert("WARNING: This will immediately wipe your software and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?",
					"Wipe Software", "No", "No", "Yes") != "Yes")
		return

	close_up()
	visible_message("<b>[src]</b> fades away from the screen, the pAI device goes silent.")
	card.removePersonality()
	clear_client()

/mob/living/silicon/pai/proc/pai_nom(var/mob/living/T in oview(1))
	set name = "pAI Nom"
	set category = "pAI Commands"
	set desc = "Allows you to eat someone while unfolded. Can't be used while in card form."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/pai/verb/change_shell_clothing()
	set name = "pAI Clothing"
	set category = "pAI Commands"
	set desc = "Allows you to transform your shell into clothing."

	if(!can_change_shell())
		return

	var/clothing_entry = tgui_input_list(usr, "What clothing would you like to change your shell to?", "Options", list("Chameleon Clothing List","Last Uploaded Clothing"))
	if(clothing_entry)
		if(clothing_entry == "Chameleon Clothing List")
			var/clothing_type_entry = tgui_input_list(usr, "What type of clothing would you like to change your shell to?", "Clothing Type", list("Undershirt", "Suit", "Hat", "Shoes", "Gloves", "Mask", "Glasses"))
			var/list/clothing_for_type
			if(clothing_type_entry)
				switch(clothing_type_entry)
					if("Undershirt")
						clothing_for_type = GLOB.clothing_under
					if("Suit")
						clothing_for_type = GLOB.clothing_suit
					if("Hat")
						clothing_for_type = GLOB.clothing_head
					if("Shoes")
						clothing_for_type = GLOB.clothing_shoes
					if("Gloves")
						clothing_for_type = GLOB.clothing_gloves
					if("Mask")
						clothing_for_type = GLOB.clothing_mask
					if("Glasses")
						clothing_for_type = GLOB.clothing_glasses
				var/clothing_item_entry = tgui_input_list(usr, "Choose clothing item", "Clothing", clothing_for_type)
				if(clothing_item_entry)
					change_shell_by_path(clothing_for_type[clothing_item_entry])
		else if(clothing_entry == "Last Uploaded Clothing")
			if(last_uploaded_path && can_change_shell())
				last_special = world.time + 20
				var/state = initial(last_uploaded_path.icon_state)
				var/icon = initial(last_uploaded_path.icon)
				var/obj/item/clothing/new_clothing = new base_uploaded_path
				new_clothing.forceMove(src.loc)
				new_clothing.name = "[src.name] (pAI)"
				new_clothing.desc = src.desc
				new_clothing.icon = icon
				new_clothing.icon_state = state
				new_clothing.add_atom_colour(uploaded_color, FIXED_COLOUR_PRIORITY)

				var/obj/item/clothing/under/U = new_clothing
				if(istype(U))
					U.snowflake_worn_state = uploaded_snowflake_worn_state

				switch_shell(new_clothing)

/mob/living/silicon/pai/verb/revert_shell_to_card()
	set name = "Reset Shell"
	set category = "pAI Commands"
	set desc = "Reverts your shell back to card form."

	if(!can_change_shell())
		return
	if(!card || card.loc != src || card == shell)
		return
	switch_shell(card)
