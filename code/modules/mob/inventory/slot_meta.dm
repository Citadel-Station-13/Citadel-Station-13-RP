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
		if(!(M.inventory_slot_flags & INV_SLOT_ALLOW_RANDOM_ID))
			GLOB.inventory_slot_type_cache[M.type] = M
	tim_sort(., /proc/cmp_inventory_slot_meta_dsc, TRUE)
	tim_sort(GLOB.inventory_slot_type_cache, /proc/cmp_inventory_slot_meta_dsc, TRUE)

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
 * returns inventory slot render key for an id
 */
/proc/resolve_inventory_slot_render_key(datum/inventory_slot_meta/id)
	return resolve_inventory_slot_meta(id)?.render_key

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
	//! Intrinsics
	/// slot name
	var/name = "unknown"
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

	//! HUD
	/// our screen loc
	var/hud_position

	//! Grammar
	/// player friendly name
	var/display_name = "unknown"
	/// player friendly preposition
	var/display_preposition = "on"
	/// is this a "plural" slot?
	var/display_plural = FALSE

	//! Equip Checks
	/// equip checks to use
	var/slot_equip_checks = NONE
	/// slot flags required to have if checking
	var/slot_flags_required = NONE
	/// slot flags forbidden to have if checking
	var/slot_flags_forbidden = NONE

	//! Stripping
	/// always show on strip/force equip menu, or only show when full
	var/always_show_on_strip_menu = TRUE
	/// default INV_VIEW flags for stripping
	var/default_strip_inv_view_flags = NONE

	//! Rendering
	/// rendering slot key
	var/render_key
	/// rendering plural slot key - only set on base type of plural slots
	var/render_key_plural
	/// rendering default layer; first is default, rest are alt layers. can be list or just one number.
	VAR_PROTECTED/list/render_layer
	/// rendering icon state cache for default icons
	VAR_PRIVATE/list/render_state_cache
	/// rendering default icons by bodytype
	VAR_PROTECTED/list/render_default_icons
	/// rendering dim x
	VAR_PRIVATE/list/render_dim_x_cache
	/// rendering dim y
	VAR_PRIVATE/list/render_dim_y_cache
	/// fallback states; if set for a bodytype, that bodytype converts to this if not in worn_bodytypes, rather than defaulted.
	VAR_PROTECTED/list/render_fallback

/datum/inventory_slot_meta/New()
	if(!id && (inventory_slot_flags & INV_SLOT_ALLOW_RANDOM_ID))
		id = "[++id_next]"

	rebuild_rendering_caches()

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
/datum/inventory_slot_meta/proc/strip_obfuscation_check(obj/item/equipped, mob/wearer, mob/user)
	return default_strip_inv_view_flags

/datum/inventory_slot_meta/proc/rebuild_rendering_caches()
	PROTECTED_PROC(TRUE) // if you think you need this outside you should rethink
	render_state_cache = list()
	render_dim_x_cache = list()
	render_dim_y_cache = list()
	if(!islist(render_default_icons))		// save the checks later for null
		render_default_icons = list()
	if(!islist(render_fallback))			// save the checks later for null
		render_fallback = list()
	for(var/bodytype_str in render_default_icons)
		render_default_icons[bodytype_str] = istype(render_default_icons[bodytype_str], /icon)? render_default_icons[bodytype_str] : icon(render_default_icons[bodytype_str])
		if(!isicon(render_default_icons[bodytype_str]))
			stack_trace("invalid icon in cache for bodytype [bodytype_str]; discarding")
			render_default_icons -= bodytype_str
			continue
		var/icon/I = render_default_icons[bodytype_str]
		render_state_cache[bodytype_str] = icon_states(I)
		// turn into hash
		for(var/state in render_state_cache[bodytype_str])
			render_state_cache[bodytype_str][state] = TRUE
		render_dim_x_cache[bodytype_str] = I.Width()
		render_dim_y_cache[bodytype_str] = I.Height()

/**
 * returns (icon, dim_x, dim_y) if found in defaults, null if not
 */
