//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: DECLARE_CLIENT_VERB
/client/verb/view_playtime()
	set name = "View Playtime"
	set desc = "View your own playtime."
	set category = VERB_CATEGORY_SYSTEM

	if(TIMER_COOLDOWN_CHECK(src, TIMER_CD_INDEX_CLIENT_VIEW_PLAYTIME))
		return
	TIMER_COOLDOWN_START(src, TIMER_CD_INDEX_CLIENT_VIEW_PLAYTIME, 2 SECONDS)

	log_game("[key_name(usr)] invoked view_playtime on [key_name(src)].")

	// todo: self-panel for client maybe? instead of a different datum
	if(!legacy_playtime_viewer)
		legacy_playtime_viewer = new(src)
	legacy_playtime_viewer.ui_interact(mob)

/datum/client_view_playtime
	var/client/owner

/datum/client_view_playtime/New(client/C)
	src.owner = C
	src.owner.persistent.load_playtime()

/datum/client_view_playtime/Destroy()
	if(owner?.legacy_playtime_viewer == src)
		owner.legacy_playtime_viewer = null
	return ..()

/datum/client_view_playtime/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	owner.persistent.block_on_playtime_loaded()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "client/ClientPlaytime")
		ui.open()

/datum/client_view_playtime/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	// TODO: annotate playtime don't just throw raw strings
	.["playtime"] = owner.persistent.playtime_loaded ? owner.persistent.playtime : null

/datum/client_view_playtime/ui_state()
	return GLOB.always_state
