/**
 * Item rendering system
 *
 * * IF YOU ONLY CARE ABOUT MAKING A NEW ITEM OR ARE CONVERTING AN ITEM, JUST READ THIS!!
 *
 * 0. Do you want the on-mob icons to be *entirely* shared/defaulted? If so, why are you here?
 *        Use the old system, by putting your states into the default icons as defined in
 *        [code/modules/mob/inventory/slot_meta.dm]
 *        and setting inhand_state and worn_state so they're found.
 *        If you want to share *some* icons, read State Generation and
 *        use worn_icon, and inhand_icon to do what you need to do.
 *
 *        !! If your sprite already exists in default icons, it will override what !!
 *        !! we do here. This is an unfortunate tradeoff of speed we have to make. !!
 *        !! Make sure to set worn_species_default to FALSE to stop this.          !!
 *        ?? THIS IS SOMETIMES A GOOD THING.                                       ??
 *        ?? There's common states available for inhands and some worn stuff.      ??
 *        ?? You just need to set inhand_state and worn_state to use them!         ??
 *
 *    Otherwise, continue on with the rest of the steps, setting
 *        worn_render_flags = NONE
 *    to instruct the system to ignore default icons entirely.
 *
 *    ?? A note on bitfields: worn_render_flags                                             ??
 *    ?? Without getting into the nitty gritty, worn_render_flags control all               ??
 *    ?? behavior and logic. When the guide below says "add" a flag of a certain            ??
 *    ?? name to it, it means boolean OR it.                                                ??
 *    ?? For noncoders, basically: to combine, say, WORN_RENDER_SLOT_ONE_FOR_ALL            ??
 *    ?? and WORN_RENDER_INHAND_ONE_FOR_ALL, you just put a | between them, like so:        ??
 *    ?? worn_render_flags =  WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ONE_FOR_ALL ??
 *    ?? Congratulations, you used a bitfield.                                              ??
 *
 * 1. Have a sensical place for your item's .dmi.
 *    e.g. /obj/item/pickaxe goes in icons/modules/mining/tools/pickaxe.dmi
 * 2. Put what the item looks like in the world, and in your inventory, as the base state.
 *    e.g. a sprite of a pickaxe as state `pickaxe`. Set your item's icon_state to this,
 *    and its icon to the file you made.
 * 3. Add inhands if needed with state_left and state_right.
 *    In this case, it'd be
 *        pickaxe_left
 *        pickaxe_right
 *    If you for some reason want it to use a singular state only when inhand,
 *    set worn_inhand_ignored to TRUE, and it'll render as pickaxe_all instead.
 * 4. Does the item go in multiple slots and require multiple sprites?
 *    If not, add WORN_RENDER_SLOT_ONE_TO_ALL to worn_render_flags,
 *    and it'll render as pickaxe_all always.
 *        pickaxe_all
 *    If so, set states for each slot id, e.g. in this case,
 *        pickaxe_back
 *        pickaxe_belt
 *    A full list of slot ids are in [code/modules/mob/inventory/slot_meta.dm].
 * 5. Do you care about bodytypes? If so, set worn_bodytypes to the bodytypes you want
 *    to implement with bitfield notation, aka
 *    worn_bodytypes = BODYTYPE_TESHARI | BODYTYPE_UNATHI
 *    Then, put in states for the bodytypes in question like so:
 *        pickaxe_back_teshari
 *        pickaxe_back_unathi
 *    A full list of available bodytypes and what the string keys for them are
 *    in [code/__DEFINES/inventory/bodytypes.dm].
 *    The default bodytypes, as well as any bodytypes that aren't explicitly set as implemented,
 *    do not get appended (e.g. if a human or vox puts it on it's still pickaxe_back)
 * 6. Do you want the base state, in this case 'pickaxe', for on-mob generation
 *    to be different from icon_state? This is useful if you want to switch
 *    your item's icon state or worn state without impacting the others.
 *    If so, set overrides for worn (held in inventory slots) and inhand (held in hands)
 *        worn_state = "pickaxe_onbody"
 *        inhand_state = "pickaxe_onhand"
 *    like so. Generation for the previous parts will become
 *        pickaxe_onbody_back
 *        pickaxe_onbody_belt
 *    or in the example of "ignore slot"
 *        pickaxe_onbody_all
 *    and for inhands
 *        pickaxe_onhand_left
 *        pickaxe_onhand_right
 * 7. Defaulting: In the case you want to default slot/inhands (usually one but not the other),
 *    simply add to worn_render_flags, depending on which:
 *        WORN_RENDER_SLOT_ALLOW_DEFAULT
 *        WORN_RENDER_INHAND_ALLOW_DEFAULt
 * 8. Congratulations, you're done!
 *
 * * Overall Goal
 * - Being able to stuff an entire item's assets in one icon
 * - Otherwise being able to split an entire item's assets into modular folders
 * - Generic inhands and slot icons go in general onmob item folders
 * - Not forcing usage of something as asinine as suit.dmi
 *
 * * Limitations
 * - inhand state only supports left and right; no weird index-based for now. this can easily change.
 *
 * * State Generation
 * This is only pertinent to single-icon rendering, which the system falls back to
 * if it can't find anything else. This is what people should be using for non-reused
 * item sprites.
 *
 * This system also supports worn_icon and inhand_icon if you really want to split it up.
 *
 * Pattern:
 *
 * state_slot_bodytype, where
 * state: (inhand_state if inhand, worn_state if not) || icon_state
 * slot: the inventory slot's `render_key`, or null if worn slot is ignored
 *       if it's a hand, it'll be _left or _right if it's not ignored.
 * bodytype: if not trampled, or ignored, the bodytype as string (see DEFINES)
 *           if converted to default, or it is default, or is ignored, this is null
 *
 * Obviously the _ part of the state is left out if the part doesn't exist
 *
 * Examples:
 * in world/on map/in inventory:
 * pickaxe
 *
 * worn:
 * pickaxe_belt		(implicit default bodytype)
 * pickaxe_belt_teshari
 * pickaxe_left
 * pickaxe_right
 * pickaxe_right_teshari		(overrides on teshari)
 *
 * * Coloration
 *
 * ! Coloration WIP. For now, color var only.
 * ! TODO: GAGS, polychromatic overlays with _1, _2, _3, _..., and RED/BLUE, RED/GREEN, GREEN/BLUE matrices.
 * ! TODO: For most of these, it will require mutating the icon states used.
 *
 * * Why mutable appearances?
 * Rendering of equipment changes regularly. They're quite literally built to be changed.
 * Since items always have the same direction as wearer, this means we don't have to use images.
 *
 * * Centering
 * All sprites are centered on the mob regardless of dimensions.
 * The species/mob in question can then pixel shift the resulting object as fit.
 *
 * ? Everything else: read the procs.
 */
