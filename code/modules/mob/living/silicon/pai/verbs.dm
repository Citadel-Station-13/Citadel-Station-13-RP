/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"

	open_up_safe()

/mob/living/silicon/pai/verb/fold_up()
	set category = "pAI Commands"
	set name = "Collapse Chassis"

	close_up_safe()

/mob/living/silicon/pai/proc/choose_chassis()
	set category = "pAI Commands"
	set name = "Choose Chassis"

	update_chassis()

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

	change_to_clothing()

/mob/living/silicon/pai/verb/revert_shell_to_card()
	set name = "Reset Shell"
	set category = "pAI Commands"
	set desc = "Reverts your shell back to card form."

	revert_to_card()

/mob/living/silicon/pai/verb/hologram_display()
	set name = "Hologram Display"
	set category = "pAI Commands"
	set desc = "Allows you to pick a scanned object to display from your holoprojector."

	card_hologram_display()
