#define ROD_SLOT_BAIT "bait"
#define ROD_SLOT_LINE "line"
#define ROD_SLOT_HOOK "hook"

/obj/item/fishing_rod
	name = "fishing rod"
	desc = "You can fish with this."
	icon = 'icons/modules/fishing/fishing_rod.dmi'
	icon_state = "rod"
	inhand_icon = 'icons/modules/fishing/fishing_rod_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	damage_force = 8
	w_class = WEIGHT_CLASS_HUGE

	/// How far can you cast this
	var/cast_range = 5
	/// Fishing minigame difficulty modifier (additive)
	var/difficulty_modifier = 0
	/// Explaination of rod functionality shown in the ui
	var/ui_description = "A classic fishing rod, with no special qualities."

	var/obj/item/bait
	var/obj/item/fishing_line/line
	var/obj/item/fishing_hook/hook

	/// Currently hooked item for item reeling
	var/obj/item/currently_hooked_item
	/// hook EVERYTHING
	var/adminbus_hooking = FALSE

	/// Fishing line visual for the hooked item
	var/datum/beam/hooked_item_fishing_line

	/// Are we currently casting
	var/casting = FALSE

	/// List of fishing line beams
	var/list/fishing_lines = list()

	var/default_line_color = "gray"

/obj/item/fishing_rod/Destroy(force)
	. = ..()
	//Remove any leftover fishing lines
	QDEL_LIST(fishing_lines)

/**
 * Catch weight modifier for the given fish_type (or FISHING_DUD)
 * and source, multiplicative. Called before `additive_fish_bonus()`.
 */
/obj/item/fishing_rod/proc/multiplicative_fish_bonus(fish_type, datum/fish_source/source)
	if(!hook)
		return FISHING_DEFAULT_HOOK_BONUS_MULTIPLICATIVE
	return hook.get_hook_bonus_multiplicative(fish_type)

/**
 * Catch weight modifier for the given fish_type (or FISHING_DUD)
 * and source, additive. Called after `multiplicative_fish_bonus()`.
 */
/obj/item/fishing_rod/proc/additive_fish_bonus(fish_type, datum/fish_source/source)
	if(!hook)
		return FISHING_DEFAULT_HOOK_BONUS_ADDITIVE
	return hook.get_hook_bonus_additive(fish_type)

/**
 * Is there a reason why this fishing rod couldn't fish in target_fish_source?
 * If so, return the denial reason as a string, otherwise return `null`.
 *
 * Arguments:
 * * target_fish_source - The /datum/fish_source we're trying to fish in.
 */
/obj/item/fishing_rod/proc/reason_we_cant_fish(datum/fish_source/target_fish_source)
	return hook?.reason_we_cant_fish(target_fish_source)

/obj/item/fishing_rod/proc/consume_bait()
	if(isnull(bait))
		return
	QDEL_NULL(bait)
	SStgui.update_uis(src)
	update_icon()

/obj/item/fishing_rod/on_attack_self(mob/user)
	reel(user)

/obj/item/fishing_rod/proc/reel(mob/user, atom/target)
	// signal first for fishing minigame
	if(SEND_SIGNAL(src, COMSIG_FISHING_ROD_REEL) & FISHING_ROD_REEL_HANDLED)
		return TRUE
	// don't reel if same target
	if(target == currently_hooked_item)
		return FALSE
	if(isnull(currently_hooked_item))
		return FALSE
	. = TRUE
	//Could use sound here for feedback
	if(!do_after(user, 1 SECONDS, currently_hooked_item))
		return
	// Should probably respect and used force move later
	if(currently_hooked_item.anchored)
		return // nah
	step_towards(currently_hooked_item, get_turf(src))
	if(get_dist(currently_hooked_item, get_turf(src)) < 1)
		clear_hooked_item()

/// Generates the fishing line visual from the current user to the target and updates inhands
/obj/item/fishing_rod/proc/create_fishing_line(atom/movable/target, target_py = null)
	var/mob/user = loc
	if(!istype(user))
		return
	var/beam_color = line?.line_color || default_line_color
	var/datum/beam/fishing_line/fishing_line_beam = new(user, target, icon_state = "fishing_line", beam_color = beam_color, override_target_pixel_y = target_py)
	fishing_line_beam.lefthand = user.get_held_index(src) % 2 == 1
	RegisterSignal(fishing_line_beam, COMSIG_BEAM_BEFORE_DRAW, PROC_REF(check_los))
	RegisterSignal(fishing_line_beam, COMSIG_PARENT_QDELETING, PROC_REF(clear_line))
	fishing_lines += fishing_line_beam
	INVOKE_ASYNC(fishing_line_beam, TYPE_PROC_REF(/datum/beam/, Start))
	update_worn_icon()
	return fishing_line_beam

