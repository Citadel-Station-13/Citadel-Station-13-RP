/datum/action/pai
	button_icon = 'icons/screen/actions/pai.dmi'

/// Toggle unfolding/collapsing chassis
/datum/action/pai/toggle_fold
	button_icon_state = "pai_open"

/datum/action/pai/toggle_fold/update_icon()
	var/mob/living/silicon/pai/user = owner
	if(!istype(user))
		return

	if(user.loc == user.shell)
		button_icon_state = "pai_open"
		name = "Unfold Chassis"
		desc = "Unfold Chassis"
	else
		button_icon_state = "pai_close"
		name = "Collapse Chassis"
		desc = "Collapse Chassis"

/datum/action/pai/toggle_fold/on_trigger(mob/living/silicon/pai/user)
	if(user.loc == user.shell)
		open_up_safe()
	else
		close_up_safe()

	update_icon()