/datum/inventory_slot_meta/proc/resolve_default_assets(bodytype, state, mob/wearer, obj/item/equipped, inhand_domain)
	var/bodytype_str = bodytype_to_string(bodytype)
	if(!render_state_cache[bodytype_str]?[state])
		return
	return list(render_default_icons[bodytype_str], render_dim_x_cache[bodytype_str], render_dim_y_cache[bodytype_str])

/**
 * returns layer
 */
/datum/inventory_slot_meta/proc/resolve_default_layer(bodytype, mob/wearer, obj/item/equipped, inhand_domain)
	if(!islist(render_layer))
		return render_layer
	var/index = 1
	if(istype(equipped, /obj/item/clothing/shoes))
		var/obj/item/clothing/shoes/S = equipped
		index = (S.shoes_under_pants == 1)? 2 : 1
	else if(istype(equipped, /obj/item/storage/belt))
		var/obj/item/storage/belt/B = equipped
		index = (B.show_above_suit == 1)? 2 : 1
	return render_layer[clamp(index, 1, length(render_layer))]

/datum/inventory_slot_meta/proc/handle_worn_fallback(bodytype, list/worn_data)
	var/bodytype_str = bodytype_to_string(bodytype)
	if(!render_fallback[bodytype_str])
		return FALSE
	worn_data[WORN_DATA_ICON] = render_default_icons[bodytype_str]
	worn_data[WORN_DATA_SIZE_X] = render_dim_x_cache[bodytype_str]
	worn_data[WORN_DATA_SIZE_Y] = render_dim_y_cache[bodytype_str]
	worn_data[WORN_DATA_STATE] = render_fallback[bodytype_str]
	return TRUE

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/back.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/back.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/back.dmi',
	)
	render_fallback = list(
		BODYTYPE_STRING_TESHARI = "_fallback_"
	)
	render_layer = BACK_LAYER

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/uniform.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/uniform.dmi',
		BODYTYPE_STRING_VOX = 'icons/mob/clothing/species/vox/uniform.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/uniform.dmi',
	)
	render_fallback = list(
		BODYTYPE_STRING_TESHARI = "_fallback_",
		BODYTYPE_STRING_VOX = "_fallback_",
	)
	render_layer = UNIFORM_LAYER

	/// list of rolldown icons; must DIRECTLY corrospond to default icons.
	var/list/render_rolldown_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/uniform_rolled_down.dmi',
		BODYTYPE_STRING_VOX = 'icons/mob/clothing/species/vox/uniform_rolled_down.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/uniform_rolled_down.dmi',
	)
	/// list of rollsleeve icons; must DIRECTLY corrospond to default icons.
	var/list/render_rollsleeve_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/uniform_sleeves_rolled.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/uniform_sleeves_rolled.dmi',
	)
	/// list of rolldown states
	var/list/render_rolldown_states
	/// list of rollsleeve states
	var/list/render_rollsleeve_states

/datum/inventory_slot_meta/inventory/uniform/rebuild_rendering_caches()
	. = ..()
	render_rolldown_states = list()
	for(var/bodytype_str in render_rolldown_icons)
		render_rolldown_icons[bodytype_str] = istype(render_rolldown_icons[bodytype_str], /icon)? render_rolldown_icons[bodytype_str] : icon(render_rolldown_icons[bodytype_str])
		if(!isicon(render_rolldown_icons[bodytype_str]))
			stack_trace("invalid icon in rolldown cache for bodytype [bodytype_str]; discarding")
			render_rolldown_icons -= bodytype_str
			continue
		var/icon/I = render_rolldown_icons[bodytype_str]
		render_rolldown_states[bodytype_str] = icon_states(I)
		// turn into hash
		for(var/state in render_rolldown_states[bodytype_str])
			render_rolldown_states[bodytype_str][state] = TRUE
	render_rollsleeve_states = list()
	for(var/bodytype_str in render_rollsleeve_icons)
		render_rollsleeve_icons[bodytype_str] = istype(render_rollsleeve_icons[bodytype_str], /icon)? render_rollsleeve_icons[bodytype_str] : icon(render_rollsleeve_icons[bodytype_str])
		if(!isicon(render_rollsleeve_icons[bodytype_str]))
			stack_trace("invalid icon in rollsleeve cache for bodytype [bodytype_str]; discarding")
			render_rollsleeve_icons -= bodytype_str
			continue
		var/icon/I = render_rollsleeve_icons[bodytype_str]
		render_rollsleeve_states[bodytype_str] = icon_states(I)
		// turn into hash
		for(var/state in render_rollsleeve_states[bodytype_str])
			render_rollsleeve_states[bodytype_str][state] = TRUE

