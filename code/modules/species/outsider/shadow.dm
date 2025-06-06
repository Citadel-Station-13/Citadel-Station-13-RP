/datum/species/shadow
	uid = SPECIES_ID_SHADOW
	name = SPECIES_SHADOW
	name_plural = "shadows"

	blurb = {"
	A being of pure darkness, hates the light and all that comes with it.
	"}

	icobase   = 'icons/mob/species/shadow/body.dmi'
	deform    = 'icons/mob/species/shadow/body.dmi'
	husk_icon = 'icons/mob/species/shadow/husk.dmi'

	// language = "Sol Common" //todo?
	assisted_langs = list()

	light_dam = 2
	vision_innate = /datum/vision/baseline/species_tier_3
	has_organ = list()
	siemens_coefficient = 0

	vision_organ = O_EYES

	blood_color = "#CCCCCC"
	flesh_color = "#AAAAAA"

	virus_immune = TRUE

	remains_type = /obj/effect/debris/cleanable/ash
	death_message = "dissolves into ash..."

	species_flags = NO_SCAN | NO_SLIP | NO_POISON | NO_MINOR_CUT
	species_spawn_flags = SPECIES_SPAWN_SPECIAL

	genders = list(NEUTER)

	unarmed_types = list(
		/datum/melee_attack/unarmed/claws/strong,
		/datum/melee_attack/unarmed/bite/sharp,
	)

/datum/species/shadow/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		new /obj/effect/debris/cleanable/ash(H.loc)
		qdel(H)
