/obj/item/plunger
	name = "plunger"
	desc = "It's a plunger, for plunging."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "plunger"
	slot_flags = SLOT_MASK
	var/plunge_mod = 1 //time*plunge_mod = total time we take to plunge an object
	var/reinforced = FALSE //whether we do heavy duty stuff like geysers

// /obj/item/plunger/pre_attack(atom/target, mob/user, clickchain_flags, list/params)
// 	if(!isobj(target))
// 		return ..()
// 	var/obj/O = target
// 	if(O.plunger_act(src, user, reinforced))
// 		return CLICKCHAIN_DO_NOT_PROPAGATE
// 	return ..()

/obj/item/plunger/throw_impact(atom/hit_atom, mob/living/carbon/human/target, target_zone)
	. = ..()
	if(target_zone != BP_HEAD)
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/H = hit_atom
		if(!H.wear_mask)
			H.equip_to_slot_if_possible(src, SLOT_MASK, INV_OP_SUPPRESS_WARNING)
			H.visible_message("<span class='warning'>The plunger slams into [H]'s face!</span>", "<span class='warning'>The plunger suctions to your face!</span>")

/obj/item/plunger/reinforced
	name = "reinforced plunger"
	desc = "It's an Mk7 Reinforced Plunger, for heavy duty plunging."
	icon_state = "reinforced_plunger"

	reinforced = TRUE
	plunge_mod = 0.8
