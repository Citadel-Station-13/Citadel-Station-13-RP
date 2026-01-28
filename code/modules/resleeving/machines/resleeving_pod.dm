/obj/machinery/resleeving/resleeving_pod
	name = "resleeving pod"
	desc = "Used to combine mind and body into one unit.\n <span class='notice'>\[Accepts Upgrades\]</span>"
	catalogue_data = list(
		/datum/category_item/catalogue/technology/resleeving,
	)
	icon = 'icons/modules/resleeving/machinery/resleeving_pod.dmi'
	icon_state = "resleever"
	#warn resleever-occupied
	circuit = /obj/item/circuitboard/resleeving/resleeving_pod
	density = TRUE
	opacity = FALSE
	anchored = TRUE

	/// held occupant
	var/mob/living/occupant
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
	#warn drop occupant/mirror
	return ..()

/obj/machinery/resleeving/resleeving_pod/drop_products(method, atom/where)
	. = ..()
	#warn drop occupant/mirror

/obj/machinery/resleeving/resleeving_pod/machinery_occupant_pod_exited(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent)
	..()
	update_icon()

/obj/machinery/resleeving/resleeving_pod/machinery_occupant_pod_entered(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent)
	..()
	update_icon()

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
	// never ever allow sleeve-wiping someone
	if(target.mind)
		return FALSE
	var/datum/mind/checking_mind = mirror.recorded_mind?.mind_ref?.resolve()
	// do not allow impersonation
	if(target.resleeving_check_mind_belongs(checking_mind))
		return FALSE

	// human only for the love of god lol even if we technically support living for idfk cryptbiology later on
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/casted_human = target

	#warn impl

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

	mind.active = TRUE
	mind.transfer(target)


	// - LEGACY - //

	// this is legacy because this shouldn't be here
	update_antag_icons(target.mind)
	// this is because vore is fucking weird
	target.apply_vore_prefs()

	// - END - //
