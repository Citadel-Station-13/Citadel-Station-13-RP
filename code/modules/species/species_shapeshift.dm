// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for changelings later.
var/list/wrapped_species_by_ref = list()

/datum/species/shapeshifter
	abstract_type = /datum/species/shapeshifter

	#warn every shapeshifter needs the funny shapeshift panel, capabiltiies implemented, etc
	var/datum/shapeshift_system/shapeshift_system
	var/datum/shapeshift_panel/shapeshift_panel
	var/shapeshift_capability

	var/list/valid_transform_species = list()
	var/monochromatic = FALSE
	var/default_form = SPECIES_HUMAN
	var/heal_rate = 0

/datum/species/shapeshifter/get_valid_shapeshifter_forms(mob/living/carbon/human/H)
	return valid_transform_species

/datum/species/shapeshifter/get_icobase(mob/living/carbon/human/H, get_deform)
	if(!H) return ..(null, get_deform)
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_icobase(H, get_deform)

/datum/species/shapeshifter/real_race_key(mob/living/carbon/human/H)
	return "[..()]-[wrapped_species_by_ref["\ref[H]"]]"

/datum/species/shapeshifter/get_effective_bodytype(mob/living/carbon/human/H, obj/item/I, slot_id)
	if(!H) return ..(H, I, slot_id)
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_effective_bodytype(H, I, slot_id)

/datum/species/shapeshifter/get_bodytype_legacy(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_bodytype_legacy(H)

/datum/species/shapeshifter/get_worn_legacy_bodytype(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_worn_legacy_bodytype(H)

/datum/species/shapeshifter/get_blood_mask(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_blood_mask(H)

/datum/species/shapeshifter/get_damage_mask(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_damage_mask(H)

/datum/species/shapeshifter/get_damage_overlays(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_damage_overlays(H)

/datum/species/shapeshifter/get_tail(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail(H)

/datum/species/shapeshifter/get_tail_animation(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail_animation(H)

/datum/species/shapeshifter/get_tail_hair(mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
	return S.get_tail_hair(H)

/datum/species/shapeshifter/get_husk_icon(mob/living/carbon/human/H)
	if(H)
		var/datum/species/S = SScharacters.resolve_species_name(wrapped_species_by_ref["\ref[H]"])
		if(S)
			return S.get_husk_icon(H)
	 return ..()

/datum/species/shapeshifter/handle_post_spawn(mob/living/carbon/human/H)
	..()
	wrapped_species_by_ref["\ref[H]"] = default_form
	if(monochromatic)
		H.r_hair =   H.r_skin
		H.g_hair =   H.g_skin
		H.b_hair =   H.b_skin
		H.r_facial = H.r_skin
		H.g_facial = H.g_skin
		H.b_facial = H.b_skin

	for(var/obj/item/organ/external/E in H.organs)
		E.sync_colour_to_human(H)

#warn allow selecting emissiveness on ears, tail, wings
#warn BODY MARKING SELECTER + EMISSIVES

/mob/living/carbon/human/proc/promethean_select_opaqueness()

	set name = "Toggle Transparency"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	for(var/limb in src.organs)
		var/obj/item/organ/external/L = limb
		L.transparent = !L.transparent
	visible_message(SPAN_NOTICE("\The [src]'s interal composition seems to change."))
	update_icons_body()

/datum/species/shapeshifter/handle_environment_special(mob/living/carbon/human/H)
	// Heal remaining damage.
	if(H.fire_stacks >= 0 && heal_rate > 0)
		if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
			var/nutrition_cost = 0
			var/nutrition_debt = H.getBruteLoss()
			var/starve_mod = 1
			if(H.nutrition <= 25)
				starve_mod = 0.75
			H.adjustBruteLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getBruteLoss()

			nutrition_debt = H.getFireLoss()
			H.adjustFireLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getFireLoss()

			nutrition_debt = H.getOxyLoss()
			H.adjustOxyLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getOxyLoss()

			nutrition_debt = H.getToxLoss()
			H.adjustToxLoss(-heal_rate * starve_mod)
			nutrition_cost += nutrition_debt - H.getToxLoss()
			H.nutrition -= (2 * nutrition_cost) //Costs Nutrition when damage is being repaired, corresponding to the amount of damage being repaired.
			H.nutrition = max(0, H.nutrition) //Ensure it's not below 0.
	..()
