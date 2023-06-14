/mob/living/carbon/human/proc/hybrid_plant()
	set name = "Plant Weed (10)"
	set desc = "Plants some alien weeds"
	set category = "Abilities"

	if(check_alien_ability(10,1,O_RESIN))
		visible_message("<span class='green'><B>[src] has planted some alien weeds!</B></span>")
		var/obj/O = new /obj/effect/alien/weeds/hybrid(loc)
		if(O)
			O.color = "#422649"
	return

/datum/ability/species/xenomorph_hybrid
	action_icon = 'icons/screen/actions/xenomorph.dmi'

/datum/ability/species/xenomorph_hybrid/regenerate
	name = "Rest and regenerate"
	desc = "Lie down and regenerate your health"
	action_state = "regenerate"
	windup = 0 SECOND
	interact_type = ABILITY_INTERACT_TRIGGER
	always_bind = TRUE
	ability_check_flags = ABILITY_CHECK_RESTING
	mobility_check_flags = MOBILITY_IS_CONSCIOUS

/datum/ability/species/xenomorph_hybrid/regenerate/on_trigger()
	. = ..()
	var/mob/living/carbon/human/O = owner
	if(istype(O))
		to_chat(O, SPAN_NOTICEALIEN("We begin to mend our wounds."))
		O.active_regen = TRUE







