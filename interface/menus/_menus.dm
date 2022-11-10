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
	/// during initial build, we will construct groups list
	var/list/button_groups

/datum/skin_menu/New()
	init_categories()

/datum/skin_menu/Destroy()
	QDEL_LIST(categories)
	button_groups = null
	return ..()

/datum/skin_menu/proc/init_entries()

/datum/skin_menu/proc/creation_list(client/C)

/datum/skin_menu/proc/setup(client/C)
	create_and_bind(C)
	load_settings(C)

/datum/skin_menu/proc/load_settings(client/C)

/datum/skin_menu/proc/create_and_bind(client/C)
	var/list/creation = creation_list(C)
	for(var/id in creation)
		winset(C, id, creation[id])

//! skin menu categories
/datum/skin_menu_category
	/// id - used for both skin and savefiles
	var/id
	/// name
	var/name
	/// entry datum types - transformed into datums at runtime
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

/datum/skin_menu_category/proc/

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
	/// are we the default for the group?
	var/default
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

/datum/skin_menu_entry/proc/load(client/C)

/datum/skin_menu_entry/proc/save(client/C, enabled)

/datum/skin_menu_entry/proc/pressed(client/C)

/datum/skin_menu_entry/proc/load_command_enabled(client/C)
	CRASH("why did the proc get called without an override?")

/datum/skin_menu_entry/proc/load_command_disabled(client/C)
	CRASH("why did the proc get called without an override?")

/**
 * should omit id, that'll be set separately
 */
/datum/skin_menu_entry/proc/creation_parameters()

/datum/skin_menu_entry/proc/cache_constructor()
	cached_constructor = creation_parameters()

//! client stuff needed to make this work
/client/verb/menu_button_triggered(id as text)
	set name = ".menutrigger"
	set hidden = TRUE

	var/datum/skin_menu_entry/E = GLOB.skin_menu_entries[id]
	if(!E)
		stack_trace("no entry found for [id], triggered by [src]")
		to_chat(usr, SPAN_WARNING("error: no menu entry found; this is a bug. id: [id]"))
		return
	E.pressed(src)
