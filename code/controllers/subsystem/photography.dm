/**
 * manages pictures / photos
 *
 * for full functionality, the following must be enabled and working:
 * - SQL DB for storage
 * - Round ID system
 * - picture directory that's accessible from the internet for delivery
 *
 * failure to have all of these will result in the system automatically falling back to
 * non-persistent mode and delivering pictures with browse_rsc() instead of links.
 */
SUBSYSTEM_DEF(photography)
	/// pictures loaded by hash
	var/list/datum/picture/picture_lookup
	/// picture root: without the ending /
	var/picture_root
	/// picture web root: without the ending /
	var/picture_cdn

#warn impl all

/datum/controller/subsystem/photography/proc/is_persistent()
	#warn impl

/**
 * url image path for a picture hash. fails if we're not persistent-enabled.
 */
/datum/controller/subsystem/photography/proc/url_for_picture(hash)

/**
 * creates a picture from an icon, immediately flushing it to disk.
 *
 * @return /datum/picture instance
 */
/datum/controller/subsystem/photography/proc/create_picture(icon/I)

/**
 * resolves a /datum/picture from a hash
 *
 * @return /datum/picture instance, or null
 */
/datum/controller/subsystem/photography/proc/resolve_picture(hash)

/**
 * saves a photograph to disk.
 *
 * photograph is immutable after.
 */
/datum/controller/subsystem/photography/proc/save_photograph(datum/photograph/photograph)
