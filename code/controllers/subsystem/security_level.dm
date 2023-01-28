SUBSYSTEM_DEF(security_level)
	name = "Security Level"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_SECURITY_LEVEL

	var/datum/security_level/current_security_level
	/// All avaliable security levels for us.
	var/list/available_levels = list()

/datum/controller/subsystem/security_level/Initialize()
	for(var/level in subtypesof(/datum/security_level))
		var/datum/security_level/SL = new level
		available_levels[SL.name] = SL
	current_security_level = available_levels[number_level_to_text(SEC_LEVEL_GREEN)]
	return ..()

/**
 * Sets the current security level to the new level
 * 
 * Arguments:
 * * new_level - The new level to be set.
 */
/datum/controller/subsystem/security_level/proc/set_level(new_level)
	new_level = istext(new_level) ? new_level : number_level_to_text(new_level) // Convert the level to text if in number/define form.
	if(new_level == current_security_level.name) // If we're already at this level, do nothing.
		return

	var/datum/security_level/SL = available_levels[new_level]
	if(!SL)
		CRASH("set_level was called with an invalid level: [new_level]")

	announce_security_level(SL) // Announce before we actually set the new level

	var/newlevel = get_current_level_as_text()
	for(var/obj/machinery/firealarm/FA in GLOB.machines)
		if(FA.z in GLOB.using_map.contact_levels)
			FA.set_security_level(newlevel)
	for(var/obj/machinery/status_display/FA in GLOB.machines)
		if(FA.z in GLOB.using_map.contact_levels)
			FA.display_alert(newlevel)
			FA.mode = 3

	if(get_current_level_as_number() >= SEC_LEVEL_RED)
		GLOB.lore_atc.reroute_traffic(TRUE) // Tell them to fuck off, we're busy.
	else
		GLOB.lore_atc.reroute_traffic(FALSE)

	SSnightshift.check_nightshift()

/**
 * Announces the new security level to the station.
 * 
 * Arguments:
 * * SL - The new security level.
 */
/datum/controller/subsystem/security_level/proc/announce_security_level(datum/security_level/SL)
	if(SL.number_level > current_security_level.number_level) // Elevating to this level.
		simple_announcement(GLOB.announcer_station_legacy_centcom, "Alert Manager", "Attention! Security level elevated to [SL.name]:", SL.raised_to_announcement, null, SL.up_sound)
	else // Lowering to this level.
		simple_announcement(GLOB.announcer_station_legacy_centcom, "Alert Manager", "Attention! Security level lowered to [SL.name]:", SL.lowered_to_announcement, null, SL.down_sound)

/**
 * Returns the number_level of the current security level.
 */
/datum/controller/subsystem/security_level/proc/get_current_level_as_number()
	//Send the default security level in case the subsystem hasn't finished initializing yet
	return  ((!initialized || !current_security_level) ? SEC_LEVEL_GREEN : current_security_level.number_level)

/**
 * Returns the current security level as text
 */
/datum/controller/subsystem/security_level/proc/get_current_level_as_text()
	return ((!initialized || !current_security_level) ? "green" : current_security_level.name)

/**
 * Convert the text security level to the number
 *
 * Arguments:
 * * level - The text security level to convert
 */
/datum/controller/subsystem/security_level/proc/text_level_to_number(level)
	var/datum/security_level/selected_level = available_levels[level]
	if(selected_level)
		return selected_level.number_level

/**
 * Convert the number security level to the text
 *
 * Arguments:
 * * level - The text security level to convert
 */
/datum/controller/subsystem/security_level/proc/number_level_to_text(level)
	for(var/SL_text in available_levels)
		var/datum/security_level/SL = available_levels[SL_text]
		if(SL.number_level == level)
			return SL.name
