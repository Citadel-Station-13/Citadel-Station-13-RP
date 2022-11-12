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
	button_groups = list()
	for(var/i in 1 to categories.len)
		if(ispath(categories[i]))
			var/path = categories[i]
			var/datum/skin_menu_category/C = new path(src)
			categories[i] = C
			// category will init in /New(), so...
			for(var/datum/skin_menu_entry/E as anything in C.entries)
				// again let it runtime if it's bad, we WANT it to runtime so integration tests fail
				if(E.group)
					button_groups |= E.group
				if(E.is_default)
					button_groups[E.group] = E.id
		else
			continue	// wtf? let it runtime later
	// verify
	for(var/group in button_groups)
		if(!button_groups[group])
			stack_trace("no default for group [group]")

/datum/skin_menu/proc/creation_list(client/C)
	. = list()
	// create categories after
	for(var/datum/skin_menu_category/cat as anything in categories)
		. |= cat.creation_list(C)

/datum/skin_menu/proc/setup(client/C, load = TRUE)
	create_and_bind(C)
	if(load)
		load_settings(C)

/datum/skin_menu/proc/all_entries()
	. = list()
	for(var/datum/skin_menu_category/C as anything in categories)
		for(var/datum/skin_menu_entry/E as anything in C.entries)
			if(istype(C, /datum/skin_menu_entry/spacer))
				continue
			. += E

/datum/skin_menu/proc/load_settings(client/C)
	// let's like, not do that before they load
	UNTIL(C.prefs.initialized)
	// basically we need to load saved settings, and default if not
	for(var/datum/skin_menu_entry/E as anything in all_entries())
		if(!E.checkbox || !E.is_saved)
			continue	// don't care
		// don't load groups, they only load enable, not disable
		if(E.group)
			// we, do, however, want to load *unchecking* it.
			winset(C, E.id, "is-checked=false")
			continue
		// load anything else
		var/enabled = C.prefs.skin[E.id]
		if(isnull(enabled))
			// default
			enabled = E.is_default
			// save it while we're at it
			E.save(C, enabled)
		E.load(C, enabled)
	// we do need to load groups if possible
	for(var/group in button_groups)
		var/choice = C.prefs.skin[group]
		var/datum/skin_menu_entry/E
		if(isnull(choice) || !GLOB.skin_menu_entries[choice])
			// default if null or if choice doesn't exist anymore
			E = GLOB.skin_menu_entries[button_groups[group]]
			// save it while we're at it
			E.save(C, TRUE)
		else
			E = GLOB.skin_menu_entries[choice]
		E.load(C, TRUE)

/datum/skin_menu/proc/create_and_bind(client/C)
	// menu creation is special
	// we must winclone; skin must not have a control named "menu"
	winclone(C, SKIN_ID_ABSTRACT_MENU, id)
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
		var/datum/skin_menu_entry/entry
		if(isnull(path))
			entry = new /datum/skin_menu_entry/spacer(src)
		else if(ispath(path))
			entry = new path(src)
		else
			continue	// wtf? let it runtime later
		entries[i] = entry

/datum/skin_menu_category/proc/creation_list(client/C)
	. = list()
	// create us first
	.[id] = list2params(list(
		"parent" = menu.id,
		"name" = name,
	))
	// create our children
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
	/**
	 * command to execute; \n to execute multiple.
	 * this datum will also inject our own command for synchronization automatically.
	 * generate_command() overrides this.
	 */
	var/command
	/// do we have a button group? checkbox is required for this; we will NOT load disabled for groups!
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
	/// default load_command_enabled to command
	var/load_command_default = FALSE
	/// is saved? only applicable for checkboxes
	var/is_saved = TRUE
	/// cached creation parameters
	var/cached_constructor
	/// category we belong to
	var/datum/skin_menu_category/category

/datum/skin_menu_entry/New(datum/skin_menu_category/category)
	src.category = category
	cache_constructor()
	if(load_command_default)
		load_command_enabled = generate_command(TRUE)
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
	if(!checkbox || !is_saved)
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
		C.menu_buttons_checked[id] = TRUE
		if(group)
			C.menu_group_status[group] = id
	else
		C.menu_buttons_checked -= id
		// we assume group is taken care of by the other item overwriting it.
	winset(C, id, "is-checked=[enabled? "true" : "false"]")

/datum/skin_menu_entry/proc/save(client/C, enabled)
	if(!checkbox || !is_saved)
		return	// we don't care
	if(group)
		C.prefs.set_skin_data(group, id)
	else
		C.prefs.set_skin_data(id, enabled)

/**
 * called when someone presses us; using usr here is fine as this should only be called from verb anyways!
 */
/datum/skin_menu_entry/proc/pressed(client/C, new_checked)
	save(C, new_checked)
	if(!checkbox)
		return	// don't care
	if(group && new_checked)
		C.menu_group_status[group] = id
	else
		if(new_checked)
			C.menu_buttons_checked[id] = TRUE
		else
			C.menu_buttons_checked -= id

/datum/skin_menu_entry/proc/load_command_enabled(client/C)
	CRASH("why did the proc get called without an override?")

/datum/skin_menu_entry/proc/load_command_disabled(client/C)
	CRASH("why did the proc get called without an override?")

/**
 * generates our normal command
 *
 * ! WARNING !
 * While loading, you CANNOT use chained commands with \n.
 */
/datum/skin_menu_entry/proc/generate_command(loading)
	return command

/**
 * should omit id, that'll be set separately
 */
/datum/skin_menu_entry/proc/creation_parameters()
	var/list/params = list()
	params["parent"] = category.id
	params["command"] = ".menutrigger \"[id]\" \[\[is-checked\]\]\n[generate_command()]"
	params["name"] = name
	if(group)
		params["group"] = group
	params["is-checked"] = is_default? "true" : "false"
	params["can-check"] = checkbox? "true" : "false"
	return list2params(params)

/datum/skin_menu_entry/proc/cache_constructor()
	cached_constructor = creation_parameters()

/**
 * the empty entry used as a spacer
 */
/datum/skin_menu_entry/spacer
	id = null
	name = null
	/// next id
	var/static/next_id = 0

/datum/skin_menu_entry/spacer/New()
	..()
	id = "menubutton_spacer_[++next_id]"

/datum/skin_menu_entry/spacer/register()
	return

/datum/skin_menu_entry/spacer/unregister()
	return

/datum/skin_menu_entry/spacer/creation_parameters()
	return list2params(list(
		parent = category.id,
		name = ""
	))

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
	return menu_group_status[group]

/**
 * gets if a button is checked
 */
/client/proc/menu_button_checked(id)
	return menu_buttons_checked[id]

/**
 * executes a command
 */
/client/proc/menu_run_command(str)
	winset(src, null, list2params(list("command" = str)))
