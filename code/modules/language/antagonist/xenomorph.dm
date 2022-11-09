/datum/language/xenocommon
	id = LANGUAGE_ID_XENOMORPH
	name = SPECIES_XENO
	colour = "alien"
	desc = "The common tongue of the xenomorphs."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	key = "u"
	machine_understands = 0
	language_flags = RESTRICTED
	syllables = list("sss","sSs","SSS")

/datum/language/xenos
	id = LANGUAGE_ID_XENOMORPH_HIVEMIND
	name = "Hivemind"
	desc = "Xenomorphs have the strange ability to commune over a psychic hivemind."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	colour = "alien"
	machine_understands = 0
	key = "x"
	language_flags = RESTRICTED | HIVEMIND

/datum/language/xenos/check_special_condition(var/mob/other)

	var/mob/living/carbon/M = other
	if(!istype(M))
		return 1
	if(locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1

	return 0