/obj/item/fishing_rod/proc/clear_line(datum/source)
	SIGNAL_HANDLER
	fishing_lines -= source
	update_worn_icon()

/obj/item/fishing_rod/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	if(currently_hooked_item)
		clear_hooked_item()
	for(var/datum/beam/fishing_line in fishing_lines)
		SEND_SIGNAL(fishing_line, COMSIG_FISHING_LINE_SNAPPED)
	QDEL_LIST(fishing_lines)

/// Hooks the item
/obj/item/fishing_rod/proc/hook_item(mob/user, atom/target_atom)
	if(currently_hooked_item)
		return FALSE
	if(!can_be_hooked(target_atom))
		return FALSE
	currently_hooked_item = target_atom
	hooked_item_fishing_line = create_fishing_line(target_atom)
	RegisterSignal(currently_hooked_item, COMSIG_MOVABLE_MOVED, PROC_REF(hooked_item_moved))
	RegisterSignal(hooked_item_fishing_line, COMSIG_FISHING_LINE_SNAPPED, PROC_REF(clear_hooked_item))
	return TRUE

/obj/item/fishing_rod/proc/hooked_item_moved(atom/movable/source)
	if(!isturf(source.loc))
		clear_hooked_item()

/// Checks what can be hooked
/obj/item/fishing_rod/proc/can_be_hooked(atom/movable/target)
	// Could be made dependent on actual hook, ie magnet to hook metallic items
	return hook?.can_hook_atom(target) || adminbus_hooking

/obj/item/fishing_rod/proc/clear_hooked_item()
	SIGNAL_HANDLER

	if(!QDELETED(hooked_item_fishing_line))
		QDEL_NULL(hooked_item_fishing_line)
	UnregisterSignal(currently_hooked_item, COMSIG_MOVABLE_MOVED)
	currently_hooked_item = null

// Checks fishing line for interruptions and range
/obj/item/fishing_rod/proc/check_los(datum/beam/source)
	SIGNAL_HANDLER
	. = NONE

	if(!ismob(loc) || !check_fishing_reach(source.target, loc))
		SEND_SIGNAL(source, COMSIG_FISHING_LINE_SNAPPED) //Stepped out of range or los interrupted
		return BEAM_CANCEL_DRAW

/obj/item/fishing_rod/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()

	// Reel in if able
	if(reel(user, target))
		return

	// break line if same target and didn't reel
	if(target == currently_hooked_item)
		clear_hooked_item()
		return

	// try to fish
	if(try_initiate_fishing(target, user) != null)
		return

	// try to hook item
	if(isitem(target) && try_hook_item(target, user))
		return

	// not a fishing spot or an item
	user.bubble_action_feedback("can't fish there", src)

/**
 * Automatically attempt to try to hook an item
 *
 * @return TRUE / FALSE on success / fail.
 */
/obj/item/fishing_rod/proc/try_hook_item(obj/item/target, mob/user)
	if(!check_fishing_reach(target, user))
		return FALSE
	if(SEND_SIGNAL(target, COMSIG_FISHING_ROD_CAST, src, user) & FISHING_ROD_CAST_HANDLED)
		return FALSE
	return hook_item(user, target)

/**
 * Automatically attempt to start fishing somewhere.
 *
 * @return TRUE / FALSE on success / fail, null if not a fishing spot.
 */
/obj/item/fishing_rod/proc/try_initiate_fishing(atom/target, mob/user)
	if(!check_fishing_reach(target, user))
		return FALSE
	if(SEND_SIGNAL(target, COMSIG_FISHING_ROD_CAST, src, user) & FISHING_ROD_CAST_HANDLED)
		return FALSE
	target.pre_fishing_query()
	var/datum/component/fishing_spot/spot = target.is_fishing_spot()
	if(isnull(spot))
		return null
	return spot.try_start_fishing(src, user)

/obj/item/fishing_rod/proc/check_fishing_reach(atom/target, mob/user)
	if(!isturf(target) && !isturf(target.loc))
		return FALSE // NO
	return user.Reachability(target, depth = 1, range = 5, tool = src)

/obj/item/fishing_rod/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FishingRod", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/item/fishing_rod/update_overlays()
	. = ..()
	var/line_color = line?.line_color || default_line_color
	/// Line part by the rod, always visible
	var/mutable_appearance/reel_overlay = mutable_appearance(icon, "reel")
	reel_overlay.color = line_color;
	. += reel_overlay

	// Line & hook is also visible when only bait is equipped but it uses default appearances then
	if(hook || bait)
		var/mutable_appearance/line_overlay = mutable_appearance(icon, "line")
		line_overlay.color = line_color;
		. += line_overlay
		var/mutable_appearance/hook_overlay = mutable_appearance(icon, hook?.rod_overlay_icon_state || "hook")
		. += hook_overlay

	if(bait)
		var/bait_state = "worm" //default to worm overlay for anything without specific one
		if(istype(bait, /obj/item/reagent_containers/food/snacks/bait))
			var/obj/item/reagent_containers/food/snacks/bait/real_bait = bait
			bait_state = real_bait.rod_overlay_icon_state
		. += bait_state

