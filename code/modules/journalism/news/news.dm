/**
 * root type of news data
 *
 * most of these are identified internally by an ID in SQL
 * however, byond ids are limited due to the dumb 24 bit fake-int issue of byond floats
 * we'll however pretend this is fine because ids are per-category
 */
/datum/news_data
	/// flushed to storage at time
	var/flushed
	/// sql id of this data - table obviously differs based on datatype
	var/id
	/// generated hash - only make this when needed
	var/hash

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
	return hash || rehash()

