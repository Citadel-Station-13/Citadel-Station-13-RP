/obj/item/clothing/suit/storage
	//* Directly passed to storage system. *//

	var/list/insertion_whitelist
	var/list/insertion_blacklist
	var/list/insertion_allow

	var/max_single_weight_class = WEIGHT_CLASS_SMALL
	var/max_combined_weight_class
	var/max_combined_volume = WEIGHT_VOLUME_SMALL * 4
	var/max_items

	var/weight_subtract = 0
	var/weight_multiply = 1

	var/allow_mass_gather = FALSE
	var/allow_mass_gather_mode_switch = TRUE
	var/mass_gather_mode = STORAGE_QUICK_GATHER_COLLECT_ALL

	var/allow_quick_empty = FALSE
	var/allow_quick_empty_via_clickdrag = TRUE
	var/allow_quick_empty_via_attack_self = TRUE

	var/sfx_open = "rustle"
	var/sfx_insert = "rustle"
	var/sfx_remove = "rustle"

	var/ui_numerical_mode = FALSE

	//* Initialization *//

	/// storage datum path
	var/storage_datum_path = /datum/object_system/storage
	/// Cleared after Initialize().
	/// List of types associated to amounts.
	var/list/starts_with
	/// set to prevent us from spawning starts_with
	var/empty = FALSE

/obj/item/clothing/suit/storage/Initialize(mapload)
	. = ..()
	initialize_storage()
	spawn_contents()

/**
 * Make sure to set [worth_dynamic] to TRUE if this does more than spawning what's in starts_with.
 */
/obj/item/clothing/suit/storage/proc/spawn_contents()
	if(length(starts_with) && !empty)
		// this is way too permissive already
		var/safety = 256
		var/atom/where_real_contents = obj_storage.real_contents_loc()
		for(var/path in starts_with)
			var/amount = starts_with[path] || 1
			for(var/i in 1 to amount)
				if(!--safety)
					CRASH("tried to spawn too many objects")
				new path(where_real_contents)
	starts_with = null

/obj/item/clothing/suit/storage/proc/initialize_storage()
	ASSERT(isnull(obj_storage))
	init_storage(storage_datum_path, TRUE)
	obj_storage.set_insertion_allow(insertion_allow)
	obj_storage.set_insertion_whitelist(insertion_whitelist)
	obj_storage.set_insertion_blacklist(insertion_blacklist)

	obj_storage.max_single_weight_class = max_single_weight_class
	obj_storage.max_combined_weight_class = max_combined_weight_class
	obj_storage.max_combined_volume = max_combined_volume
	obj_storage.max_items = max_items

	obj_storage.weight_subtract = weight_subtract
	obj_storage.weight_multiply = weight_multiply

	obj_storage.allow_mass_gather = allow_mass_gather
	obj_storage.allow_mass_gather_mode_switch = allow_mass_gather_mode_switch
	obj_storage.mass_gather_mode = mass_gather_mode

	obj_storage.allow_quick_empty = allow_quick_empty
	obj_storage.allow_quick_empty_via_clickdrag = allow_quick_empty_via_clickdrag
	obj_storage.allow_quick_empty_via_attack_self = allow_quick_empty_via_attack_self

	obj_storage.sfx_open = sfx_open
	obj_storage.sfx_insert = sfx_insert
	obj_storage.sfx_remove = sfx_remove

	obj_storage.ui_numerical_mode = ui_numerical_mode

/obj/item/clothing/suit/storage/toggle/AltClick()	// This only works for things that can be toggled, of course.
	..()
	ToggleButtons()

//Jackets with buttons, used for labcoats, IA jackets, First Responder jackets, and brown jackets.
/obj/item/clothing/suit/storage/toggle
	inv_hide_flags = HIDEHOLSTER
	var/open = 0	//0 is closed, 1 is open, -1 means it won't be able to toggle
	action_button_name = "Toggle Coat Buttons"

/obj/item/clothing/suit/storage/toggle/ui_action_click()
	ToggleButtons()

/obj/item/clothing/suit/storage/toggle/proc/ToggleButtons()
	if(open == 1) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
		open = 0
		icon_state = initial(icon_state)
		inv_hide_flags = HIDETIE|HIDEHOLSTER
		to_chat(usr, "You button up the coat.")
	else if(open == 0)
		open = 1
		icon_state = "[icon_state]_open"
		inv_hide_flags = HIDEHOLSTER
		to_chat(usr, "You unbutton the coat.")
	else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
		to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how silly you are.")
		return
	update_worn_icon()	//so our overlays update


/obj/item/clothing/suit/storage/hooded/toggle
	inv_hide_flags = HIDEHOLSTER
	var/open = 0	//0 is closed, 1 is open, -1 means it won't be able to toggle

/obj/item/clothing/suit/storage/hooded/toggle/verb/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr
	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		return 0

	if(open == 1) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
		open = 0
		icon_state = initial(icon_state)
		inv_hide_flags = HIDETIE|HIDEHOLSTER
		to_chat(usr, "You button up the coat.")
	else if(open == 0)
		open = 1
		icon_state = "[icon_state]_open"
		inv_hide_flags = HIDEHOLSTER
		to_chat(usr, "You unbutton the coat.")
	else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
		to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how silly you are.")
		return
	update_worn_icon()	//so our overlays update

/obj/item/clothing/suit/storage/vest
	var/icon_badge
	var/icon_nobadge

/obj/item/clothing/suit/storage/vest/verb/toggle()
	set name ="Adjust Badge"
	set category = "Object"
	set src in usr
	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		return 0

	if(icon_state == icon_badge)
		icon_state = icon_nobadge
		to_chat(usr, "You conceal \the [src]'s badge.")
	else if(icon_state == icon_nobadge)
		icon_state = icon_badge
		to_chat(usr, "You reveal \the [src]'s badge.")
	else
		to_chat(usr, "\The [src] does not have a badge.")
		return
	update_worn_icon()
