SUBSYSTEM_DEF(turbolifts)
	name = "Turbolifts"
	wait = 10
	var/static/list/moving_lifts = list()

/datum/controller/subsystem/turbolifts/fire(resumed)
	for(var/liftref in moving_lifts)
		if(world.time < moving_lifts[liftref])
			continue
		var/datum/turbolift/lift = locate(liftref)
		if(lift.busy)
			continue
		INVOKE_ASYNC(src, .proc/tick_turbolift, lift, liftref)

/datum/controller/subsystem/turbolifts/proc/tick_turbolift(datum/turbolift/lift, liftref)
	lift.busy = TRUE
	var/floor_delay
	if(!(floor_delay = lift.do_move()))
		moving_lifts[liftref] = null
		moving_lifts -= liftref
		if(lift.target_floor)
			lift.target_floor.ext_panel.reset()
			lift.target_floor = null
	else
		lift_is_moving(lift,floor_delay)
	lift.busy = FALSE

/datum/controller/subsystem/turbolifts/proc/lift_is_moving(datum/turbolift/lift, floor_delay)
	moving_lifts["\ref[lift]"] = world.time + floor_delay
