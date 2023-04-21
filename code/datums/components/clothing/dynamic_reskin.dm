/datum/component/dynamic_reskin
	/// we should be an action button
	var/use_action_system
	/// we should override worn style system
	var/use_worn_style
	/// action button, if any
	var/datum/action/dynamic_reskin_component/action

/datum/component/dynamic_reskin/Initialize(use_action_system = FALSE, use_worn_style = TRUE)
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	src.use_action_system = use_action_system
	src.use_worn_style = use_worn_style

/datum/component/dynamic_reskin/RegisterWithParent()
	. = ..()

/datum/component/dynamic_reskin/UnregisterFromParent()
	. = ..()


/datum/component/dynamic_reskin/proc/on_pickup(datum/source, mob/user, flags, atom/old_loc)
	SIGNAL_HANDLER

/datum/component/dynamic_reskin/proc/on_drop(datum/source, mob/user, flags, atom/new_loc)
	SIGNAL_HANDLER

/datum/component/dynamic_reskin/proc/assert_action()

/datum/component/dynamic_reskin/ui_action_click(datum/action/action, mob/user)
	. = ..()

/datum/component/dynamic_reskin/

#warn impl


/datum/action/dynamic_reskin_component
	expected_type = /datum/component/dynamic_reskin

/datum/action/dynamic_reskin_component/update_button()
	. = ..()

	#warn guh
