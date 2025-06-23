//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/pre_examine(datum/event_args/examine/examine, examine_for, examine_from)
	. = ..()
	if(. != src)
		return

#warn impl all

/mob/living/carbon/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()

	if(!examine.legacy_examine_no_touch)
		#warn pulse

	LAZYINITLIST(output.visible_descriptors)

	var/list/tagged_organs_or_missing_descriptors = list()
	var/list/obj/item/organ/external/additional_organs = list()

	for(var/external_organ_tag in species.has_limbs)
		var/list/external_organ_data = species.has_limbs[external_organ_tag]
		tagged_organs_or_missing_descriptors[external_organ_tag] = external_organ_data["descriptor"]

	for(var/obj/item/organ/external/external_organ in organs)
		if(external_organ.organ_tag in tagged_organs_or_missing_descriptors)
			tagged_organs_or_missing_descriptors[external_organ.organ_tag] = external_organ
		else
			additional_organs += external_organ

	for(var/external_organ_tag in tagged_organs_or_missing_descriptors)
		var/obj/item/organ/external/organ_or_descriptor = tagged_organs_or_missing_descriptors[external_organ_tag]
		if(istype(organ_or_descriptor) && (organ_or_descriptor.legacy_examine_skip_flags & examine.legacy_examine_skip_body))
			continue
		else if(!istype(organ_or_descriptor) || (organ_or_descriptor.status & ORGAN_DESTROYED))
			output.visible_descriptors += SPAN_BOLDWARNING("[gender_datum_visible.He] [gender_datum_visible.is] missing [gender_datum_visible.his] [organ_or_descriptor]")
			continue
		else if(organ_or_descriptor.is_stump())
			output.visible_descriptors += SPAN_BOLDWARNING("[gender_datum_visible.He] [gender_datum_visible.has] a stump where [gender_datum_visible.his] [organ_or_descriptor] should be.")
			continue
		output.visible_descriptors += organ_or_descriptor.examine_encoding_as_visible_organ(examine, examine_for, examine_from)

	for(var/obj/item/organ/external/extra_organ in additional_organs)
		output.visible_descriptors += extra_organ.examine_encoding_as_visible_organ(examine, examine_for, examine_from)

	#warn above; are organs good now?

	if(pose)
		LAZYADD(output.visible_descriptors, SPAN_INFO("[gender_datum_visible.He] [pose]"))

	var/effective_hud_name = name
	var/obj/item/in_id_slot = inventory.get_slot_single(/datum/inventory_slot/inventory/id::id)
	if(istype(in_id_slot, /obj/item/card/id))
		var/obj/item/card/id/casted_id = in_id_slot
		effective_hud_name = casted_id.registered_name
	else if(istype(in_id_slot, /obj/item/pda))
		var/obj/item/pda/casted_pda = in_id_slot
		effective_hud_name = casted_pda.owner

	if(hasHUD(examine.seer, "medical"))
		var/medical_status = "None"
		for(var/datum/data/record/record in data_core.medical)
			if(record.fields["name"] != effective_hud_name)
				continue
			medical_status = record.fields["p_stat"]
		LAZYADD(output.analysis_descriptors, "Physical status: <a href='?src=\ref[src];medical=1'>\[[medical_status]\]</a>")
		LAZYADD(output.analysis_descriptors, "Medical records: <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>")

	if(hasHUD(examine.seer, "security"))
		var/security_status = "None"
		for(var/datum/data/record/record in data_core.security)
			if(record.fields["name"] != effective_hud_name)
				continue
			security_status = record.fields["criminal"]
		LAZYADD(output.analysis_descriptors, "Criminal status: <a href='?src=\ref[src];criminal=1'>\[[security_status]\]</a>")
		LAZYADD(output.analysis_descriptors, "Security records: <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>")

	if(hasHUD(examine.seer, "best"))
		LAZYADD(output.analysis_descriptors, SPAN_BOLDNOTICE("Employment records: <a href='?src=\ref[src];emprecord=`'>\[View\]</a>"))

	//! dumb vorestation weight system
	if(show_pudge()) //Some clothing or equipment can hide this.
		var/weight_heavy_verb = "heavy"
		var/weight_examine = round(weight)
		var/weight_message
		if(gender == MALE)
			weight_heavy_verb = "bulky"
		else if(gender == FEMALE)
			weight_heavy_verb = "curvy"

		switch(weight_examine)
			if(0 to 74)
				weight_message = SPAN_WARNING("[gender_datum_visible.He] [gender_datum_visible.is] terribly lithe and frail!")
			if(75 to 99)
				weight_message = SPAN_INFO("[gender_datum_visible.He] [gender_datum_visible.has] a very slender frame.")
			if(100 to 124)
				weight_message = SPAN_INFO("[gender_datum_visible.He] [gender_datum_visible.has] a lightweight, athletic build.")
			if(125 to 174)
				weight_message = SPAN_INFO("[gender_datum_visible.He] [gender_datum_visible.has] a healthy, average body.")
			if(175 to 224)
				weight_message = SPAN_INFO("[gender_datum_visible.He] [gender_datum_visible.has] a thick, [weight_heavy_verb] physique.")
			if(225 to 274)
				weight_message = SPAN_INFO("[gender_datum_visible.He] [gender_datum_visible.has] a plush, chubby figure.")
			if(275 to 325)
				weight_message = SPAN_INFO("[gender_datum_visible.He] [gender_datum_visible.has] an especially plump body with a round potbelly and large hips.")
			if(325 to 374)
				weight_message = SPAN_INFO("[gender_datum_visible.He] [gender_datum_visible.has] a very fat frame with a bulging potbelly, and very wide hips.")
			if(375 to 474)
				weight_message = SPAN_WARNING("[gender_datum_visible.He] [gender_datum_visible.is] incredibly obese. [gender_datum_visible.His] massive potbelly sags over [gender_datum_visible.his] waistline while [gender_datum_visible.he] would likely require two chairs to sit down comfortably!")
			else
				weight_message = SPAN_DANGER("[gender_datum_visible.He] [gender_datum_visible.is] so morbidly obese, you wonder how [gender_datum_visible.he] can even stand, let alone waddle around the station.")

		if(weight_mes)
			LAZYADD(output.visible_descriptors, weight_message)
	//! god i hate it

	return output
