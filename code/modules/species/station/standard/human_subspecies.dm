/datum/species/human/gravworlder
	uid = SPECIES_ID_HUMAN_GRAV
	name = SPECIES_HUMAN_GRAV
	name_plural = "grav-adapted Humans"

	icobase      = 'icons/mob/species/human/subspecies/body_gravworlder.dmi'
	preview_icon = 'icons/mob/species/human/subspecies/preview_gravworlder.dmi'

	blurb = {"
	Heavier and stronger than a baseline human, gravity-adapted people have thick radiation-resistant
	skin with a high lead content, denser bones, and recessed eyes beneath a prominent brow in order
	to shield them from the glare of a dangerously bright, alien sun. This comes at the cost of
	mobility, flexibility, and increased oxygen requirements to support their robust metabolism.
	"}

	brute_mod     = 0.90
	burn_mod      = 0.90
	oxy_mod       = 1.1
	radiation_mod = 0.95
	toxins_mod    = 0.8

	slowdown = 0.2 //Minor general slowdown
	item_slowdown_mod = 0.95 //Reduced Item slowdown

	minimum_breath_pressure = 18

	total_health = 130
	hunger_factor = 0.075//50% more hungry

	species_flags = NO_MINOR_CUT
	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	color_force_greyscale = TRUE
	base_color = "#EECEB3"

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/gravworlder),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/gravworlder),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/gravworlder),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/gravworlder),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/gravworlder),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/gravworlder),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/gravworlder),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/gravworlder),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/gravworlder),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/gravworlder),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/gravworlder),
	)

/datum/species/human/spacer
	uid = SPECIES_ID_HUMAN_SPACE
	name = SPECIES_HUMAN_SPACER
	name_plural = "space-adapted Humans"

	icobase      = 'icons/mob/species/human/subspecies/body_spacer.dmi'
	preview_icon = 'icons/mob/species/human/subspecies/preview_spacer.dmi'

	blurb = {"
	Lithe and frail, these sickly folk were engineered for work in environments that lack both light and
	atmosphere. As such, they're quite resistant to asphyxiation as well as toxins, but they suffer from
	weakened bone structure and a marked vulnerability to bright lights.
	"}

	blood_volume = 640 // 8/7 of baseline

	flash_mod     = 1.2
	oxy_mod       = 0.6
	radiation_mod = 0.6
	toxins_mod    = 1.4

	minimum_breath_pressure = 12

	slowdown = -0.1//Minor speedboost
	item_slowdown_mod = 1.05 //Minor slowdown

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	color_force_greyscale = TRUE
	base_color = "#EECEB3"

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/spacer),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/spacer),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/spacer),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/spacer),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/spacer),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/spacer),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/spacer),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/spacer),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/spacer),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/spacer),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/spacer),
	)

/datum/species/human/vatgrown
	uid = SPECIES_ID_HUMAN_VAT
	name = SPECIES_HUMAN_VATBORN
	name_plural = SPECIES_HUMAN_VATBORN

	icobase      = 'icons/mob/species/human/subspecies/body_vatgrown.dmi'
	preview_icon = 'icons/mob/species/human/subspecies/preview_vatgrown.dmi'

	blurb = {"
	With cloning on the forefront of human scientific advancement, cheap mass production of bodies is
	a very real and rather ethically grey industry.  Vat-grown or Vatborn humans tend to be paler than
	baseline, with no appendix and fewer inherited genetic disabilities, but a more aggressive metabolism.
	"}

	oxy_mod    = 1.05
	toxins_mod = 1.05

	total_health = 115
	hunger_factor = 0.35//less hungry

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	color_force_greyscale = TRUE
	base_color = "#EECEB3"

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_SPLEEN    = /obj/item/organ/internal/spleen/minor,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)
