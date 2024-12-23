#define HOLOGRAM_OTHER_ALPHA 255
#define HOLOGRAM_SHIELD_MAX_HEALTH 20

/datum/species/holosphere
	name = SPECIES_HOLOSPHERE
	uid = SPECIES_ID_HOLOSPHERE
	id = SPECIES_ID_HOLOSPHERE
	category = SPECIES_CATEGORY_RESTRICTED
	name_plural   = "Holospheres"
	override_worn_legacy_bodytype = SPECIES_HUMAN
	icobase = 'icons/mob/species/human/body_greyscale.dmi'
	deform  = 'icons/mob/species/human/deformed_body_greyscale.dmi'

	species_spawn_flags = SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_BODY_ALPHA | HAS_HAIR_ALPHA
	species_flags =            NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT | NO_PAIN | CONTAMINATION_IMMUNE

	total_health = 20

	hunger_factor = 0 // doesn't get hungry naturally, but instead when healing they use nutrition

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
	)

	minimum_hair_alpha = MINIMUM_HOLOGRAM_HAIR_ALPHA
	maximum_hair_alpha = MAXIMUM_HOLOGRAM_HAIR_ALPHA
	minimum_body_alpha = MINIMUM_HOLOGRAM_BODY_ALPHA
	maximum_body_alpha = MAXIMUM_HOLOGRAM_BODY_ALPHA

	color_mult = 1
	base_color = "#EECEB3"

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

	var/cached_loadout_flags
	var/cached_loadout_role

	var/datum/component/custom_transform/transform_component
	var/mob/living/simple_mob/holosphere_shell/holosphere_shell
	var/hologram_death_duration = 10 SECONDS

/datum/species/holosphere/on_apply(mob/living/carbon/human/H)
	. = ..()
	RegisterSignal(H, COMSIG_CARBON_UPDATING_OVERLAY, PROC_REF(handle_hologram_overlays))
	RegisterSignal(H, COMSIG_HUMAN_EQUIPPING_LOADOUT, PROC_REF(handle_hologram_loadout))
	holosphere_shell = new(H)
	transform_component = H.AddComponent(/datum/component/custom_transform, holosphere_shell, null, null, FALSE)
	holosphere_shell.transform_component = transform_component
	holosphere_shell.hologram = H

/datum/species/holosphere/on_remove(mob/living/carbon/human/H)
	. = ..()
	UnregisterSignal(H, COMSIG_CARBON_UPDATING_OVERLAY)
	UnregisterSignal(H, COMSIG_HUMAN_EQUIPPING_LOADOUT)

	for(var/slot in equipped_chameleon_gear)
		var/chameleon_item = equipped_chameleon_gear[slot]
		qdel(chameleon_item)

/datum/species/holosphere/proc/get_alpha_from_key(var/mob/living/carbon/human/H, var/key)
	switch(key)
		if(HUMAN_OVERLAY_BODY)
			return H.body_alpha
		if(HUMAN_OVERLAY_HAIR, HUMAN_OVERLAY_FACEHAIR)
			return H.hair_alpha
	return HOLOGRAM_OTHER_ALPHA

/datum/species/holosphere/proc/handle_hologram_overlays(datum/source, list/overlay_args, category)
	var/is_clothing = category == CARBON_APPEARANCE_UPDATE_CLOTHING
	var/overlay_index = is_clothing ? 1 : 2
	var/overlay_object = overlay_args[overlay_index]
	var/alpha_to_use = is_clothing ? 255 : get_alpha_from_key(source, category)
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

/datum/species/holosphere/proc/give_chameleon_gear(mob/living/carbon/human/H)
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

/datum/species/holosphere/proc/handle_hologram_loadout(datum/source, flags, datum/role/role, list/datum/loadout_entry/loadout)
	if(istype(source, /mob/living/carbon/human/dummy))
		return

	cached_loadout_flags = flags
	cached_loadout_role = role

	give_chameleon_gear(source)

	equip_loadout(source, loadout)

/datum/species/holosphere/proc/equip_loadout(mob/living/carbon/human/H, list/datum/loadout_entry/loadout)
	var/slots_used = list()
	for(var/datum/loadout_entry/entry as anything in loadout)
		var/use_slot = entry.slot
		if(isnull(use_slot))
			continue
		var/obj/item/equipped = equipped_chameleon_gear[use_slot]
		if(equipped)
			equipped.disguise(entry.path, H)
			equipped.update_worn_icon()
			slots_used += use_slot
			loadout -= entry

	// no loadout items in that slot, hide the items icon
	for(var/slot in equipped_chameleon_gear)
		if(!(slot in slots_used))
			var/obj/item/chameleon_item = equipped_chameleon_gear[slot]
			chameleon_item.icon = initial(chameleon_item.icon)
			chameleon_item.icon_state = CLOTHING_BLANK_ICON_STATE
			var/obj/item/clothing/under/chameleon_uniform = chameleon_item
			if(istype(chameleon_uniform))
				chameleon_uniform.snowflake_worn_state = CLOTHING_BLANK_ICON_STATE
			chameleon_item.update_worn_icon()

/datum/species/holosphere/verb/switch_loadout(mob/living/carbon/human/H)
	var/list/loadout_options = list()
	for(var/i in 1 to LOADOUT_MAX_SLOTS)
		loadout_options["Loadout [i]"] = i
	var/loadout_option = tgui_input_list(usr, "Choose Loadout", "Loadout", loadout_options)
	var/loadout_slot = loadout_options[loadout_option]
	var/list/datum/loadout_entry/loadout_entries = H.client.prefs.generate_loadout_entry_list(cached_loadout_flags, cached_loadout_role, loadout_slot)
	equip_loadout(H, loadout_entries)

/datum/species/holosphere/handle_death(var/mob/living/carbon/human/H, gibbed)
	var/deathmsg = "<span class='userdanger'>Systems critically damaged. Emitters temporarily offline.</span>"
	to_chat(H, deathmsg)
	transform_component.try_transform()
	holosphere_shell.afflict_stun(hologram_death_duration)
	sleep(hologram_death_duration)
	if(holosphere_shell.stat != DEAD)
		H.revive(full_heal = TRUE)
		var/regenmsg = "<span class='userdanger'>Emitters have returned online. Systems functional.</span>"
		to_chat(holosphere_shell, regenmsg)

/datum/species/holosphere/verb/disable_hologram(mob/living/carbon/human/H)
	transform_component.try_transform()

/// holosphere 'sphere'
/mob/living/simple_mob/holosphere_shell
	name = "test"
	desc = "test"

	maxHealth = 100
	health = 100

	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	aquatic_movement = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	minbodytemp = 0
	maxbodytemp = INFINITY
	heat_resist = 1
	cold_resist = 1

	legacy_melee_damage_lower = 0
	legacy_melee_damage_upper = 0

	// space movement related
	var/last_space_movement = 0

	// the transform component we are used with
	var/datum/component/custom_transform/transform_component
	// the human we belong to
	var/mob/living/carbon/human/hologram

/mob/living/simple_mob/holosphere_shell/verb/enable_hologram()
	transform_component.try_untransform()

// same way pAI space movement works in pai/mobility.dm
/mob/living/simple_mob/holosphere_shell/Process_Spacemove(movement_dir = NONE)
	. = ..()
	if(!. && src.loc != hologram)
		if(world.time >= last_space_movement + 3 SECONDS)
			last_space_movement = world.time
			// place an effect for the movement
			new /obj/effect/temp_visual/pai_ion_burst(get_turf(src))
			return TRUE
