/**
  * Airflow subsystem for ZAS active edges.
  * This is not a processing subsystem because atmospherics is special; I don't want to restrict future expansions to using processing subsystem's fire().
  */
SUBSYSTEM_DEF(airflow)
	name = "Airflow (Active Edges)"
	priority = FIRE_PRIORITY_AIRFLOW
	wait = 2
	flags = SS_BACKGROUND | SS_POST_FIRE_TIMING | SS_NO_INIT

	/// Active edges
	var/list/datum/zone_edge/active_edges = list()
	/// Currentrun
	var/list/datum/zone_edge/currentrun = list()

/datum/controller/subsystem/airflow/process(resumed)
	if(!resumed)
		currentrun = active_edges.Copy()
	var/list/datum/zone_edge/running = currentrun
	var/datum/zone_edge/E
	for(var/i in length(running) to 1 step -1)
		E = running[i]
		running.len--
		E.process()
