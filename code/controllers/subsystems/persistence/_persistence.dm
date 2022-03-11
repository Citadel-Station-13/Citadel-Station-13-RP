SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE
	var/list/tracking_values = list()
	var/list/persistence_datums = list()
	/// The directory to write to for per-map persistence. If null, the current map shouldn't be persisted to/from.
	var/current_map_directory

/datum/controller/subsystem/persistence/Initialize()
	SetMapDirectory()
	LoadPersistence()
	for(var/thing in subtypesof(/datum/persistent))
		var/datum/persistent/P = new thing
		persistence_datums[thing] = P
		P.Initialize()
	return ..()

/datum/controller/subsystem/persistence/Shutdown()
	SavePersistence()
	for(var/thing in persistence_datums)
		var/datum/persistent/P = persistence_datums[thing]
		P.Shutdown()
	return ..()

/datum/controller/subsystem/persistence/proc/track_value(var/atom/value, var/track_type)

	if(config_legacy.persistence_disabled) //if the config is set to persistence disabled, nothing will save or load.
		return

	var/turf/T = get_turf(value)
	if(!T)
		return

	var/area/A = get_area(T)
	if(!A || (A.flags & AREA_FLAG_IS_NOT_PERSISTENT))
		return

	if(!(T.z in GLOB.using_map.persist_levels))
		return

	if(!tracking_values[track_type])
		tracking_values[track_type] = list()
	tracking_values[track_type] += value

/datum/controller/subsystem/persistence/proc/forget_value(var/atom/value, var/track_type)
	if(tracking_values[track_type])
		tracking_values[track_type] -= value


/datum/controller/subsystem/persistence/proc/show_info(var/mob/user)
	if(!user.client.holder)
		return

	var/list/dat = list("<table width = '100%'>")
	var/can_modify = check_rights(R_ADMIN, 0, user)
	for(var/thing in persistence_datums)
		var/datum/persistent/P = persistence_datums[thing]
		if(P.has_admin_data)
			dat += P.GetAdminSummary(user, can_modify)
	dat += "</table>"
	var/datum/browser/popup = new(user, "admin_persistence", "Persistence Data")
	popup.set_content(jointext(dat, null))
	popup.open()

/**
  * Loads all persistent information from disk.
  */
/datum/controller/subsystem/persistence/proc/LoadPersistence()
	return

/**
  * Saves all persistent information to disk.
  */
/datum/controller/subsystem/persistence/proc/SavePersistence()
	return

/**
  * Sets our current_map_directory to corrospond to the current map.
  */
/datum/controller/subsystem/persistence/proc/SetMapDirectory()
	if(!SSmapping.config.persistence_id)
		return			// map doesn't support persistence.
	current_map_directory = "[PERSISTENCE_MAP_ROOT_DIRECTORY]/[SSmapping.config.persistence_id]"
