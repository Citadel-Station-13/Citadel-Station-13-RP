/// HOLOSPHERES
/* 'transform_component' refers to the component letting them switch between their 'shell' (see holosphere_shell.dm) and their 'hologram' (the mob/living/carbon/human part)
 * 'try_transform' means going from the hologram to the shell
 * 'try_untransform' means going from the shell to the hologram
 * holospheres get holographic clothing and limbs
 * their clothing is copied from their loadout onto a set of chameleon clothing that cannot be taken off
 */

/datum/species/holosphere
	name = SPECIES_HOLOSPHERE
	uid = SPECIES_ID_HOLOSPHERE
	id = SPECIES_ID_HOLOSPHERE
	category = SPECIES_CAEGORY_HOLOSPHERE
	name_plural   = "Holospheres"
	override_worn_legacy_bodytype = SPECIES_HUMAN
	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	blurb = {"This species is testmerged and currently being tested - things might break, and everything about it is subject to change!
	"}

	selects_bodytype = TRUE

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_BODY_ALPHA | HAS_HAIR_ALPHA
	species_flags =            NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT | NO_PAIN | CONTAMINATION_IMMUNE | NO_BLOOD | NO_NUTRITION_GAIN

	total_health = 20
	death_health = 0
	crit_health = -100 // never happens because you hit death health first, and cant go into crit while dead

	hunger_factor = 0 // doesn't get hungry naturally, but instead when healing they use nutrition

	has_organ = list(
		O_BRAIN     = /obj/item/organ/internal/brain/holosphere
	)
	vision_organ = O_BRAIN

	name_language    = LANGUAGE_ID_EAL
	intrinsic_languages = LANGUAGE_ID_EAL

	thirst_factor = 0

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/indestructible/holosphere),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/indestructible/holosphere),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/indestructible/holosphere),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/indestructible/holosphere),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/indestructible/holosphere),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/indestructible/holosphere),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/indestructible/holosphere),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/indestructible/holosphere),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/indestructible/holosphere),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/indestructible/holosphere),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/indestructible/holosphere),
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
		/mob/living/carbon/human/proc/switch_loadout_holosphere,
		/mob/living/carbon/human/proc/disable_hologram,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_horns,
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/hologram_reset_to_slot,
		/mob/living/proc/set_size,
	)

	minimum_hair_alpha = MINIMUM_HOLOGRAM_HAIR_ALPHA
	maximum_hair_alpha = MAXIMUM_HOLOGRAM_HAIR_ALPHA
	minimum_body_alpha = MINIMUM_HOLOGRAM_BODY_ALPHA
	maximum_body_alpha = MAXIMUM_HOLOGRAM_BODY_ALPHA

	color_mult = 1
	base_color = "#EECEB3"

	breath_type = null
	poison_type = null

	virus_immune =	1
	blood_volume =	0

	oxy_mod =		0
	radiation_mod = 0
	toxins_mod =	0

	cold_level_1 = 0
	cold_level_2 = 0
	cold_level_3 = 0

	warning_low_pressure = -1
	hazard_low_pressure = -1

	actions_to_apply = list(
		/datum/action/holosphere/toggle_transform,
		/datum/action/holosphere/change_loadout
	)

	hunger_slowdown_multiplier = 0.5 // they can't eat and hitting 0 hunger makes them absolutely defenceless, no need to punish them much for this

	var/list/chameleon_gear = list(
		SLOT_ID_UNIFORM = /obj/item/clothing/under/chameleon/holosphere,
		SLOT_ID_SUIT    = /obj/item/clothing/suit/chameleon/holosphere,
		SLOT_ID_HEAD    = /obj/item/clothing/head/chameleon/holosphere,
		SLOT_ID_SHOES   = /obj/item/clothing/shoes/chameleon/holosphere,
		SLOT_ID_GLOVES  = /obj/item/clothing/gloves/chameleon/holosphere,
		SLOT_ID_MASK    = /obj/item/clothing/mask/chameleon/holosphere,
	)
	var/list/equipped_chameleon_gear = list()

	var/cached_loadout_flags
	var/cached_loadout_role

	var/datum/component/custom_transform/transform_component
	var/mob/living/simple_mob/holosphere_shell/holosphere_shell
	var/hologram_death_duration = 2 SECONDS

	// what gear slots we initialised when spawning in for our chameleon gear, so we dont try override job gear with loadout gear
	var/list/slots_used = list()

	var/actively_healing = TRUE
	var/heal_rate = 1 // this is pretty high but they have 20 health and it costs nutrition to heal

	var/heal_nutrition_multiplier = 10 // 10 nutrition per hp healed

	var/last_death_time

