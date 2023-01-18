// Species for the opaque appearance
// Due to sprite construction, they have to have separate limb lists

/datum/species/shapeshifter/promethean/avatar/human
	name = SPECIES_VR_HUMAN
	uid = SPECIES_ID_VIRTUAL_REALITY_HUMAN
	icobase = 'icons/mob/species/human/body.dmi'
	deform = 'icons/mob/species/human/deformed_body.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

/datum/species/shapeshifter/promethean/avatar/unathi
	name = SPECIES_VR_UNATHI
	uid = SPECIES_ID_VIRTUAL_REALITY_UNATHI
	icobase = 'icons/mob/species/unathi/body_greyscale.dmi'
	deform  = 'icons/mob/species/unathi/deformed_body_greyscale.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail_greyscale.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/unathi),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/unathi),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/unathi),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

/datum/species/shapeshifter/promethean/avatar/tajaran
	name = "Virtual Reality Tajaran"
	uid = SPECIES_ID_VIRTUAL_REALITY_TAJARAN
	icobase = 'icons/mob/species/tajaran/body_greyscale.dmi'
	deform  = 'icons/mob/species/tajaran/deformed_body_greyscale.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail_greyscale.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

/datum/species/shapeshifter/promethean/avatar/skrell
	name = SPECIES_VR_SKRELL
	uid = SPECIES_ID_VIRTUAL_REALITY_SKRELL
	icobase = 'icons/mob/species/skrell/body_greyscale.dmi'
	deform  = 'icons/mob/species/skrell/deformed_body_greyscale.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/skrell),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

/datum/species/shapeshifter/promethean/avatar/teshari
	name = SPECIES_VR_TESHARI
	uid = SPECIES_ID_VIRTUAL_REALITY_TESHARI
	icobase = 'icons/mob/species/teshari/body.dmi'
	deform  = 'icons/mob/species/teshari/deformed_body.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/teshari),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/teshari),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/teshari),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/teshari),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/teshari),
	)

/datum/species/shapeshifter/promethean/avatar/diona
	uid = SPECIES_ID_VIRTUAL_REALITY_DIONA
	name = SPECIES_VR_DIONA
	icobase = 'icons/mob/species/diona/body.dmi'
	deform  = 'icons/mob/species/diona/deformed_body.dmi'
	species_appearance_flags = NONE
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/diona/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/diona/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/no_eyes/diona),
		BP_L_ARM  = list("path" = /obj/item/organ/external/diona/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/diona/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/diona/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/diona/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/diona/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/diona/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/diona/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/diona/foot/right),
	)

/datum/species/shapeshifter/promethean/avatar/monkey
	uid = SPECIES_ID_VIRTUAL_REALITY_MONKEY
	name = SPECIES_VR_MONKEY
	icobase         = 'icons/mob/species/monkey/body_monkey.dmi'
	deform          = 'icons/mob/species/monkey/body_monkey.dmi'
	damage_overlays = 'icons/mob/species/monkey/damage_overlay.dmi'
	damage_mask     = 'icons/mob/species/monkey/damage_mask.dmi'
	blood_mask      = 'icons/mob/species/monkey/blood_mask.dmi'
	fire_icon_state = "monkey"
	species_appearance_flags = NONE
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/no_eyes),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

/datum/species/shapeshifter/promethean/avatar/vox
	uid = SPECIES_ID_VIRTUAL_REALITY_VOX
	name = SPECIES_VR_VOX
	icobase = 'icons/mob/species/vox/body.dmi'
	deform  = 'icons/mob/species/vox/deformed_body.dmi'
	species_appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/vox),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)

/datum/species/shapeshifter/promethean/avatar/skeleton
	uid = SPECIES_ID_VIRTUAL_REALITY_SKELETON
	name = SPECIES_VR_SKELETON
	icobase = 'icons/mob/species/human/skeleton.dmi'
	deform  = 'icons/mob/species/human/skeleton.dmi'
	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right),
	)
