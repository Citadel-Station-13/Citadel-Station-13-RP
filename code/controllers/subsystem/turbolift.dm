SUBSYSTEM_DEF(turbolifts)
	name = "Turbolifts"
	subsystem_flags = SS_NO_INIT
	wait = 1 SECONDS
	var/static/list/moving_lifts = list()
	var/list/currentrun

/datum/controller/subsystem/turbolifts/fire(resumed)
	if (!resumed)
		currentrun = moving_lifts.Copy()

	for(var/liftref in currentrun)
		currentrun -= liftref
		if(world.time < currentrun[liftref])
			continue
		var/datum/turbolift/lift = locate(liftref)
		if(lift.busy) // shouldn't happen as currentrun should contain valid, non-busy ones
			continue

		lift.busy = TRUE
		var/floor_delay
		if(!(floor_delay = lift.do_move()))
			// we are done, remove ourself from the lift queue
			moving_lifts[liftref] = null
			moving_lifts -= liftref
			if(lift.target_floor)
				lift.target_floor.ext_panel.reset()
				lift.target_floor = null
		else
			lift_is_moving(lift,floor_delay)
		lift.busy = FALSE

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/turbolifts/proc/lift_is_moving(datum/turbolift/lift, floor_delay)
	var/lift_ref = "[REF(lift)]"
	moving_lifts[lift_ref] = world.time + floor_delay
	if(currentrun[lift_ref])
		currentrun[lift_ref] = world.time + floor_delay
