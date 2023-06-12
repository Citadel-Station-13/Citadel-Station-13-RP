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
	name = "Photography"
	init_order = INIT_ORDER_PHOTOGRAPHY
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT
	/// pictures loaded by hash as text
	var/list/datum/picture/picture_cache = list()
	/// photos loaded by id as text
	var/list/datum/photograph/photograph_cache = list()

// todo: our config system is awful and needs a proper cache..
// todo: cache eviction

/datum/controller/subsystem/photography/proc/is_persistent()
	return CONFIG_GET(flag/sql_enabled) && CONFIG_GET(flag/picture_persistent)

/**
 * url image path for a photograph id. fails if we're not persistent-enabled and the image isn't loaded.
 *
 * this is the preferred method of fetching a picture that should be stored
 * as we don't even need to grab (and cache) the datum itself.
 */
/datum/controller/subsystem/photography/proc/url_for_photograph(id, list/client/clients)
	var/datum/photograph/loaded = load_photograph(id)
	return loaded?.img_src(clients)

/**
 * url image path for a picture hash. fails if we're not persistent-enabled and the image isn't loaded.
 *
 * this is the preferred method of fetching a picture that should be stored
 * as we don't even need to grab (and cache) the datum itself.
 */
/datum/controller/subsystem/photography/proc/url_for_picture(hash, list/client/clients)
	if(!is_persistent())
		var/datum/picture/loaded = picture_cache[hash]
		if(isnull(loaded))
			return
		return loaded.rsc_src(clients)
	var/root = CONFIG_GET(string/picture_webroot)
	return "[root]/[copytext(hash, 1, 3)]/[hash].png"

/**
 * returns path to store picture. null if we're not persistent.
 */
/datum/controller/subsystem/photography/proc/path_for_picture(hash)
	if(!is_persistent())
		return
	var/root = CONFIG_GET(string/picture_storage)
	return "[root]/[copytext(hash, 1, 3)]/[hash].png"

/**
 * creates a picture from an icon, immediately flushing it to disk.
 *
 * @return /datum/picture instance
 */
/datum/controller/subsystem/photography/proc/create_picture(icon/I)
	var/datum/picture/picture = new
	// init
	picture.image_loaded = I
	var/hash = sha1asfile(I)
	ASSERT(length(hash))
	picture.image_hash = hash
	// cache - load existing if exists to de-dupe
	__sql_load_picture(picture.image_hash)
	if(picture_cache[picture.image_hash])
		// return existing copy if already exists
		return picture_cache[picture.image_hash]
	picture.width = I.Width()
	picture.height = I.Height()
	picture_cache[picture.image_hash] = picture
	// sql + storage enabled?
	if(!is_persistent())
		// nope; bail
		return picture
	// store
	// todo: did we really need to fcopy twice to hash and then copy? probably, but that seems wild.
	fcopy(picture.full, path_for_picture(hash))
	__sql_save_picture(picture)
	picture.image_saved = TRUE
	// unload to conserve memory
	picture.unload()
	// return instance
	return picture

/**
 * resolves a /datum/picture from a hash
 *
 * @return /datum/picture instance, or null
 */
/datum/controller/subsystem/photography/proc/resolve_picture(hash)
	. = picture_cache[hash]
	if(. || !is_persistent())
		return
	var/datum/picture/loaded = __sql_load_picture(hash)
	if(isnull(loaded))
		return
	picture_cache[hash] = loaded
	return loaded

/datum/controller/subsystem/photography/proc/__sql_save_picture(datum/picture/pic)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	var/datum/db_query/query = SSdbcore.NewQuery(
		{"
			INSERT INTO [format_table_name("pictures")]
			(`hash`, `width`, `height`) VALUES
			(:hash, :width, :height)
		"},
		list(
			"hash" = pic.image_hash,
			"width" = pic.width,
			"height" = pic.height,
		)
	)
	query.Execute()

	// resume admin proccall guard
	usr = __oldusr


/datum/controller/subsystem/photography/proc/__sql_load_picture(hash)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	var/datum/db_query/query = SSdbcore.NewQuery(
		{"
			SELECT `width`, `height`
			FROM [format_table_name("pictures")]
			WHERE `hash` = :hash
		"},
		list(
			"hash" = hash,
		)
	)
	query.Execute()

	if(query.NextRow())
		var/datum/picture/pic = new
		pic.image_hash = hash
		pic.width = text2num(query.item[1])
		pic.height = text2num(query.item[2])
		. = pic

	// resume admin proccall guard
	usr = __oldusr

/**
 * saves a photograph to disk.
 *
 * photograph is immutable after.
 */
/datum/controller/subsystem/photography/proc/save_photograph(datum/photograph/photograph)
	if(!is_persistent())
		// just assign it a temporary id; if it collides we don't really care we did our best
		var/static/temporary_id_next = 0
		photograph.id = "[GLOB.round_id]_[num2text(temporary_id_next++, 99999999)]"
	else
		__sql_save_photograph(photograph)
	photograph_cache[photograph.id] = photograph
	return photograph

/**
 * loads a photograph datum based on id
 */
/datum/controller/subsystem/photography/proc/load_photograph(id)
	. = photograph_cache[id]
	if(. || !is_persistent())
		return
	var/datum/photograph/loaded = __sql_load_photograph(id)
	if(isnull(loaded))
		return
	photograph_cache[id] = loaded
	return loaded

/datum/controller/subsystem/photography/proc/__sql_save_photograph(datum/photograph/photo)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	var/datum/db_query/query = SSdbcore.NewQuery(
		{"
			INSERT INTO [format_table_name("photographs")]
			(`picture`, `scene`, `desc`) VALUES
			(:hash, :scene, :desc)
		"},
		list(
			"hash" = photo.picture_hash,
			"scene" = photo.scene,
			"desc" = photo.desc,
		)
	)
	query.Execute()
	photo.id = query.last_insert_id

	// resume admin proccall guard
	usr = __oldusr

/datum/controller/subsystem/photography/proc/__sql_load_photograph(id)
	// pause admin proccall guard
	var/__oldusr = usr
	usr = null
	// section below can never be allowed to runtime

	var/datum/db_query/query = SSdbcore.NewQuery(
		{"
			SELECT `picture`, `scene`, `desc`
			FROM [format_table_name("photographs")]
			WHERE `id` = :id
		"},
		list(
			"id" = id,
		)
	)
	query.Execute()

	if(query.NextRow())
		var/datum/photograph/photo = new
		photo.id = id
		photo.picture_hash = query.item[1]
		photo.scene = query.item[2]
		photo.desc = query.item[3]
		. = photo

	// resume admin proccall guard
	usr = __oldusr

