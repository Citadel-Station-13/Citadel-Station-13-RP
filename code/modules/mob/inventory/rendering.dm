/**
 * Item rendering system
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
	/* Species-specific sprites, concept stolen from Paradise//vg/.
	 * ex:
	 * sprite_sheets = list(
	 * 	SPECIES_TAJ = 'icons/cat/are/bad'
	 * 	)
	 * If index term exists and icon_override is not set, this sprite sheet will be used.
	*/
	var/list/sprite_sheets = list()

	/// Species-specific sprite sheets for inventory sprites
	/// Works similarly to worn sprite_sheets, except the alternate sprites are used when the clothing/refit_for_species() proc is called.
	var/list/sprite_sheets_obj = list()

	//! vv/map only
	/// when set, use this state always when in a specific slot id or just in general; list or state
	VAR_PRIVATE/list/mob_state_override
	/// when set, use this icon always when in a specific slot id or just in general; list or state
	VAR_PRIVATE/list/mob_icon_override

	/// worn icon file
	var/icon/worn_icon

	/// dimensions of our worn icon file
	var/worn_x_dimension
	/// dimensions of our worn icon file
	var/worn_y_dimension

	/// dimensions of inhand sprites
	var/inhand_x_dimension
	/// dimensions of inhand sprites
	var/inhand_y_dimension

/obj/item/proc/render_mob_appearance(mob/M, slot_id_or_hand_index, bodytype)
	// determine if in hands
	var/inhands = isnum(slot_id_or_hand_index)
	var/datum/inventory_slot_meta/slot_meta
	// resolve slot
	if(inhands)
		slot_meta = (inhands % 2)? resolve_inventory_slot_meta(/datum/inventory_slot_meta/abstract/right_hand : /datum/inventory_slot_meta/abstract/left_hand)
	else
		slot_meta = resolve_inventory_slot_meta(slot_id_or_hand_index)

	var/list/resolved = = resolve_worn_assets(mob/M, slot_meta, inhands, bodytype)

	return _render_mob_appearance(M, slot_meta, inhands, bodytype, resolved[1], resolved[2], resolved[3])

/obj/item/proc/_render_mob_appearance(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype, icon_used, state_used, layer_used)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	var/mutable_appearance/MA = mutable_appearance(icon_used, state_used, layer_used, FLOAT_PLANE)
	var/list/additional = render_additional(MA, bodytype, inhands, slot_meta)
	// todo: signal with (args, add)
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
 *
 * icon/icon state/layer information is included in the mutable appearance
 */
/obj/item/proc/render_additional(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	RETURN_TYPE(/list)
	return list()

/**
 * override to apply overlays to our current mutable appearance; called first
 */
/obj/item/proc/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	return MA

/**
 * returns a tuple of (icon, state, layer)
 */
/obj/item/proc/resolve_worn_assets(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype)

/// Worn icon generation for on-mob sprites
/obj/item/proc/make_worn_icon(var/body_type,var/slot_id,var/inhands,var/default_icon,var/default_layer,var/icon/clip_mask = null)
	//Get the required information about the base icon
	var/icon/icon2use = get_worn_icon_file(body_type = body_type, slot_id = slot_id, default_icon = default_icon, inhands = inhands)
	var/state2use = get_worn_icon_state(slot_id = slot_id)
	var/layer2use = get_worn_layer(default_layer = default_layer)

	//Snowflakey inhand icons in a specific slot
	if(inhands && icon2use == icon_override)
		switch(slot_id)
			if(slot_r_hand_str)
				state2use += "_r"
			if(slot_l_hand_str)
				state2use += "_l"

	//Generate the base onmob icon
	var/icon/standing_icon = icon(icon = icon2use, icon_state = state2use)

	if(!inhands)
		apply_custom(standing_icon)		//Pre-image overridable proc to customize the thing
		apply_addblends(icon2use,standing_icon)		//Some items have ICON_ADD blend shaders

	var/image/standing = image(standing_icon)
	standing = center_image(standing, inhands ? inhand_x_dimension : worn_x_dimension, inhands ? inhand_y_dimension : worn_y_dimension)
	standing.alpha = alpha
	standing.color = color
	standing.layer = layer2use

	//Apply any special features
	if(!inhands)
		apply_blood(standing)			//Some items show blood when bloodied
		apply_accessories(standing)		//Some items sport accessories like webbing

	//Return our icon
	return standing

//Returns the icon object that should be used for the worn icon
/obj/item/proc/get_worn_icon_file(var/body_type,var/slot_id,var/default_icon,var/inhands)

	//1: icon_override var
	if(icon_override)
		return icon_override

	//2: species-specific sprite sheets (skipped for inhands)
	if(LAZYLEN(sprite_sheets))
		var/sheet = sprite_sheets[body_type]
		if(sheet && !inhands)
			return sheet

	//3: slot-specific sprite sheets
	if(LAZYLEN(item_icons))
		var/sheet = item_icons[slot_id]
		if(sheet)
			return sheet

	//4: item's default icon
	if(!inhands && worn_icon)
		return worn_icon

	//5: provided default_icon
	if(default_icon)
		return default_icon

	//6: give up
	return

//Returns the state that should be used for the worn icon
/obj/item/proc/get_worn_icon_state(var/slot_id)

	//1: slot-specific sprite sheets
	if(LAZYLEN(item_state_slots))
		var/state = item_state_slots[slot_id]
		if(state)
			return state

	//2: item_state variable
	if(item_state)
		return item_state

	//3: icon_state variable
	if(icon_state)
		return icon_state

/// Returns the layer that should be used for the worn icon (as a FLOAT_LAYER layer, so negative)
/obj/item/proc/get_worn_layer(default_layer = 0)

	//1: worn_layer variable
	if(!isnull(worn_layer)) //Can be zero, so...
		return BODY_LAYER+worn_layer

	//2: your default
	return BODY_LAYER+default_layer

//! legacy
//Apply the addblend blends onto the icon
/obj/item/proc/apply_addblends(var/source_icon, var/icon/standing_icon)
#warn impl
	//If we have addblends, blend them onto the provided icon
	if(addblends && standing_icon && source_icon)
		var/addblend_icon = icon("icon" = source_icon, "icon_state" = addblends)
		standing_icon.Blend(addblend_icon, ICON_ADD)
