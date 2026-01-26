#define OFF 0
#define FORWARDS 1
#define BACKWARDS -1

//conveyor2 is pretty much like the original, except it supports corners, but not diverters.
//note that corner pieces transfer stuff clockwise when running forward, and anti-clockwise backwards.
// todo: main-like stacks of conveyor belts.

/obj/machinery/conveyor
	icon = 'icons/obj/recycling.dmi'
	icon_state = "conveyor_map"
	name = "conveyor belt"
	desc = "A conveyor belt."
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = 1
	circuit = /obj/item/circuitboard/conveyor
	speed_process = TRUE
	/// What we set things to glide size to when they are being moved by us
	var/conveyor_glide_size = 8

	var/operating = OFF	// 1 if running forward, -1 if backwards, 0 if off
	var/operable = 1	// true if can operate (no broken segments in this belt run)
	var/forwards		// this is the default (forward) direction, set by the map dir
	var/backwards		// hopefully self-explanatory
	var/movedir			// the actual direction to move stuff in

	var/id = ""			// the control ID	- must match controller ID

	// create a conveyor
/obj/machinery/conveyor/Initialize(mapload, newdir, on = 0)
	. = ..()
	icon_state = "conveyor0"
	if(newdir)
		setDir(newdir)

	update_dir()

	if(on)
		operating = FORWARDS
		setmove()

	component_parts = list()
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stack/cable_coil(src,5)
	RefreshParts()

/obj/machinery/conveyor/examine(mob/user, dist)
	. = ..()
	// give a hint about catastrophic crowding
	if(length(loc?.contents) > TURF_CROWDING_HARD_LIMIT)
		. += span_warning("There's far too many things on [src] for it to move!")

/obj/machinery/conveyor/proc/setmove()
	if(operating == FORWARDS)
		movedir = forwards
	else if(operating == BACKWARDS)
		movedir = backwards
	else
		operating = OFF
	update()

/obj/machinery/conveyor/setDir()
	. =..()
	update_dir()

/obj/machinery/conveyor/Crossed(atom/movable/AM)
	. = ..()
	if(operating)
		AM.set_glide_size(conveyor_glide_size)

/obj/machinery/conveyor/Uncrossed(atom/movable/AM)
	. = ..()
	if(operating)
		AM.reset_glide_size()

/obj/machinery/conveyor/proc/update_dir()
	if(!(dir in GLOB.cardinal)) // Diagonal. Forwards is *away* from dir, curving to the right.
		forwards = turn(dir, 135)
		backwards = turn(dir, 45)
	else
		forwards = dir
		backwards = turn(dir, 180)

/obj/machinery/conveyor/proc/update()
	if(machine_stat & BROKEN)
		icon_state = "conveyor-broken"
		operating = OFF
		return
	if(!operable)
		operating = OFF
	if(machine_stat & NOPOWER)
		operating = OFF
	if(operating)
		for(var/atom/movable/AM in loc)
			AM.set_glide_size(conveyor_glide_size)
	icon_state = "conveyor[operating]"

// machine process
// move items to the target location
/obj/machinery/conveyor/process(delta_time)
	if(machine_stat & (BROKEN | NOPOWER))
		return
	if(!operating)
		return
	use_power(10)
	// check catastrophic crowding
	if(length(loc.contents) > TURF_CROWDING_HARD_LIMIT)
		return
	// todo: this is still kind of tick-dependent, and will result in issues
	// todo: conveyors should be on their own subsystem that lets it run a collect-sweep cycle?
	addtimer(CALLBACK(src, PROC_REF(convey), loc.contents.Copy()), 1)

/**
 * Conveys a list of movables.
 *
 * * This does filter to make sure the movables in question are still in us.
 * * This is done in a separate proc so that order of operations from process() is canonical.
 */
/obj/machinery/conveyor/proc/convey(list/atom/movable/to_convey)
	var/turf/target_turf = get_step(src, movedir)
	if(!target_turf)
		return
	// limit items to soft crowding limit
	to_convey.len = clamp(TURF_CROWDING_SOFT_LIMIT - length(target_turf.contents), 0, length(to_convey))
	if(!length(to_convey))
		return
	// move items
	for(var/atom/movable/AM in to_convey)
		// todo: movement force check?
		if(AM.anchored)
			continue
		if(AM.loc != loc)
			continue
		step(AM, movedir)

// attack with item, place item on conveyor
/obj/machinery/conveyor/attackby(var/obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(default_deconstruction_crowbar(user, I))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	if(istype(I, /obj/item/multitool))
		if(panel_open)
			var/input = sanitize(input(usr, "What id would you like to give this conveyor?", "Multitool-Conveyor interface", id))
			if(!input)
				to_chat(user, "No input found. Please hang up and try your call again.")
				return CLICKCHAIN_DO_NOT_PROPAGATE
			id = input
			for(var/obj/machinery/conveyor_switch/C in GLOB.machines)
				if(C.id == id)
					C.conveyors |= src
			return CLICKCHAIN_DO_NOT_PROPAGATE

	if(user.a_intent == INTENT_HELP)
		user.transfer_item_to_loc(I, loc)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

// attack with hand, move pulled object onto conveyor
/obj/machinery/conveyor/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(!CHECK_ALL_MOBILITY(user, MOBILITY_CAN_MOVE | MOBILITY_CAN_USE))
		return
	if(isnull(user.pulling) || user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		user.stop_pulling()
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
		user.stop_pulling()

// make the conveyor broken
// also propagate inoperability to any connected conveyor with the same ID
/obj/machinery/conveyor/proc/broken()
	machine_stat |= BROKEN
	update()

	var/obj/machinery/conveyor/C = locate() in get_step(src, dir)
	if(C)
		C.set_operable(dir, id, 0)

	C = locate() in get_step(src, turn(dir,180))
	if(C)
		C.set_operable(turn(dir,180), id, 0)


//set the operable var if ID matches, propagating in the given direction

/obj/machinery/conveyor/proc/set_operable(stepdir, match_id, op)

	if(id != match_id)
		return
	operable = op

	update()
	var/obj/machinery/conveyor/C = locate() in get_step(src, stepdir)
	if(C)
		C.set_operable(stepdir, id, op)

/obj/machinery/conveyor/power_change()
	..()
	update()
