/datum/species/shadekin/black_eyed
	uid = SPECIES_ID_SHADEKIN_BLACK
	name = SPECIES_SHADEKIN_CREW
	name_plural = SPECIES_SHADEKIN_CREW
	uid = SPECIES_ID_SHADEKIN_BLACK
	id = SPECIES_ID_SHADEKIN

	item_slowdown_mod = 2 // Originally 1.5. They're not as physically fits, slowed down more by heavy gear.

	total_health = 75   // Fragile
	brute_mod    = 1 // Originally 1.25, lowered to 1 because lower HP and increased damage is a bit heavy.
	burn_mod     = 1.25 // Furry
	toxins_mod = 1.2

	blood_volume  = 500 // Slightly less blood than human baseline.
	hunger_factor = 0.2 // Gets hungrier faster than human baseline.

	hazard_high_pressure = 1000 // Same High Pressure resistance as Voidsuits get

	species_spawn_flags = SPECIES_SPAWN_CHARACTER | SPECIES_SPAWN_WHITELISTED

	species_appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_UNDERWEAR

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain/shadekin/crewkin,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/crewkin),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/crewkin),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/vr/crewkin),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/crewkin),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/crewkin),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/crewkin),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/crewkin),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/crewkin),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/crewkin),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/crewkin),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/crewkin),
	)

	// todo: nerf these two abilities when someone wants to make it not a fucking copypaste ~silicons
	shadekin_abilities = list(
		/datum/power/shadekin/regenerate_other,
		/datum/power/shadekin/create_shade,
	)

	energy_light = 0.5
	energy_dark = 1
