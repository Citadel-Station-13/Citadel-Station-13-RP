/**
 * gun render system
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 *
 * todo: better documentation
 */
/datum/gun_renderer
	/// firemode state is taken into account
	var/use_firemode = FALSE

/datum/gun_renderer/New(use_firemode)
	if(!isnull(use_firemode))
		src.use_firemode = use_firemode

/datum/gun_renderer/proc/render(obj/item/gun/gun)
	CRASH("attempted to render with abstract gun renderer")

/**
 * uses a copy of a segment to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 * if independent_firemode is set, the firemode overlay will be overlaid independently from segments
 *
 * segment state is "[gun.base_icon_state]-ammo"
 * empty state is "[gun.base_icon_state]-empty"
 */
/datum/gun_renderer/segments
	var/count = 0
	var/initial_x = 0
	var/initial_y = 0
	var/offset_x
	var/offset_y
	var/use_empty = FALSE
	var/independent_firemode = FALSE

/datum/gun_renderer/segments/New(count, offset_x, offset_y, initial_x, initial_y, use_empty_state, use_firemode, independent_firemode)
	..(use_firemode = use_firemode)
	if(!isnull(count))
		src.count = count
	if(!isnull(offset_x))
		src.offset_x = offset_x
	if(!isnull(offset_y))
		src.offset_y = offset_y
	if(!isnull(initial_x))
		src.initial_x = initial_x
	if(!isnull(initial_y))
		src.initial_y = initial_y
	if(!isnull(use_empty_state))
		src.use_empty = use_empty_state
	if(!isnull(independent_firemode))
		src.independent_firemode = independent_firemode

/datum/gun_renderer/segments/render(obj/item/gun/gun)

#warn impl

/**
 * uses either 1 to n or only the nth overlay to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 * if independent_firemode is set, the firemode overlay will be overlaid independently from overlays
 *
 * overlay state is "[gun.base_icon_state]-[n]"
 * empty state append is -0
 *
 * if use_single_overlay is set, we only render the -n'th state,
 * otherwise we render -1 to -n, or -0 if empty (and use zero state is on)
 */
/datum/gun_renderer/overlays
	var/count
	var/use_empty
	var/use_single
	var/independent_firemode

/datum/gun_renderer/overlays/New(count, use_zero_state, use_single_overlay, use_firemode, independent_firemode)
	..(use_firemode = use_firemode)
	if(!isnull(count))
		src.count = count
	if(!isnull(use_zero_state))
		src.use_empty = use_zero_state
	if(!isnull(use_single_overlay))
		src.use_single = use_single_overlay
	if(!isnull(independent_firemode))
		src.independent_firemode = independent_firemode

/datum/gun_renderer/overlays/render(obj/item/gun/gun)

#warn impl

/**
 * uses icon states to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 *
 * gun's icon state is changed to "[gun.base_icon_state][use_firemode && "[firemode]-"]-[n]"
 * empty state append is -0
 */
/datum/gun_renderer/states
	var/use_empty
	var/count

/datum/gun_renderer/states/New(count, use_zero_state, use_firemode)
	..(use_firemode = use_firemode)
	if(!isnull(use_zero_state))
		src.use_empty = use_zero_state
	if(!isnull(count))
		src.count = count

/datum/gun_renderer/states/render(obj/item/gun/gun)

#warn impl
