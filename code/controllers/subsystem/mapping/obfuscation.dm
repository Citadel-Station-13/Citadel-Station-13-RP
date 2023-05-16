/**
 * Obfuscation module
 *
 * Allows for generating arbitrary obfuscation IDs from static mapload time IDs, that are deterministic within a round.
 */
/datum/controller/subsystem/mapping
	/// "secret" key
	var/obfuscation_secret
	/// subtly obfuscated id lookup
	var/list/obfuscation_cache

/datum/controller/subsystem/mapping/PreInit(recovering)
	. = ..()
	if(!obfuscation_secret)
		obfuscation_secret = md5(GUID())
	obfuscation_cache = recovering? ((istype(SSmapping) && SSmapping.obfuscation_cache) || list()) : list()

/**
 * Generates an obfuscated but constant ID for an original ID for cases where you don't want players codediving for an ID.
 * This is slightly more expensive but is unique for an id/idtype combo, meaning it's safe to reveal - use in cases where you want to allow a player to reverse engineer,
 * but want them to find out ICly rather than codedive for an ID
 *
 * Both original and id_type are CASE INSENSITIVE.
 */
/datum/controller/subsystem/mapping/proc/get_obfuscated_id(original, id_type = "$any")
	if(!original)
		return	// no.
	return md5("[obfuscation_secret]%[lowertext(original)]%[lowertext(id_type)]")

/**
 * more expensive obfuscation: just 4 random hexadecimals at the end.
 * each given id should output the same resulting id.
 * do not abuse this, we do cache this in memory.
 *
 * use in cases where you want a player-readable id that can be recovered
 */
/datum/controller/subsystem/mapping/proc/subtly_obfuscated_id(original, id_type = "$any")
	if(isnull(obfuscation_cache[id_type]?[original]))
		LAZYINITLIST(obfuscation_cache[id_type])
		obfuscation_cache[id_type][original] = "[original]_[num2text(rand(0, (16 ** 4) - 1), 4, 16)]"
	return obfuscation_cache[id_type][original]
