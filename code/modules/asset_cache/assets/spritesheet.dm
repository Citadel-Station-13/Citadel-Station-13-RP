
/**
 * spritesheet implementation - coalesces various icons into a single .png file
 * and uses CSS to select icons out of that file - saves on transferring some
 * 1400-odd individual PNG files
 *
 * To use, use classes of "[name][size_key]" and the state name used in Insert().
 * If you used InsertAll(), don't forget the prefix.
 *
 * Example: <div class='sheetmaterials32x32 glass-3'>
 * In tgui, usually would be clsasName={classes(['sheetmaterials32x32', 'glass-3'])}
 */
#define SPR_SIZE 1
#define SPR_IDX  2

#define SPRSZ_COUNT    1
#define SPRSZ_ICON     2
#define SPRSZ_STRIPPED 3

/datum/asset/spritesheet
	abstract_type = /datum/asset/spritesheet
	var/name
	/**
	 * List of arguments to pass into queuedInsert.
	 * Exists so we can queue icon insertion, mostly for stuff like preferences.
	 */
	var/list/to_generate = list()
	/// "32x32" -> list(10, icon/normal, icon/stripped)
	var/list/sizes = list()
	/// "foo_bar" -> list("32x32", 5)
	var/list/sprites = list()
	var/list/cached_spritesheets_needed
	var/generating_cache = FALSE
	var/fully_generated = FALSE
	/**
	 * If this asset should be fully loaded on new
	 * Defaults to false so we can process this stuff nicely
	 */
	var/load_immediately = FALSE

/datum/asset/spritesheet/should_refresh()
	if (..())
		return TRUE

	/// Static so that the result is the same, even when the files are created, for this run.
	var/static/should_refresh = null

	if (isnull(should_refresh))
		// `fexists` seems to always fail on static-time
		should_refresh = !fexists("[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[name].css")

	return should_refresh

/datum/asset/spritesheet/register()
	SHOULD_NOT_OVERRIDE(TRUE)

	if (!name)
		CRASH("spritesheet [type] cannot register without a name")

	if (!should_refresh() && read_from_cache())
		return

	/// If it's cached, may as well load it now, while the loading is cheap
	if(CONFIG_GET(flag/cache_assets) && cross_round_cachable)
		load_immediately = TRUE

	create_spritesheets()
	if(load_immediately)
		realize_spritesheets(yield = FALSE)
	else
		SSasset_loading.generate_queue += src

/datum/asset/spritesheet/proc/realize_spritesheets(yield)
	if(fully_generated)
		return
	while(length(to_generate))
		var/list/stored_args = to_generate[to_generate.len]
		to_generate.len--
		queuedInsert(arglist(stored_args))
		if(yield && TICK_CHECK)
			return

	ensure_stripped()
	for(var/size_id in sizes)
		var/size = sizes[size_id]
		SSassets.transport.register_asset("[name]_[size_id].png", size[SPRSZ_STRIPPED])
	var/res_name = "spritesheet_[name].css"
	var/fname = "data/spritesheets/[res_name]"
	fdel(fname)
	text2file(generate_css(), fname)
	SSassets.transport.register_asset(res_name, fcopy_rsc(fname))
	fdel(fname)

	if (CONFIG_GET(flag/cache_assets) && cross_round_cachable)
		write_to_cache()

	fully_generated = TRUE
	// If we were ever in there, remove ourselves
	SSasset_loading.generate_queue -= src

/datum/asset/spritesheet/queued_generation()
	realize_spritesheets(yield = TRUE)

/datum/asset/spritesheet/ensure_ready()
	if(!fully_generated)
		realize_spritesheets(yield = FALSE)
	return ..()

/datum/asset/spritesheet/send(client/client)
	if (!name)
		return

	if (!should_refresh())
		return send_from_cache(client)

	var/all = list("spritesheet_[name].css")
	for(var/size_id in sizes)
		all += "[name]_[size_id].png"
	. = SSassets.transport.send_assets(client, all)

