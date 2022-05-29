/*
 * Augments. This file contains the base, and organic-targeting augments.
 */

/obj/item/organ/internal/augment
	name = "augment"

	icon_state = "cell_bay"

	robotic = ORGAN_ROBOT
	parent_organ = BP_TORSO

	/// Verbs added by the organ when present in the body.
	organ_verbs = list(/mob/living/carbon/human/proc/augment_menu)
	/// Is the parent supposed to be organic, robotic, assisted?
	target_parent_classes = list()
	/// Will the organ give its verbs when it isn't a perfect match? I.E., assisted in organic, synthetic in organic.
	forgiving_class = FALSE

	butcherable = FALSE

	/// Objects held by the organ, used for re-usable, deployable things.
	var/obj/item/integrated_object
	/// Object type the organ will spawn.
	var/integrated_object_type
	var/target_slot = null

	var/silent_deploy = FALSE

	//* Raidal vars *//
	/// Holder for the augment's image.
	var/image/my_radial_icon = null
	/// DMI for the augment's radial icon.
	var/radial_icon = null
	/// The augment's name in the Radial Menu.
	var/radial_name = null
	/// Icon state for the augment's radial icon.
	var/radial_state = null

	var/aug_cooldown = 30 SECONDS
	var/last_activate = null

/obj/item/organ/internal/augment/Initialize(mapload)
	. = ..()

	setup_radial_icon()

	if(integrated_object_type)
		integrated_object = new integrated_object_type(src)
		integrated_object.canremove = FALSE

/obj/item/organ/internal/augment/proc/setup_radial_icon()
	if(!radial_icon)
		radial_icon = icon
	if(!radial_name)
		radial_name = name
	if(!radial_state)
		radial_state = icon_state
	my_radial_icon = image(icon = radial_icon, icon_state = radial_state)

/obj/item/organ/internal/augment/handle_organ_mod_special(var/removed = FALSE)
	if(removed && integrated_object && integrated_object.loc != src)
		if(isliving(integrated_object.loc))
			var/mob/living/L = integrated_object.loc
			L.drop_from_inventory(integrated_object)
		integrated_object.forceMove(src)
	..(removed)

/obj/item/organ/internal/augment/proc/augment_action()
	if(!owner)
		return

	if(aug_cooldown)
		if(last_activate <= world.time + aug_cooldown)
			last_activate = world.time
		else
			return

	if(robotic && owner.get_restraining_bolt())
		to_chat(owner, SPAN_WARNING("\The [src] doesn't respond."))
		return

	var/item_to_equip = integrated_object
	if(!item_to_equip && integrated_object_type)
		item_to_equip = integrated_object_type

	if(ispath(item_to_equip))
		owner.equip_augment_item(target_slot, item_to_equip, silent_deploy, FALSE)
	else if(item_to_equip)
		owner.equip_augment_item(target_slot, item_to_equip, silent_deploy, FALSE, src)

/*
 * The delicate handling of augment-controlled items.
 */

// Attaches to the end of dropped items' code.

/obj/item
/// Used by augments to determine if the item should destroy itself when dropped, or return to its master.
	var/destroy_on_drop = FALSE
	/// Used to reference the object's host organ.
	var/obj/item/organ/my_augment = null

/obj/item/dropped(mob/user)
	. = ..()
	if(src)
		if(destroy_on_drop && !QDELETED(src))
			qdel(src)
			return
		if(my_augment)
			forceMove(my_augment)

/*
 * Human-specific mob procs.
 */

// The next two procs simply handle the radial menu for augment activation.

/mob/living/carbon/human/proc/augment_menu()
	set name = "Open Augment Menu"
	set desc = "Toggle your augment menu."
	set category = "Augments"

	enable_augments(usr)

/mob/living/carbon/human/proc/enable_augments(var/mob/living/user)
	var/list/options = list()

	var/list/present_augs = list()

	for(var/obj/item/organ/internal/augment/Aug in internal_organs)
		if(Aug.my_radial_icon && !Aug.is_broken() && Aug.check_verb_compatability())
			present_augs[Aug.radial_name] = Aug

	for(var/augname in present_augs)
		var/obj/item/organ/internal/augment/iconsource = present_augs[augname]
		options[augname] = iconsource.my_radial_icon

	var/list/choice = list()
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options)

	if(!isnull(choice) && options[choice])
		var/obj/item/organ/internal/augment/A = present_augs[choice]
		A.augment_action(user)

/* equip_augment_item
 * Used to equip an organ's augment items when possible.
 * slot is the target equip slot, if it's not a generic either-hand deployable,
 * equipping is either the target object, or a path for the target object,
 * destroy_on_drop is the default value for the object to be deleted if it is removed from their person, if equipping is a path, however, this will be set to TRUE,
 * cling_to_organ is a reference to the organ object itself, so they can easily return to their organ when removed by any means.
 */
/mob/living/carbon/human/proc/equip_augment_item(var/slot, var/obj/item/equipping = null, var/make_sound = TRUE, var/destroy_on_drop = FALSE, var/obj/item/organ/cling_to_organ = null)
	if(!ishuman(src))
		return FALSE

	if(!equipping)
		return FALSE

	var/mob/living/carbon/human/M = src

	if(buckled)
		var/obj/Ob = buckled
		if(Ob.buckle_lying)
			to_chat(M, SPAN_NOTICE("You cannot use your augments when restrained."))
			return FALSE

	if((slot == slot_l_hand && l_hand) || (slot == slot_r_hand && r_hand))
		to_chat(M, SPAN_WARNING("Your hand is full.  Drop something first."))
		return FALSE

	var/del_if_failure = destroy_on_drop

	if(ispath(equipping))
		del_if_failure = TRUE
		equipping = new equipping(src)

	if(!slot)
		put_in_any_hand_if_possible(equipping, del_if_failure)

	else
		if(slot_is_accessible(slot, equipping, src))
			equip_to_slot(equipping, slot, 1, 1)
		else if(destroy_on_drop || del_if_failure)
			qdel(equipping)
			return FALSE

	if(cling_to_organ) // Does the object automatically return to the organ?
		equipping.my_augment = cling_to_organ

	if(make_sound)
		playsound(src, 'sound/items/change_jaws.ogg', 30, TRUE)

	if(equipping.loc != src)
		equipping.dropped()

	return TRUE
