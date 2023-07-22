//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Get - Names

/**
 * get visible name used for examine
 *
 * * this takes into account obfuscation from clothing.
 * * this will render our face identifier if it can be seen.
 *
 * @params
 * * recognizing - if specified, we get name from recognition perspective of this mob
 * * dist - override distance of seeing mob
 */
/mob/proc/get_visible_name(mob/recognizing, dist)
	if(isnull(dist))
		dist = isnull(recognizing)? get_dist(src, recognizing) : 0
	var/face_name = is_face_obscured(recognizing, dist)? "Unknown" : face_name = get_face_name(recognizing, dist)
	var/id_name = get_id_name(recognizing, dist)
	if(face_name == id_name)
		return face_name
	#warn impl - discriminator hoverover tooltip? SPAN_TOOLTIP(tip, str)

/**
 * get face name
 *
 * @params
 * * recognizing - if specified, we get name from recognition perspective of this mob
 * * dist - override distance of seeing mob
 */
/mob/proc/get_face_name(mob/recognizing, dist)
	if(isnull(dist))
		dist = isnull(recognizing)? get_dist(src, recognizing) : 0
	// check disfigurement
	// todo: different species might not have a head for recognition?
	var/obj/item/organ/external/head_organ = get_organ(BP_HEAD)
	if(isnull(head_organ) || head_organ.disfigured || head_organ.is_stump())
		return "Unknown"
	if(MUTATION_HUSK in mutations)
		return "Unknown"
	// if there's a recognizing mob, use their procs to identify us
	if(!isnull(recognition) && !isnull(recognizing?.identity))
		return recognizing.recognize_face(src)
	return real_name || "Unknown"

/**
 * get name we're recognized as from our ID
 * this usually depends on distance
 *
 * @params
 * * recognizing - if specified, we get name from recognition perspective of this mob
 * * dist - override distance of seeing mob
 */
/mob/proc/get_id_name(mob/recognizing, dist)
	if(isnull(dist))
		dist = isnull(recognizing)? get_dist(src, recognizing) : 0
	. = "Unknown"
	// todo: modifiers? sight?
	if(dist > 2)
		return
	var/obj/item/card/id/used = get_idcard()
	if(!isnull(used))
		. = used.registered_name

//* Check - Obscure

/**
 * check if our face is obscured
 *
 * @params
 * * recognizing - if specified, we get name from recognition perspective of this mob
 * * dist - override distance of seeing mob
 */
/mob/proc/is_face_obscured()
	var/obj/item/checking
	// todo: proper cached hide flags on /datum/inventory
	checking = item_by_slot(SLOT_ID_MASK)
	if(checking.inv_hide_flags & HIDEFACE)
		return TRUE
	checking = item_by_slot(SLOT_ID_HEAD)
	if(checking.inv_hide_flags & HIDEFACE)
		return TRUE
	return FALSE
