/// global slot meta cache - all ids must be string!
GLOBAL_LIST_INIT(inventory_slot_meta, init_inventory_slot_meta())
/// global slot meta cache by type - only works for hardcoded
GLOBAL_LIST_EMPTY(inventory_slot_type_cache)

/proc/init_inventory_slot_meta()
	. = list()
	GLOB.inventory_slot_meta = .
	GLOB.inventory_slot_type_cache = list()
	for(var/path in subtypesof(/datum/inventory_slot_meta))
		var/datum/inventory_slot_meta/M = path
		if(initial(M.abstract_type) == path)
			continue
		M = new path
		if(!M.id)
			stack_trace("no ID on [path], skipping")
			continue
		.[M.id || M.type] = M
	sortTim(., /proc/cmp_inventory_slot_meta_dsc)

/proc/all_inventory_slot_ids()
	. = list()
	for(var/id in GLOB.inventory_slot_meta)
		. += id

/proc/cmp_inventory_slot_meta_dsc(datum/inventory_slot_meta/a, datum/inventory_slot_meta/b)
	return b.sort_order - a.sort_order

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
		return inventory_slot_type_lookup(id)
	return GLOB.inventory_slot_meta[id]

/**
 * get inventory slot meta of a typepath
 */
/proc/inventory_slot_type_lookup(type)
	. = GLOB.inventory_slot_type_cache[type]
	if(.)
		return
	for(var/id in GLOB.inventory_slot_meta)
		var/datum/inventory_slot_meta/slot = GLOB.inventory_slot_meta[id]
		if(slot.type != type)
			continue
		GLOB.inventory_slot_meta[type] = . = slot
		break
	if(!.)
		CRASH("Failed to do type lookup for [type].")

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
	/// flags
	var/inventory_slot_flags = INV_SLOT_IS_RENDERED
	/// display order - higher is upper. a <hr> is applied on 0.
	var/sort_order = 0
	/// always show on strip/force equip menu, or only show when full
	var/always_show_on_strip_menu = TRUE
	/// rendering slot key
	var/render_key
	/// our screen loc
	var/hud_position
	/// equip checks to use
	var/slot_equip_checks = NONE
	/// slot flags required to have if checking
	var/slot_flags_required = NONE
	/// slot flags forbidden to have if checking
	var/slot_flags_forbidden = NONE

/datum/inventory_slot_meta/New()
	if(!id && (inventory_slot_flags & INV_SLOT_ALLOW_RANDOM_ID))
		id = "[++id_next]"

/datum/inventory_slot_meta/proc/_equip_check(obj/item/I, mob/wearer, mob/user, flags)
	if(slot_equip_checks & SLOT_EQUIP_CHECK_USE_FLAGS)
		if(!(flags & INV_OP_FORCE))
			if(!CHECK_MULTIPLE_BITFIELDS(I.slot_flags, slot_flags_required))
				return FALSE
			if(I.slot_flags & slot_flags_forbidden)
				return FALSE
	if(slot_equip_checks & SLOT_EQUIP_CHECK_USE_PROC)
		if(!allow_equip(I, wearer, user, flags))
			return FALSE
	return TRUE

/**
 * checked if slot_equip_checks specifies to use proc
 */
/datum/inventory_slot_meta/proc/allow_equip(obj/item/I, mob/wearer, mob/user, force)
	return TRUE

/**
 * checks for obfuscation when making the strip menu
 */
/datum/inventory_slot_meta/proc/strip_obfuscation_check
	#warn impl + args + pockets

/datum/inventory_slot_meta/inventory
	abstract_type = /datum/inventory_slot_meta/inventory
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_HUD_REQUIRES_EXPAND | INV_SLOT_CONSIDERED_WORN

/datum/inventory_slot_meta/inventory/back
	name = "back"
	render_key = "back"
	id = SLOT_ID_BACK
	sort_order = 2000
	display_name = "back"
	display_preposition = "on"
	hud_position = ui_back
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_CONSIDERED_WORN
	slot_flags_required = SLOT_BACK

/datum/inventory_slot_meta/inventory/uniform
	name = "uniform"
	render_key = "under"
	id = SLOT_ID_UNIFORM
	sort_order = 5000
	display_name = "body"
	display_preposition = "on"
	hud_position = ui_iclothing
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_ICLOTHING
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_HUD_REQUIRES_EXPAND | INV_SLOT_CONSIDERED_WORN

/datum/inventory_slot_meta/inventory/head
	name = "head"
	render_key = "head"
	id = SLOT_ID_HEAD
	sort_order = 10000
	display_name = "back"
	display_preposition = "on"
	display_name = "head"
	display_preposition = "on"
	hud_position = ui_head
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_HEAD
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_HUD_REQUIRES_EXPAND | INV_SLOT_CONSIDERED_WORN

/datum/inventory_slot_meta/inventory/suit
	name = "outerwear"
	render_key = "suit"
	id = SLOT_ID_SUIT
	sort_order = 7000
	display_name = "clohtes"
	display_preposition = "over"
	hud_position = ui_oclothing
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_OCLOTHING
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_HUD_REQUIRES_EXPAND | INV_SLOT_CONSIDERED_WORN

/datum/inventory_slot_meta/inventory/belt
	name = "belt"
	render_key = "belt"
	id = SLOT_ID_BELT
	sort_order = 6000
	display_name = "waist"
	display_preposition = "on"
	hud_position = ui_belt
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_BELT
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_CONSIDERED_WORN

/datum/inventory_slot_meta/inventory/pocket
	abstract_type = /datum/inventory_slot_meta/inventory/pocket
	sort_order = 2000
	inventory_slot_flags = INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_PROC

