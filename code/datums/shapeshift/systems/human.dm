/datum/shapeshift_system/human

#warn impl

/datum/shapeshift/human
	template_name = "ShapeshiftTemplateHuman"
	shapeshift_type = /datum/shapeshift/human
	/// hair
	var/datum/sprite_accessory_data/hair
	/// facial hair
	var/datum/sprite_accessory_data/facial_hair
	/// ears
	var/datum/sprite_accessory_data/ears_1
	/// ears
	var/datum/sprite_accessory_data/ears_2
	/// tail
	var/datum/sprite_accessory_data/tail
	/// wings
	var/datum/sprite_accessory_data/wings
	/// body markings
	var/list/datum/sprite_accessory_data/markings
	/// body color
	var/body_color
	/// eyes color
	var/eye_color
	/// external limbs - BP_<TAG> to list(company: company name, color: color override); set to null instead for organic limb
	var/list/robolimbs
	/// species id
	var/species_id
	/// custom species name
	var/species_name

/datum/shapeshift/human/apply_to_mob(mob/living/carbon/human/applying, capabilities)
	. = ..()

/datum/shapeshift/human/copy_from_mob(mob/living/carbon/human/template, capabilities)
	. = ..()

/datum/shapeshift/human/clone()
	var/datum/shapeshift/human/cloned = ..()

/datum/shapeshift/human/ui_data()
	var/list/data = ..()
	data["hair"] = hair?.ui_data()
	data["facial_hair"] = facial_hair?.ui_data()
	data["ears_1"] = ears_1?.ui_data()
	data["ears_2"] = ears_2?.ui_data()
	data["tail"] = tail?.ui_data()
	data["wings"] = wings?.ui_data()
	var/list/markings_built = list()
	for(var/datum/sprite_accessory_data/marking_data in markings)
		markings_built += marking_data.ui_data()
	data["markings"] = markings_built
	data["body_color"] = body_color
	data["eye_color"] = eye_color
	data["robolimbs"] = robolimbs
	data["species_id"] = species_id
	data["species_name"] = species_name

// todo: json de/serialize
