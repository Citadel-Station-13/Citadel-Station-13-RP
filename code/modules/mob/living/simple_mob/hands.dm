// Hand procs for player-controlled SA's
/mob/living/simple_mob/swap_hand()
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "l_hand_active"
			hud_used.r_hand_hud_object.icon_state = "r_hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "l_hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "r_hand_active"
	return

/mob/living/simple_mob/update_inv_r_hand()
	if(QDESTROYING(src))
		return

	if(r_hand)
		r_hand.screen_loc = ui_rhand	//TODO
		r_hand_sprite = r_hand.render_mob_appearance(src, 2, BODYTYPE_DEFAULT)
	else
		r_hand_sprite = null

	update_icon()

/mob/living/simple_mob/update_inv_l_hand()
	if(QDESTROYING(src))
		return

	if(l_hand)
		l_hand.screen_loc = ui_lhand	//TODO
		l_hand_sprite = r_hand.render_mob_appearance(src, 1, BODYTYPE_DEFAULT)
	else
		l_hand_sprite = null

	update_icon()

//Can insert extra huds into the hud holder here.
/mob/living/simple_mob/proc/extra_huds(var/datum/hud/hud,var/icon/ui_style,var/list/hud_elements)
	return

//If they can or cannot use tools/machines/etc
/mob/living/simple_mob/IsAdvancedToolUser()
	return has_hands

/mob/living/simple_mob/proc/IsHumanoidToolUser(var/atom/tool)
	if(!humanoid_hands)
		var/display_name = null
		if(tool)
			display_name = tool
		else
			display_name = "object"
		to_chat(src, "<span class='danger'>Your [hand_form] are not fit for use of \the [display_name].</span>")
	return humanoid_hands
