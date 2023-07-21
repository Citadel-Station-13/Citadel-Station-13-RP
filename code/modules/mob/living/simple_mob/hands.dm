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
