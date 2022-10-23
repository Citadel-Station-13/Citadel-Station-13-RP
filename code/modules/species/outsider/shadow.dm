/datum/species/shadow
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
	darksight = 8
	has_organ = list()
	siemens_coefficient = 0

	blood_color = "#CCCCCC"
	flesh_color = "#AAAAAA"

	virus_immune = TRUE

	remains_type = /obj/effect/debris/cleanable/ash
	death_message = "dissolves into ash..."

	flags = NO_SCAN | NO_SLIP | NO_POISON | NO_MINOR_CUT
	spawn_flags = SPECIES_IS_RESTRICTED

	genders = list(NEUTER)

	unarmed_types = list(
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/sharp,
	)

/datum/species/shadow/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		new /obj/effect/debris/cleanable/ash(H.loc)
		qdel(H)
