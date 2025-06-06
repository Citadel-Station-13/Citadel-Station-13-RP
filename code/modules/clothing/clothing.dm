/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	drop_sound = 'sound/items/drop/clothing.ogg'
// todo: this is an awful way to do it but it works
	unequip_sound = 'sound/items/drop/clothing.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	item_flags = NONE

	//? equip
	/// Inventory slot IDs where this is active for any effects. Used by subtypes, to be potentially refactored in the future.
	var/list/active_slots

	//? legacy

	var/list/species_restricted = null //Only these species can wear this kit.
	var/gunshot_residue //Used by forensics.

	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/list/starting_accessories

	var/flash_protection = FLASH_PROTECTION_NONE
	var/tint = TINT_NONE
	// todo: probably refactor these two
	var/list/enables_planes		//Enables these planes in the wearing mob's plane_holder

	// todo: kill this stupid shit lmao
	/*
		Sprites used when the clothing item is refit. This is done by setting icon_override.
		For best results, if this is set then sprite_sheets should be null and vice versa, but that is by no means necessary.
		Ideally, sprite_sheets_refit should be used for "hard" clothing items that can't change shape very well to fit the wearer (e.g. helmets, hardsuits),
		while sprite_sheets should be used for "flexible" clothing items that do not need to be refitted (e.g. aliens wearing jumpsuits).
	*/
	var/list/sprite_sheets_refit = null
	var/ear_protection = 0
	var/blood_sprite_state

	var/recent_struggle = 0

	/// is considered wizard garb?
	var/wizard_garb = FALSE

	//? accessory system - used as accessory
	/// are we an accessory?
	var/is_accessory = FALSE
	/// accessory render as _acc slot key instead of obeying worn render.
	/// accessories will use one for all if flagged as such, otherwise they'll inherit the real slot of where they are.
	var/accessory_render_specific = FALSE
	/// use legacy system - only works for /obj/item/clothing/accessory.
	var/accessory_render_legacy = FALSE
	/// FALSE for no render at all when accessory - /obj/item has this by default as it doesn't have clothing procs.
	var/accessory_renders = TRUE
	/// what we're attached to if we're an accessory
	var/obj/item/clothing/accessory_host
	/// what state we render as for the inventory overlay, *not* worn overlay. defaults to icon_state.
	var/accessory_inv_state
	/// currently cached inv state
	var/mutable_appearance/accessory_inv_cached

	//? accessory system - attached to by accessories
	/// full list of accessories, everything inside must be an /obj/item/clothing.
	var/list/accessories

	//* Clothing *//
	/// Don't automatically have someone yank us off on attack hand if this is FALSE
	var/attack_hand_auto_unequip = TRUE

	//* Carry Weight
	/// encumbrance compensation for accessories - flat.
	var/accessory_encumbrance_mitigation = 0
	/// encumbrance multiplier for accessories.
	var/accessory_encumbrance_multiply = 1

/obj/item/clothing/Initialize(mapload)
	. = ..()
	if(islist(active_slots))
		active_slots = typelist(NAMEOF(src, active_slots), active_slots)
	if(starting_accessories)
		for(var/T in starting_accessories)
			var/obj/item/clothing/accessory/tie = new T(src)
			src.attach_accessory(null, tie)

// Aurora forensics port.
/obj/item/clothing/clean_blood()
	..()
	gunshot_residue = null

/obj/item/clothing/proc/get_fibers()
	. = "material from \a [name]"
	var/list/acc = list()
	for(var/obj/item/clothing/accessory/A in accessories)
		if(prob(40) && A.get_fibers())
			acc += A.get_fibers()
	if(acc.len)
		. += " with traces of [english_list(acc)]"

/obj/item/clothing/should_attempt_pickup(datum/event_args/actor/actor)
	// if we're currently attached as an accessory
	if(accessory_host)
		return FALSE
	// either attack_hand_auto_unequip off, not being worn
	var/equipped_by_performer = actor.performer == get_worn_mob()
	. = ..() && (attack_hand_auto_unequip || !equipped_by_performer)
	if(!.)
		return
	if(equipped_by_performer)
		for(var/obj/item/clothing/accessory as anything in accessories)
			// check if accessory has storage allowing equipped click
			if(accessory.obj_storage?.allow_open_via_equipped_click)
				return FALSE
			// check if they allow pickup
			if(!accessory.should_attempt_pickup(actor))
				return FALSE

/obj/item/clothing/equipped(mob/user, slot, flags)
	. = ..()
	if(enables_planes)
		user.recalculate_vis()

/obj/item/clothing/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	if(enables_planes)
		user.recalculate_vis()

/obj/item/clothing/examine_more(mob/user)
	. = ..()
	if(user.using_perspective?.eye && get_dist(user.using_perspective?.eye, src) <= 2)
		. += "From this distance you can determine its <a href='?src=[REF(src)];examine_armor=1'>armor</a> with a close examination."

/obj/item/clothing/Topic(href, list/href_list)
	. = ..()
	if(.)
		return
	if(href_list["examine_armor"])
		if(!usr.using_perspective || get_dist(usr.using_perspective?.eye, src) > 2)
			to_chat(usr, SPAN_WARNING("You are too far away!"))
			return TRUE
		var/list/assembled = fetch_armor().describe_english_list()
		to_chat(usr, SPAN_BLOCKQUOTE("<center>--- Armor: [src] ---</center><hr>[jointext(assembled, "<br>")]", null))
		return TRUE

