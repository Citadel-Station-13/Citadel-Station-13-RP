/datum/species/golem
	name = SPECIES_GOLEM
	name_plural = "golems"
	uid = SPECIES_ID_GOLEM

	icobase      = 'icons/mob/species/golem/body.dmi'
	deform       = 'icons/mob/species/golem/body.dmi'
	preview_icon = 'icons/mob/species/golem/preview.dmi'
	husk_icon    = 'icons/mob/species/golem/husk.dmi'

	intrinsic_languages = LANGUAGE_ID_HUMAN // todo?

	species_spawn_flags = SPECIES_SPAWN_RESTRICTED
	species_flags = NO_PAIN | NO_SCAN | NO_POISON | NO_MINOR_CUT

	siemens_coefficient = 0

	assisted_langs = list()

	breath_type = null
	poison_type = null

	blood_color = "#515573"
	flesh_color = "#137E8F"

	virus_immune = TRUE

	death_message = "becomes completely motionless..."

	genders = list(NEUTER)

	has_organ = list(
		"brain" = /obj/item/organ/internal/brain/golem,
		)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
	)

/datum/species/golem/handle_post_spawn(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = SPECIES_GOLEM
		H.mind.special_role = SPECIES_GOLEM
	H.real_name = "adamantine golem ([rand(1, 1000)])"
	H.name = H.real_name
	..()