/datum/inventory_slot_meta/inventory/pocket/allow_equip(obj/item/I, mob/wearer, mob/user, force)
	. = ..()
	if(I.slot_flags & SLOT_DENYPOCKET)
		return FALSE
	if(I.slot_flags & SLOT_POCKET)
		return TRUE
	return I.w_class <= WEIGHT_CLASS_SMALL

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
	sort_order = 3000
	display_name = "badge"
	display_preposition = "as"
	hud_position = ui_id
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_ID
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_CONSIDERED_WORN

/datum/inventory_slot_meta/inventory/shoes
	name = "shoes"
	render_key = "shoes"
	id = SLOT_ID_SHOES
	sort_order = 4000
	display_name = "feet"
	display_preposition = "on"
	hud_position = ui_shoes
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_FEET
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_CONSIDERED_WORN | INV_SLOT_HUD_REQUIRES_EXPAND

/datum/inventory_slot_meta/inventory/gloves
	name = "gloves"
	render_key = "gloves"
	id = SLOT_ID_GLOVES
	sort_order = 6500
	display_name = "hands"
	display_preposition = "on"
	hud_position = ui_gloves
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_GLOVES
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_CONSIDERED_WORN | INV_SLOT_HUD_REQUIRES_EXPAND

/datum/inventory_slot_meta/inventory/glasses
	name = "glasses"
	render_key = "glasses"
	id = SLOT_ID_GLASSES
	sort_order = 7500
	display_name = "eyes"
	display_preposition = "over"
	hud_position = ui_glasses
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_EYES
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_CONSIDERED_WORN | INV_SLOT_HUD_REQUIRES_EXPAND

/datum/inventory_slot_meta/inventory/suit_storage
	name = "suit storage"
	render_key = "suit-store"
	id = SLOT_ID_SUIT_STORAGE
	sort_order = 500
	display_name = "suit"
	display_preposition = "on"
	hud_position = ui_sstore1
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_PROC
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE

/datum/inventory_slot_meta/inventory/suit_storage/allow_equip(obj/item/I, mob/wearer, mob/user, force)
	. = ..()
	var/obj/item/suit_item = wearer.item_by_slot(SLOT_ID_SUIT)
	if(!suit_item)
		return FALSE
	// todo: this check is ass
	if(istype(I, /obj/item/pda) || istype(I, /obj/item/pen) || is_type_in_list(I, suit_item.allowed))
		return TRUE
	return FALSE

/datum/inventory_slot_meta/inventory/ears
	sort_order = 9500
	abstract_type = /datum/inventory_slot_meta/inventory/ears
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_CONSIDERED_WORN | INV_SLOT_HUD_REQUIRES_EXPAND

/datum/inventory_slot_meta/inventory/ears/left
	name = "left ear"
	render_key = "ear-l"
	id = SLOT_ID_LEFT_EAR
	display_name = "left ear"
	display_preposition = "on"
	hud_position = ui_l_ear
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_EARS

/datum/inventory_slot_meta/inventory/ears/right
	name = "right ear"
	render_key = "ear-r"
	id = SLOT_ID_RIGHT_EAR
	display_name = "left ear"
	display_preposition = "on"
	hud_position = ui_r_ear
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_EARS

/datum/inventory_slot_meta/inventory/mask
	name = "mask"
	render_key = "mask"
	id = SLOT_ID_MASK
	sort_order = 9250
	display_name = "face"
	display_preposition = "on"
	hud_position = ui_mask
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_MASK

/datum/inventory_slot_meta/restraints
	sort_order = -250
	is_inventory = FALSE
	always_show_on_strip_menu = FALSE
	abstract_type = /datum/inventory_slot_meta/restraints
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_STRIPPABLE | INV_SLOT_STRIP_ONLY_REMOVES | INV_SLOT_STRIP_SIMPLE_LINK

/datum/inventory_slot_meta/restraints/handcuffs
	name = "handcuffed"
	render_key = "handcuffs"
	id = SLOT_ID_HANDCUFFED
	display_name = "hands"
	display_preposition = "around"
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_PROC

/datum/inventory_slot_meta/restraints/handcuffs/allow_equip(obj/item/I, mob/wearer, mob/user, force)
	return istype(I, /obj/item/handcuffs) && !istype(I, /obj/item/handcuffs/legcuffs)

/datum/inventory_slot_meta/restraints/legcuffs
	name = "legcuffed"
	render_key = "legcuffs"
	id = SLOT_ID_LEGCUFFED
	display_name = "legs"
	display_preposition = "around"
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_PROC

/datum/inventory_slot_meta/restraints/legcuffs/allow_equip(obj/item/I, mob/wearer, mob/user, force)
	return istype(I, /obj/item/handcuffs/legcuffs)

/**
 * these have no excuse to be accessed by id
 * they will have randomized ids
 */
/datum/inventory_slot_meta/abstract
	inventory_slot_flags = INV_SLOT_IS_ABSTRACT | INV_SLOT_ALLOW_RANDOM_ID
	abstract_type = /datum/inventory_slot_meta/abstract

/datum/inventory_slot_meta/abstract/put_in_hands
	name = "put in hands"
	id = SLOT_ID_HANDS
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

/**
 * like put in storage, but prioritizes active, even if it's not on you.
 */
/datum/inventory_slot_meta/abstract/put_in_storage_try_active
	name = "put in storage (active storage)"
	display_name = "storage"
	display_name = "in"

/datum/inventory_slot_meta/abstract/left_hand
	name = "put in left hand"
	display_name = "left hand"
	display_preposition = "in"

/datum/inventory_slot_meta/abstract/right_hand
	name = "put in right hand"
	display_name = "right hand"
	display_preposition = "in"
