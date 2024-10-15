SUBSYSTEM_DEF(emergencyshuttle)
	name = "Emergency Shuttle"
	wait = 20

/datum/controller/subsystem/emergencyshuttle
	var/datum/shuttle/autodock/ferry/emergency/shuttle	// Set in shuttle_emergency.dm TODO - is it really?
	var/list/escape_pods

	var/launch_time			//the time at which the shuttle will be launched
	var/auto_recall = 0		//if set, the shuttle will be auto-recalled
	var/auto_recall_time	//the time at which the shuttle will be auto-recalled
	var/evac = 0			//1 = emergency evacuation, 0 = crew transfer
	var/wait_for_launch = 0	//if the shuttle is waiting to launch
	var/autopilot = 1		//set to 0 to disable the shuttle automatically launching

	var/deny_shuttle = 0	//allows admins to prevent the shuttle from being called
	var/departed = 0		//if the shuttle has left the station at least once

	var/datum/legacy_announcement/priority/emergency_shuttle_docked = new(0, new_sound = sound('sound/AI/shuttledock.ogg'))
	var/datum/legacy_announcement/priority/emergency_shuttle_called = new(0, new_sound = sound('sound/AI/shuttlecalled.ogg'))
	var/datum/legacy_announcement/priority/emergency_shuttle_recalled = new(0, new_sound = sound('sound/AI/shuttlerecalled.ogg'))

/datum/controller/subsystem/emergencyshuttle/PreInit(recovering)
	escape_pods = list()

/datum/controller/subsystem/emergencyshuttle/fire()
	if (wait_for_launch)
		if (evac && auto_recall && world.time >= auto_recall_time)
			recall()
		if (world.time >= launch_time)	//time to launch the shuttle
			stop_launch_countdown()

			if(evac)
				if(GLOB.legacy_emergency_shuttle_controller.is_at_away())
					//leaving from the station
					//launch the pods!
					launch_escape_pods()

			if (autopilot)
				if(GLOB.legacy_emergency_shuttle_controller.is_at_home())
					GLOB.legacy_emergency_shuttle_controller.transit_towards_away(5 MINUTES)
				else
					GLOB.legacy_emergency_shuttle_controller.transit_towards_home(5 MINUTES)

//called when the shuttle has arrived.

/datum/controller/subsystem/emergencyshuttle/proc/shuttle_arrived()
	if(GLOB.legacy_emergency_shuttle_controller.is_at_away()) //at station
		if (autopilot)
			set_launch_countdown(3 MINUTES)	//get ready to return
			var/estimated_time = round(estimate_launch_time()/60,1)

			if (evac)
				emergency_shuttle_docked.Announce(
					replacetext(
						replacetext(
							(LEGACY_MAP_DATUM).emergency_shuttle_docked_message,
							"%dock_name%",
							"[(LEGACY_MAP_DATUM).dock_name]",
						),
						"%ETD%",
						"[estimated_time] minute\s",
					),
				)
			else
				priority_announcement.Announce(
					replacetext(
						replacetext(
							(LEGACY_MAP_DATUM).shuttle_docked_message,
							"%dock_name%",
							"[(LEGACY_MAP_DATUM).dock_name]"
						),
						"%ETD%",
						"[estimated_time] minute\s",
					),
				)

		//arm the escape pods
		if (evac)
			arm_escape_pods()

//begins the launch countdown and sets the amount of time left until launch
/datum/controller/subsystem/emergencyshuttle/proc/set_launch_countdown(time)
	wait_for_launch = 1
	launch_time = world.time + time

/datum/controller/subsystem/emergencyshuttle/proc/stop_launch_countdown()
	wait_for_launch = 0

//calls the shuttle for an emergency evacuation
/datum/controller/subsystem/emergencyshuttle/proc/call_evac()
	if(!can_call()) return

	//set the launch timer
	autopilot = 1
	set_launch_countdown(5 MINUTES)
	auto_recall_time = rand(world.time + 300, launch_time - 300)

	GLOB.legacy_emergency_shuttle_controller.round_end_armed = TRUE

	//reset the shuttle transit time if we need to
	var/estimated_time = round(estimate_arrival_time()/60,1)

	evac = 1
	emergency_shuttle_called.Announce(
		replacetext(
			(LEGACY_MAP_DATUM).emergency_shuttle_called_message,
			"%ETA%",
			"[estimated_time] minute\s",
		),
	)
	for(var/area/A in GLOB.sortedAreas)
		if(istype(A, /area/hallway))
			A.readyalert()
	if(SSlegacy_atc.squelched == FALSE)
		SSlegacy_atc.toggle_broadcast()

//calls the shuttle for a routine crew transfer
/datum/controller/subsystem/emergencyshuttle/proc/call_transfer()
	if(!can_call()) return

	//set the launch timer
	autopilot = 1
	set_launch_countdown(5 MINUTES)
	auto_recall_time = rand(world.time + 300, launch_time - 300)

	GLOB.legacy_emergency_shuttle_controller.round_end_armed = TRUE

	//reset the shuttle transit time if we need to
	var/estimated_time = round(estimate_arrival_time()/60,1)

	priority_announcement.Announce(
		replacetext(
			replacetext(
				(LEGACY_MAP_DATUM).shuttle_called_message,
				"%dock_name%",
				"[(LEGACY_MAP_DATUM).dock_name]",
			),
			"%ETA%", "[estimated_time] minute\s",
		),
	)
	SSlegacy_atc.shift_ending()

