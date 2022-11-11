//! skin menus
/**
 * dynamic in-code menu system with blackjack and hookers
 */
/datum/skin_menu
	/// id - used for both skin and savefiles
	var/id
	/// id of window to bind to; we will OVERWRITE ANY EXISTING MENU.
	var/bind_to
	/// category datum types - transformed into datums at runtime
	var/list/datum/skin_menu_category/categories
	/// during initial build, we will construct groups list, group name associated to button id for default
	var/list/button_groups

/datum/skin_menu/New()
	init_categories()

/datum/skin_menu/Destroy()
	QDEL_LIST(categories)
	button_groups = null
	return ..()

/datum/skin_menu/proc/init_categories()
	for(var/i in 1 to categories.len)
		if(ispath(categories[i]))
			categories[i] = new categories[i]
		else
			continue	// wtf? let it runtime later

/datum/skin_menu/proc/creation_list(client/C)
	. = list()
	for(var/datum/skin_menu_category/C as anything in categories)
		. |= C.creation_list(C)

/datum/skin_menu/proc/setup(client/C)
	create_and_bind(C)
	load_settings(C)

/datum/skin_menu/proc/load_settings(client/C)
	#warn impl

/datum/skin_menu/proc/create_and_bind(client/C)
	var/list/creation = creation_list(C)
	for(var/id in creation)
		winset(C, id, creation[id])
	winset(C, bind_to, "menu=[id]")

//! skin menu categories
/datum/skin_menu_category
	/// id - used for both skin and savefiles
	var/id
	/// name
	var/name
	/// entry datum types - transformed into datums at runtime; insert a null to create a divider
	var/list/datum/skin_menu_entry/entries
	/// menu we belong to
	var/datum/skin_menu/menu

/datum/skin_menu_category/New(datum/skin_menu/menu)
	src.menu = menu
	init_entries()

/datum/skin_menu_category/Destroy()
	QDEL_LIST(entries)
	return ..()

/datum/skin_menu_category/proc/init_entries()
	for(var/i in 1 to entries.len)
		var/path = entries[i]
		if(isnull(path))
			entries[path] = new /datum/skin_menu_entry/spacer
		else if(ispath(path))
			entries[path] = new path
		else
			continue	// wtf? let it runtime later

/datum/skin_menu_category/proc/creation_list(client/C)
	. = list()
	for(var/datum/skin_menu_entry/E as anything in entries)
		.[E.id] = E.cached_constructor

//! skin menu entries
/// lookup for skin menu entries
GLOBAL_LIST_EMPTY(skin_menu_entries)
/datum/skin_menu_entry
	/// id - used for both skin and savefiles
	var/id
	/// name
	var/name
	/** command to execute; \n to execute multiple.
	 * this datum will also inject our own command for synchronization automatically.
	 */
	var/command
	/// do we have a button group? checkbox is required for this
	var/group
	/// default enabled for checkable? only one in a group can have this!! infact, only one in a group **MUST** have tihs!!
	var/is_default = FALSE
	/// checkable?
	var/checkbox = FALSE
	/// command to execute, if any, when loading prefs if we're checked
	var/load_command_enabled
	/// command to execute, if any, when loading prefs if we're unchecked
	var/load_command_disabled
	/// use proc for load command
	var/load_command_proc = FALSE
	/// cached creation parameters
	var/cached_constructor
	/// category we belong to
	var/datum/skin_menu_category/category

/datum/skin_menu_entry/New(datum/skin_menu_category/category)
	src.category = category
	cache_constructor()
	register()

/datum/skin_menu_entry/Destroy()
	unregister()
	return ..()

/datum/skin_menu_entry/proc/register()
	if(GLOB.skin_menu_entries[id])
		stack_trace("warning: collision on [id] between [src] and [GLOB.skin_menu_entries[id]]; overwriting...")
	GLOB.skin_menu_entries[id] = src

/datum/skin_menu_entry/proc/unregister()
	GLOB.skin_menu_entries -= id

/datum/skin_menu_entry/proc/load(client/C, enabled)
	if(!checkbox)
		return	// why do we care?
	var/command
	if(load_command_proc)
		if(enabled)
			command = load_command_enabled(C)
		else
			command = load_command_enabled(C)
	else
		if(enabled)
			command = load_command_enabled
		else
			command = load_command_disabled
	if(command)
		C.menu_run_command(command)
	if(enabled)
		LAZYSET(C.menu_buttons_checked, id, TRUE)
		if(group)
			LAZYSET(C.menu_group_statuses, group, id)
	winset(C, id, "is-checked=[enabled? "true" : "false"]")

/datum/skin_menu_entry/proc/save(client/C, enabled)
	if(!checkbox)
		return	// we don't care
	if(group)
		C.prefs.save_skin_data(group, id)
	else
		C.prefs.save_skin_data(id, enabled)

/datum/skin_menu_entry/proc/pressed(client/C, new_checked)
	if(!checkbox)
		return	// we don't care
	save(C, new_enabled)

/datum/skin_menu_entry/proc/load_command_enabled(client/C)
	CRASH("why did the proc get called without an override?")

/datum/skin_menu_entry/proc/load_command_disabled(client/C)
	CRASH("why did the proc get called without an override?")

/**
 * generates our normal command
 */
/datum/skin_menu_entry/proc/generate_command()
	return command

/**
 * should omit id, that'll be set separately
 */
/datum/skin_menu_entry/proc/creation_parameters()
	var/list/params = list()
	params["parent"] = category.id
	params["type"] = "menu"
	var/built = "[generate_command()]\n.menutrigger [id] \[\[is-checked\]\]"
	params["command"] = built
	params["name"] = name
	if(group)
		params["group"] = group
	params["is-checked"] = is_default? "true" : "false"
	params["can-check"] = checkbox? "true" : "false"

/datum/skin_menu_entry/proc/cache_constructor()
	cached_constructor = creation_parameters()

/**
 * the empty entry used as a spacer
 */
/datum/skin_menu_entry/spacer
	id = null
	name = null

//! client stuff needed to make this work
/client/verb/menu_button_triggered(id as text, checked as num)
	set name = ".menutrigger"
	set hidden = TRUE

	var/datum/skin_menu_entry/E = GLOB.skin_menu_entries[id]
	if(!E)
		stack_trace("no entry found for [id], triggered by [src]")
		to_chat(usr, SPAN_WARNING("error: no menu entry found; this is a bug. id: [id]"))
		return
	E.pressed(src, checked)

/**
 * gets which button of a group we have selected
 */
/client/proc/menu_group_query(group)
	return menu_group_statuses[group]

/**
 * gets if a button is checked
 */
/client/proc/menu_button_checked(id)
	return menu_buttons_checked[id]

/**
 * executes a command
 */
/client/proc/menu_run_command(str)
	winset(src, null, "command=[str]")
