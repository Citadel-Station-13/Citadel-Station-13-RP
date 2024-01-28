

// External storage-related logic:
// /mob/proc/ClickOn() in /_onclick/click.dm - clicking items in storages
// /mob/living/Move() in /modules/mob/living/living.dm - hiding storage boxes on mob movement

/datum/component/storage
	var/silent = FALSE								//whether this makes a message when things are put in.
	var/rustle_sound = TRUE							//play rustle sound on interact.
	var/quickdraw = FALSE							//altclick interact
	var/datum/action/item_action/storage_gather_mode/modeswitch_action

/datum/component/storage/Initialize(datum/component/storage/concrete/master)
	update_actions()

/datum/component/storage/proc/update_actions()
	QDEL_NULL(modeswitch_action)
	if(!isitem(parent) || !allow_quick_gather)
		return
	var/obj/item/I = parent
	modeswitch_action = new(I)
	RegisterSignal(modeswitch_action, COMSIG_ACTION_TRIGGER, .proc/action_trigger)
	if(I.obj_flags & IN_INVENTORY)
		var/mob/M = I.loc
		if(!istype(M))
			return
		modeswitch_action.Grant(M)

/datum/component/storage/proc/preattack_intercept(datum/source, obj/O, mob/M, params)
	if(!isitem(O) || !click_gather || SEND_SIGNAL(O, COMSIG_CONTAINS_STORAGE))
		return FALSE
	. = COMPONENT_NO_ATTACK
	if(check_locked(source, M, TRUE))
		return FALSE
	var/atom/A = parent
	var/obj/item/I = O
	if(collection_mode == COLLECT_ONE)
		if(can_be_inserted(I, null, M))
			handle_item_insertion(I, null, M)
			A.do_squish()
		return
	if(!isturf(I.loc))
		return
	var/list/things = I.loc.contents.Copy()
	if(collection_mode == COLLECT_SAME)
		things = typecache_filter_list(things, typecacheof(I.type))
	var/len = length(things)
	if(!len)
		to_chat(M, "<span class='notice'>You failed to pick up anything with [parent].</span>")
		return
	var/datum/progressbar/progress = new(M, len, I.loc)
	var/list/rejections = list()
	while(do_after(M, 10, TRUE, parent, FALSE, CALLBACK(src, .proc/handle_mass_pickup, things, I.loc, rejections, progress)))
		stoplag(1)
	qdel(progress)
	to_chat(M, "<span class='notice'>You put everything you could [insert_preposition] [parent].</span>")
	A.do_squish(1.4, 0.4)

/datum/component/storage/proc/quick_empty(mob/M)
	var/atom/A = parent
	if(!M.canUseStorage() || !A.Adjacent(M) || M.incapacitated())
		return
	if(check_locked(null, M, TRUE))
		return FALSE
	A.add_fingerprint(M)
	to_chat(M, "<span class='notice'>You start dumping out [parent].</span>")
	var/turf/T = get_turf(A)
	var/list/things = contents()
	var/datum/progressbar/progress = new(M, length(things), T)
	while (do_after(M, 10, TRUE, T, FALSE, CALLBACK(src, .proc/mass_remove_from_storage, T, things, progress, TRUE, M)))
		stoplag(1)
	qdel(progress)
	A.do_squish(0.8, 1.2)

/datum/component/storage/proc/do_quick_empty(atom/_target)
	if(!_target)
		_target = get_turf(parent)
	if(usr)
		ui_hide(usr)
	var/list/contents = contents()
	var/atom/real_location = real_location()
	for(var/obj/item/I in contents)
		if(I.loc != real_location)
			continue
		remove_from_storage(I, _target)
	return TRUE

/datum/component/storage/proc/mob_item_insertion_feedback(mob/user, mob/M, obj/item/I, override = FALSE)
	if(silent && !override)
		return
	if(rustle_sound)
		playsound(parent, "rustle", 50, 1, -5)
	to_chat(user, "<span class='notice'>You put [I] [insert_preposition]to [parent].</span>")
	for(var/mob/viewing in fov_viewers(world.view, user)-M)
		if(in_range(M, viewing)) //If someone is standing close enough, they can tell what it is...
			viewing.show_message("<span class='notice'>[M] puts [I] [insert_preposition]to [parent].</span>", MSG_VISUAL)
		else if(I && I.w_class >= 3) //Otherwise they can only see large or normal items from a distance...
			viewing.show_message("<span class='notice'>[M] puts [I] [insert_preposition]to [parent].</span>", MSG_VISUAL)

/datum/component/storage/proc/on_alt_click(datum/source, mob/user)
	if(!isliving(user) || !user.CanReach(parent))
		return
	if(check_locked(source, user, TRUE))
		return TRUE

	var/atom/A = parent
	if(!quickdraw)
		A.add_fingerprint(user)
		user_show_to_mob(user, trigger_on_found = TRUE)
		if(rustle_sound)
			playsound(A, "rustle", 50, 1, -5)
		return TRUE

	if(user.can_hold_items() && !user.incapacitated())
		var/obj/item/I = locate() in real_location()
		if(!I)
			return
		A.add_fingerprint(user)
		remove_from_storage(I, get_turf(user))
		if(!user.put_in_hands(I))
			user.visible_message("<span class='warning'>[user] fumbles with the [parent], letting [I] fall on the floor.</span>", \
								"<span class='notice'>You fumble with [parent], letting [I] fall on the floor.</span>")
			return TRUE
		user.visible_message("<span class='warning'>[user] draws [I] from [parent]!</span>", "<span class='notice'>You draw [I] from [parent].</span>")
		return TRUE

/datum/component/storage/proc/action_trigger(datum/action/source, obj/target)
	gather_mode_switch(source.owner)
	return COMPONENT_ACTION_BLOCK_TRIGGER

/datum/component/storage/proc/gather_mode_switch(mob/user)
	collection_mode = (collection_mode+1)%3
	switch(collection_mode)
		if(COLLECT_SAME)
			to_chat(user, "[parent] now picks up all items of a single type at once.")
		if(COLLECT_EVERYTHING)
			to_chat(user, "[parent] now picks up all items in a tile at once.")
		if(COLLECT_ONE)
			to_chat(user, "[parent] now picks up one item at a time.")
