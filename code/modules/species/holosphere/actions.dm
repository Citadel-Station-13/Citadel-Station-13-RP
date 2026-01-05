/datum/action/holosphere
	button_icon = 'icons/screen/actions/holosphere.dmi'

/// Toggle transform
/datum/action/holosphere/toggle_transform
	name = "Toggle Hologram"
	desc = "Toggle Hologram"
	button_icon_state = "toggle_transform"

/datum/action/holosphere/toggle_transform/invoke_target(mob/M, datum/event_args/actor/actor)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/species/shapeshifter/holosphere/S = H.species
		if(!istype(S))
			return
		S.try_transform()
	else if(is_holosphere_shell(M))
		//Are a sphere, being held in an inventory, and the inventory is the AI container, don't break it, by breaking out of that
		if(istype(M.loc, /obj/item/holder/holosphere_shell) && istype(M.loc.loc, /obj/item/hardsuit_module/ai_container))
			actor.chat_feedback(SPAN_WARNING("You are integrated with a hardsuit system, get disconnected first."))
			return
		var/mob/living/simple_mob/holosphere_shell/H = M
		var/datum/species/shapeshifter/holosphere/S = H.hologram.species
		if(!istype(S))
			return
		S.try_untransform()

/// Change appearance to selected loadout slot
/datum/action/holosphere/change_loadout
	name = "Change Loadout"
	desc = "Change Loadout"
	button_icon_state = "change_loadout"

/datum/action/holosphere/change_loadout/invoke_target(mob/M, datum/event_args/actor/actor)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/species/shapeshifter/holosphere/S = H.species
		if(!istype(S))
			return
		H.switch_loadout_holosphere()

/// Change limb icons
/datum/action/holosphere/change_limb_icons
	name = "Change Limb Icons"
	desc = "Change Limb Icons"
	button_icon_state = "change_limbs"

/datum/action/holosphere/change_limb_icons/invoke_target(mob/M, datum/event_args/actor/actor)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/species/shapeshifter/holosphere/S = H.species
		if(!istype(S))
			return
		S.change_limb_icons(M)