/obj/item/fishing_rod/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta, icon_used)
	var/slot_key = slot_meta.render_key
	var/line_color = line?.line_color || default_line_color
	var/mutable_appearance/reel_overlay = mutable_appearance(icon_used, "reel_[slot_key]")
	reel_overlay.appearance_flags |= RESET_COLOR
	reel_overlay.color = line_color
	MA.overlays += reel_overlay
	/// if we don't have anything hooked show the dangling hook & line
	if(inhands && length(fishing_lines) == 0)
		var/mutable_appearance/line_overlay = mutable_appearance(icon_used, "line_[slot_key]")
		line_overlay.appearance_flags |= RESET_COLOR
		line_overlay.color = line_color
		MA.overlays += line_overlay
		MA.overlays += mutable_appearance(icon_used, "hook_[slot_key]")
	return ..()

/obj/item/fishing_rod/attackby(obj/item/attacking_item, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(slot_check(attacking_item,ROD_SLOT_LINE))
		use_slot(ROD_SLOT_LINE, user, attacking_item)
		SStgui.update_uis(src)
		return TRUE
	else if(slot_check(attacking_item,ROD_SLOT_HOOK))
		use_slot(ROD_SLOT_HOOK, user, attacking_item)
		SStgui.update_uis(src)
		return TRUE
	else if(slot_check(attacking_item,ROD_SLOT_BAIT))
		use_slot(ROD_SLOT_BAIT, user, attacking_item)
		SStgui.update_uis(src)
		return TRUE
	else if(istype(attacking_item, /obj/item/bait_can)) //Quicker filling from bait can
		var/obj/item/bait_can/can = attacking_item
		var/obj/item/bait = can.retrieve_bait(user)
		if(bait)
			user.put_in_hands_or_drop(bait)
			if(use_slot(ROD_SLOT_BAIT, user, bait))
				user.action_feedback(SPAN_NOTICE("You take a piece of bait out of [can] and hook it onto [src]."), src)
			SStgui.update_uis(src)
		return TRUE
	return ..()

/obj/item/fishing_rod/ui_data(mob/user)
	. = ..()
	var/list/data = list()

	data["bait_name"] = format_text(bait?.name)
	data["bait_icon"] = bait != null ? icon2base64(icon(bait.icon, bait.icon_state)) : null

	data["line_name"] = format_text(line?.name)
	data["line_icon"] = line != null ? icon2base64(icon(line.icon, line.icon_state)) : null

	data["hook_name"] = format_text(hook?.name)
	data["hook_icon"] = hook != null ? icon2base64(icon(hook.icon, hook.icon_state)) : null

	data["description"] = ui_description

	return data

/// Checks if the item fits the slot
/obj/item/fishing_rod/proc/slot_check(obj/item/item,slot)
	if(!istype(item))
		return FALSE
	switch(slot)
		if(ROD_SLOT_HOOK)
			if(!istype(item,/obj/item/fishing_hook))
				return FALSE
		if(ROD_SLOT_LINE)
			if(!istype(item,/obj/item/fishing_line))
				return FALSE
		if(ROD_SLOT_BAIT)
			if(!HAS_TRAIT(item, FISHING_BAIT_TRAIT))
				return FALSE
	return TRUE

/obj/item/fishing_rod/ui_act(action, list/params)
	. = ..()
	if(.)
		return .
	var/mob/user = usr
	switch(action)
		if("slot_action")
			// Simple click with empty hand to remove, click with item to insert/switch
			var/obj/item/held_item = user.get_active_held_item()
			if(held_item == src)
				return
			use_slot(params["slot"], user, held_item)
			return TRUE

/// Ideally this will be replaced with generic slotted storage datum + display
/obj/item/fishing_rod/proc/use_slot(slot, mob/user, obj/item/new_item)
	var/obj/item/current_item
	switch(slot)
		if(ROD_SLOT_BAIT)
			current_item = bait
		if(ROD_SLOT_HOOK)
			current_item = hook
		if(ROD_SLOT_LINE)
			current_item = line
	if(!new_item && !current_item)
		return FALSE
	// Trying to remove the item
	if(!new_item && current_item)
		user.put_in_hands_or_drop(current_item)
		update_icon()
		return TRUE
	// Trying to insert item into empty slot
	if(new_item && !current_item)
		if(!slot_check(new_item, slot))
			return FALSE
		if(user.is_holding(new_item)? user.transfer_item_to_loc(new_item, src) : new_item.forceMove(src))
			switch(slot)
				if(ROD_SLOT_BAIT)
					bait = new_item
				if(ROD_SLOT_HOOK)
					hook = new_item
				if(ROD_SLOT_LINE)
					line = new_item
			update_icon()
	/// Trying to swap item
	if(new_item && current_item)
		if(!slot_check(new_item,slot))
			return FALSE
		if(user.is_holding(new_item)? user.transfer_item_to_loc(new_item, src) : new_item.forceMove(src))
			switch(slot)
				if(ROD_SLOT_BAIT)
					bait = new_item
				if(ROD_SLOT_HOOK)
					hook = new_item
				if(ROD_SLOT_LINE)
					line = new_item
		user.put_in_hands_or_drop(current_item)
		update_icon()
	return TRUE

/obj/item/fishing_rod/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == bait)
		bait = null
	if(gone == line)
		line = null
	if(gone == hook)
		hook = null

