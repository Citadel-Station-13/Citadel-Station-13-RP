/obj/machinery/computer/guestpass
	name = "guest pass terminal"
	desc = "A terminal allowing one to issue guest passes for other crewmembers with their access."
	icon_state = "guest"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	icon_keyboard = null
	icon_screen = "pass"
	depth_projected = FALSE
	climb_allowed = FALSE
	density = FALSE
	circuit = /obj/item/circuitboard/guestpass

	/// authing card
	var/obj/item/card/id/giver
	/// selected access ids
	var/list/selected = list()
	/// giving name
	var/guest_name
	/// giving reason
	var/guest_reason
	/// duration in minutes
	var/duration = 5
	/// max duration in minutes
	var/max_duration = 120
	/// min duration in minutes
	var/min_duration = 5

	/// prints left
	var/prints_left = 5
	/// print recharge time
	var/print_recharge = 20 SECONDS
	/// print recharge timerid
	var/print_timer

/obj/machinery/computer/guestpass/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("Alt-click to eject the ID inside, if there is any.")

/obj/machinery/computer/guestpass/Initialize(mapload)
	. = ..()
	// todo: this is not a real uid
	uid = "[rand(100,999)]-G[rand(10,99)]"

/obj/machinery/computer/guestpass/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/card/id))
		if(istype(I, /obj/item/card/id/guest))
			user.action_feedback(SPAN_WARNING("\the [src] will not accept other guest passes."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(isnull(giver))
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			insert_id(I)
			user.action_feedback(SPAN_NOTICE("You insert [I] into \the [src]."), src)
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		else
			user.action_feedback(SPAN_WARNING("There is already an ID card inside."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

// todo: altclick radials?? refactor??
/obj/machinery/computer/guestpass/AltClick(mob/user)
	if(user.Adjacent(src))
		if(!isnull(giver))
			user.grab_item_from_interacted_with(giver, src)
			user.visible_message(SPAN_NOTICE("[user] grabs a card out of [src]."), SPAN_NOTICE("You grab [giver] out of [src]."))
			eject_id(drop_location())
			return TRUE
		else
			user.action_feedback(SPAN_WARNING("[src] has no ID in it!"), src)
			return TRUE
	return ..()

/obj/machinery/computer/guestpass/proc/eject_id(atom/where_to)
	if(giver.loc == src)
		giver.forceMove(where_to)
	giver = null
	selected.len = 0
	push_selected_accesses()
	push_allowed_accesses()
	push_inserted_card()

/obj/machinery/computer/guestpass/proc/insert_id(obj/item/card/id/inserting)
	if(inserting.loc != src)
		inserting.forceMove(src)
	giver = inserting
	push_allowed_accesses()
	push_inserted_card()

/obj/machinery/computer/guestpass/proc/print(mob/user)
	var/obj/item/card/id/guest/issued = new(drop_location())
	issued.prime_for(duration MINUTES, TRUE)
	issued.given_reason = guest_reason || "NOT SPECIFIED"
	issued.registered_name = guest_name || "NOT SPECIFIED"
	issued.rank = "Guest"
	// todo: way to bypass this, maybe with hacking or emag?
	if(!isnull(giver))
		issued.giver_name = giver.registered_name
		issued.giver_rank = giver.assignment || giver.rank
	issued.access = selected.Copy()
	if(user.Adjacent(src))
		user.put_in_hands(issued)

	if(!prints_left)
		return
	--prints_left
	if(!print_timer)
		print_timer = addtimer(CALLBACK(src, PROC_REF(print_cycle)), print_recharge, TIMER_STOPPABLE | TIMER_LOOP)

/obj/machinery/computer/guestpass/proc/print_cycle()
	++prints_left
	if(prints_left >= initial(prints_left))
		prints_left = initial(prints_left)
		if(print_timer)
			deltimer(print_timer)
			print_timer = null

/obj/machinery/computer/guestpass/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["access"] = SSjob.tgui_access_data()
	.["allowed"] = allowed_accesses()
	.["selected"] = selected
	.["durationMax"] = max_duration
	.["durationMin"] = min_duration
	.["auth"] = tgui_inserted_card()

/obj/machinery/computer/guestpass/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["guestName"] = guest_name
	.["guestReason"] = guest_reason
	.["duration"] = duration
	.["printsLeft"] = prints_left

/obj/machinery/computer/guestpass/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GuestPassTerminal")
		ui.open()

/obj/machinery/computer/guestpass/proc/push_selected_accesses()
	push_ui_data(data = list("selected" = selected))

/obj/machinery/computer/guestpass/proc/push_allowed_accesses()
	push_ui_data(data = list("allowed" = allowed_accesses()))

/obj/machinery/computer/guestpass/proc/push_inserted_card()
	push_ui_data(data = list("auth" = tgui_inserted_card()))

/obj/machinery/computer/guestpass/proc/tgui_inserted_card()
	return isnull(giver)? giver : list(
		"name" = giver.name || "-----",
		"owner" = giver.registered_name || "-----",
		"rank" = giver.rank || "Unassigned",
	)

/**
 * allowed access ids
 *
 * this list is assumed to be constant/not-for-edit
 */
/obj/machinery/computer/guestpass/proc/allowed_accesses()
	RETURN_TYPE(/list)
	return isnull(giver)? list() : giver.access

/obj/machinery/computer/guestpass/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return TRUE
	switch(action)
		if("toggle")
			var/id = params["value"]
			if(!(id in allowed_accesses()))
				return TRUE
			if(id in selected)
				selected -= id
			else
				selected += id
			push_selected_accesses()
			return TRUE
		if("grant")
			var/category = params["category"]
			var/list/ids
			var/list/ids_allowed = allowed_accesses()
			if(category)
				ids = SSjob.access_ids_of_category(category) & ids_allowed
			else
				ids = ids_allowed
			selected |= ids
			push_selected_accesses()
			return TRUE
		if("deny")
			var/category = params["category"]
			var/list/ids
			var/list/ids_allowed = allowed_accesses()
			if(category)
				ids = SSjob.access_ids_of_category(category) & ids_allowed
			else
				ids = ids_allowed
			selected -= ids
			push_selected_accesses()
			return TRUE
		if("eject")
			if(isnull(giver))
				var/obj/item/card/id/the_card = usr.get_active_held_item()
				if(!istype(the_card))
					return TRUE
				if(!usr.attempt_insert_item_for_installation(the_card, src))
					return FALSE
				insert_id(the_card)
				usr.action_feedback(SPAN_NOTICE("You insert [the_card] into [src]."), src)
				return TRUE
			var/obj/item/card/id/the_card = usr.get_active_held_item()
			if(istype(the_card) && !usr.attempt_void_item_for_installation(the_card))
				return FALSE
			usr.grab_item_from_interacted_with(giver, src)
			eject_id()
			if(istype(the_card))
				insert_id(the_card)
				usr.action_feedback(SPAN_NOTICE("You quickly swap [the_card] into \the [src]."), src)
			else
				usr.action_feedback(SPAN_NOTICE("You remove [giver] from [src]."), src)
			return TRUE
		if("issue")
			if(prints_left <= 0)
				usr.action_feedback(SPAN_WARNING("[src] cannot print another pass yet!"), src)
				return TRUE
			print(usr)
			return TRUE
		if("name")
			guest_name = params["value"] || "NOT SPECIFIED"
			return TRUE
		if("reason")
			guest_reason = params["value"] || "NOT SPECIFIED"
			return TRUE
		if("duration")
			duration = clamp(text2num(params["value"]), min_duration, max_duration)
			return TRUE
