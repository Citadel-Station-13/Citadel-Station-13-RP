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

	return _render_mob_appearance(M, slot_meta, inhands, bodytype, resolved[1], resolved[2], resolved[3], resolved [4], resolved[5])

/obj/item/proc/_render_mob_appearance(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype, icon_used, state_used, layer_used, dim_x, dim_y)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	var/mutable_appearance/MA = mutable_appearance(icon_used, state_used, BODY_LAYER + layer_used, FLOAT_PLANE)
	MA = center_appearance(MA, dim_x, dim_y)
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
 * returns a tuple of (icon, state, layer, size_x, size_y)
 */
/obj/item/proc/resolve_worn_assets(mob/M, datum/inventory_slot_meta/slot_meta, inhands, bodytype)
	. = new /list(5)	// 5 tuple


	//? state ; item_state_slots --> item_state --> icon_state
	.[2] = (item_state_slots?[slot_meta.id]) || item_state || icon_state

	//? icon, size
	//* icon_override
	if(icon_override)
		.[1] = icon_override
		if(inhands)
			switch(slot_meta.id)
				if(SLOT_ID_LEFT_HAND)
					.[2] += "_l"
				if(SLOT_ID_RIGHT_HAND)
					.[2] += "_r"
		.[4] = worn_x_dimension
		.[5] = worn_y_dimension

	//* species-specific sprite sheets
	else if()
	#warn god what the fuck

	//* slot-specific sprite sheets
	else if(item_icons?[slot_meta.id])
		.[1] = item_icons[slot_meta.id]
		.[4] = worn_x_dimension
		.[5] = worn_y_dimension

	//* item worn_icon override
	else if(worn_icon && !inhands)
		// todo: rework
		.[1] = worn_icon
		.[4] = worn_x_dimension
		.[5] = worn_y_dimension

	//* inventory slot defaults
	else
		var/list/resolved = slot_meta.resolve_default_assets(bodytype, .[2], M, src)
		if(resolved)
			.[1] = resolved[1]
			.[4] = resolved[2]
			.[5] = resolved[3]

	//* our icon
	if(!.[1])
		.[1] = icon
		.[4] = icon_dimension_x
		.[5] = icon_dimension_y

	//? layer ; wonr_layer --> slot defaults for the item in question
	.[3] = worn_layer || slot_meta.resolve_default_layer(bodytype, M, src)


//! legacy
	//Snowflakey inhand icons in a specific slot
	if(inhands && icon2use == icon_override)
		switch(slot_id)
			if(SLOT_ID_RIGHT_HAND)
				state2use += "_r"
			if(SLOT_ID_LEFT_HAND)
				state2use += "_l"


//Returns the icon object that should be used for the worn icon
/obj/item/proc/get_worn_icon_file(var/body_type,var/slot_id,var/default_icon,var/inhands)

	//2: species-specific sprite sheets (skipped for inhands)
	if(LAZYLEN(sprite_sheets))
		var/sheet = sprite_sheets[body_type]
		if(sheet && !inhands)
			return sheet


//! legacy
//Apply the addblend blends onto the icon
/obj/item/proc/apply_addblends(var/source_icon, var/icon/standing_icon)
#warn impl
	//If we have addblends, blend them onto the provided icon
	if(addblends && standing_icon && source_icon)
		var/addblend_icon = icon("icon" = source_icon, "icon_state" = addblends)
		standing_icon.Blend(addblend_icon, ICON_ADD)
