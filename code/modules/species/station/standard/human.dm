/datum/species/human
	id = SPECIES_ID_HUMAN
	uid = SPECIES_ID_HUMAN
	category = "Human"
	name = SPECIES_HUMAN
	name_plural = "Humans"
	primitive_form = SPECIES_MONKEY
	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	blurb = "Humanity originated in the Sol system, and over the last five centuries has spread \
	colonies across a wide swathe of space. They hold a wide range of forms and creeds.<br/><br/> \
	While the Orion Confederation government represents humanity at large, on the Frontier powerful corporate \
	interests, rampant cyber and bio-augmentation initiatives, and secretive factions make life on most human \
	worlds tumultous at best."
	catalogue_data = list(/datum/category_item/catalogue/fauna/humans)

	max_additional_languages = 3
	intrinsic_languages = list(
		LANGUAGE_ID_COMMON,
		LANGUAGE_ID_HUMAN
	)
	whitelist_languages = list(
		LANGUAGE_ID_HUMAN_SLAVIC
	)
	name_language    = null // Use the first-name last-name generator rather than a language scrambler
	assisted_langs   = list(LANGUAGE_EAL, LANGUAGE_SKRELLIAN, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)

	max_age = 130

	economic_modifier = 10

	health_hud_intensity = 1.5

	species_spawn_flags = SPECIES_SPAWN_CHARACTER

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_APPENDIX  = /obj/item/organ/internal/appendix,
		O_SPLEEN    = /obj/item/organ/internal/spleen,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite,
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
	)

	color_mult = 1
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	base_color = "#EECEB3"
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Humanity"

/datum/category_item/catalogue/fauna/humans
	name = "Sapients - Humans"
	desc = {"
		Humans are a space-faring species hailing originally from the planet Earth in the Sol system.
		They are currently among the most numerous known species in the galaxy, in both population and holdings,
		and are relatively technologically advanced. With good healthcare and a reasonable lifestyle,
		they can live to around 110 years. The oldest humans are around 150 years old.

		Humanity is the primary driving force for rapid space expansion, owing to their strong, expansionist central
		government and opportunistic Trans-Stellar Corporations. The prejudices of the 21st century have mostly
		given way to bitter divides on the most important issue of the times� technological expansionism,
		with the major human factions squabbling over their approach to technology in the face of a
		looming singularity.

		While most humans have accepted the existence of aliens in their communities and workplaces as a
		fact of life, exceptions abound. While more culturally diverse than most species, humans are
		generally regarded as somewhat technophobic and isolationist by members of other species.
	"}
	value = CATALOGUER_REWARD_TRIVIAL