/datum/asset/spritesheet/get_url_mappings()
	if (!name)
		return

	if (!should_refresh())
		return get_cached_url_mappings()

	. = list("spritesheet_[name].css" = SSassets.transport.get_asset_url("spritesheet_[name].css"))
	for(var/size_id in sizes)
		.["[name]_[size_id].png"] = SSassets.transport.get_asset_url("[name]_[size_id].png")

/datum/asset/spritesheet/proc/ensure_stripped(sizes_to_strip = sizes)
	for(var/size_id in sizes_to_strip)
		var/size = sizes[size_id]
		if (size[SPRSZ_STRIPPED])
			continue

		// save flattened version
		var/fname = "data/spritesheets/[name]_[size_id].png"
		fcopy(size[SPRSZ_ICON], fname)
		var/error = rustg_dmi_strip_metadata(fname)
		if(length(error))
			stack_trace("Failed to strip [name]_[size_id].png: [error]")
		size[SPRSZ_STRIPPED] = icon(fname)
		fdel(fname)

/datum/asset/spritesheet/proc/generate_css()
	var/list/out = list()

	for (var/size_id in sizes)
		var/size = sizes[size_id]
		var/icon/tiny = size[SPRSZ_ICON]
		out += ".[name][size_id]{display:inline-block;width:[tiny.Width()]px;height:[tiny.Height()]px;background:url('[get_background_url("[name]_[size_id].png")]') no-repeat;}"

	for (var/sprite_id in sprites)
		var/sprite = sprites[sprite_id]
		var/size_id = sprite[SPR_SIZE]
		var/idx = sprite[SPR_IDX]
		var/size = sizes[size_id]

		var/icon/tiny = size[SPRSZ_ICON]
		var/icon/big = size[SPRSZ_STRIPPED]
		var/per_line = big.Width() / tiny.Width()
		var/x = (idx % per_line) * tiny.Width()
		var/y = round(idx / per_line) * tiny.Height()

		out += ".[name][size_id].[sprite_id]{background-position:-[x]px -[y]px;}"

	return out.Join("\n")

/datum/asset/spritesheet/proc/read_from_cache()
	var/replaced_css = file2text("[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[name].css")

	var/regex/find_background_urls = regex(@"background:url\('%(.+?)%'\)", "g")
	while (find_background_urls.Find(replaced_css))
		var/asset_id = find_background_urls.group[1]
		var/asset_cache_item = SSassets.transport.register_asset(asset_id, "[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[asset_id]")
		var/asset_url = SSassets.transport.get_asset_url(asset_cache_item = asset_cache_item)
		replaced_css = replacetext(replaced_css, find_background_urls.match, "background:url('[asset_url]')")
		LAZYADD(cached_spritesheets_needed, asset_id)

	var/replaced_css_filename = "data/spritesheets/spritesheet_[name].css"
	rustg_file_write(replaced_css, replaced_css_filename)
	SSassets.transport.register_asset("spritesheet_[name].css", replaced_css_filename)

	fdel(replaced_css_filename)

	return TRUE

/datum/asset/spritesheet/proc/send_from_cache(client/client)
	if (isnull(cached_spritesheets_needed))
		stack_trace("cached_spritesheets_needed was null when sending assets from [type] from cache")
		cached_spritesheets_needed = list()

	return SSassets.transport.send_assets(client, cached_spritesheets_needed + "spritesheet_[name].css")

/// Returns the URL to put in the background:url of the CSS asset
/datum/asset/spritesheet/proc/get_background_url(asset)
	if (generating_cache)
		return "%[asset]%"
	else
		return SSassets.transport.get_asset_url(asset)

/datum/asset/spritesheet/proc/write_to_cache()
	for (var/size_id in sizes)
		fcopy(SSassets.cache["[name]_[size_id].png"].resource, "[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[name]_[size_id].png")

	generating_cache = TRUE
	var/mock_css = generate_css()
	generating_cache = FALSE

	rustg_file_write(mock_css, "[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[name].css")

/datum/asset/spritesheet/proc/get_cached_url_mappings()
	var/list/mappings = list()
	mappings["spritesheet_[name].css"] = SSassets.transport.get_asset_url("spritesheet_[name].css")

	for (var/asset_name in cached_spritesheets_needed)
		mappings[asset_name] = SSassets.transport.get_asset_url(asset_name)

	return mappings

