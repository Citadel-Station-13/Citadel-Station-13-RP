/**
 * picture system
 *
 * uses SQL to save metadata
 *
 * if picture saving is not enabled, pictures still work; they just won't be saved and will use old asset
 * sending format.
 */
/datum/controller/subsystem/persistence
	/// picture logging table name cache
	var/picture_store_dbtable
	/// picture logging enabled
	var/picture_store_enabled
	/// loaded pictures by hash
	var/static/list/datum/picture/pictures_by_hash

/**
 * constructs a new, freshly taken picture.
 *
 * doesn't fill metadata, you can do that.
 */
/datum/controller/subsystem/persistence/proc/construct_picture(icon/I)
	RETURN_TYPE(/datum/picture)

/**
 * fetches a picture of a hash
 */
/datum/controller/subsystem/persistence/proc/fetch_picture(hash)
	RETURN_TYPE(/datum/picture)

/**
 * checks if a hash of a picture exists
 */
/datum/controller/subsystem/persistence/proc/picture_exists(hash)

/**
 * saves a picture's metadata to disk. construct_picture will save the .png
 */
/datum/controller/subsystem/persistence/proc/save_picture(datum/picture/P)

/**
 * hashes a picture
 */
/datum/controller/subsystem/persistence/proc/hash_picture(datum/picture/P)


/datum/controller/subsystem/persistence/proc/picture_logging_active()
	return CONFIG_GET(flag/picture_store)

/datum/controller/subsystem/persistence/proc/picture_logging_table()
	. = CONFIG_GET(string/picture_store_dbtable)
	if(. == "DEFAULT")
		#warn prefix table default + picture_store

/datum/controller/subsystem/persistence/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, picture_store_dbtable))
			return FALSE
		if(NAMEOF(src, picture_store_enabled))
			return FALSE
	return ..()

/datum/controller/subsystem/persistence/OnConfigLoad()
	picture_store_dbtable = picture_logging_active() && picture_logging_table()
	picture_store_enabled = !!picture_store_dbtable

#warn impl all