/obj/item/clothing/can_equip(mob/M, slot, mob/user, flags)
	. = ..()

	if(!. || !LAZYLEN(species_restricted))
		return

	var/exclude_mode = ("exclude" in species_restricted)

	var/mob/living/carbon/human/H = M

	if(!istype(H))
		return exclude_mode

	if((H.species.get_worn_legacy_bodytype(H) in species_restricted) == exclude_mode)
		if(slot in list(SLOT_ID_LEFT_POCKET, SLOT_ID_RIGHT_POCKET, SLOT_ID_SUIT_STORAGE))
			return TRUE		// don't care, didn't ask
		if(!(flags & INV_OP_SUPPRESS_WARNING))
			to_chat(H, SPAN_DANGER("Your species cannot wear [src]."))
		return FALSE

	return TRUE

//micros in shoes
/obj/item/clothing/relaymove(var/mob/living/user,var/direction)
	if(recent_struggle)
		return

	recent_struggle = 1

	spawn(100)
		recent_struggle = 0

	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.shoes == src)
			to_chat(H, "<font color='red'>[user]'s tiny body presses against you in \the [src], squirming!</font>")
			to_chat(user, "<font color='red'>Your body presses out against [H]'s form! Well, what little you can get to!</font>")
		else
			to_chat(H, "<font color='red'>[user]'s form shifts around in the \the [src], squirming!</font>")
			to_chat(user, "<font color='red'>You move around inside the [src], to no avail.</font>")
	else
		src.visible_message("<font color='red'>\The [src] moves a little!</font>")
		to_chat(user, "<font color='red'>You throw yourself against the inside of \the [src]!</font>")

/obj/item/clothing/proc/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	// * temporary *//
	// this entire proc is pending decommissioning. the new worn_bodytypes system is the
	// successor, and contains proper non-strict restriction support via fallbacks system

	// for now, we only bother mechnically restricting if it's a very different race; otherwise, we
	// swap icons if they exist, but do not actually restrict it, so you can actually have
	// humans wearing lizard suits in the interrim

	// we should also investigate being able to intentionally mis-cycle a suit to something you're not
	// so you can disguise as a lizard by using a lizard suit as a human or something

	var/static/list/actually_different_species = list(
		SPECIES_VOX,
		SPECIES_TESHARI,
	)

	if(target_species in actually_different_species)
		species_restricted = list(target_species)
	else
		species_restricted = list("exclude") + actually_different_species

	//Set icon
	LAZYINITLIST(sprite_sheets)
	if (sprite_sheets_refit && (target_species in sprite_sheets_refit))
		sprite_sheets[target_species] = sprite_sheets_refit[target_species]

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

/obj/item/clothing/head/helmet/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if(SPECIES_HUMAN, SPECIES_SKRELL)	//humanoid bodytypes
			species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_PROMETHEAN, SPECIES_HUMAN_SPACER, SPECIES_HUMAN_GRAV, SPECIES_HUMAN_VATBORN) //skrell/humans can wear each other's suits
		if (SPECIES_UNATHI)
			//For the sake of gameplay, unathi is unathi
			species_restricted = list(SPECIES_UNATHI, SPECIES_UNATHI_DIGI)
		else
			species_restricted = list(target_species)

	//Set icon
	if (sprite_sheets_refit && (target_species in sprite_sheets_refit))
		sprite_sheets[target_species] = sprite_sheets_refit[target_species]

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

//* Style Repicking *//

/**
 * returns available styles as name = state or image or mutable_appearance
 */
/obj/item/clothing/proc/style_repick_query(mob/user)
	SHOULD_NOT_SLEEP(TRUE)
	. = list()

/**
 * sets us to a specific style
 *
 * * do not update_icon() or update_worn_icon() in here, we do that automatically.
 */
/obj/item/clothing/proc/style_repick_set(style, mob/user)
	SHOULD_NOT_SLEEP(TRUE)
	return FALSE

/**
 * prompts a user to pick style
 */
/obj/item/clothing/proc/style_repick_open(mob/user)
	var/list/available = style_repick_query(user)
	var/list/assembled = list()
	for(var/name in available)
		var/using = available[name]
		if(istext(using))
			assembled[name] = image(icon,
					icon_state = using,
					pixel_x = -((icon_x_dimension - WORLD_ICON_SIZE) / 2),
					pixel_y = -((icon_y_dimension - WORLD_ICON_SIZE) / 2),
				)
		else if(isimage(using) || ismutableappearance(using))
			assembled[name] = using
		else if(islist(using))
			var/mutable_appearance/collated = mutable_appearance()
			collated.dir = SOUTH
			collated.overlays = using
			assembled[name] = collated
	if(!length(available))
		to_chat(user, SPAN_WARNING("[src] can only be worn one way."))
		return
	var/choice = show_radial_menu(user, loc == user ? user : src, assembled, radius = 48)
	if(isnull(choice))
		return
	if(!style_repick_set(choice, user))
		return
	// todo: logging API
	to_chat(user, SPAN_NOTICE("You set [src]'s style to [choice]."))
	log_game("[key_name(user)] set [src]'s style to [choice]")
	update_icon()
	update_worn_icon()

// todo: context menu this instead
/obj/item/clothing/verb/style_repick_verb()
	set name = "Set Worn Style"
	set category = VERB_CATEGORY_IC
	set desc = "Wear this piece of clothing in a different style."
	set src in usr

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		usr.action_feedback(SPAN_WARNING("You can't do that right now!"), src)
		return

	style_repick_open(usr)

/obj/item/clothing/can_unequip(mob/M, slot, mob/user, flags)
	if(clothing_flags & NO_UNEQUIP)
		return FALSE
	return ..()