/datum/inventory_slot_meta/inventory/uniform/resolve_default_assets(bodytype, state, mob/wearer, obj/item/equipped, inhand_domain)
	if(!istype(equipped, /obj/item/clothing/under))
		return ..()
	var/obj/item/clothing/under/U = equipped
	var/bodytype_str = bodytype_to_string(bodytype)
	if(U.worn_rolled_down == UNIFORM_ROLL_TRUE)
		if(check_rolldown_cache(bodytype, state))
			return list(render_rolldown_icons[bodytype_str], render_dim_x_cache[bodytype_str], render_dim_y_cache[bodytype_str])
	else if(U.worn_rolled_sleeves == UNIFORM_ROLL_TRUE)
		if(check_rollsleeve_cache(bodytype, state))
			return list(render_rollsleeve_icons[bodytype_str], render_dim_x_cache[bodytype_str], render_dim_y_cache[bodytype_str])
	else
		return ..()

/datum/inventory_slot_meta/inventory/uniform/proc/check_rolldown_cache(bodytype, state)
	return render_rolldown_states[bodytype_to_string(bodytype)]?[state]

/datum/inventory_slot_meta/inventory/uniform/proc/check_rollsleeve_cache(bodytype, state)
	return render_rollsleeve_states[bodytype_to_string(bodytype)]?[state]

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/head.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/head.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/head.dmi',
		BODYTYPE_STRING_VOX = 'icons/mob/clothing/species/vox/head.dmi',
		BODYTYPE_STRING_TAJARAN = 'icons/mob/clothing/species/tajaran/helmet.dmi',
		BODYTYPE_STRING_UNATHI = 'icons/mob/clothing/species/unathi/helmet.dmi',
		BODYTYPE_STRING_AKULA       = 'icons/mob/clothing/species/akula/helmet.dmi',
		BODYTYPE_STRING_NEVREAN     = 'icons/mob/clothing/species/nevrean/helmet.dmi',
		BODYTYPE_STRING_PHORONOID   = 'icons/mob/clothing/species/phoronoid/head.dmi',
		BODYTYPE_STRING_PROMETHEAN  = 'icons/mob/clothing/species/skrell/helmet.dmi',
		BODYTYPE_STRING_SERGAL      = 'icons/mob/clothing/species/sergal/helmet.dmi',
		BODYTYPE_STRING_SKRELL      = 'icons/mob/clothing/species/skrell/helmet.dmi',
		BODYTYPE_STRING_VULPKANIN   = 'icons/mob/clothing/species/vulpkanin/helmet.dmi',
		BODYTYPE_STRING_XENOHYBRID  = 'icons/mob/clothing/species/unathi/helmet.dmi',
		BODYTYPE_STRING_ZORREN_FLAT = 'icons/mob/clothing/species/fennec/helmet.dmi',
		BODYTYPE_STRING_ZORREN_HIGH = 'icons/mob/clothing/species/fox/helmet.dmi',
	)
	render_layer = HEAD_LAYER

