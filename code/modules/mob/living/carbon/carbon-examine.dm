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

	var/list/tagged_organs_or_missing_descriptors = list()
	var/list/obj/item/organ/external/additional_organs = list()

	for(var/external_organ_tag in species.has_limbs)
		var/list/external_organ_data = species.has_limbs[external_organ_tag]
		tagged_organs_or_missing_descriptors[external_organ_tag] = external_organ_data["descriptor"]

	for(var/obj/item/organ/external/external_organ in organs)

	for(var/external_organ_tag in tagged_organs_or_missing_descriptors)
		var/obj/item/organ/external/organ_or_descriptor = tagged_organs_or_missing_descriptors[external_organ_tag]

	for(var/obj/item/organ/external/extra_organ in additional_organs)

	if(pose)
		LAZYADD(output.visible_descriptors, SPAN_INFO("[gender_datum_visible.He] [pose]"))

	var/effective_hud_name = name
	var/obj/item/in_id_slot = inventory.get_slot_single(/datum/inventory_slot/inventory/id::id)
	if(istype(maybe_id, /obj/item/card/id))
		var/obj/item/card/id/casted_id = in_id_slot
		effective_hud_name = casted_id.registered_name
	else if(istype(maybe_id, /obj/item/pda))
		var/obj/item/pda/casted_pda = in_id_slot
		effective_hud_name = casted_pda.owner

	if(hasHUD(examine.seer, "medical"))
		var/medical_status = "None"
		for(var/datum/data/record/record in data_core.medical)
			if(record.fields["name"] != effective_hud_name)
				continue
			security_status = record.fields["p_stat"]
		LAZYADD(output.analysis_descriptors, "Physical status: <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>")
		LAZYADD(output.analysis_descriptors, "Medical records: <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>")

	if(hasHUD(examine.seer, "security"))
		var/security_status = "None"
		for(var/datum/data/record/record in data_core.security)
			if(record.fields["name"] != effective_hud_name)
				continue
			security_status = record.fields["criminal"]
		LAZYADD(output.analysis_descriptors, "Criminal status: <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>")
		LAZYADD(output.analysis_descriptors, "Security records: <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>")

	if(hasHUD(examiner.seer, "best"))
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
				weight_message = SPAN_WARNING("[T.He] [T.is] terribly lithe and frail!")
			if(75 to 99)
				weight_message = SPAN_INFO("[T.He] [T.has] a very slender frame.")
			if(100 to 124)
				weight_message = SPAN_INFO("[T.He] [T.has] a lightweight, athletic build.")
			if(125 to 174)
				weight_message = SPAN_INFO("[T.He] [T.has] a healthy, average body.")
			if(175 to 224)
				weight_message = SPAN_INFO("[T.He] [T.has] a thick, [weight_heavy_verb] physique.")
			if(225 to 274)
				weight_message = SPAN_INFO("[T.He] [T.has] a plush, chubby figure.")
			if(275 to 325)
				weight_message = SPAN_INFO("[T.He] [T.has] an especially plump body with a round potbelly and large hips.")
			if(325 to 374)
				weight_message = SPAN_INFO("[T.He] [T.has] a very fat frame with a bulging potbelly, and very wide hips.")
			if(375 to 474)
				weight_message = SPAN_WARNING("[T.He] [T.is] incredibly obese. [T.His] massive potbelly sags over [T.his] waistline while [T.he] would likely require two chairs to sit down comfortably!")
			else
				weight_message = SPAN_DANGER("[T.He] [T.is] so morbidly obese, you wonder how [T.he] can even stand, let alone waddle around the station.")

		if(weight_mes)
			LAZYADD(output.visible_descriptors, weight_message)
	//! god i hate it

	return output
