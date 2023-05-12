/**
 * tracks a single device's connection to the plasma network
 */
/datum/plasmanet_connection

/datum/plasmanet_connection/proc/disconnect()

/datum/plasmanet_connection/proc/connect(obj/structure/plasma_conduit/conduit)

/datum/plasmanet_connection/proc/auto_to_turf(turf/T, require_junction = TRUE)


/datum/proc/plasmanet_connected(datum/plasmanet_connection/connection)

/datum/proc/plasmanet_disconnected(datum/plasmanet_connection/connection)

/**
 * lazy version - automatically update to location
 */
/datum/plasmanet_connection/automatic

#warn impl; lmao
