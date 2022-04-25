/**
 * embodies a single FTL trip
 */
/datum/ftl
	/// object making the trip
	var/atom/movable/overmap_object/object
	/// where they're jumping to
	var/datum/ftl_destination/destination
	/// the FTL drive - can be null
	var/atom/movable/drive

#warn impl
#warn visual holder


