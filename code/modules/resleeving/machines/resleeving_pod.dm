/obj/machinery/resleeving/resleeving_pod
	name = "resleeving pod"
	desc = "Used to combine mind and body into one unit.\n <span class='notice'>\[Accepts Upgrades\]</span>"
	catalogue_data = list(
		/datum/category_item/catalogue/technology/resleeving,
	)
	icon = 'icons/modules/resleeving/machinery/resleeving_pod.dmi'
	icon_state = "resleever"
	base_icon_state = "resleever"
	circuit = /obj/item/circuitboard/resleeving/resleeving_pod
	density = TRUE
	opacity = FALSE
	anchored = TRUE

	/// held mirror
	/// * is what's inserted into a mob to sleeve the person back in
	var/obj/item/organ/internal/mirror/held_mirror

	var/c_blur_time = 20 SECONDS
	var/c_confuse_time = 20 SECONDS

/obj/machinery/resleeving/resleeving_pod/Initialize(mapload)
	. = ..()
	update_icon()
	init_occupant_pod_default_openable()

/obj/machinery/resleeving/resleeving_pod/Destroy()
	if(held_mirror)
		remove_mirror(drop_location())
	return ..()

/obj/machinery/resleeving/resleeving_pod/Exited(atom/movable/AM, atom/newLoc)
	..()
	if(AM == held_mirror)
		held_mirror = null

/obj/machinery/resleeving/resleeving_pod/drop_products(method, atom/where)
	. = ..()
	if(held_mirror)
		remove_mirror(where)

/obj/machinery/resleeving/resleeving_pod/machinery_occupant_pod_exited(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent)
	..()
	update_icon()

/obj/machinery/resleeving/resleeving_pod/machinery_occupant_pod_entered(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent)
	..()
	update_icon()

/obj/machinery/resleeving/resleeving_pod/update_icon(updates)
	. = ..()
	icon_state = "[base_icon_state][machine_occupant_pod?.occupant ? "-occupied" : ""]"

/obj/machinery/resleeving/resleeving_pod/examine(mob/user, dist)
	. = ..()
	if(held_mirror)
		. += SPAN_NOTICE("It seems to have a mirror held in its receptacle.")

/obj/machinery/resleeving/resleeving_pod/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	.["remove-mirror"] = create_context_menu_tuple("remove mirror", image(src), 1, MOBILITY_CAN_USE, FALSE)

/obj/machinery/resleeving/resleeving_pod/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("remove-mirror")
			if(!e_args.check_performer_reachability(src))
				return TRUE
			user_remove_mirror(e_args, TRUE)
			return TRUE

/obj/machinery/resleeving/resleeving_pod/proc/user_insert_mirror(datum/event_args/actor/actor, obj/item/organ/internal/mirror/mirror, silent, suppressed)
	if(held_mirror)
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("There's already a mirror in [src]."),
				target = src,
			)
		return FALSE
	if(!insert_mirror(mirror, actor, silent))
		return FALSE
	if(!suppressed)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = SPAN_NOTICE("[actor.performer] inserts [mirror] into [src]."),
		)
	return TRUE

/obj/machinery/resleeving/resleeving_pod/proc/user_remove_mirror(datum/event_args/actor/actor, put_in_hands, silent, suppressed)
	var/obj/item/organ/internal/mirror/removed = remove_mirror(src, actor, silent)
	if(!removed)
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("There's no mirror in [src]."),
				target = src,
			)
		return FALSE
	if(put_in_hands)
		actor.performer.put_in_hands_or_drop(removed)
	else
		removed.forceMove(drop_location())
	if(!suppressed)
		actor.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = SPAN_WARNING("[actor.performer] removes [removed] from [src]."),
		)
	return TRUE

/**
 * @return TRUE/FALSE
 */
/obj/machinery/resleeving/resleeving_pod/proc/insert_mirror(obj/item/organ/internal/mirror/mirror, datum/event_args/actor/actor, silent)
	if(held_mirror)
		return FALSE
	held_mirror = mirror
	return TRUE

/**
 * @return mirror or null
 */
/obj/machinery/resleeving/resleeving_pod/proc/remove_mirror(atom/new_loc, datum/event_args/actor/actor, silent) as /obj/item/organ/internal/mirror
	if(!held_mirror)
		return
	. = held_mirror
	held_mirror = null

/obj/machinery/resleeving/resleeving_pod/proc/perform_resleeve(mob/living/target, obj/item/organ/internal/mirror/mirror)
	// human only for the love of god lol even if we technically support living for idfk cryptbiology later on
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/casted_human = target
	if(!mirror?.recorded_mind?.mind_ref)
		return FALSE
	// never ever allow sleeve-wiping someone
	if(target.mind)
		send_audible_system_message("Occupant has another consciousness.")
		return FALSE
	var/datum/resleeving_mind_backup/using_backup = mirror.recorded_mind
	var/datum/mind/using_mind = using_backup.mind_ref?.resolve()
	if(!checking_mind)
		return FALSE
	// do not allow impersonation
	if(target.resleeving_check_mind_belongs(checking_mind))
		return FALSE
	// -- POINT OF NO RETURN AFTER THIS CALL --
	if(!perform_mind_insertion_impl(target, using_mind))
		return FALSE
	if(!perform_backup_insertion_impl(target, using_backup))
		STACK_TRACE("Failed to perform backup insertion after mind insertion call.")

	var/obj/item/organ/internal/mirror/old_mirror = casted_human.resleeving_remove_mirror(src)
	casted_human.resleeving_insert_mirror(mirror)
	if(old_mirror)
		if(held_mirror)
			old_mirror.forceMove(drop_location())
		else
			insert_mirror(old_mirror)

	// TODO: if they're not connected / whatnot can we hold onto this?
	casted_human.Confuse(c_confuse_time / (2 SECONDS))
	casted_human.eye_blurry = c_blur_time / (2 SECONDS)
	var/message = SPAN_NOTICE({"
		You feel a small pain in your back as you're given a new mirror implant. \
		Oh, and a new body. The last moments of your past life cut away cleanly to \
		your eyes opening in this new sleeve, lingering at the forefront of your memory. \
		Your brain will struggle for some time to relearn its control pathways, \
		and your body feels <i>foreign</i>, somehow.\
	"})
	to_chat(target, message)

	// TODO: variable sound
	playsound(src, 'sound/machines/medbayscanner1.ogg', 75, TRUE)

/obj/machinery/resleeving/resleeving_pod/proc/perform_backup_insertion_impl(mob/living/target, datum/resleeving_mind_backup/backup)
	// human only for the love of god lol even if we technically support living for idfk cryptbiology later on
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/casted_human = target
	casted_human.identifying_gender = backup.legacy_identifying_gender

	for(var/langauge_id in backup.legacy_language_ids)
		var/datum/prototype/language/resolved_language = RSlanguages.fetch_local_or_throw(langauge_id)
		casted_human.add_language(resolved_language.name)

	return TRUE

/obj/machinery/resleeving/resleeving_pod/proc/perform_mind_insertion_impl(mob/living/target, datum/mind/mind)
	log_game("Resleeving pod at [COORD(src)] called by [key_name(usr)] (or unmanned if no key) inserted mind [mind.name] into [key_name(target)] ([REF(target)]).")
	mind.active = TRUE
	mind.transfer(target)

	// - LEGACY - //

	// this is legacy because this shouldn't be here
	update_antag_icons(target.mind)
	// this is because vore is fucking weird
	target.apply_vore_prefs()

	// - END - //
