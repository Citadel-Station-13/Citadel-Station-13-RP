//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/// id = datum lookup for /datum/bodyset
/// initialized by SSearly_init
GLOBAL_LIST_EMPTY(bodyset_lookup)
/proc/init_bodyset_lookup()
	GLOB.bodyset_lookup = . = list()
	for(var/datum/bodyset/path as anything in subtypesof(/datum/bodyset))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/bodyset/instance = new path
		if(.[instance.id])
			stack_trace("collision between [path] and [.[instance.id]:type]")
			continue
		.[instance.id] = instance

/**
 * Descriptor / metadata about a set of carbon/mob body sprites.
 *
 * * This, for the most part, does not mechanically enforce anything. It doesn't determine organs or anything like that.
 */
/datum/bodyset
	abstract_type = /datum/bodyset

	/// id - **must** be unique
	var/id
	/// name - should be unique
	var/name
	/// base id; if set, we use that for checking for markings and whatnot.
	/// used so you can choose between a set of similar-enough bodysets that it's still considered the same
	var/base_id
	/// icon file
	///
	/// * should have a list of "[icon_state && "[icon_state]-"][bp_tag]" states
	var/icon
	/// icon state prepend
	var/state_prepend
	/// bodyparts included
	var/list/body_parts = list(
		BP_HEAD,
		BP_TORSO,
		BP_GROIN,
		BP_L_ARM,
		BP_L_HAND,
		BP_R_ARM,
		BP_R_HAND,
		BP_L_LEG,
		BP_L_FOOT,
		BP_R_LEG,
		BP_R_FOOT,
	)
	/// which bodyparts are gendered
	var/list/gendered_parts = list()
	/// specific layers for bodyparts having multiple states / overlays.
	/// used for stuff like legs having front-behind
	/// the state (e.g. "front") will be appended after everything else
	/// as an example: "unathi-l_leg-digi-m-front" (append, part, variation, gender, front)
	///
	/// format:
	/// list(
	/// 	BP_L_LEG = list(
	/// 		"front" = HUMAN_BODYLAYER_FRONT,
	/// 		"behind" = HUMAN_BODYLAYER_BEHIND,
	/// 	),
	/// 	BP_R_LEG = list(
	/// 		"front" = HUMAN_BODYLAYER_FRONT,
	/// 		"behind" = HUMAN_BODYLAYER_BEHIND,
	/// 	),
	/// )
	var/list/layered_parts = list()
	/// overridden by [layered_parts]
	/// automatically slice these bodyparts
	/// use "ALL" for 'rest of dirs',
	/// use TEXT_[DIR] macros otherwise.
	///
	/// by default, we autoslice legs and feet.
	///
	/// format:
	/// list(
	/// 	BP_L_LEG = list(TEXT_EAST = HUMAN_BODYLAYER_BEHIND, "ALL" = HUMAN_BODYLAYER_FRONT),
	/// 	BP_R_LEG = list(TEXT_WEST = HUMAN_BODYLAYER_BEHIND, "ALL" = HUMAN_BODYLAYER_FRONT),
	/// )
	var/list/autoslice_parts = list(
		BP_L_LEG = list(TEXT_EAST = HUMAN_BODYLAYER_BEHIND, "ALL" = HUMAN_BODYLAYER_FRONT),
		BP_R_LEG = list(TEXT_WEST = HUMAN_BODYLAYER_BEHIND, "ALL" = HUMAN_BODYLAYER_FRONT),
		BP_L_FOOT = list(TEXT_EAST = HUMAN_BODYLAYER_BEHIND, "ALL" = HUMAN_BODYLAYER_FRONT),
		BP_R_FOOT = list(TEXT_WEST = HUMAN_BODYLAYER_BEHIND, "ALL" = HUMAN_BODYLAYER_FRONT),
	)
	/// autosliced icons by "[zone][-variation][-gender]"
	/// autosliced icons will not have [state_prepend], or state_append on variations, or even the variation whatsoever
	/// they'll just be "[zone][-gender]"
	var/list/autoslice_cache = list()
	/// are we meant to be a greyscale set? if set to TRUE, we'll be colored as such
	///
	/// * Please greyscale your bodysets where-ever possible.
	/// * DO NOT RELY ON DEFAULTING THIS VALUE. You must set it explicitly, or the behavior is undefined.
	var/greyscale
	/// valid variations; list("string_id" = /datum/bodyset_variation{use anonymous types!})
	///
	/// * variations inherit autoslice behaviors.
	var/list/variations
	/// valid overlays; list("string_id" = /datum/bodyset_overlay{use anonymous types!})
	var/list/overlays

	/// our preview icon; defaults to [icon]
	var/preview_icon
	/// our preview icon state; defaults to null, for automatic generation of preview.
	var/preview_icon_state

	/// mask icon; defaults to [icon]
	///
	/// * states in here should just be "[icon_state && "[icon_state]-"][bp_tag]"
	/// * used for [damage_overlay_use_masking]
	var/mask_icon
	/// mask icon state prepend; defaults to "mask"
	///
	/// * used for [damage_overlay_use_masking]
	var/mask_icon_state

	/// damage overlay - masking system? in this system, we'll use the "[brutestage][burnstage]" with a mask applied to it to determine limb graphics
	var/damage_overlay_use_masking
	/// damage overlay icon; defaults to [icon]
	var/damage_overlay_icon
	/// damage overlay icon state prepend; defaults to "damage"
	var/damage_overlay_icon_state
	/// max brute stages
	var/damage_overlay_brute_stages
	/// max burn stages
	var/damage_overlay_burn_stages

/datum/bodyset/New()
	if(isnull(src.base_id))
		src.base_id = src.id

/**
 * please handle the returned lists properly
 *
 * @return list(list(normal overlays), list(emissive overlays))
 */
/datum/bodyset/proc/render(bodypart_tag, list/datum/bodyset_marking_descriptor/marking_descriptors, obj/item/organ/external/for_bodypart)
	var/list/normal = list()
	var/list/emissive = list()

	. = list(normal, emissive)

	if(!(bodypart_tag in body_parts))
		return

	var/gendered = bodypart_tag in gendered_parts

	#warn autoslicing

#warn impl all

//* Subtypes for builtin sprite accessories used in bodysets             *//
//* These should not be used for anything other than bodyset defaulting. *//

/datum/sprite_accessory/hair/bodyset
	abstract_type = /datum/sprite_accessory/hair/bodyset
	selectable = FALSE

/datum/sprite_accessory/facial_hair/bodyset
	abstract_type = /datum/sprite_accessory/facial_hair/bodyset
	selectable = FALSE

/datum/sprite_accessory/ears/bodyset
	abstract_type = /datum/sprite_accessory/ears/bodyset
	selectable = FALSE

/datum/sprite_accessory/tail/bodyset
	abstract_type = /datum/sprite_accessory/tail/bodyset
	selectable = FALSE

/datum/sprite_accessory/wing/bodyset
	abstract_type = /datum/sprite_accessory/wing/bodyset
	selectable = FALSE
