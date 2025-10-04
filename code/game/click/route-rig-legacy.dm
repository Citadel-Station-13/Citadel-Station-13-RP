
#define MIDDLE_CLICK 0
#define ALT_CLICK 1
#define CTRL_CLICK 2
#define MAX_HARDSUIT_CLICK_MODE 2

/client
	var/hardsuit_click_mode = MIDDLE_CLICK

/client/verb/toggle_hardsuit_mode()
	set name = "Toggle Hardsuit Activation Mode"
	set desc = "Switch between hardsuit activation modes."
	set category = VERB_CATEGORY_OOC

	hardsuit_click_mode++
	if(hardsuit_click_mode > MAX_HARDSUIT_CLICK_MODE)
		hardsuit_click_mode = 0

	switch(hardsuit_click_mode)
		if(MIDDLE_CLICK)
			to_chat(src, "Hardsuit activation mode set to middle-click.")
		if(ALT_CLICK)
			to_chat(src, "Hardsuit activation mode set to alt-click.")
		if(CTRL_CLICK)
			to_chat(src, "Hardsuit activation mode set to control-click.")
		else
			// should never get here, but just in case:
			soft_assert(0, "Bad hardsuit click mode: [hardsuit_click_mode] - expected 0 to [MAX_HARDSUIT_CLICK_MODE]")
			to_chat(src, "Somehow you bugged the system. Setting your hardsuit mode to middle-click.")
			hardsuit_click_mode = MIDDLE_CLICK

/mob/living/click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/active_item)
	if(!active_item)
		var/route_to_rig = FALSE
		// this is shitcode but at some point we'll need to refactor how this works so it works for now
		switch(client?.hardsuit_click_mode)
			if(MIDDLE_CLICK)
				if(clickchain.click_params["button"] == "middle" && !clickchain.click_params["ctrl"] && !clickchain.click_params["shift"] && !clickchain.click_params["alt"])
					route_to_rig = TRUE
			if(ALT_CLICK)
				if(clickchain.click_params["alt"] && !clickchain.click_params["ctrl"] && !clickchain.click_params["shift"] )
					route_to_rig = TRUE
			if(CTRL_CLICK)
				if(clickchain.click_params["ctrl"] && !clickchain.click_params["alt"] && !clickchain.click_params["shift"] )
					route_to_rig = TRUE
		// this is definitely shitcode.
		var/obj/item/hardsuit/maybe_hardsuit = get_hardsuit(TRUE)
		if(route_to_rig && maybe_hardsuit)
			. = attempt_rigsuit_click(clickchain, clickchain_flags, maybe_hardsuit)
			clickchain.data[ACTOR_DATA_RIG_CLICK_LOG] ||= "[maybe_hardsuit]"
			return
	return ..()

/mob/living/proc/can_use_hardsuit()
	return 0

/mob/living/carbon/human/can_use_hardsuit()
	return 1

/mob/living/simple_mob/holosphere_shell/can_use_hardsuit()
	return 1

/mob/living/carbon/brain/can_use_hardsuit()
	return istype(loc, /obj/item/mmi)

/mob/living/silicon/ai/can_use_hardsuit()
	return carded

/mob/living/silicon/pai/can_use_hardsuit()
	return loc == card

#undef MIDDLE_CLICK
#undef ALT_CLICK
#undef CTRL_CLICK
#undef MAX_HARDSUIT_CLICK_MODE
