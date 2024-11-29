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

	var/list/chameleon_gear = list(
		SLOT_ID_UNIFORM = /obj/item/clothing/under/chameleon/holosphere,
		SLOT_ID_SUIT    = /obj/item/clothing/suit/chameleon/holosphere,
		SLOT_ID_HEAD    = /obj/item/clothing/head/chameleon/holosphere,
		SLOT_ID_SHOES   = /obj/item/clothing/shoes/chameleon/holosphere,
		SLOT_ID_BACK    = /obj/item/storage/backpack/chameleon/holosphere,
		SLOT_ID_GLOVES  = /obj/item/clothing/gloves/chameleon/holosphere,
		SLOT_ID_MASK    = /obj/item/clothing/mask/chameleon/holosphere,
		SLOT_ID_GLASSES = /obj/item/clothing/glasses/chameleon/holosphere,
		SLOT_ID_BELT    = /obj/item/storage/belt/chameleon/holosphere
	)

	var/list/equipped_chameleon_gear = list()

/datum/species/holosphere/on_apply(mob/living/carbon/human/H)
	. = ..()
	RegisterSignal(H, COMSIG_CARBON_UPDATING_OVERLAY, PROC_REF(handle_hologram_overlays))
	RegisterSignal(H, COMSIG_HUMAN_EQUIPPING_LOADOUT, PROC_REF(handle_hologram_loadout))

/datum/species/holosphere/on_remove(mob/living/carbon/human/H)
	. = ..()
	UnregisterSignal(H, COMSIG_CARBON_UPDATING_OVERLAY)
	UnregisterSignal(H, COMSIG_HUMAN_EQUIPPING_LOADOUT)

	for(var/slot in equipped_chameleon_gear)
		var/chameleon_item = equipped_chameleon_gear[slot]
		qdel(chameleon_item)

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

/datum/species/holosphere/proc/handle_hologram_loadout(datum/source, list/loadout)
	if(istype(source, /mob/living/carbon/human/dummy))
		return

	// drop everything
	var/mob/living/carbon/human/H = source
	if(!istype(H))
		return
	for(var/obj/item/I in H.get_equipped_items(TRUE, FALSE))
		var/turf = get_turf(H)
		if(turf)
			I.forceMove(get_turf(H))
		else
			qdel(I)

	// give character chameleon gear
	for(var/slot in chameleon_gear)
		var/chameleon_path = chameleon_gear[slot]
		var/obj/item/chameleon_item = new chameleon_path()
		H.equip_to_slot_if_possible(chameleon_item, slot, INV_OP_SILENT | INV_OP_FLUFFLESS)
		equipped_chameleon_gear[slot] = chameleon_item

	var/slots_used = list()

	for(var/datum/loadout_entry/entry as anything in loadout)
		var/use_slot = entry.slot
		if(isnull(use_slot))
			continue
		var/obj/item/equipped = equipped_chameleon_gear[use_slot]
		if(equipped)
			equipped.disguise(entry.path, source)
			equipped.update_worn_icon()
			slots_used += use_slot
			loadout -= entry

	// no loadout items in that slot, hide the items icon
	for(var/slot in equipped_chameleon_gear)
		if(!(slot in slots_used))
			var/obj/item/chameleon_item = equipped_chameleon_gear[slot]
			chameleon_item.icon = initial(chameleon_item.icon)
			chameleon_item.icon_state = CLOTHING_BLANK_ICON_STATE
			chameleon_item.update_worn_icon()
