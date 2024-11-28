#define HOLOGRAM_OTHER_ALPHA 230
#define HOLOGRAM_BODY_ALPHA 100
#define HOLOGRAM_CLOTHING_ALPHA 255

/datum/species/holosphere
	name = SPECIES_HOLOSPHERE
	uid = SPECIES_ID_HOLOSPHERE
	id = SPECIES_ID_HOLOSPHERE
	category = SPECIES_CATEGORY_RESTRICTED
	name_plural   = "Holospheres"
	override_worn_legacy_bodytype = SPECIES_HUMAN
	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	selects_bodytype = TRUE

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
	vision_organ = O_EYES

	has_limbs = list(
		BP_TORSO  = list("path" = /obj/item/organ/external/chest/indestructible),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/indestructible),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/indestructible),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/indestructible),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/indestructible),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/indestructible),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/indestructible),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/indestructible),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/indestructible),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/indestructible),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/indestructible),
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/hide_horns,
		/mob/living/carbon/human/proc/hide_wings,
		/mob/living/carbon/human/proc/hide_tail,
	)

	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

/datum/species/holosphere/on_apply(mob/living/carbon/human/H)
	. = ..()
	RegisterSignal(H, COMSIG_CARBON_UPDATING_OVERLAY, PROC_REF(handle_hologram_overlays))
	RegisterSignal(H, COMSIG_HUMAN_EQUIPPING_LOADOUT, PROC_REF(handle_hologram_loadout))

/datum/species/holosphere/on_remove(mob/living/carbon/human/H)
	. = ..()
	UnregisterSignal(H, COMSIG_CARBON_UPDATING_OVERLAY)
	UnregisterSignal(H, COMSIG_HUMAN_EQUIPPING_LOADOUT)

/datum/species/holosphere/proc/get_alpha_from_key(var/key)
	return key == HUMAN_OVERLAY_BODY ? HOLOGRAM_BODY_ALPHA : HOLOGRAM_OTHER_ALPHA

/datum/species/holosphere/proc/handle_hologram_overlays(datum/source, list/overlay_args, category)
	var/is_clothing = category == CARBON_APPEARANCE_UPDATE_CLOTHING
	var/overlay_index = is_clothing ? 1 : 2
	var/overlay_object = overlay_args[overlay_index]
	var/alpha_to_use = is_clothing ? HOLOGRAM_CLOTHING_ALPHA : get_alpha_from_key(overlay_args[1])
	if(islist(overlay_object))
		var/list/new_list = list()
		var/list/overlay_list = overlay_object
		for(var/I in overlay_list)
			if(isnull(I))
				continue
			var/mutable_appearance/new_overlay = make_hologram_appearance(I, alpha_to_use, TRUE)
			new_list += new_overlay
		overlay_args[overlay_index] = new_list
	else
		var/mutable_appearance/new_overlay = make_hologram_appearance(overlay_object, alpha_to_use, TRUE)
		overlay_args[overlay_index] = list(new_overlay)

/datum/species/proc/handle_hologram_loadout(datum/source, list/loadout)
	// drop everything

	// give character chameleon gear


	for(var/datum/loadout_entry/entry as anything in loadout)
		var/list/data = loadout[entry]
		var/obj/item/instanced = entry.instantiate(entry_data = data)
		var/use_slot = entry.slot
		if(isnull(use_slot))
			continue
		var/succeeded = FALSE
		// if we have a piece of chameleon gear in that slot currently, update our chameleon gear to that icon, remove from the list
		if(TRUE)
			loadout -= entry