/datum/species/holosphere/on_apply(mob/living/carbon/human/H)
	. = ..()
	RegisterSignal(H, COMSIG_CARBON_UPDATING_OVERLAY, PROC_REF(handle_hologram_overlays))
	RegisterSignal(H, COMSIG_HUMAN_EQUIPPING_LOADOUT, PROC_REF(handle_hologram_loadout))

	if(istype(H, /mob/living/carbon/human/dummy))
		return

	holosphere_shell = new(H, H)
	transform_component = H.AddComponent(/datum/component/custom_transform, holosphere_shell, null, null, FALSE)
	holosphere_shell.transform_component = transform_component
	holosphere_shell.hologram = H
	holosphere_shell.copy_iff_factions(H)

/datum/species/holosphere/on_remove(mob/living/carbon/human/H)
	. = ..()
	UnregisterSignal(H, COMSIG_CARBON_UPDATING_OVERLAY)
	UnregisterSignal(H, COMSIG_HUMAN_EQUIPPING_LOADOUT)

	remove_chameleon_gear()

/datum/species/holosphere/proc/try_transform(force = FALSE)
	if(force || !IS_DEAD(holosphere_shell))
		if(holosphere_shell.hologram.incapacitated(INCAPACITATION_ALL))
			to_chat(holosphere_shell.hologram, SPAN_WARNING("You can't do that right now!"))
			return

		holosphere_shell.name = holosphere_shell.hologram.name
		if(transform_component.try_transform())
			holosphere_shell.hologram.drop_held_items()
			holosphere_shell.regenerate_icons()

/datum/species/holosphere/proc/try_untransform(force = FALSE)
	if(force || !IS_DEAD(holosphere_shell.hologram))
		transform_component.try_untransform()

/mob/living/carbon/human/proc/disable_hologram()
	set name = "Disable Hologram (Holosphere)"
	set desc = "Disable your hologram."
	set category = VERB_CATEGORY_IC

	var/datum/species/holosphere/holosphere_species = species
	if(!istype(holosphere_species))
		return

	holosphere_species.try_transform()

/datum/species/holosphere/apply_survival_gear(mob/living/carbon/for_target, list/into_box, list/into_inv)
	into_box?.Add(/obj/item/tool/prybar/red)
	into_box?.Add(/obj/item/flashlight/flare/survival)
	into_box?.Add(/obj/item/fbp_backup_cell)

// hotfix: they're synthetic without synthetic parts, oops!
/datum/species/holosphere/get_blood_colour(mob/living/carbon/human/H)
	if(H)
		return blood_color

/datum/species/holosphere/get_bodytype_legacy()
	return base_species

/datum/species/holosphere/get_worn_legacy_bodytype()
	var/datum/species/real = SScharacters.resolve_species_name(base_species)
	// infinite loop guard
	return istype(real, src)? base_species : real.get_worn_legacy_bodytype()

/datum/species/holosphere/get_race_key(mob/living/carbon/human/H)
	var/datum/species/real = SScharacters.resolve_species_name(base_species)
	return real.real_race_key(H)

/datum/species/holosphere/get_valid_shapeshifter_forms()
	return list(
		SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_UNATHI_DIGI, SPECIES_TAJ, SPECIES_SKRELL,
		SPECIES_DIONA, SPECIES_TESHARI, SPECIES_MONKEY, SPECIES_SERGAL,
		SPECIES_AKULA, SPECIES_NEVREAN, SPECIES_ZORREN_HIGH,
		SPECIES_ZORREN_FLAT, SPECIES_VULPKANIN, SPECIES_VASILISSAN,
		SPECIES_RAPALA, SPECIES_MONKEY_SKRELL, SPECIES_MONKEY_UNATHI,
		SPECIES_MONKEY_TAJ, SPECIES_MONKEY_AKULA, SPECIES_MONKEY_VULPKANIN,
		SPECIES_MONKEY_SERGAL, SPECIES_MONKEY_NEVREAN,
	)
