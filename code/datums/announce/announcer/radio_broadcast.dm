/**
 * radio broadcasts
 */
/datum/announcer/radio_broadcast
	name = "Radio Announcement"
	desc = "Eris-style intercom announcements."
	/// channel
	var/channel

/datum/announcer/radio_broadcast/New(datum/announce_location/location, channel = "Common")
	..(location)
	src.channel = channel

/datum/announcer/radio_broadcast/SendText(source, name, message, list/affected)
	var/msg = "[SPAN_ALERT(name)]: [message]"
	GLOB.global_announcer.autosay(msg, source, channel, location.get_affected_levels())
