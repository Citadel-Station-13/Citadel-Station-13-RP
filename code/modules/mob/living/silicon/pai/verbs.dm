/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"

	// see pai/mobility.dm
	// we don't check mobility here because while folded up, you can't move
	if(!can_action())
		return
	// to fold out we need to be in the card
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

	var/choice
	var/finalized = "No"
	while(finalized == "No" && src.client)

		choice = input(usr,"What would you like to use for your mobile chassis icon?") as null|anything in (list("-- LOAD CHARACTER SLOT --") + possible_chassis)
		if(!choice)
			return

		if(choice == "-- LOAD CHARACTER SLOT --")
			icon = render_hologram_icon(usr.client.prefs.render_to_appearance(PREF_COPY_TO_FOR_RENDER | PREF_COPY_TO_NO_CHECK_SPECIES | PREF_COPY_TO_UNRESTRICTED_LOADOUT), 210)
		else
			icon = 'icons/mob/pai.dmi'
			icon_state = possible_chassis[choice]
		finalized = alert("Look at your sprite. Is this what you wish to use?",,"No","Yes")

	chassis = possible_chassis[choice]
	add_verb(src, /mob/living/proc/hide)

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
		toggle_resting()
		icon_state = resting ? "[chassis]_rest" : "[chassis]"
		update_icon()
		to_chat(src, SPAN_NOTICE("You are now [resting ? "resting" : "getting up"]"))

	update_mobility()

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
