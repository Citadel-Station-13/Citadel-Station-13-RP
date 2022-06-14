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
 *
 * ABSTRACT SLOTS:
 * Abstract slots attempts to do something special, based on mob.
 * They only work on equips - can_equip, and anything unrelating to unequips, cannot check for it well.
 * Can equip supports some abstract slots but not others.
 */
/datum/inventory_slot_meta
	/// slot name
	var/name = "unknown"
	/// player friendly name
	var/display_name = "unknown"
	/// player friendly preposition
	var/display_preposition = "on"
	/// is this a "plural" slot?
	var/display_plural = FALSE
	/// id
	var/id
	/// next id
	var/static/id_next = 0
	/// abstract type
	var/abstract_type = /datum/inventory_slot_meta
	/// is inventory? if not, this won't be rendered as part of the hud's inventory
	var/is_inventory = FALSE
	/// hide unless inventory is expanded
	var/display_requires_expand = TRUE
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
	/// our screen loc
	var/hud_position

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
	display_requires_expand = FALSE
	display_name = "back"
	display_preposition = "on"
	hud_position = ui_back

/datum/inventory_slot_meta/inventory/uniform
	name = "uniform"
	render_key = "under"
	id = SLOT_ID_UNIFORM
	display_name = "body"
	display_preposition = "on"
	hud_position = ui_iclothing

/datum/inventory_slot_meta/inventory/head
	name = "head"
	render_key = "head"
	id = SLOT_ID_HEAD
	display_name = "back"
	display_preposition = "on"
	display_name = "head"
	display_preposition = "on"
	hud_position = ui_head

/datum/inventory_slot_meta/inventory/suit
	name = "outerwear"
	render_key = "suit"
	id = SLOT_ID_SUIT
	display_name = "clohtes"
	display_preposition = "over"
	hud_position = ui_oclothing

/datum/inventory_slot_meta/inventory/belt
	name = "belt"
	render_key = "belt"
	id = SLOT_ID_BELT
	display_requires_expand = FALSE
	display_name = "waist"
	display_preposition = "on"
	hud_position = ui_belt

/datum/inventory_slot_meta/inventory/pocket
	abstract_type = /datum/inventory_slot_meta/inventory/pocket
	is_rendered = FALSE
	display_requires_expand = FALSE

/datum/inventory_slot_meta/inventory/pocket/left
	name = "left pocket"
	id = SLOT_ID_LEFT_POCKET
	display_name = "left pocket"
	display_preposition = "in"
	hud_position = ui_storage1

/datum/inventory_slot_meta/inventory/pocket/right
	name = "right pocket"
	id = SLOT_ID_RIGHT_POCKET
	display_name = "right pocket"
	display_preposition = "in"
	hud_position = ui_storage2

/datum/inventory_slot_meta/inventory/id
	name = "id"
	render_key = "id"
	id = SLOT_ID_WORN_ID
	display_requires_expand = FALSE
	display_name = "badge"
	display_preposition = "as"
	hud_position = ui_id

/datum/inventory_slot_meta/inventory/shoes
	name = "shoes"
	render_key = "shoes"
	id = SLOT_ID_SHOES
	display_name = "feet"
	display_preposition = "on"
	hud_position = ui_shoes

/datum/inventory_slot_meta/inventory/gloves
	name = "gloves"
	render_key = "gloves"
	id = SLOT_ID_GLOVES
	display_name = "hands"
	display_preposition = "on"
	hud_position = ui_gloves

/datum/inventory_slot_meta/inventory/glasses
	name = "glasses"
	render_key = "glasses"
	id = SLOT_ID_GLASSES
	display_name = "eyes"
	display_preposition = "over"
	hud_position = ui_glasses

/datum/inventory_slot_meta/inventory/suit_storage
	name = "suit storage"
	render_key = "suit-store"
	id = SLOT_ID_SUIT_STORAGE
	display_requires_expand = FALSE
	display_name = "suit"
	display_preposition = "on"
	hud_position = ui_sstore1

/datum/inventory_slot_meta/inventory/ears
	abstract_type = /datum/inventory_slot_meta/inventory/ears

/datum/inventory_slot_meta/inventory/ears/left
	name = "left ear"
	render_key = "ear-l"
	id = SLOT_ID_LEFT_EAR
	display_name = "left ear"
	display_preposition = "on"
	hud_position = ui_l_ear

/datum/inventory_slot_meta/inventory/ears/right
	name = "right ear"
	render_key = "ear-r"
	id = SLOT_ID_RIGHT_EAR
	display_name = "left ear"
	display_preposition = "on"
	hud_position = ui_r_ear

/datum/inventory_slot_meta/inventory/mask
	name = "mask"
	render_key = "mask"
	id = SLOT_ID_MASK
	display_name = "face"
	display_preposition = "on"
	hud_position = ui_mask

/datum/inventory_slot_meta/restraints
	is_inventory = FALSE
	always_show_on_strip_menu = FALSE
	abstract_type = /datum/inventory_slot_meta/restraints

/datum/inventory_slot_meta/restraints/handcuffs
	name = "handcuffed"
	render_key = "handcuffs"
	id = SLOT_ID_HANDCUFFED
	display_name = "hands"
	display_preposition = "around"

/datum/inventory_slot_meta/restraints/legcuffs
	name = "legcuffed"
	render_key = "legcuffs"
	id = SLOT_ID_LEGCUFFED
	display_name = "legs"
	display_preposition = "around"

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
	display_requires_expand = FALSE
	display_name = "hands"
	display_preposition = "in"
	display_plural = TRUE

/datum/inventory_slot_meta/abstract/attach_as_accessory
	name = "attach as accessory"
	display_name = "clothes"
	display_preposition = "clipped to"

/datum/inventory_slot_meta/abstract/put_in_backpack
	name = "put in backpack"
	display_name = "backpack"
	display_preposition = "in"

/datum/inventory_slot_meta/abstract/put_in_belt
	name = "put in belt"
	display_name = "belt"
	display_preposition = "in"

/datum/inventory_slot_meta/abstract/put_in_storage
	name = "put in storage"
	display_name = "storage"
	display_preposition = "in"

/datum/inventory_slot_meta/abstract/left_hand
	name = "put in left hand"
	display_name = "left hand"
	display_preposition = "in"

/datum/inventory_slot_meta/abstract/right_hand
	name = "put in right hand"
	display_name = "right hand"
	display_preposition = "in"
