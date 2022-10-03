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
 * * Legacy
 * todo: legacy isn't actually legacy; fix this documentation
 *
 * If you are not using `worn_icon` or `inhand_icon` or falling back to `icon`,
 * you are considered to be using the legacy system.
 * Since these generally have "one file many items" rather than "one item one file",
 * effective icon state changes in these cases.
 *
 * This will unfortunately be the state we're in until we fully rework the system to be consistent.
 *
 * * Equipped
 * Icon file priority:
 * -1. icon_override // todo: remove other than for vv
 * 0. mob_icon_override
 * 1. worn_icon
 * 2. item_icons // todo: remove (we'll never successfully do this)
 * 3. default icon for slot // todo: overhaul (we'll never successfully do this)
 * 4. icon
 *
 * Icon state priority:
 * 0. mob_state_override
 * 1. worn_state
 * 2. item_state_slots // todo: remove (we'll never successfully do this)
 * 3. item_state // todo: remove (we'll never successfully do this)
 * 4. icon_state
 *
 * Icon state generation:
 * If not using legacy,
 * [state]_[slot_id]
 * If non default bodytype,
 * [state]_[slot_id]_[bodytype]
 * If legacy,
 * [state]
 *
 * * Inhands
 * Icon file priority:
 * -1. icon_override // todo: remove other than for vv
 * 0. mob_icon_override
 * 1. inhand_icon
 * 2. worn_icon
 * 3. item_icons // todo: remove (we'll never successfully do this)
 * 4. default icon for hand // todo: overhaul (we'll never successfully do this)
 * 5. icon
 *
 * Icon state priority:
 * 0. mob_state_override
 * 1. inhand_state
 * 2. worn_state
 * 3. item_state_slots // todo: remove (we'll never successfully do this)
 * 4. item_state // todo: remove (we'll never successfully do this)
 * 5. icon_state
 *
 * Icon state generation:
 * If not using legacy,
 * [state]_left or [state]_right
 * If legacy,
 * [state]
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

	//! equipped
	/// worn icon file
	var/icon/worn_icon
	/// worn icon state
	var/worn_state
	/// dimensions of our worn icon file
	var/worn_x_dimension
	/// dimensions of our worn icon file
	var/worn_y_dimension
	/// worn layer override
	var/worn_layer


	//! inhands
	/// inhand icon file
	var/icon/inhand_icon
	/// inhand icon state
	var/inhand_state
	/// dimensions of inhand sprites
	var/inhand_x_dimension
	/// dimensions of inhand sprites
	var/inhand_y_dimension
	/// inhand layer override
	var/inhand_layer

//! Inhand
/**
 * Builds worn icon
 */
/obj/item/proc/render_worn_appeaerance(mob/M, index)
	SHOULD_NOT_OVERRIDE(TRUE)

	/// get assets
	var/list/data = worn_inhand_data(M, index)

	return _render_inhand_appearance(M, index, assets[1], assets[2], assets[3])

/obj/item/proc/_render_inhand_appearance(mob/M, index, icon_used, state_used, layer_used)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	var/list/additional = worn_inhand_additional(M, index, icon_used, state_used, layer_used)

	// todo: comsig with (args, list/mutable_add) for overrides

	var/mutable_appearance/MA = mutable_appearance(icon_used, state_used, layer_used, FLOAT_PLANE)

	worn_inhand_apply(MA, M, index, icon_used, state_used, layer_used)

	return length(additional)? (additional + MA) : MA

/**
 * Gets tuple of (icon, state) to use in inhand rendering
 */
