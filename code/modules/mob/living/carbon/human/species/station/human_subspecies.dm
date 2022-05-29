/datum/species/human/gravworlder
	name = SPECIES_HUMAN_GRAV
	name_plural = "grav-adapted Humans"
	blurb = "Heavier and stronger than a baseline human, gravity-adapted people have \
	thick radiation-resistant skin with a high lead content, denser bones, and recessed \
	eyes beneath a prominent brow in order to shield them from the glare of a dangerously \
	bright, alien sun. This comes at the cost of mobility, flexibility, and increased \
	oxygen requirements to support their robust metabolism."

	toxins_mod = 	0.8
	radiation_mod = 0.95

	brute_mod =     0.90
	burn_mod = 		0.90

	slowdown =      0.2 //Minor general slowdown
	item_slowdown_mod = 0.95 //Reduced Item slowdown

	oxy_mod =       1.1
	minimum_breath_pressure = 18

	total_health = 130
	hunger_factor = 0.075//50% more hungry

	has_limbs = list(
		BP_TORSO =	list("path" = /obj/item/organ/external/chest/gravworlder),
		BP_GROIN =	list("path" = /obj/item/organ/external/groin/gravworlder),
		BP_HEAD  =	list("path" = /obj/item/organ/external/head/gravworlder),
		BP_L_ARM =	list("path" = /obj/item/organ/external/arm/gravworlder),
		BP_R_ARM =	list("path" = /obj/item/organ/external/arm/right/gravworlder),
		BP_L_LEG =	list("path" = /obj/item/organ/external/leg/gravworlder),
		BP_R_LEG =	list("path" = /obj/item/organ/external/leg/right/gravworlder),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/gravworlder),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/gravworlder),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/gravworlder),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/gravworlder)
		)

	flags = NO_MINOR_CUT

	spawn_flags = SPECIES_CAN_JOIN
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	color_mult = 1
	icobase = 'icons/mob/human_races/subspecies/r_gravworlder.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	base_color = "#EECEB3"

/datum/species/human/spacer
	name = SPECIES_HUMAN_SPACER
	name_plural = "space-adapted Humans"
	blurb = "Lithe and frail, these sickly folk were engineered for work in environments that \
	lack both light and atmosphere. As such, they're quite resistant to asphyxiation as well as \
	toxins, but they suffer from weakened bone structure and a marked vulnerability to bright lights."

	blood_volume = 640 // 8/7 of baseline

	toxins_mod =   1.4
	radiation_mod = 0.6

	oxy_mod =   0.6

	minimum_breath_pressure = 12

	flash_mod = 1.2

	slowdown = -0.1//Minor speedboost
	item_slowdown_mod = 1.05 //Minor slowdown

	has_limbs = list(
		BP_TORSO =	list("path" = /obj/item/organ/external/chest/spacer),
		BP_GROIN =	list("path" = /obj/item/organ/external/groin/spacer),
		BP_HEAD =	 list("path" = /obj/item/organ/external/head/spacer),
		BP_L_ARM =	list("path" = /obj/item/organ/external/arm/spacer),
		BP_R_ARM =	list("path" = /obj/item/organ/external/arm/right/spacer),
		BP_L_LEG =	list("path" = /obj/item/organ/external/leg/spacer),
		BP_R_LEG =	list("path" = /obj/item/organ/external/leg/right/spacer),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/spacer),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/spacer),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/spacer),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/spacer)
		)

	color_mult = 1
	icobase = 'icons/mob/human_races/subspecies/r_spacer.dmi'
	spawn_flags = SPECIES_CAN_JOIN
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	base_color = "#EECEB3"


/datum/species/human/vatgrown
	name = SPECIES_HUMAN_VATBORN
	name_plural = SPECIES_HUMAN_VATBORN
	blurb = "With cloning on the forefront of human scientific advancement, cheap mass production \
	of bodies is a very real and rather ethically grey industry. Vat-grown or Vatborn humans tend to be \
	paler than baseline, with no appendix and fewer inherited genetic disabilities, but a more aggressive metabolism."

	oxy_mod = 		1.05
	toxins_mod =   	1.05

	total_health = 115
	hunger_factor = 0.35//less hungry

	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_VOICE =    /obj/item/organ/internal/voicebox,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_SPLEEN =   /obj/item/organ/internal/spleen/minor,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_EYES =     /obj/item/organ/internal/eyes,
		O_STOMACH =	 /obj/item/organ/internal/stomach,
		O_INTESTINE =/obj/item/organ/internal/intestine
		)

	color_mult = 1
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	//icobase = 'icons/mob/human_races/subspecies/r_vatgrown.dmi'
	//Icon base needs Greyscaleing
	spawn_flags = SPECIES_CAN_JOIN
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	base_color = "#EECEB3"

/*
// These guys are going to need full resprites of all the suits/etc so I'm going to
// define them and commit the sprites, but leave the clothing for another day.
/datum/species/human/chimpanzee
	name = "uplifted Chimpanzee"
	name_plural = "uplifted Chimpanzees"
	blurb = "Ook ook."
	icobase = 'icons/mob/human_races/subspecies/r_upliftedchimp.dmi'
*/
