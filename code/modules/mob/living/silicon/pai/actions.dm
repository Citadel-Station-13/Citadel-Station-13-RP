/datum/action/pai
	button_icon = 'icons/screen/actions/pai.dmi'
	var/update_on_grant = FALSE
	var/update_on_chassis_change = FALSE

/// Toggle unfolding/collapsing chassis
/datum/action/pai/toggle_fold
	name = "Fold / Unfold Chassis"
	desc = "Fold / Unfold Chassis"
	button_icon_state = "pai"
	update_on_grant = TRUE
	update_on_chassis_change = TRUE

/datum/action/pai/toggle_fold/invoke_target(mob/living/silicon/pai/target, datum/event_args/actor/actor)
	. = ..()
	if(target.loc == target.shell)
		target.open_up_safe()
	else
		target.close_up_safe()

/// Change chassis
/datum/action/pai/change_chassis
	name = "Change Chassis"
	desc = "Select a different chassis"
	button_icon_state = "pai_chassis_change"

/datum/action/pai/change_chassis/invoke_target(mob/living/silicon/pai/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.update_chassis()

/// Revert to card
/// This only shows if your shell is not currently the card, otherwise this action is hidden
/datum/action/pai/revert_to_card
	name = "Revert To Card"
	desc = "Revert your shell back to card-form"
	button_icon_state = "pai_shell_revert"
	update_on_chassis_change = TRUE

/datum/action/pai/revert_to_card/invoke_target(mob/living/silicon/pai/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.revert_to_card()

/// Clothing Transform
/datum/action/pai/clothing_transform
	name = "Clothing Transform"
	desc = "Change shell to clothing form"
	button_icon_state = "pai_clothing"
	update_on_chassis_change = TRUE

/datum/action/pai/clothing_transform/invoke_target(mob/living/silicon/pai/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.change_to_clothing()

/// Hologram Display (show scanned object from card form)
/// This only shows if you are in card form, otherwise this action is hidden
/datum/action/pai/hologram_display
	name = "Hologram Display"
	desc = "Display a scanned object as a hologram"
	button_icon_state = "pai_hologram_display"
	update_on_chassis_change = TRUE

/datum/action/pai/hologram_display/invoke_target(mob/living/silicon/pai/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.card_hologram_display()

/// Hologram Placement
/datum/action/pai/place_hologram
	name = "Place Hologram"
	desc = "Place a hologram of a scanned object on the floor."
	button_icon_state = "pai_place_hologram"

/datum/action/pai/place_hologram/invoke_target(mob/living/silicon/pai/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.prompt_hologram_placement()

/// Delete All Holograms
/datum/action/pai/delete_holograms
	name = "Delete All Holograms"
	desc = "Delete all placed holograms."
	button_icon_state = "pai_delete_holograms"

/datum/action/pai/delete_holograms/invoke_target(mob/living/silicon/pai/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	target.delete_all_holograms()
