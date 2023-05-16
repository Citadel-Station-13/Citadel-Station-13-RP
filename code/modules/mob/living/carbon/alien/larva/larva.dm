/datum/category_item/catalogue/fauna/alien/larva
	name = "Xenomorph - Larva"
	desc = "Known colloquially as 'chestbursters', Xenomorph larva are the second \
	stage of the Xenomorph life cycle. Gestating inside the chest of their host, Larva \
	will tunnel their way out once they reach maturity, killing their host in the process. \
	Spotting a larva is an especially bad sign, because it means that at best there are eggs \
	active in the area, and at worst, that there is a functioning Hive nearby. Kill on sight."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"
	adult_form = /mob/living/carbon/human
	speak_emote = list("hisses")
	icon_state = "larva"
	language = "Hivemind"
	maxHealth = 25
	health = 25
	faction = "xeno"
	catalogue_data = list(/datum/category_item/catalogue/fauna/alien/larva)

/mob/living/carbon/alien/larva/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_XENO) //Bonus language.
	internal_organs |= new /obj/item/organ/internal/xenos/hivenode(src)