/obj/item
	//! LEGACY
	//** These specify item/icon overrides for _slots_

	/// Overrides the default item_state for particular slots.
	var/list/item_state_slots = list()

	/// Used to specify the icon file to be used when the item is worn. If not set the default icon for that slot will be used.
	/// If icon_override or sprite_sheets are set they will take precendence over this, assuming they apply to the slot in question.
	/// Only slot_l_hand/slot_r_hand are implemented at the moment. Others to be implemented as needed.
	var/list/item_icons = list()

	/// Used to override hardcoded clothing dmis in human clothing proc. //TODO: Get rid of this crap -Zandario
	var/icon_override = null

	//** These specify item/icon overrides for _species_
	//TODO Refactor this from the ground up. Too many overrides. -Zandario
	//! THIS IS NOW BANNED. DO NOT USE THIS OR I WILL PUT A LEMON ON YOUR EYES. ~silicons
	//! Use the new bodytype system, PLEASE.
	//! Accessories are currently exempt from the ban, but also accessories need refactored
	//! God this is fucking asinine
	/* Species-specific sprites, concept stolen from Paradise//vg/.
	 * ex:
	 * sprite_sheets = list(
	 * 	BODYTYPE_STRING_TAJARAN = 'icons/cat/are/bad'
	 * 	)
	 * If index term exists and icon_override is not set, this sprite sheet will be used.
	*/
	var/list/sprite_sheets = list()

	/// Species-specific sprite sheets for inventory sprites
	/// Works similarly to worn sprite_sheets, except the alternate sprites are used when the clothing/refit_for_species() proc is called.
	var/list/sprite_sheets_obj = list()

	// todo: remove
	/// worn icon file
	var/icon/default_worn_icon

	//! NEW RENDERING SYSTEM (to be used by all new content tm); read comment section at top
	//? for equipment slots: prioritized over icon, icon_state, icon dimensions
	/// state to use; icon_state is used if this isn't set
	var/worn_state
	/// worn icon used instead of base icon
	var/icon/worn_icon
	/// dimensions of our worn icon file if different from icon
	var/worn_x_dimension = 32
	/// dimensions of our worn icon file if different from icon
	var/worn_y_dimension = 32
	//? for hands: prioritized over icon, icon_state, icon dimensions
	/// state to use; worn_state, then icon_state is used if this isn't set
	var/inhand_state
	/// inhand icon used instead of base icon
	var/icon/inhand_icon
	/// dimensions of inhand sprites if different from icon
	var/inhand_x_dimension = 32
	/// dimensions of inhand sprites if different from icon
	var/inhand_y_dimension = 32
	/// inhand default domain aka which icon we grab to check for state
	var/inhand_default_type = INHAND_DEFAULT_ICON_GENERAL
	//? for belts
	/// state to use in [icons/mob/clothing/belt.dmi] for belt overlay
	var/belt_state
	//? general handling directives
	/**
	 * bodytypes that *can* get trampled to default if the default icon is not found on species
	 * this only works for default sprites, if you're using single-icon/the new rendering system
	 * this does nothing.
	 */
	var/worn_bodytypes_converted = ALL
	/// bodytypes that are implemented. Anything not in here is converted to default.
	var/worn_bodytypes = NONE
	/// worn rendering flags
	var/worn_render_flags = WORN_RENDER_INHAND_ALLOW_DEFAULT | WORN_RENDER_SLOT_ALLOW_DEFAULT
	//? support for adminbus
	/// vv only; slot id to icon; worn_x_dimension and worn_y_dimension will be used in this case.
	VAR_PRIVATE/list/worn_icon_override
	/// vv only; slot id to state
	VAR_PRIVATE/list/worn_state_override
	/// vv only; set to override layer
	VAR_PRIVATE/worn_layer_override