//recalls the shuttle
/datum/controller/subsystem/emergencyshuttle/proc/recall()
	if (!can_recall()) return

	wait_for_launch = 0
	GLOB.legacy_emergency_shuttle_controller.transit_towards_home(0)

	if (evac)
		emergency_shuttle_recalled.Announce(
			(LEGACY_MAP_DATUM).emergency_shuttle_recall_message,
		)

		for(var/area/A in GLOB.sortedAreas)
			if(istype(A, /area/hallway))
				A.readyreset()
		evac = 0
	else
		priority_announcement.Announce((LEGACY_MAP_DATUM).shuttle_recall_message)

/datum/controller/subsystem/emergencyshuttle/proc/can_call()
	if (deny_shuttle)
		return 0
	if(GLOB.legacy_emergency_shuttle_controller.get_transit_stage() || !GLOB.legacy_emergency_shuttle_controller.is_at_home())
		return 0
	if (wait_for_launch)	//already launching
		return 0
	return 1

//this only returns 0 if it would absolutely make no sense to recall
//e.g. the shuttle is already at the station or wasn't called to begin with
//other reasons for the shuttle not being recallable should be handled elsewhere
/datum/controller/subsystem/emergencyshuttle/proc/can_recall()
	if(GLOB.legacy_emergency_shuttle_controller.get_transit_stage())
		return 0
	if(!GLOB.legacy_emergency_shuttle_controller.is_at_home())
		//already at the station.
		return 0
	if (!wait_for_launch)	//we weren't going anywhere, anyways...
		return 0
	return 1

/*
	These procs are not really used by the controller itself, but are for other parts of the
	game whose logic depends on the emergency shuttle.
*/

//returns 1 if the shuttle is docked at the station and waiting to leave
/datum/controller/subsystem/emergencyshuttle/proc/waiting_to_leave()
	if(GLOB.legacy_emergency_shuttle_controller.is_at_home())
		return 0	//not at station
	return (wait_for_launch || !GLOB.legacy_emergency_shuttle_controller.get_transit_stage())

//so we don't have emergencyshuttleshuttle.location everywhere
/datum/controller/subsystem/emergencyshuttle/proc/location()
	return GLOB.legacy_emergency_shuttle_controller.is_at_home()

//returns the time left until the shuttle arrives at it's destination, in seconds
/datum/controller/subsystem/emergencyshuttle/proc/estimate_arrival_time()
	var/eta
	if(GLOB.legacy_emergency_shuttle_controller.get_transit_stage())
		//we are in transition and can get an accurate ETA
		eta = GLOB.legacy_emergency_shuttle_controller.transit_time_left()
	else
		//otherwise we need to estimate the arrival time using the scheduled launch time
		eta = launch_time + GLOB.legacy_emergency_shuttle_controller.default_takeoff_time() + GLOB.legacy_emergency_shuttle_controller.default_transit_time()
	return (eta - world.time)/10

//returns the time left until the shuttle launches, in seconds
/datum/controller/subsystem/emergencyshuttle/proc/estimate_launch_time()
	return (launch_time - world.time)/10

/datum/controller/subsystem/emergencyshuttle/proc/has_eta()
	return (wait_for_launch || GLOB.legacy_emergency_shuttle_controller.get_transit_stage())

//returns 1 if the shuttle has gone to the station and come back at least once,
//used for game completion checking purposes
/datum/controller/subsystem/emergencyshuttle/proc/returned()
	return (departed && GLOB.legacy_emergency_shuttle_controller.is_at_home())	//we've gone to the station at least once, no longer in transit and are idle back at centcom

//returns 1 if the shuttle is not idle at centcom
/datum/controller/subsystem/emergencyshuttle/proc/online()
	if(!shuttle)
		return FALSE
	if(!GLOB.legacy_emergency_shuttle_controller.is_at_home())
	if (wait_for_launch || GLOB.legacy_emergency_shuttle_controller.get_transit_stage())
		return 1
	return 0

//returns 1 if the shuttle is currently in transit (or just leaving) to the station
/datum/controller/subsystem/emergencyshuttle/proc/going_to_station()
	return GLOB.legacy_emergency_shuttle_controller.is_in_transit_towards_away()

//returns 1 if the shuttle is currently in transit (or just leaving) to centcom
/datum/controller/subsystem/emergencyshuttle/proc/going_to_centcom()
	return GLOB.legacy_emergency_shuttle_controller.is_in_transit_towards_home()

/datum/controller/subsystem/emergencyshuttle/proc/get_status_panel_eta()
	if (online())
		if(GLOB.legacy_emergency_shuttle_controller.get_transit_stage())
			var/timeleft = estimate_arrival_time()
			return "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

		if (waiting_to_leave())
			switch(GLOB.legacy_emergency_shuttle_controller.get_transit_stage())
				if(SHUTTLE_TRANSIT_STAGE_TAKEOFF, SHUTTLE_TRANSIT_STAGE_UNDOCK)
					return "Departing..."

			var/timeleft = estimate_launch_time()
			return "ETD-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

	return ""
