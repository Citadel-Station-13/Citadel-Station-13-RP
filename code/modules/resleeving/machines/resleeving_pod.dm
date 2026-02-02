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
	init_occupant_pod_openable()

/obj/machinery/resleeving/resleeving_pod/Destroy()
	if(held_mirror)
		remove_mirror(drop_location())
	return ..()

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

/**
 * @return TRUE/FALSE
 */
/obj/machinery/resleeving/resleeving_pod/proc/insert_mirror(obj/item/organ/internal/mirror/mirror, datum/event_args/actor/actor, silent)
	#warn impl

/**
 * @return TRUE/FALSE
 */
/obj/machinery/resleeving/resleeving_pod/proc/remove_mirror(atom/new_loc, datum/event_args/actor/actor, silent)
	#warn impl

/obj/machinery/resleeving/resleeving_pod/proc/perform_resleeve(mob/living/target, obj/item/organ/internal/mirror/mirror)
	if(!mirror?.recorded_mind?.mind_ref)
		return FALSE
	// never ever allow sleeve-wiping someone
	if(target.mind)
		return FALSE
	var/datum/mind/checking_mind = mirror.recorded_mind.mind_ref?.resolve()
	if(!checking_mind)
		return FALSE
	// do not allow impersonation
	if(target.resleeving_check_mind_belongs(checking_mind))
		return FALSE

	// human only for the love of god lol even if we technically support living for idfk cryptbiology later on
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/casted_human = target

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
	#warn impl

	for(var/langauge_id in backup.legacy_language_ids)
		var/datum/prototype/language/resolved_language = RSlanguages.fetch_local_or_throw(langauge_id)
		casted_human.add_language(resolved_language.name)

	return TRUE

/obj/machinery/resleeving/resleeving_pod/proc/perform_mind_insertion_impl(mob/living/target, datum/mind/mind)
	#warn logging

	mind.active = TRUE
	mind.transfer(target)

	// - LEGACY - //

	// this is legacy because this shouldn't be here
	update_antag_icons(target.mind)
	// this is because vore is fucking weird
	target.apply_vore_prefs()

	// - END - //
