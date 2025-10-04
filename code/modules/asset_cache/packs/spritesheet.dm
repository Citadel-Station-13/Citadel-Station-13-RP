
/**
 * spritesheet implementation - coalesces various icons into a single .png file
 * and uses CSS to select icons out of that file - saves on transferring some
 * 1400-odd individual PNG files
 *
 * To use, use classes of "[name][size_key]" and the state name used in insert().
 * If you used insert_all(), don't forget the prefix.
 *
 * Example: <div class='sheetmaterials32x32 glass-3'>
 * In tgui, usually would be className={classes(['sheetmaterials32x32', 'glass-3'])}
 */
#define SPR_SIZE 1
#define SPR_IDX  2

#define SPRSZ_COUNT    1
#define SPRSZ_ICON     2
#define SPRSZ_STRIPPED 3

/datum/asset_pack/spritesheet
	abstract_type = /datum/asset_pack/spritesheet
	do_not_separate = TRUE
	/// so unfortunately we can't mangle it due to the fact that
	/// * the .css needs to know where the image is
	/// * we don't know what to name the image until the entire pack is encoded
	/// * so the easiest way is to set do_not_mangle to TRUE for now, and deal with it later
	/// todo: completely unnecessarily overengineer some more and fix this in 2025 ~silicons
	do_not_mangle = TRUE
	/// the spritesheet's name
	var/name

	/**
	 * List of arguments to pass into do_insert.
	 * Exists so we can queue icon insertion, mostly for stuff like preferences.
	 */
	var/list/to_generate = list()

	/// "32x32" -> list(10, icon/normal, icon/stripped)
	var/list/sizes = list()
	/// "foo_bar" -> list("32x32", 5)
	var/list/sprites = list()

/datum/asset_pack/spritesheet/unload()
	..()
	to_generate = list()
	sizes = list()
	sprites = list()

/datum/asset_pack/spritesheet/register(generation)
	return construct()

/datum/asset_pack/spritesheet/proc/get_css_url()
	return get_url("spritesheet_[name].css")

/datum/asset_pack/spritesheet/proc/construct()
	. = list()

	while(length(to_generate))
		var/list/stored_args = to_generate[to_generate.len]
		to_generate.len--
		do_insert(arglist(stored_args))
		CHECK_TICK

	ensure_stripped()
	for(var/size_id in sizes)
		var/size = sizes[size_id]
		.["[name]_[size_id].png"] = size[SPRSZ_STRIPPED]

	var/fname = "tmp/assets/spritesheets/[name].css"
	fdel(fname)
	text2file(generate_css(), fname)
	var/res_name = "spritesheet_[name].css"
	.[res_name] = fname

/datum/asset_pack/spritesheet/proc/ensure_stripped(sizes_to_strip = sizes)
	for(var/size_id in sizes_to_strip)
		var/size = sizes[size_id]
		if (size[SPRSZ_STRIPPED])
			continue

		// save flattened version
		var/fname = "tmp/assets/spritesheets/[name]_[size_id].png"
		fdel(fname)
		fcopy(size[SPRSZ_ICON], fname)
		var/error = rustg_dmi_strip_metadata(fname)
		if(length(error))
			stack_trace("Failed to strip [name]_[size_id].png: [error]")
		size[SPRSZ_STRIPPED] = icon(fname)

/datum/asset_pack/spritesheet/proc/generate_css()
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

/// Returns the URL to put in the background:url of the CSS asset
/datum/asset_pack/spritesheet/proc/get_background_url(image_name)
	return image_name

/**
 * LEMON NOTE
 * A GOON CODER SAYS BAD ICON ERRORS CAN BE THROWN BY THE "ICON CACHE"
 * APPARENTLY IT MAKES ICONS IMMUTABLE
 * LOOK INTO USING THE MUTABLE APPEARANCE PATTERN HERE
 *
 * neither prefixes nor states may have spaces!
 */
/datum/asset_pack/spritesheet/proc/do_insert(sprite_name, icon/I, icon_state = "", dir = SOUTH, frame = 1, moving = FALSE, skip_checks)
	I = icon(I, icon_state, dir, frame, moving)
	// Check that it exists.
	if(!skip_checks && !length(adaptive_icon_states(I)))
		return
	// Any sprite modifications we want to do (aka, coloring a greyscaled asset)
	I = modify_inserted(I)
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
 * neither prefixes nor states may have spaces!
 */
/datum/asset_pack/spritesheet/proc/insert(sprite_name, icon/I, icon_state="", dir=SOUTH, frame=1, moving=FALSE, skip_checks)
	to_generate += list(args.Copy())

/**
 * neither prefixes nor states may have spaces!
 */
/datum/asset_pack/spritesheet/proc/insert_all(prefix, icon/I, list/directions)
	if (length(prefix))
		prefix = "[prefix]-"

	if (!directions)
		directions = list(SOUTH)

	for (var/icon_state_name in icon_states(I))
		for (var/direction in directions)
			var/prefix2 = (directions.len > 1) ? "[dir2text(direction)]-" : ""
			insert("[prefix][prefix2][icon_state_name]", I, icon_state=icon_state_name, dir=direction)

/**
 * A simple proc handing the Icon for you to modify before it gets turned into an asset.
 *
 * Arguments:
 * * I: icon being turned into an asset
 */
/datum/asset_pack/spritesheet/proc/modify_inserted(icon/pre_asset)
	return pre_asset

/**
 * todo: deprecated; logic should be tgui-side.
 */
/datum/asset_pack/spritesheet/proc/icon_tag(sprite_name)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	return {"<span class='[name][size_id] [sprite_name]'></span>"}

/**
 * todo: deprecated; logic should be tgui-side.
 */
/datum/asset_pack/spritesheet/proc/icon_class_name(sprite_name)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	return {"[name][size_id] [sprite_name]"}

#undef SPR_SIZE
#undef SPR_IDX
#undef SPRSZ_COUNT
#undef SPRSZ_ICON
#undef SPRSZ_STRIPPED