/obj/item/proc/render_mob_appearance(mob/M, slot_id_or_hand_index, bodytype = BODYTYPE_STRING_DEFAULT)
	// SHOULD_NOT_OVERRIDE(TRUE) // if you think you need to, rethink.
	// todo: eh reevaluate later
	// determine if in hands
	var/inhands = isnum(slot_id_or_hand_index)
	var/datum/inventory_slot_meta/slot_meta
	// resolve slot
	if(inhands)
		slot_meta = resolve_inventory_slot_meta((slot_id_or_hand_index % 2)? /datum/inventory_slot_meta/abstract/hand/left : /datum/inventory_slot_meta/abstract/hand/right)
	else
		slot_meta = resolve_inventory_slot_meta(slot_id_or_hand_index)

	var/list/resolved = resolve_worn_assets(M, slot_meta, inhands, bodytype)

	return _render_mob_appearance(M, slot_meta, inhands, bodytype, resolved[WORN_DATA_ICON], resolved[WORN_DATA_STATE], resolved[WORN_DATA_LAYER], resolved [WORN_DATA_SIZE_X], resolved[WORN_DATA_SIZE_Y])

/obj/item/proc/_render_mob_appearance(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype, icon_used, state_used, layer_used, dim_x, dim_y)
	SHOULD_NOT_OVERRIDE(TRUE) // if you think you need to, rethink.
	PRIVATE_PROC(TRUE) // if you think you need to call this, rethink.
	var/list/additional = render_additional(icon_used, state_used, layer_used, dim_x, dim_y, bodytype, inhands, slot_meta)
	// todo: signal with (args, add)
	// todo: args' indices should be defines
	var/no_render = inhands? (worn_render_flags & WORN_RENDER_INHAND_NO_RENDER) : (worn_render_flags & WORN_RENDER_SLOT_NO_RENDER)
	var/mutable_appearance/MA
	// worn_state_guard makes us not render if we'd render the same as in-inventory icon.
	if(no_render)		// don't bother
		return additional
	MA = mutable_appearance(icon_used, state_used, BODY_LAYER + layer_used, FLOAT_PLANE)
	// temporary - until coloration
	MA.color = color
	MA = center_appearance(MA, dim_x, dim_y)
	MA = render_apply_overlays(MA, bodytype, inhands, slot_meta)
	MA = render_apply_blood(MA, bodytype, inhands, slot_meta)
	MA = render_apply_custom(MA, bodytype, inhands, slot_meta)
	return length(additional)? (additional + MA) : MA

