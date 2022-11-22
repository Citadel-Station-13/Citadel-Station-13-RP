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
	var/eyes_color
	/// external limbs - BP_<TAG> to list(company: company name, color: color override); set to null instead for organic limb
	var/list/external_robolimbs

/datum/shapeshift/human/apply_to_mob(mob/living/carbon/human/applying, capabilities)
	. = ..()

/datum/shapeshift/human/copy_from_mob(mob/living/carbon/human/template, capabilities)
	. = ..()

/datum/shapeshift/clone()
	var/datum/shapeshift/human/cloned = ..()

#warn impl