/datum/inventory_slot_meta/inventory/suit
	name = "outerwear"
	render_key = "suit"
	id = SLOT_ID_SUIT
	sort_order = 7000
	display_name = "suit"
	display_preposition = "over"

	hud_position = ui_oclothing
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_OCLOTHING
	inventory_slot_flags = INV_SLOT_IS_RENDERED | INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE | INV_SLOT_HUD_REQUIRES_EXPAND | INV_SLOT_CONSIDERED_WORN
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/suits.dmi',
		BODYTYPE_STRING_AKULA       = 'icons/mob/clothing/species/akula/suits.dmi',
		BODYTYPE_STRING_NEVREAN     = 'icons/mob/clothing/species/nevrean/suits.dmi',
		BODYTYPE_STRING_PHORONOID   = 'icons/mob/clothing/species/phoronoid/suits.dmi',
		BODYTYPE_STRING_PROMETHEAN  = 'icons/mob/clothing/species/skrell/suits.dmi',
		BODYTYPE_STRING_SERGAL      = 'icons/mob/clothing/species/sergal/suits.dmi',
		BODYTYPE_STRING_SKRELL      = 'icons/mob/clothing/species/skrell/suits.dmi',
		BODYTYPE_STRING_TAJARAN         = 'icons/mob/clothing/species/tajaran/suits.dmi',
		BODYTYPE_STRING_TESHARI     = 'icons/mob/clothing/species/teshari/suits.dmi',
		BODYTYPE_STRING_UNATHI      = 'icons/mob/clothing/species/unathi/suits.dmi',
		BODYTYPE_STRING_VOX         = 'icons/mob/clothing/species/vox/suits.dmi',
		BODYTYPE_STRING_VULPKANIN   = 'icons/mob/clothing/species/vulpkanin/suits.dmi',
		BODYTYPE_STRING_XENOHYBRID  = 'icons/mob/clothing/species/unathi/suits.dmi',
		BODYTYPE_STRING_ZORREN_FLAT = 'icons/mob/clothing/species/fennec/suits.dmi',
		BODYTYPE_STRING_ZORREN_HIGH = 'icons/mob/clothing/species/fox/suits.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/suits.dmi',
		BODYTYPE_STRING_ZADDAT      = 'icons/mob/clothing/species/zaddat/suits.dmi',
	)
	render_layer = SUIT_LAYER

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/belt.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/belt.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/belt.dmi',
	)
	render_layer = list(BELT_LAYER, BELT_LAYER_ALT)

/datum/inventory_slot_meta/inventory/pocket
	abstract_type = /datum/inventory_slot_meta/inventory/pocket
	sort_order = 2000
	inventory_slot_flags = INV_SLOT_IS_INVENTORY | INV_SLOT_IS_STRIPPABLE
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_PROC
	default_strip_inv_view_flags = INV_VIEW_OBFUSCATE_HIDE_ITEM_NAME | INV_VIEW_STRIP_FUMBLE_ON_FAILURE | INV_VIEW_STRIP_IS_SILENT

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/mob.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/id.dmi',
	)
	render_fallback = list(
		BODYTYPE_STRING_TESHARI = "_fallback_"
	)
	render_layer = ID_LAYER

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/feet.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/shoes.dmi',
		BODYTYPE_STRING_VOX = 'icons/mob/clothing/species/vox/shoes.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/feet.dmi',
		BODYTYPE_STRING_ZADDAT    = 'icons/mob/clothing/species/zaddat/shoes.dmi',
 	)
	render_fallback = list(
		BODYTYPE_STRING_TESHARI = "_fallback_"	// this doesn't actually exist, so item becomes invis
	)
	render_layer = list(SHOES_LAYER, SHOES_LAYER_ALT)

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/hands.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/gloves.dmi',
		BODYTYPE_STRING_VOX = 'icons/mob/clothing/species/vox/gloves.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/hands.dmi',
	)
	render_fallback = list(
		BODYTYPE_STRING_TESHARI = "_fallback_"
	)
	render_layer = GLOVES_LAYER

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/eyes.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/eyes.dmi',
		BODYTYPE_STRING_VOX = 'icons/mob/clothing/species/vox/eyes.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/eyes.dmi',
	)
	render_fallback = list(
		BODYTYPE_STRING_TESHARI = "_fallback_"
	)
	render_layer = GLASSES_LAYER

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
	render_layer = SUIT_STORE_LAYER

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/ears.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/ears.dmi',
		BODYTYPE_STRING_WEREBEAST = 'icons/mob/clothing/species/werebeast/ears.dmi',
		BODYTYPE_STRING_VOX = 'icons/mob/clothing/species/vox/ears.dmi',
	)
	render_fallback = list(
		BODYTYPE_STRING_TESHARI = "_fallback_"
	)
	render_layer = EARS_LAYER
	render_key_plural = "ears"

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
	display_name = "right ear"
	display_preposition = "on"
	hud_position = ui_r_ear
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_FLAGS
	slot_flags_required = SLOT_EARS
	render_layer = EARS_LAYER

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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/clothing/mask.dmi',
		BODYTYPE_STRING_AKULA       = 'icons/mob/clothing/species/akula/mask.dmi',
		BODYTYPE_STRING_NEVREAN     = 'icons/mob/clothing/species/nevrean/mask.dmi',
		BODYTYPE_STRING_SERGAL      = 'icons/mob/clothing/species/sergal/mask.dmi',
		BODYTYPE_STRING_TAJARAN         = 'icons/mob/clothing/species/tajaran/mask.dmi',
		BODYTYPE_STRING_TESHARI     = 'icons/mob/clothing/species/teshari/masks.dmi',
		BODYTYPE_STRING_UNATHI      = 'icons/mob/clothing/species/unathi/mask.dmi',
		BODYTYPE_STRING_VOX         = 'icons/mob/clothing/species/vox/masks.dmi',
		BODYTYPE_STRING_VULPKANIN   = 'icons/mob/clothing/species/vulpkanin/mask.dmi',
		BODYTYPE_STRING_WEREBEAST   = 'icons/mob/clothing/species/werebeast/masks.dmi',
		BODYTYPE_STRING_XENOCHIMERA = 'icons/mob/clothing/species/tajaran/mask.dmi',
		BODYTYPE_STRING_ZORREN_FLAT = 'icons/mob/clothing/species/fennec/mask.dmi',
		BODYTYPE_STRING_ZORREN_HIGH = 'icons/mob/clothing/species/fox/mask.dmi',
	)
	render_layer = FACEMASK_LAYER