/**
 * override to apply custom stuff to rendering; called last
 *
 * icon/icon state/layer information is included in the mutable appearance
 */
/obj/item/proc/render_apply_custom(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	return MA

/**
 * override to determine how we apply blood overlays to rendering
 *
 * icon/icon state/layer information is included in the mutable appearance
 */
/obj/item/proc/render_apply_blood(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	return MA

/**
 * override to include additional appearances while rendering
 */
/obj/item/proc/render_additional(icon/icon_used, state_used, layer_used, dim_x, dim_y, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	RETURN_TYPE(/list)
	return list()

/**
 * override to apply overlays to our current mutable appearance; called first
 */
/obj/item/proc/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	if(addblends)
		var/mutable_appearance/adding = mutable_appearance(icon = MA.icon, icon_state = addblends)
		adding.blend_mode = BLEND_ADD
		MA.add_overlay(adding)
	return MA

/**
 * returns a tuple of (icon, state, layer, size_x, size_y)
 *
 * @params
 * - M - mob putting us on; optional
 * - slot_meta - inventory slot datum
 * - inhands - if we're going to inhands
 * - bodytype - bodytype in question
 */
/obj/item/proc/resolve_worn_assets(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype)
	if(istext(slot_meta))
		slot_meta = resolve_inventory_slot_meta(slot_meta)
	var/list/data = new /list(WORN_DATA_LIST_SIZE)	// 5 tuple

	//? state ; item_state_slots --> (worn_state | inhand_state) --> item_state --> icon_state
	data[WORN_DATA_STATE] = resolve_legacy_state(M, slot_meta, inhands, bodytype)

	//? icon, size
	//* icon_override
	if(icon_override)
		data[WORN_DATA_ICON] = icon_override
		if(inhands)
			switch(slot_meta.id)
				if(SLOT_ID_LEFT_HAND)
					data[WORN_DATA_STATE] += "_l"
				if(SLOT_ID_RIGHT_HAND)
					data[WORN_DATA_STATE] += "_r"
				if(SLOT_ID_LEFT_EAR)
					data[WORN_DATA_STATE] += "_l"
				if(SLOT_ID_RIGHT_EAR)
					data[WORN_DATA_STATE] += "_l"
		data[WORN_DATA_SIZE_X] = worn_x_dimension
		data[WORN_DATA_SIZE_Y] = worn_y_dimension

	//* species-specific sprite sheets
	else if(length(sprite_sheets) && !inhands && (sprite_sheets[bodytype_to_string(bodytype)]))
		data[WORN_DATA_ICON] = sprite_sheets[bodytype_to_string(bodytype)]
		data[WORN_DATA_SIZE_X] = WORLD_ICON_SIZE
		data[WORN_DATA_SIZE_Y] = WORLD_ICON_SIZE

	//* slot-specific sprite sheets
	else if(item_icons?[slot_meta.id])
		data[WORN_DATA_ICON] = item_icons[slot_meta.id]
		data[WORN_DATA_SIZE_X] = worn_x_dimension
		data[WORN_DATA_SIZE_Y] = worn_y_dimension

	//* item default_worn_icon override
	else if(default_worn_icon && !inhands)
		// todo: rework
		data[WORN_DATA_ICON] = default_worn_icon
		data[WORN_DATA_SIZE_X] = worn_x_dimension
		data[WORN_DATA_SIZE_Y] = worn_y_dimension

	//* inventory slot defaults
	else if(inhands? (worn_render_flags & WORN_RENDER_INHAND_ALLOW_DEFAULT) : (worn_render_flags & WORN_RENDER_SLOT_ALLOW_DEFAULT))
		var/list/resolved = slot_meta.resolve_default_assets(bodytype, data[WORN_DATA_STATE], M, src, inhand_default_type)
		if(!resolved && (bodytype != BODYTYPE_DEFAULT) && (bodytype & worn_bodytypes_converted))
			// attempt 2 - convert to default if specified to convert
			resolved = slot_meta.resolve_default_assets(BODYTYPE_DEFAULT, data[WORN_DATA_STATE], M, src, inhand_default_type)
		if(resolved)
			data[WORN_DATA_ICON] = resolved[1]
			data[WORN_DATA_SIZE_X] = resolved[2]
			data[WORN_DATA_SIZE_Y] = resolved[3]

	//* Now, the actual intended render system.
	if(!data[WORN_DATA_ICON])
		// grab icon based on priority
		if(inhands && inhand_icon)
			data[WORN_DATA_ICON] = inhand_icon
			data[WORN_DATA_SIZE_X] = inhand_x_dimension
			data[WORN_DATA_SIZE_Y] = inhand_y_dimension
		else if(!inhands && worn_icon)
			data[WORN_DATA_ICON] = worn_icon
			data[WORN_DATA_SIZE_X] = worn_x_dimension
			data[WORN_DATA_SIZE_Y] = worn_y_dimension
		else
			data[WORN_DATA_ICON] = icon
			data[WORN_DATA_SIZE_X] = icon_dimension_x
			data[WORN_DATA_SIZE_Y] = icon_dimension_y
		data[WORN_DATA_STATE] = resolve_worn_state(inhands, slot_meta.render_key, bodytype)

	//? layer ; worn_layer --> slot defaults for the item in question
	data[WORN_DATA_LAYER] = worn_layer_override || slot_meta.resolve_default_layer(bodytype, M, src)

	//* Handle overrides
	if(LAZYACCESS(worn_icon_override, slot_meta.id))
		data[WORN_DATA_ICON] = worn_icon_override[slot_meta.id]
	if(LAZYACCESS(worn_state_override, slot_meta.id))
		data[WORN_DATA_STATE] = worn_state_override[slot_meta.id]

	return data

// todo: remove, aka get rid of fucking uniform _s state
/obj/item/proc/resolve_legacy_state(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype)
	return (item_state_slots?[slot_meta.id]) || (inhands? inhand_state : worn_state) || item_state || icon_state

/obj/item/proc/resolve_worn_state(inhands, slot_key, bodytype)
	// PRIVATE_PROC(TRUE)
	if(inhands)
		return "[base_worn_state(inhands, slot_key, bodytype)][(worn_render_flags & WORN_RENDER_INHAND_ONE_FOR_ALL)? "_all" : "_[slot_key]"]"
	return "[base_worn_state(inhands, slot_key, bodytype)][(worn_render_flags & WORN_RENDER_SLOT_ONE_FOR_ALL)? "_all" : "_[slot_key]"][((worn_bodytypes & (~BODYTYPE_DEFAULT)) & bodytype)? "_[bodytype_to_string(bodytype)]" : ""]"

/obj/item/proc/base_worn_state(inhands, slot_key, bodytype)
	if(inhands)
		return inhand_state || icon_state
	return worn_state || icon_state
