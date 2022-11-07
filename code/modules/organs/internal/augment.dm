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

	var/aug_cooldown = 0 SECONDS
	var/last_activate = null

/obj/item/organ/internal/augment/Initialize(mapload)
	. = ..()
	setup_radial_icon()
	if(integrated_object_type)
		set_item(integrated_object_type)

/obj/item/organ/internal/augment/proc/set_item(obj/item/item_or_type)
	if(ispath(item_or_type))
		item_or_type = new item_or_type
	register_item(item_or_type)

/obj/item/organ/internal/augment/proc/register_item(obj/item/I)
	if(!I)
		return
	if(integrated_object)
		unregister_item(integrated_object)
	RegisterSignal(I, COMSIG_MOVABLE_MOVED, .proc/on_item_moved)
	RegisterSignal(I, COMSIG_ITEM_DROPPED, .proc/on_item_dropped)
	if(I.loc != src)
		I.forceMove(src)
	integrated_object = I

/obj/item/organ/internal/augment/proc/unregister_item(obj/item/I)
	UnregisterSignal(I, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_ITEM_DROPPED
	))
	if(I == integrated_object)
		integrated_object = null

/obj/item/organ/internal/augment/proc/on_item_moved(datum/source, atom/old)
	SIGNAL_HANDLER

	// gives a chance for dropped to fire
	addtimer(CALLBACK(src, .proc/check_item_yank, source), 0)

/obj/item/organ/internal/augment/proc/on_item_dropped(datum/source)
	SIGNAL_HANDLER

	var/obj/item/I = source
	I.visible_message(SPAN_NOTICE("[I] snaps back into [src]!"))
	I.forceMove(src)
	. = COMPONENT_ITEM_DROPPED_RELOCATE | COMPONENT_ITEM_DROPPED_SUPPRESS_SOUND

/obj/item/organ/internal/augment/proc/check_item_yank(obj/item/I)
	if(I.loc != src && I.loc != owner)
		unregister_item(I)

// todo: multi-item
/*
/obj/item/organ/cyberimp/arm/proc/add_item(obj/item/I)
	if(I in items_list)
		return
	I.forceMove(src)
	items_list += I
	// ayy only dropped signal for performance, we can't possibly have shitcode that doesn't call it when removing items from a mob, right?
	// .. right??!
	RegisterSignal(I, COMSIG_ITEM_DROPPED, .proc/magnetic_catch)

/obj/item/organ/cyberimp/arm/proc/magnetic_catch(datum/source, mob/user)
	. = COMPONENT_DROPPED_RELOCATION
	var/obj/item/I = source			//if someone is misusing the signal, just runtime
	if(I in items_list)
		if(I in contents)		//already in us somehow? i probably shouldn't catch this so it's easier to spot bugs but eh..
			return
		I.visible_message("<span class='notice'>[I] snaps back into [src]!</span>")
		I.forceMove(src)
		if(I == holder)
			holder = nul
*/

/obj/item/organ/internal/augment/Destroy()
	if(integrated_object)
		QDEL_NULL(integrated_object)
	return ..()

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

	//! todo: re fucking factor.

	if(owner.is_in_inventory(integrated_object))
		// retracting
		integrated_object.forceMove(src)
		owner.visible_message(SPAN_NOTICE("[integrated_object] snaps back into [src]."))
		return

	// extending
	if(ispath(integrated_object))
		owner.equip_augment_item(target_slot, integrated_object, silent_deploy, FALSE)
	else if(integrated_object)
		owner.equip_augment_item(target_slot, integrated_object, silent_deploy, FALSE, src)

/*
 * Human-specific mob procs.
 */

// The next two procs simply handle the radial menu for augment activation.

/mob/living/carbon/human/proc/augment_menu()
	set name = "Open Augment Menu"
	set desc = "Toggle your augment menu."
	set category = "Augments"

	enable_augments(usr)

/mob/living/carbon/human/proc/enable_augments(mob/living/L)
	var/list/options = list()

	var/list/present_augs = list()

	for(var/obj/item/organ/internal/augment/Aug in organs)
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
		choice = show_radial_menu(L, src, options)

	if(!isnull(choice) && options[choice])
		var/obj/item/organ/internal/augment/A = present_augs[choice]
		A.augment_action(L)

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
		if(Ob.buckle_lying(src))
			to_chat(M, SPAN_NOTICE("You cannot use your augments when restrained."))
			return FALSE

	if((slot == /datum/inventory_slot_meta/abstract/hand/left && l_hand) || (slot == /datum/inventory_slot_meta/abstract/hand/right && r_hand))
		to_chat(M, SPAN_WARNING("Your hand is full.  Drop something first."))
		return FALSE

	var/del_if_failure = destroy_on_drop

	if(ispath(equipping))
		del_if_failure = TRUE
		equipping = new equipping(src)

	if(!slot)
		if(!put_in_hands(equipping) && del_if_failure)
			qdel(equipping)

	else
		if(!equip_to_slot_if_possible(equipping, slot, INV_OP_FLUFFLESS))
			if(destroy_on_drop || del_if_failure)
				qdel(equipping)
			return FALSE

	if(make_sound)
		playsound(src, 'sound/items/change_jaws.ogg', 30, TRUE)

	return TRUE
