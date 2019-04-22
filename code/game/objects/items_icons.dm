//Worn icon generation for on-mob sprites
/obj/item/proc/build_worn_icon(body_type, slot_name, inhands, default_icon, default_layer)
	//Get the required information about the base icon
	var/icon/icon2use = get_worn_icon_file(body_type = body_type, slot_name = slot_name, default_icon = default_icon, inhands = inhands)
	var/state2use = get_worn_icon_state(slot_name = slot_name)
	var/layer2use = get_worn_layer(default_layer = default_layer)

	//Snowflakey inhand icons in a specific slot
	if(inhands && icon2use == icon_override)
		switch(slot_name)
			if(slot_r_hand_str)
				state2use += "_r"
			if(slot_l_hand_str)
				state2use += "_l"

	// testing("[src] (\ref[src]) - Slot: [slot_name], Inhands: [inhands], Worn Icon:[icon2use], Worn State:[state2use], Worn Layer:[layer2use]")

	//Generate the base onmob icon
	var/icon/standing_icon = icon(icon = icon2use, icon_state = state2use)

	if(!inhands)
		apply_custom(standing_icon)		//Pre-image overridable proc to customize the thing
		apply_addblends(icon2use,standing_icon)		//Some items have ICON_ADD blend shaders

	var/mutable_appearance/standing = mutable_appearance(standing_icon)
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
/obj/item/proc/get_worn_icon_file(var/body_type,var/slot_name,var/default_icon,var/inhands)

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
		var/sheet = item_icons[slot_name]
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
/obj/item/proc/get_worn_icon_state(var/slot_name)

	//1: slot-specific sprite sheets
	if(LAZYLEN(item_state_slots))
		var/state = item_state_slots[slot_name]
		if(state)
			return state

	//2: item_state variable
	if(item_state)
		return item_state

	//3: icon_state variable
	if(icon_state)
		return icon_state

//Returns the layer that should be used for the worn icon (as a FLOAT_LAYER layer, so negative)
/obj/item/proc/get_worn_layer(var/default_layer = 0)

	//1: worn_layer variable
	if(!isnull(worn_layer)) //Can be zero, so...
		return BODY_LAYER+worn_layer

	//2: your default
	return BODY_LAYER+default_layer

//Apply the addblend blends onto the icon
/obj/item/proc/apply_addblends(source_icon, icon/standing_icon)

	//If we have addblends, blend them onto the provided icon
	if(addblends && standing_icon && source_icon)
		var/addblend_icon = icon("icon" = source_icon, "icon_state" = addblends)
		standing_icon.Blend(addblend_icon, ICON_ADD)

//STUB
/obj/item/proc/apply_custom(icon/standing_icon)
	return standing_icon

//STUB
/obj/item/proc/apply_blood(mutable_appearance/standing)
	return standing

//STUB
/obj/item/proc/apply_accessories(mutable_appearance/standing)
	return standing

