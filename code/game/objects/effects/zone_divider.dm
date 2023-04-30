// This artificially splits a ZAS zone, useful if you wish to prevent massive super-zones which can cause lag.
/obj/effect/zone_divider
	name = "zone divider"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE
	density = FALSE
	opacity = FALSE

/obj/effect/zone_divider/CanAtmosPass(turf/T, d)
	// Special case to prevent us from being part of a zone during the first air master tick.
	// We must merge ourselves into a zone on next tick.  This will cause a bit of lag on
	// startup, but it can't really be helped you know?
	if(air_master.current_cycle == 0)
		if(!isturf(loc))
			return
		SSticker.OnRoundstart(CALLBACK(loc, /turf/proc/queue_zone_update))
		return ATMOS_PASS_AIR_BLOCKED
	return ATMOS_PASS_ZONE_BLOCKED
