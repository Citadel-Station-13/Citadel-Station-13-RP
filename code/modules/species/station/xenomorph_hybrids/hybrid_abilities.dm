/mob/living/carbon/human/proc/hybrid_plant()
	set name = "Plant Weed (10)"
	set desc = "Plants some alien weeds"
	set category = "Abilities"

	if(check_alien_ability(10,1,O_RESIN))
		visible_message("<span class='green'><B>[src] has planted some alien weeds!</B></span>")
		var/obj/O = new /obj/structure/alien/weeds/hybrid(loc)
		if(O)
			O.color = "#422649"
	return

/datum/ability/species/xenomorph_hybrid
	action_icon = 'icons/screen/actions/xenomorph.dmi'
	var/plasma_cost = 0

/datum/ability/species/xenomorph_hybrid/available_check()
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = owner
		if(plasma_cost && !istype(H))
			return FALSE
		if(plasma_cost > 0 && !check_plasmavessel(H))
			return FALSE
		var/obj/item/organ/internal/xenos/plasmavessel/P = H.internal_organs_by_name[O_PLASMA]
		if(istype(P) && P.stored_plasma < plasma_cost)
			return FALSE

/datum/ability/species/xenomorph_hybrid/proc/check_plasmavessel(var/mob/living/carbon/human/H)
	var/obj/item/organ/internal/xenos/plasmavessel/P = H.internal_organs_by_name[O_PLASMA]
	if(!istype(P))
		return FALSE
	return TRUE

/datum/ability/species/xenomorph_hybrid/proc/take_plasma(var/mob/living/carbon/human/H)
	var/obj/item/organ/internal/xenos/plasmavessel/P = H.internal_organs_by_name[O_PLASMA]
	if(!istype(P))
		return
	P.adjust_plasma(-plasma_cost)

/datum/ability/species/xenomorph_hybrid/on_trigger(mob/user, toggling)
	. = ..()
	take_plasma(user)

/datum/ability/species/xenomorph_hybrid/regenerate
	name = "Rest and regenerate"
	desc = "Lie down and regenerate your health"
	action_state = "regenerate"
	windup = 0 SECOND
	interact_type = ABILITY_INTERACT_TRIGGER
	always_bind = TRUE
	ability_check_flags = ABILITY_CHECK_RESTING
	mobility_check_flags = MOBILITY_IS_CONSCIOUS
	plasma_cost = 10

/datum/ability/species/xenomorph_hybrid/regenerate/on_trigger()
	. = ..()
	var/mob/living/carbon/human/O = owner
	if(istype(O))
		to_chat(O, SPAN_NOTICEALIEN("We begin to mend our wounds."))
		O.active_regen = TRUE

	if (O.getBruteLoss() == 0) //If we have no flat damage remaining, fix internal issues, and not running around
		for(var/limb_type in O.species.has_limbs)
			var/obj/item/organ/external/E = O.organs_by_name[limb_type]
			if((E.status & ORGAN_BROKEN))
				E.status &= ~ORGAN_BROKEN
				to_chat(O, SPAN_NOTICEALIEN("You mend the bone in your [E]"))
				return//fix one then stop, trigger again to mend more






