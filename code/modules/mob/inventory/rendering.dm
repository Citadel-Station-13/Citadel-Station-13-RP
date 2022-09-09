//! wip
/obj/item
	//** These specify item/icon overrides for _slots_

	/// Overrides the default item_state for particular slots.
	var/list/item_state_slots = list()

	/// Used to specify the icon file to be used when the item is worn. If not set the default icon for that slot will be used.
	/// If icon_override or sprite_sheets are set they will take precendence over this, assuming they apply to the slot in question.
	/// Only slot_l_hand/slot_r_hand are implemented at the moment. Others to be implemented as needed.
	var/list/item_icons = list()

	/// Dimensions of the icon file used when this item is worn, eg: hats.dmi
	/// eg: 32x32 sprite, 64x64 sprite, etc.
	/// allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_x_dimension = 32
	var/worn_y_dimension = 32
	//Allows inhands/worn sprites for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_x_dimension = 32
	var/inhand_y_dimension = 32

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

	/// Default on-mob icon.
	var/icon/default_worn_icon
	/// Default on-mob layer.
	var/worn_layer

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

	// testing("[src] (\ref[src]) - Slot: [slot_id], Inhands: [inhands], Worn Icon:[icon2use], Worn State:[state2use], Worn Layer:[layer2use]")

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
	if(default_worn_icon)
		return default_worn_icon

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
