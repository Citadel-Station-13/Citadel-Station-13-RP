/// global slot meta cache - all ids must be string!
GLOBAL_LIST_INIT(inventory_slot_meta, init_inventory_slot_meta())

/proc/init_inventory_slot_meta()
	. = list()
	for(var/path in subtypesof(/datum/inventory_slot_meta))
		var/datum/inventory_slot_meta/M = path
		if(initial(M.abstract_type) == path)
			continue
		M = new path
		if(!M.id)
			stack_trace("no ID on [path], skipping")
			continue
		.[M.id] = M

/proc/all_inventory_slot_ids()
	. = list()
	for(var/id in GLOB.inventory_slot_meta)
		. += id

/**
 * returns inventory slot meta for an id
 *
 * **You must use a typepath for hardcoded datums.**
 * String IDs are not automatically converted to paths for speed.
 */
/proc/resolve_inventory_slot_meta(datum/inventory_slot_meta/id)
	RETURN_TYPE(/datum/inventory_slot_meta)
	if(istype(id))
		return id
	else if(ispath(id))
		id = inventory_slot_type_to_id(id)
	return GLOB.inventory_slot_meta[id]

/**
 * get inventory slot meta id of a typepath
 */
/proc/inventory_slot_type_to_id(type)
	var/datum/inventory_slot_meta/M = type
	return initial(M.id)

/**
 * inventory slot meta
 * stores all the required information for an inventory slot
 *
 * **Typepaths for these are used directly in most circumstances of slot IDs**
 * **Use get_inventory_slot_meta(id) to automatically translate anything to the static datum.**
 */
/datum/inventory_slot_meta
	/// slot name
	var/name = "unknown"
	/// id
	var/id
	/// next id
	var/static/id_next = 0
	/// abstract type
	var/abstract_type = /datum/inventory_slot_meta
	/// is inventory? if not, this won't be rendered as part of the hud's inventory
	var/is_inventory = FALSE
	/// always show on strip/force equip menu, or only show when full
	var/always_show_on_strip_menu = TRUE
	/// fully abstract - represents "put into something"
	var/is_abstract = FALSE
	/// rendering slot key
	var/render_key
	/// do we render on mob?
	var/is_rendered = TRUE
	/// allow random id?
	var/allow_random_id = FALSE

#warn unit test for id uniqueness

/datum/inventory_slot_meta/New()
	if(allow_random_id && !id)
		id = "[++id_next]"

/datum/inventory_slot_meta/inventory
	abstract_type = /datum/inventory_slot_meta/inventory
	is_inventory = TRUE
	always_show_on_strip_menu = TRUE

/datum/inventory_slot_meta/inventory/back
	name = "back"
	render_key = "back"
	id = SLOT_ID_BACK

/datum/inventory_slot_meta/inventory/uniform
	name = "uniform"
	render_key = "under"
	id = SLOT_ID_UNIFORM

/datum/inventory_slot_meta/inventory/head
	name = "head"
	render_key = "head"
	id = SLOT_ID_HEAD

/datum/inventory_slot_meta/inventory/suit
	name = "outerwear"
	render_key = "suit"
	id = SLOT_ID_SUIT

/datum/inventory_slot_meta/inventory/belt
	name = "belt"
	render_key = "belt"
	id = SLOT_ID_BELT

/datum/inventory_slot_meta/inventory/pocket
	abstract_type = /datum/inventory_slot_meta/inventory/pocket
	is_rendered = FALSE

/datum/inventory_slot_meta/inventory/pocket/left
	name = "left pocket"
	id = SLOT_ID_LEFT_POCKET

/datum/inventory_slot_meta/inventory/pocket/right
	name = "right pocket"
	id = SLOT_ID_RIGHT_POCKET

/datum/inventory_slot_meta/inventory/id
	name = "id"
	render_key = "id"
	id = SLOT_ID_WORN_ID

/datum/inventory_slot_meta/inventory/shoes
	name = "shoes"
	render_key = "shoes"
	id = SLOT_ID_SHOES

/datum/inventory_slot_meta/inventory/gloves
	name = "gloves"
	render_key = "gloves"
	id = SLOT_ID_GLOVES

/datum/inventory_slot_meta/inventory/glasses
	name = "glasses"
	render_key = "glasses"
	id = SLOT_ID_GLASSES

/datum/inventory_slot_meta/inventory/suit_storage
	name = "suit storage"
	render_key = "suit-store"
	id = SLOT_ID_SUIT_STORAGE

/datum/inventory_slot_meta/inventory/ears
	abstract_type = /datum/inventory_slot_meta/inventory/ears

/datum/inventory_slot_meta/inventory/ears/left
	name = "left ear"
	render_key = "ear-l"
	id = SLOT_ID_LEFT_EAR

/datum/inventory_slot_meta/inventory/ears/right
	name = "right ear"
	render_key = "ear-r"
	id = SLOT_ID_RIGHT_EAR

/datum/inventory_slot_meta/inventory/mask
	name = "mask"
	render_key = "mask"
	id = SLOT_ID_MASK

/datum/inventory_slot_meta/restraints
	is_inventory = FALSE
	always_show_on_strip_menu = FALSE
	abstract_type = /datum/inventory_slot_meta/restraints

/datum/inventory_slot_meta/restraints/handcuffs
	name = "handcuffed"
	render_key = "handcuffs"
	id = SLOT_ID_HANDCUFFED

/datum/inventory_slot_meta/restraints/legcuffs
	name = "legcuffed"
	render_key = "legcuffs"
	id = SLOT_ID_LEGCUFFED

/**
 * these have no excuse to be accessed by id
 * they will have randomized ids
 */
/datum/inventory_slot_meta/abstract
	is_inventory = FALSE
	always_show_on_strip_menu = FALSE
	is_abstract = FALSE
	is_rendered = FALSE
	abstract_type = /datum/inventory_slot_meta/abstract
	allow_random_id = TRUE

/datum/inventory_slot_meta/abstract/put_in_hands
	name = "put in hands"
	id = SLOT_ID_HANDS

/datum/inventory_slot_meta/abstract/attach_as_accessory
	name = "attach as accessory"

/datum/inventory_slot_meta/abstract/put_in_backpack
	name = "put in backpack"

/datum/inventory_slot_meta/abstract/put_in_belt
	name = "put in belt"

/datum/inventory_slot_meta/abstract/put_in_storage
	name = "put in storage"

/datum/inventory_slot_meta/abstract/left_hand
	name = "put in left hand"

/datum/inventory_slot_meta/abstract/right_hand
	name = "put in right hand"
