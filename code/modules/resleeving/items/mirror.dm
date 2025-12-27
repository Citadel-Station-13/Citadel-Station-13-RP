/**
 * Mirrors. These are a bit weird; they're supposed to be what holds people's
 * minds, ICly, if they die, as to allow them to have a mostly-continuous resurrection if
 * their brain is destroyed.
 *
 * Code-wise, this is a fucking nightmare. Oh boy.
 */
/obj/item/organ/internal/mirror
	name = "mirror"
	desc = "A small, implanted disk that stores a copy of one's consciousness."
	catalogue_data = /datum/category_item/catalogue/technology/resleeving
	icon = 'icons/obj/mirror.dmi'
	icon_state = "mirror_implant_f"
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	var/stored_mind = null
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	organ_tag = ORGAN_TAG_MIRROR
	parent_organ = BP_TORSO

	/// The 'real mind' of.. us.
	/// * Cannot be erased without admin intervention; usually set on implant.
	/// * This ensures you cannot overwrite a mirror by putting it in someone else.
	var/datum/mind_ref/owner_mind_ref

	var/datum/resleeving_body_backup/recorded_body
	var/datum/resleeving_mind_backup/recorded_mind

/obj/item/organ/internal/mirror/replaced(mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()

/obj/item/organ/internal/mirror/removed(mob/living/user, ignore_vital)
	. = ..()

/obj/item/organ/internal/mirror/update_icon_state()
	if(owner_mind_ref && recorded_body && recorded_mind)
		icon_state = "mirror_implant"
	else
		icon_state = "mirror_implant_f"
	return ..()

#warn backup shit

/obj/item/organ/internal/mirror/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	var/obj/machinery/computer/resleeving/comp = target
	if (!istype(comp))
		return
	comp.active_mr = stored_mind

/obj/item/organ/internal/mirror/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mirrorscanner))
		if(backed_up == null)
			to_chat(usr, "No consciousness found.")
		else
			to_chat(usr, "This mirror contains a consciousness.")
	else
		if(istype(I, /obj/item/mirrortool))
			var/obj/item/mirrortool/MT = I
			if(MT.imp)
				to_chat(usr, "The mirror tool already contains a mirror.")
				return // It's full.
			#warn make sure this owrks for borgs
			if(loc == user)			// we assume they can't click someone else's hand items lmao
				if(!user.attempt_insert_item_for_installation(src, MT))
					return
			else
				forceMove(MT)
			MT.imp = src
			MT.update_icon()
