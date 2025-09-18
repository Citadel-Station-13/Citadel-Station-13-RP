/datum/component/custom_transform
	var/atom/movable/transformed
	var/transform_text
	var/untransform_text
	var/start_transformed

/datum/component/custom_transform/Initialize(_transformed, _transform_text, _untransform_text, _start_transformed = TRUE)
	transformed = _transformed
	transform_text = _transform_text
	untransform_text = _untransform_text
	start_transformed = _start_transformed
	if(start_transformed)
		transform(TRUE)

/datum/component/custom_transform/proc/swap(new_object, silent = FALSE)
	. = transformed
	var/mob/owner = parent
	if(parent in transformed.contents)
		owner.forceMove(transformed.loc)
	transformed = new_object
	transform(silent)

/datum/component/custom_transform/proc/transform(silent = FALSE)
	var/mob/owner = parent
	transformed.forceMove(owner.loc)
	owner.forceMove(transformed)
	if(ishuman(owner) && ismob(transformed))
		handle_human_transform()
	if(!silent && length(transform_text))
		owner.visible_message("<b>[owner]</b> [transform_text]")

/datum/component/custom_transform/proc/try_transform(silent = FALSE)
	if(transformed.loc == parent)
		transform(silent)
		return TRUE
	return FALSE

/datum/component/custom_transform/proc/untransform(silent = FALSE)
	var/mob/owner = parent
	owner.forceMove(transformed.loc)
	transformed.forceMove(parent)
	if(ishuman(owner) && ismob(transformed))
		handle_human_untransform()
	if(!silent && length(untransform_text))
		owner.visible_message("<b>[owner]</b> [untransform_text]")

/datum/component/custom_transform/proc/try_untransform(silent = FALSE)
	var/mob/owner = parent
	if(owner.loc == transformed)
		untransform(silent)
		return TRUE
	return FALSE

/// special handling for when a human transforms taken from protean blob code
/datum/component/custom_transform/proc/handle_human_transform()
	var/mob/living/carbon/human/H = parent
	var/mob/M = transformed
	H.handle_grasp()
	remove_micros(H, H)

	H.buckled?.unbuckle_mob(src, BUCKLE_OP_FORCE)
	H.unbuckle_all_mobs(BUCKLE_OP_FORCE)
	H.pulledby?.stop_pulling()
	H.stop_pulling()

	// handle radio if we're a simple mob
	var/mob/living/simple_mob/S = M
	if(istype(S))
		if(isnull(S.mob_radio) && istype(H.l_ear, /obj/item/radio))
			S.mob_radio = H.l_ear
			if(!H.transfer_item_to_loc(H.l_ear, M, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT))
				S.mob_radio = null
		if(isnull(S.mob_radio) && istype(H.r_ear, /obj/item/radio))
			S.mob_radio = H.r_ear
			if(!H.transfer_item_to_loc(H.r_ear, M, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT))
				S.mob_radio = null

	// handle languages
	for(var/datum/prototype/language/L in H.languages)
		M.add_language(L.name)

	H.transfer_client_to(M)

/// special handling for when a human untransforms taken from protean blob code
/datum/component/custom_transform/proc/handle_human_untransform()
	var/mob/living/carbon/human/H = parent
	var/mob/M = transformed

	H.buckled?.unbuckle_mob(H, BUCKLE_OP_FORCE)
	H.unbuckle_all_mobs(BUCKLE_OP_FORCE)
	H.pulledby?.stop_pulling()
	H.stop_pulling()

	var/mob/living/simple_mob/S = M
	if(istype(S))
		if(!isnull(S.mob_radio))
			if(!H.equip_to_slots_if_possible(S.mob_radio, list(
				/datum/inventory_slot/inventory/ears/left,
				/datum/inventory_slot/inventory/ears/right,
			)))
				S.mob_radio.forceMove(get_turf(H))
			S.mob_radio = null
	H.forceMove(get_turf(M))
	M.transfer_client_to(H)