/**
 *! Override this in order to start the creation of the spritesheet.
 *! This is where all your Insert, InsertAll, etc calls should be inside.
 */
/datum/asset/spritesheet/proc/create_spritesheets()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("create_spritesheets() not implemented for [type]!")
/**
 * neither prefixes nor states may have spaces!
 */
/datum/asset/spritesheet/proc/Insert(sprite_name, icon/I, icon_state="", dir=SOUTH, frame=1, moving=FALSE)
	if(load_immediately)
		queuedInsert(sprite_name, I, icon_state, dir, frame, moving)
	else
		to_generate += list(args.Copy())

/**
 * LEMON NOTE
 * A GOON CODER SAYS BAD ICON ERRORS CAN BE THROWN BY THE "ICON CACHE"
 * APPARENTLY IT MAKES ICONS IMMUTABLE
 * LOOK INTO USING THE MUTABLE APPEARANCE PATTERN HERE
 *
 * neither prefixes nor states may have spaces!
 */
/datum/asset/spritesheet/proc/queuedInsert(sprite_name, icon/I, icon_state="", dir=SOUTH, frame=1, moving=FALSE)
	I = icon(I, icon_state=icon_state, dir=dir, frame=frame, moving=moving)
	if (!I || !length(icon_states(I))) // That direction or state doesn't exist!
		return
	// Any sprite modifications we want to do (aka, coloring a greyscaled asset)
	I = ModifyInserted(I)
	var/size_id = "[I.Width()]x[I.Height()]"
	var/size = sizes[size_id]

	if (sprites[sprite_name])
		CRASH("duplicate sprite \"[sprite_name]\" in sheet [name] ([type])")

	if (size)
		var/position = size[SPRSZ_COUNT]++
		var/icon/sheet = size[SPRSZ_ICON]
		var/icon/sheet_copy = icon(sheet)
		size[SPRSZ_STRIPPED] = null
		sheet_copy.Insert(I, icon_state=sprite_name)
		size[SPRSZ_ICON] = sheet_copy
		sprites[sprite_name] = list(size_id, position)
	else
		sizes[size_id] = size = list(1, I, null)
		sprites[sprite_name] = list(size_id, 0)

/**
 * A simple proc handing the Icon for you to modify before it gets turned into an asset.
 *
 * Arguments:
 * * I: icon being turned into an asset
 */
/datum/asset/spritesheet/proc/ModifyInserted(icon/pre_asset)
	return pre_asset

/**
 * neither prefixes nor states may have spaces!
 */
/datum/asset/spritesheet/proc/InsertAll(prefix, icon/I, list/directions)
	if (length(prefix))
		prefix = "[prefix]-"

	if (!directions)
		directions = list(SOUTH)

	for (var/icon_state_name in icon_states(I))
		for (var/direction in directions)
			var/prefix2 = (directions.len > 1) ? "[dir2text(direction)]-" : ""
			Insert("[prefix][prefix2][icon_state_name]", I, icon_state=icon_state_name, dir=direction)

/datum/asset/spritesheet/proc/css_tag()
	return {"<link rel="stylesheet" href="[css_filename()]" />"}

/datum/asset/spritesheet/proc/css_filename()
	return SSassets.transport.get_asset_url("spritesheet_[name].css")

/datum/asset/spritesheet/proc/icon_tag(sprite_name)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	return {"<span class='[name][size_id] [sprite_name]'></span>"}

/datum/asset/spritesheet/proc/icon_class_name(sprite_name)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	return {"[name][size_id] [sprite_name]"}

/**
 * Returns the size class (ex design32x32) for a given sprite's icon
 *
 * Arguments:
 * * sprite_name - The sprite to get the size of
 */
/datum/asset/spritesheet/proc/icon_size_id(sprite_name)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	return "[name][size_id]"

#undef SPR_SIZE
#undef SPR_IDX
#undef SPRSZ_COUNT
#undef SPRSZ_ICON
#undef SPRSZ_STRIPPED