/datum/inventory_slot_meta/restraints
	sort_order = -250
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
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/mob.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/handcuffs.dmi',
	)
	render_layer = HANDCUFF_LAYER

/datum/inventory_slot_meta/restraints/handcuffs/allow_equip(obj/item/I, mob/wearer, mob/user, force)
	return istype(I, /obj/item/handcuffs) && !istype(I, /obj/item/handcuffs/legcuffs)

/datum/inventory_slot_meta/restraints/legcuffs
	name = "legcuffed"
	render_key = "legcuffs"
	id = SLOT_ID_LEGCUFFED
	display_name = "legs"
	display_preposition = "around"
	slot_equip_checks = SLOT_EQUIP_CHECK_USE_PROC
	render_default_icons = list(
		BODYTYPE_STRING_DEFAULT = 'icons/mob/mob.dmi',
		BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/handcuffs.dmi',
	)
	render_layer = LEGCUFF_LAYER

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

/datum/inventory_slot_meta/abstract/hand
	abstract_type = /datum/inventory_slot_meta/abstract/hand
	// our render default icons are based on inhand type
	// this hijacks render_default_icons SO much but i don't care!

/**
 * returns (icon, dim_x, dim_y) if found in defaults, null if not
 */
/datum/inventory_slot_meta/abstract/hand/resolve_default_assets(bodytype, state, mob/wearer, obj/item/equipped, inhand_domain)
	if(!render_state_cache[inhand_domain]?[state])
		return
	return list(render_default_icons[inhand_domain], render_dim_x_cache[inhand_domain], render_dim_y_cache[inhand_domain])

