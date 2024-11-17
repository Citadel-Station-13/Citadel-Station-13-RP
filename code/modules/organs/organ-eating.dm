/**
 * yeah uh don't shoot the messenger i don't know why this file is here
 *
 * we should probably rework this or something at some point
 */

/obj/item/organ/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	// Convert it to an edible form, yum yum.
	if(!(robotic >= ORGAN_ROBOT) && user.a_intent == INTENT_HELP && user.zone_sel.selecting == O_MOUTH)
		bitten(user)
		return

/obj/item/organ/proc/bitten(mob/user)

	if(robotic >= ORGAN_ROBOT)
		return

	to_chat(user, SPAN_NOTICE("You take an experimental bite out of \the [src]."))
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
	blood_splatter(src,B,1)

	user.temporarily_remove_from_inventory(src, INV_OP_FORCE)

	var/obj/item/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.icon = icon
	O.icon_state = icon_state

	// Pass over the blood.
	reagents.trans_to(O, reagents.total_volume)

	if(fingerprints)
		O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden)
		O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast)
		O.fingerprintslast = fingerprintslast

	user.put_in_active_hand(O)
	qdel(src)
