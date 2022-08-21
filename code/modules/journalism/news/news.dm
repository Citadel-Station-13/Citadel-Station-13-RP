/**
 * root type of news data
 *
 * most of these are identified internally by an ID in news storage backend
 * however, byond ids are limited due to the dumb 24 bit fake-int issue of byond floats
 * we'll however pretend this is fine because ids are per-category
 */
/datum/news_data
	/// flushed to storage at time
	var/flushed
	/// storage backend id of this data - table obviously differs based on datatype
	var/id
	/// generated hash - only make this when needed
	var/hash
	/// dirty? rehash if so
	var/dirty = FALSE

/**
 * generate and return hash
 *
 * WARNING: CAN OVERWRITE
 */
/datum/news_data/proc/rehash()
	return (hash = sha1(json_encode(listify())))

/**
 * flatten into a data list
 */
/datum/news_data/proc/listify()
	return list()

/**
 * get hash
 */
/datum/news_data/proc/get_hash()
	return dirty? rehash() : (hash || rehash())

/**
 * mark dirty
 */
/datum/news_data/proc/mark_dirty()
	dirty = TRUE