/datum/inventory_slot_meta/abstract/hand/left
	name = "put in left hand"
	display_name = "left hand"
	display_preposition = "in"
	id = SLOT_ID_LEFT_HAND
	render_key = "left"
	render_layer = L_HAND_LAYER
	render_default_icons = list(
		INHAND_DEFAULT_ICON_BALLS = 'icons/mob/items/lefthand_balls.dmi',
		INHAND_DEFAULT_ICON_BOOKS = 'icons/mob/items/lefthand_books.dmi',
		INHAND_DEFAULT_ICON_GENERAL = 'icons/mob/items/lefthand.dmi',
		INHAND_DEFAULT_ICON_GLOVES = 'icons/mob/items/lefthand_gloves.dmi',
		INHAND_DEFAULT_ICON_GUNS = 'icons/mob/items/lefthand_guns.dmi',
		INHAND_DEFAULT_ICON_HATS = 'icons/mob/items/lefthand_hats.dmi',
		INHAND_DEFAULT_ICON_HOLDERS = 'icons/mob/items/lefthand_holder.dmi',
		INHAND_DEFAULT_ICON_MAGIC = 'icons/mob/items/lefthand_magic.dmi',
		INHAND_DEFAULT_ICON_MASKS = 'icons/mob/items/lefthand_masks.dmi',
		INHAND_DEFAULT_ICON_MATERIAL = 'icons/mob/items/lefthand_material.dmi',
		INHAND_DEFAULT_ICON_MELEE = 'icons/mob/items/lefthand_melee.dmi',
		INHAND_DEFAULT_ICON_SHOES = 'icons/mob/items/lefthand_shoes.dmi',
		INHAND_DEFAULT_ICON_STORAGE = 'icons/mob/items/lefthand_storage.dmi',
		INHAND_DEFAULT_ICON_SUITS = 'icons/mob/items/lefthand_suits.dmi',
		INHAND_DEFAULT_ICON_SWITCHTOOL = 'icons/mob/items/lefthand_switchtool.dmi',
		INHAND_DEFAULT_ICON_UNIFORMS = 'icons/mob/items/lefthand_uniforms.dmi',
		INHAND_DEFAULT_ICON_64X64 = 'icons/mob/items/64x64_lefthand.dmi',
	)

/datum/inventory_slot_meta/abstract/hand/right
	name = "put in right hand"
	display_name = "right hand"
	display_preposition = "in"
	id = SLOT_ID_RIGHT_HAND
	render_key = "right"
	render_layer = R_HAND_LAYER
	render_default_icons = list(
		INHAND_DEFAULT_ICON_BALLS = 'icons/mob/items/righthand_balls.dmi',
		INHAND_DEFAULT_ICON_BOOKS = 'icons/mob/items/righthand_books.dmi',
		INHAND_DEFAULT_ICON_GENERAL = 'icons/mob/items/righthand.dmi',
		INHAND_DEFAULT_ICON_GLOVES = 'icons/mob/items/righthand_gloves.dmi',
		INHAND_DEFAULT_ICON_GUNS = 'icons/mob/items/righthand_guns.dmi',
		INHAND_DEFAULT_ICON_HATS = 'icons/mob/items/righthand_hats.dmi',
		INHAND_DEFAULT_ICON_HOLDERS = 'icons/mob/items/righthand_holder.dmi',
		INHAND_DEFAULT_ICON_MAGIC = 'icons/mob/items/righthand_magic.dmi',
		INHAND_DEFAULT_ICON_MASKS = 'icons/mob/items/righthand_masks.dmi',
		INHAND_DEFAULT_ICON_MATERIAL = 'icons/mob/items/righthand_material.dmi',
		INHAND_DEFAULT_ICON_MELEE = 'icons/mob/items/righthand_melee.dmi',
		INHAND_DEFAULT_ICON_SHOES = 'icons/mob/items/righthand_shoes.dmi',
		INHAND_DEFAULT_ICON_STORAGE = 'icons/mob/items/righthand_storage.dmi',
		INHAND_DEFAULT_ICON_SUITS = 'icons/mob/items/righthand_suits.dmi',
		INHAND_DEFAULT_ICON_SWITCHTOOL = 'icons/mob/items/righthand_switchtool.dmi',
		INHAND_DEFAULT_ICON_UNIFORMS = 'icons/mob/items/righthand_uniforms.dmi',
		INHAND_DEFAULT_ICON_64X64 = 'icons/mob/items/64x64_righthand.dmi',
	)