/obj/item/proc/worn_inhand_data(mob/M, index)
	RETURN_TYPE(/list)

	//* -1: icon_override; considered legacy, no append
	if(icon_override)
		return list(icon_override, worn_inhand_state(M, index), worn_inhand_layer(M, index))

	//* 0: mob_icon_override; considered non-legacy, has append
	if(mob_icon_override)
		if(islist(mob_icon_override))
			. = mob_icon_override[(index % 2)? SLOT_ID_RIGHT_HAND : SLOT_ID_LEFT_HAND]
			if(.)
				return list(., worn_inhand_state(M, index) + worn_inhand_state_append(index), worn_inhand_layer(M, index))
		else
			return list(mob_icon_override, worn_inhand_state(M, index) + worn_inhand_state_append(index), worn_inhand_layer(M, index))

	//* 1: inhand_icon; considered non-legacy, has append
	if(inhand_icon)
		return list(inhand_icon, worn_inhand_state(M, index) + worn_inhand_state_append(index), worn_inhand_layer(M, index))

	//* 2: worn_icon; considered non-legacy, has append
	if(worn_icon)
		return list(worn_icon, worn_inhand_state(M, index) + worn_inhand_state_append(index), worn_inhand_layer(M, index))

	//* 3. item_icons; considered legacy, no append
	if(item_icons)
		. = item_icons[(index % 2)? slot_r_hand_str : slot_l_hand_str]
		if(.)
			return list(., worn_inhand_state(M, index), worn_inhand_layer(M, index))

	//* 4. default icons
	var/static/list/cached_default_r_hand_file_states
	var/static/list/cached_default_l_hand_file_states
 * Icon file priority:
 * -1. icon_override // todo: remove other than for vv
 * 0. mob_icon_override
 * 1. inhand_icon
 * 2. worn_icon
 * 3. item_icons // todo: remove (we'll never successfully do this)
 * 4. default icon for hand // todo: overhaul (we'll never successfully do this)
 * 5. icon
 *
 * Icon state priority:
 * 0. mob_state_override
 * 1. inhand_state
 * 2. worn_state
 * 3. item_state_slots // todo: remove (we'll never successfully do this)
 * 4. item_state // todo: remove (we'll never successfully do this)
 * 5. icon_state
 *
 * Icon state generation:
 * If not using legacy,
 * [state]_left or [state]_right
 * If legacy,
 * [state]
 *


/**
 * worn inhand state
 */
/obj/item/proc/worn_inhand_state(mob/M, index)
	//* 0: mob_state_override
	if(mob_state_override)
		if(islist(mob_state_override))
			. = mob_state_override[(index % 2)? SLOT_ID_RIGHT_HAND : SLOT_ID_LEFT_HAND]
			if(.)
				return
		else
			return mob_state_override

	//* 1: inhand_state
	if(inhand_state)
		return inhand_state

	//* 2: worn_state
	if(worn_state)
		return worn_state

	//* 3: item_state_slots
	if(length(item_state_slots))
		. = item_state_slots[(index % 2)? slot_r_hand_str : slot_l_hand_str]
		if(.)
			return

	//* 4: item_state
	if(item_state)
		return item_state

	//* 5: icon_state
	return icon_state

/**
 * worn inhand state append
 */
/obj/item/proc/worn_inhand_state_append(index)
	var/datum/inventory_slot_meta/meta = (index % 2)? resolve_inventory_slot_meta(/datum/inventory_slot_meta/abstract/right_hand) : resolve_inventory_slot_meta(/datum/inventory_slot_meta/abstract/left_hand)
	return meta.render_key

/**
 * worn inhand layer
 */
/obj/item/proc/worn_inhand_layer(mob/M, index)
	if(inhand_layer)
		return inhand_layer
	var/datum/inventory_slot_meta/meta = (index % 2)? resolve_inventory_slot_meta(/datum/inventory_slot_meta/abstract/right_hand) : resolve_inventory_slot_meta(/datum/inventory_slot_meta/abstract/left_hand)
	return meta.render_layer

/**
 * tweaks inhand appearance as needed, including adding overlays/whatever
 */
/obj/item/proc/worn_inhand_apply(mutable_appearance/MA, mob/M, index, icon_used, state_used, layer_used)
	return MA

/**
 * advanced: able to return more than one mutable appearnace to render on the mob
 */
/obj/item/proc/worn_inhand_additional(mob/M, index, icon_used, state_used, layer_used)
	RETURN_TYPE(/list)
	return list()

//! Common

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
	if(istype(clip_mask)) //For taur bodies/tails clipping off parts of uniforms and suits.
		standing.filters += filter(type = "alpha", icon = clip_mask)

	if(istype(clip_mask)) //For taur bodies/tails clipping off parts of uniforms and suits.
		standing.filters += filter(type = "alpha", icon = clip_mask)

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

//Apply the addblend blends onto the icon
/obj/item/proc/apply_addblends(var/source_icon, var/icon/standing_icon)

	//If we have addblends, blend them onto the provided icon
	if(addblends && standing_icon && source_icon)
		var/addblend_icon = icon("icon" = source_icon, "icon_state" = addblends)
		standing_icon.Blend(addblend_icon, ICON_ADD)

//STUB
/obj/item/proc/apply_custom(var/icon/standing_icon)
	return standing_icon

//STUB
/obj/item/proc/apply_blood(var/image/standing)
	return standing

//STUB
/obj/item/proc/apply_accessories(var/image/standing)
	return standing
