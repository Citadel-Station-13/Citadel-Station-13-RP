/datum/language/xenocommon
	id = LANGUAGE_ID_XENOMORPH
	name = SPECIES_XENO
	translation_class = TRANSLATION_CLASS_MONSTER | TRANSLATION_CLASS_LEVEL_3
	colour = "alien"
	desc = "The common tongue of the xenomorphs."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	key = "u"
	language_flags = LANGUAGE_RESTRICTED
	syllables = list("sss","sSs","SSS")
	shorthand = "XENO"

/datum/language/xenos
	id = LANGUAGE_ID_XENOMORPH_HIVEMIND
	name = "Hivemind"
	desc = "Xenomorphs have the strange ability to commune over a psychic hivemind."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	colour = "alien"
	key = "x"
	language_flags = LANGUAGE_RESTRICTED | LANGUAGE_HIVEMIND

/datum/language/xenos/check_special_condition(var/mob/other)

	var/mob/living/carbon/M = other
	if(!istype(M))
		return 1
	if(locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1

	return 0