/obj/item/fishing_rod/bone
	name = "bone fishing rod"
	desc = "A humble rod, made with whatever happened to be on hand."
	icon_state = "fishing_rod_bone"

/obj/item/fishing_rod/master
	name = "master fishing rod"
	desc = "The mythical rod of a lost fisher king. Said to be imbued with un-paralleled fishing power. There's writing on the back of the pole. \"中国航天制造\""
	difficulty_modifier = -10
	ui_description = "This rods makes fishing easy even for an absolute beginner."
	icon_state = "fishing_rod_master"


/obj/item/fishing_rod/tech
	name = "advanced fishing rod"
	desc = "An embedded universal constructor along with micro-fusion generator makes this marvel of technology never run out of bait. Interstellar treaties prevent using it outside of recreational fishing."
	icon_state = "fishing_rod_science"

/obj/item/fishing_rod/tech/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/food/snacks/bait/doughball/synthetic/infinite_supply_of_bait = new(src)
	bait = infinite_supply_of_bait
	update_icon()

/obj/item/fishing_rod/tech/consume_bait()
	return

/obj/item/fishing_rod/tech/use_slot(slot, mob/user, obj/item/new_item)
	if(slot == ROD_SLOT_BAIT)
		return
	return ..()

#undef ROD_SLOT_BAIT
#undef ROD_SLOT_LINE
#undef ROD_SLOT_HOOK

/datum/beam/fishing_line
	// Is the fishing rod held in left side hand
	var/lefthand = FALSE

/datum/beam/fishing_line/Start()
	update_offsets(origin.dir)
	. = ..()
	RegisterSignal(origin, COMSIG_ATOM_DIR_CHANGE, PROC_REF(handle_dir_change))

/datum/beam/fishing_line/Destroy()
	UnregisterSignal(origin, COMSIG_ATOM_DIR_CHANGE)
	. = ..()

/datum/beam/fishing_line/proc/handle_dir_change(atom/movable/source, olddir, newdir)
	SIGNAL_HANDLER
	update_offsets(newdir)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/beam/, redrawing))

/datum/beam/fishing_line/proc/update_offsets(user_dir)
	switch(user_dir)
		if(SOUTH)
			override_origin_pixel_x = lefthand ? lefthand_s_px : righthand_s_px
			override_origin_pixel_y = lefthand ? lefthand_s_py : righthand_s_py
		if(EAST)
			override_origin_pixel_x = lefthand ? lefthand_e_px : righthand_e_px
			override_origin_pixel_y = lefthand ? lefthand_e_py : righthand_e_py
		if(WEST)
			override_origin_pixel_x = lefthand ? lefthand_w_px : righthand_w_px
			override_origin_pixel_y = lefthand ? lefthand_w_py : righthand_w_py
		if(NORTH)
			override_origin_pixel_x = lefthand ? lefthand_n_px : righthand_n_px
			override_origin_pixel_y = lefthand ? lefthand_n_py : righthand_n_py

// Make these inline with final sprites
/datum/beam/fishing_line
	var/righthand_s_px = 13
	var/righthand_s_py = 16

	var/righthand_e_px = 18
	var/righthand_e_py = 16

	var/righthand_w_px = -20
	var/righthand_w_py = 18

	var/righthand_n_px = -14
	var/righthand_n_py = 16

	var/lefthand_s_px = -13
	var/lefthand_s_py = 15

	var/lefthand_e_px = 24
	var/lefthand_e_py = 18

	var/lefthand_w_px = -17
	var/lefthand_w_py = 16

	var/lefthand_n_px = 13
	var/lefthand_n_py = 15
