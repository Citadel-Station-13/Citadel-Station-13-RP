/**
 * loads a dmm map
 * raw operation, does not annihilate tiles or anything,
 *
 * ### Positioning
 *
 * ll_x/y/z are inclusive.
 * x/y_lower/upper are inclusive.
 *
 * ### Cropping
 *
 * When using x/y_lower/upper, this changes which area of the dmm we actually parse. if you do 5, 5 to 10, 10,
 * and load it at llx/y 10, 10, you end up loading a 6x6 chunk from the game world coordinates 10, 10,
 * to the game world coordinates 15, 15
 *
 * This also immediately crops what's loaded, so, don't use this if you want to have more sections of the parsed map done later.
 *
 * @params
 * * map - dmm file() or a raw file2text'd file
 * * ll_x - lowerleft x
 * * ll_y - lowerleft y
 * * ll_z - lowerleft z. for multiz, this is bottomleft.
 * * x_lower - crop dmm load to this x.
 * * y_lower - crop dmm load to this y.
 * * x_upper - crop dmm load to this x.
 * * y_upper - crop dmm load to this y.
 * * z_lower - crop dmm load to this z.
 * * z_upper - crop dmm load to this z.
 * * no_changeturf - do not call [turf/AfterChange] when loading turfs.
 * * place_on_top - use PlaceOnTop instead of ChangeTurf
 * * orientation - cardinal dir to do. default is south.
 * * area_cache - override area cache and provide your own, usually used to ensure multiple loadings share the same /area's.
 *
 * @return /datum/dmm_parsed instance
 */
/proc/load_map(map, ll_x, ll_y, ll_z, x_lower, y_lower, x_upper, y_upper, z_lower, z_upper, no_changeturf, place_on_top, orientation, list/area_cache)
	var/datum/dmm_parsed/parsed = new(map, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper)
	. = parsed
	parsed.load(ll_x, ll_y, ll_z, no_changeturf = no_changeturf, place_on_top = place_on_top, orientation = orientation, area_cache = area_cache)

/**
 * parses a dmm map
 *
 * see [/proc/load_map] for args.
 *
 * @return /datum/dmm_parsed instance
 */
/proc/parse_map(map, x_lower, y_lower, x_upper, y_upper, z_lower, z_upper)
	return new /datum/dmm_parsed(map, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper)

/**
 * SS13 optimized map loader
 *
 * Notes:
 * * This does NOT support map files where more than one Z is in each grid set, as defined in the file.
 * * MultiZ map files ARE supported (however very much discouraged), as long as each gridset only contains one z.
 * * This assumes that for the most part, map files are properly formed, either DMM or TGM standard formats. If you feed it bad data, expect to crash.
 *
 * Citadel Edits:
 * * Expanding the world is no longer allowed due to various issues with the BYOND engine that occurs due to expansion.
 */
#define SPACE_KEY "space"

/datum/dmm_gridset
	var/xcrd
	var/ycrd
	var/zcrd
	var/grid_lines

/datum/dmm_gridset/proc/height(key_len)
	return length(grid_lines)

/datum/dmm_gridset/proc/width(key_len)
	return grid_lines[1] / key_len

/datum/dmm_parsed
	/// Original path this was loaded from
	var/original_path
	/// key length of the .dmm
	var/key_len = 0
	/// dmm_gridsets - holds each set of grids in the .dmm
	var/list/grid_sets = list()
	/// grid models - holds each model line as string associated to the key like AAA = (/blah, /area/blah, /turf/blah)
	var/list/grid_models = list()
	/// cached, unpacked models so re-loads of the same map are far cheaper. only created on first load.
	var/list/model_cache
	/// did we have no changeturf set when we made the model cache?
	var/model_cache_is_no_changeturf
	/// parse successful?
	var/tmp/parsed = FALSE
	/// parsed width - this is subject to cropping!
	var/tmp/width
	/// parsed height - this is subject to cropping!
	var/tmp/height
	/// parsed bounds - non-offset
	var/tmp/list/bounds
	/// last loaded bounds
	var/tmp/list/last_loaded_bounds
	/// template we belong to, if any - makes average case dels faster
	var/tmp/datum/map_template/template_host

	#ifdef TESTING
	var/turfsSkipped = 0
	#endif

	// the actual regexes used to parse maps
	// you should probably not touch these
	// raw strings used to represent regexes more accurately
	// '' used to avoid confusing syntax highlighting
	var/static/regex/dmmRegex = new(@'"([a-zA-Z]+)" = \(((?:.|\n)*?)\)\n(?!\t)|\((\d+),(\d+),(\d+)\) = \{"([a-zA-Z\n]*)"\}', "g")
	var/static/regex/trimQuotesRegex = new(@'^[\s\n]+"?|"?[\s\n]+$|^"|"$', "g")
	var/static/regex/trimRegex = new(@'^[\s\n]+|[\s\n]+$', "g")
	/// used to parse out \[, \] to their unescaped forms
	var/static/regex/textConstantProcessing = new(@'\\([\[\]])', "g")

/**
 * creates and parses a map
 *
 * cropping here is cropping what you'd see in the map editor, aka can actually throw out data.
 */
/datum/dmm_parsed/New(map, x_lower = -INFINITY, x_upper = INFINITY, y_lower = -INFINITY, y_upper = INFINITY, z_lower = -INFINITY, z_upper = INFINITY)
	_parse(map, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper)

/datum/dmm_parsed/proc/_parse(tfile, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper)
	var/static/parsing = FALSE
	UNTIL(!parsing)
	// do not multithread this or bad things happen
	parsing = TRUE
	_do_parse(tfile, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper)
	parsing = FALSE

/datum/dmm_parsed/proc/_do_parse(tfile, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper)
	if(isfile(tfile))
		original_path = "[tfile]"
		tfile = file2text(tfile)
	else if(isnull(tfile))
		// create a new datum without loading a map
		return
	bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	ASSERT(x_upper >= x_lower)
	ASSERT(y_upper >= y_lower)
	ASSERT(z_upper >= z_lower)
	var/stored_index = 1

	//multiz lool
	while(dmmRegex.Find(tfile, stored_index))
		stored_index = dmmRegex.next

		// "aa" = (/type{vars=blah})
		if(dmmRegex.group[1]) // Model
			var/key = dmmRegex.group[1]
			if(grid_models[key]) // Duplicate model keys are ignored in DMMs
				continue
			if(key_len != length(key))
				if(!key_len)
					key_len = length(key)
				else
					CRASH("Inconsistent key length in DMM")
			// if(!measureOnly)
			grid_models[key] = dmmRegex.group[2]

		// (1,1,1) = {"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}
		else if(dmmRegex.group[3]) // Coords
			if(!key_len)
				CRASH("Coords before model definition in DMM")

			// NOTE: We are assuming each coordset only contains one z.
			var/curr_z = text2num(dmmRegex.group[5])
			if(curr_z < z_lower || curr_z > z_upper)
				continue

			var/curr_x = text2num(dmmRegex.group[3])
			var/curr_y = text2num(dmmRegex.group[4])

			var/datum/dmm_gridset/gridSet = new

			gridSet.xcrd = curr_x
			gridSet.ycrd = curr_y
			gridSet.zcrd = curr_z

			var/list/grid_lines = splittext(dmmRegex.group[6], "\n")
			gridSet.grid_lines = grid_lines

			var/leadingBlanks = 0
			while(leadingBlanks < grid_lines.len && grid_lines[++leadingBlanks] == "")
			if(leadingBlanks > 1)
				grid_lines.Cut(1, leadingBlanks) // Remove all leading blank lines.

			var/lines = length(grid_lines)
			if(lines && grid_lines[lines] == "")
				// remove one trailing blank line
				grid_lines.len--
				lines--
			// y crop
			var/right_length = y_upper - curr_y + 1
			if(lines > right_length)
				lines = grid_lines.len = right_length
			if(!lines)			// blank
				continue

			var/width = length(grid_lines[1]) / key_len
			// x crop
			var/right_width = x_upper - curr_x + 1
			if(width > right_width)
				for(var/i in 1 to lines)
					grid_lines[i] = copytext(grid_lines[i], 1, key_len * right_width)

			// during the actual load we're starting at the top and working our way down
			gridSet.ycrd += lines - 1

			// Safe to proceed, commit gridset to list and record coords.
			grid_sets += gridSet
			bounds[MAP_MINX] = min(bounds[MAP_MINX], curr_x)
			bounds[MAP_MAXX] = max(bounds[MAP_MAXX], curr_x + width - 1)
			bounds[MAP_MINY] = min(bounds[MAP_MINY], curr_y)
			bounds[MAP_MAXY] = max(bounds[MAP_MAXY], curr_y + lines - 1)
			bounds[MAP_MINZ] = min(bounds[MAP_MINZ], curr_z)
			bounds[MAP_MAXZ] = max(bounds[MAP_MAXZ], curr_z)
		CHECK_TICK

	// Indicate failure to parse any coordinates by nulling bounds
	if(bounds[1] == 1.#INF)
		bounds = null
	else
		width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1
		height = bounds[MAP_MAXY] - bounds[MAP_MINY] + 1

/datum/dmm_parsed/Destroy()
	if(template_host?.parsed == src)
		template_host.parsed = null
	. = ..()
	return QDEL_HINT_HARDDEL

/**
 * loads our map into the game world
 * raw operation, does not annihilate tiles or anything,
 *
 * ### Positioning
 *
 * ll_x/y/z are inclusive.
 * x/y_lower/upper are inclusive.
 *
 * ### Cropping
 *
 * When using x/y_lower/upper, this changes which area of the dmm we actually load. if you do 5, 5 to 10, 10,
 * and load it at llx/y 10, 10, you end up loading a 6x6 chunk from the game world coordinates 10, 10,
 * to the game world coordinates 15, 15
 *
 * ### Overflows
 *
 * Overflows to world bounds will be logged and denied.
 *
 * @params
 * * map - dmm file or path or rsc entry
 * * ll_x - lowerleft x
 * * ll_y - lowerleft y
 * * ll_z - lowerleft z. for multiz, this is bottomleft.
 * * x_lower - crop dmm load to this x.
 * * y_lower - crop dmm load to this y.
 * * x_upper - crop dmm load to this x.
 * * y_upper - crop dmm load to this y.
 * * z_lower - crop dmm load to this z.
 * * z_upper - crop dmm load to this z.
 * * no_changeturf - do not call [turf/AfterChange] when loading turfs.
 * * place_on_top - use PlaceOnTop instead of ChangeTurf
 * * area_cache - override area cache and provide your own, used to make sure multiple loadings share the same areas if two areas are the same type.
 *
 * @return bounds list of load, or null if failed.
 */
/datum/dmm_parsed/proc/load(x, y, z, x_lower = -INFINITY, x_upper = INFINITY, y_lower = -INFINITY, y_upper = INFINITY, z_lower = -INFINITY, z_upper = INFINITY, no_changeturf, place_on_top, orientation = SOUTH, list/area_cache)

	var/static/loading = FALSE
	UNTIL(!loading)
	loading = TRUE
	Master.StartLoadingMap()
	. = _load_impl(arglist(args))
	Master.StopLoadingMap()
	loading = FALSE

// todo: verify that when rotating, things load in the same way when cropped e.g. aligned to lower left
//       as opposed to rotating to somewhere else
/datum/dmm_parsed/proc/_load_impl(x, y, z, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, no_changeturf, place_on_top, orientation = SOUTH, list/area_cache = list())
	var/list/model_cache = build_cache(no_changeturf)
	var/space_key = model_cache[SPACE_KEY]

	var/list/loaded_bounds = list(INFINITY, INFINITY, INFINITY, -INFINITY, -INFINITY, -INFINITY)

	var/datum/dmm_orientation/orientation_pattern = GLOB.dmm_orientations["[orientation]"]

	var/invert_y = orientation_pattern.invert_y
	var/invert_x = orientation_pattern.invert_x
	var/swap_xy = orientation_pattern.swap_xy
	var/xi = orientation_pattern.xi
	var/yi = orientation_pattern.yi
	var/turn_angle = round(SIMPLIFY_DEGREES(orientation_pattern.turn_angle), 90)
	var/delta_swap = x - y

	// less checks later
	var/do_crop = x_lower > -INFINITY || x_upper < INFINITY || y_lower > -INFINITY || y_upper < INFINITY
	// did we try to run out of bounds?
	var/overflowed = FALSE

	for(var/datum/dmm_gridset/gridset as anything in grid_sets)
		var/load_z = gridset.zcrd + z - 1
		if(load_z > world.maxz)
			overflowed = TRUE
			continue

		//these values are the same until a new gridset is reached.
		var/edge_dist_x = gridset.xcrd - 1											//from left side, 0 is right on the x_offset
		var/edge_dist_y = gridset.ycrd - length(gridset.grid_lines)					//from bottom, 0 is right on the y_offset
		var/actual_x_starting = invert_x? (x + width - edge_dist_x - 1) : (x + edge_dist_x)		//this value is not changed, cache.
		//this value is changed
		var/actual_y = invert_y? (y + edge_dist_y) : (y + gridset.ycrd - 1)

		for(var/line in gridset.grid_lines)
			var/actual_x = actual_x_starting
			for(var/pos = 1 to (length(line) - key_len + 1) step key_len)
				var/placement_x = swap_xy? (actual_y + delta_swap) : actual_x
				var/placement_y = swap_xy? (actual_x - delta_swap) : actual_y
				// todo: i have no clue what this does, i wrote this code years ago ~silicons
				// this is probably skipping the tiles that we're cropping after calculating where it is, though for some reason
				// pos isn't being taken into account, which is a ????
				if(do_crop && ((placement_x < x_lower) || (placement_x > x_upper) || (placement_y < y_lower) || (placement_y > y_upper)))
					continue
				// todo: i have no clue what this does, i wrote this code years ago ~silicons
				// as you can see, this is not quite efficient
				// try not to overrun the world.
				// this is probably skipping the tiles while offsetting so the rest still load in even while
				// skipping (???)
				if(placement_x > world.maxx)
					actual_x += xi
					overflowed = TRUE
					continue
				if(placement_y > world.maxy)
					actual_y += yi
					overflowed = TRUE
					continue
				if(placement_x < 1)
					actual_x += xi
					overflowed = TRUE
					continue
				if(placement_y < 1)
					actual_y += yi
					overflowed = TRUE
					continue
				var/model_key = copytext(line, pos, pos + key_len)
				if(!no_changeturf || (model_key != space_key))
					var/list/cache = model_cache[model_key]
					if(!cache)
						CRASH("Undefined model key in DMM: [model_key]")
					build_coordinate(area_cache, cache, locate(placement_x, placement_y, load_z), no_changeturf, place_on_top, turn_angle, swap_xy, invert_y, invert_x)

					// only bother with bounds that actually exist
					loaded_bounds[MAP_MINX] = min(loaded_bounds[MAP_MINX], placement_x)
					loaded_bounds[MAP_MINY] = min(loaded_bounds[MAP_MINY], placement_y)
					loaded_bounds[MAP_MINZ] = min(loaded_bounds[MAP_MINZ], load_z)
					loaded_bounds[MAP_MAXX] = max(loaded_bounds[MAP_MAXX], placement_x)
					loaded_bounds[MAP_MAXY] = max(loaded_bounds[MAP_MAXY], placement_y)
					loaded_bounds[MAP_MAXZ] = max(loaded_bounds[MAP_MAXZ], load_z)
				#ifdef TESTING
				else
					++turfsSkipped
				#endif
				actual_x += xi
				CHECK_TICK
			actual_y += yi
			CHECK_TICK

	// this weird block of code calls AfterChange after everything is loaded to build adjacent turfs/zones/etc without doing it midway.
	if(!no_changeturf)
		for(var/turf/T as anything in block(
			locate(
				loaded_bounds[MAP_MINX],
				loaded_bounds[MAP_MINY],
				loaded_bounds[MAP_MINZ]
			),
			locate(
				loaded_bounds[MAP_MAXX],
				loaded_bounds[MAP_MAXY],
				loaded_bounds[MAP_MAXZ]
			)
		))
			T.AfterChange(CHANGETURF_IGNORE_AIR)

	if(overflowed)
		log_debug("Maploaders was stopped from expanding world.maxx/world.maxy. This shouldn't happen.")

	return loaded_bounds

/datum/dmm_parsed/proc/build_cache(no_changeturf, bad_paths=null)
	if(model_cache && !bad_paths)
		return model_cache
	. = model_cache = list()
	var/list/grid_models = src.grid_models
	for(var/model_key in grid_models)
		var/model = grid_models[model_key]
		var/list/members = list() //will contain all members (paths) in model (in our example : /turf/unsimulated/wall and /area/mine/explored)
		var/list/members_attributes = list() //will contain lists filled with corresponding variables, if any (in our example : list(icon_state = "rock") and list())

		/////////////////////////////////////////////////////////
		//Constructing members and corresponding variables lists
		////////////////////////////////////////////////////////

		var/index = 1
		var/old_position = 1
		var/dpos

		while(dpos != 0)
			//finding next member (e.g /turf/unsimulated/wall{icon_state = "rock"} or /area/mine/explored)
			dpos = find_next_delimiter_position(model, old_position, ",", "{", "}") //find next delimiter (comma here) that's not within {...}

			var/full_def = trim_text(copytext(model, old_position, dpos)) //full definition, e.g : /obj/foo/bar{variables=derp}
			var/variables_start = findtext(full_def, "{")
			var/path_text = trim_text(copytext(full_def, 1, variables_start))
			var/atom_def = text2path(path_text) //path definition, e.g /obj/foo/bar
			if(dpos)
				old_position = dpos + length(model[dpos])

			if(!ispath(atom_def, /atom)) // Skip the item if the path does not exist.  Fix your crap, mappers!
				if(bad_paths)
					LAZYDISTINCTADD(bad_paths[path_text], model_key)
				continue
			members.Add(atom_def)

			//transform the variables in text format into a list (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
			var/list/fields = list()

			if(variables_start)//if there's any variable
				full_def = copytext(full_def, variables_start + length(full_def[variables_start]), -length(copytext_char(full_def, -1))) //removing the last '}'
				fields = readlist(full_def, ";")
				if(fields.len)
					if(!trim(fields[fields.len]))
						--fields.len
					for(var/I in fields)
						var/value = fields[I]
						if(istext(value))
							fields[I] = apply_text_macros(value)

			//then fill the members_attributes list with the corresponding variables
			members_attributes.len++
			members_attributes[index++] = fields

			CHECK_TICK

		//check and see if we can just skip this turf
		//So you don't have to understand this horrid statement, we can do this if
		// 1. no_changeturf is set
		// 2. the space_key isn't set yet
		// 3. there are exactly 2 members
		// 4. with no attributes
		// 5. and the members are world.turf and world.area
		// Basically, if we find an entry like this: "XXX" = (/turf/default, /area/default)
		// We can skip calling this proc every time we see XXX
		if(no_changeturf \
			&& !(.[SPACE_KEY]) \
			&& members.len == 2 \
			&& members_attributes.len == 2 \
			&& length(members_attributes[1]) == 0 \
			&& length(members_attributes[2]) == 0 \
			&& (world.area in members) \
			&& (world.turf in members))

			.[SPACE_KEY] = model_key
			continue


		.[model_key] = list(members, members_attributes)

/datum/dmm_parsed/proc/build_coordinate(list/areaCache, list/model, turf/crds, no_changeturf, placeOnTop, turn_angle, swap_xy, invert_y, invert_x)
	var/index
	var/list/members = model[1]
	var/list/members_attributes = model[2]

	////////////////
	//Instanciation
	////////////////

	//The next part of the code assumes there's ALWAYS an /area AND a /turf on a given tile
	//first instance the /area and remove it from the members list
	index = members.len
	// todo: do we need this? this was so it annihilates while loading instead of annihilates before, which was useful in specific circumstances
	/*
	if(annihilate_tiles && crds)
		crds.empty(null)
	*/
	if(members[index] != /area/template_noop)
		var/atype = members[index]
		var/area/instance = areaCache[atype]
		if(isnull(instance))
			// check uniqueness
			var/area/area_casted = atype
			if(initial(area_casted.unique))
				// unique, give it one more chance
				instance = GLOB.areas_by_type[atype]
			// still null?
			if(isnull(instance))
				// create it
				// preloader / loading only done if we're making the instance.
				// warranty void if a map has varedited areas; you should know better, linter already checks against it.
				world.preloader_setup(members_attributes[index], atype, turn_angle, invert_x, invert_y, swap_xy)
				instance = new atype(null)
				if(GLOB.use_preloader)
					world.preloader_load(instance)
			areaCache[atype] = instance
		instance.contents.Add(crds)

	//then instance the /turf and, if multiple tiles are presents, simulates the DMM underlays piling effect

	var/first_turf_index = 1
	while(!ispath(members[first_turf_index], /turf)) //find first /turf object in members
		first_turf_index++

	//turn off base new Initialization until the whole thing is loaded
	SSatoms.map_loader_begin()
	//instanciate the first /turf
	var/turf/T
	if(members[first_turf_index] != /turf/template_noop)
		T = instance_atom(members[first_turf_index],members_attributes[first_turf_index],crds,no_changeturf,placeOnTop,turn_angle, swap_xy, invert_y, invert_x)

	if(T)
		//if others /turf are presents, simulates the underlays piling effect
		index = first_turf_index + 1
		while(index <= members.len - 1) // Last item is an /area
			var/underlay = T.appearance
			T = instance_atom(members[index],members_attributes[index],crds,no_changeturf,placeOnTop,turn_angle, swap_xy, invert_y, invert_x)//instance new turf
			T.underlays += underlay
			index++

	//finally instance all remainings objects/mobs
	for(index in 1 to first_turf_index-1)
		instance_atom(members[index],members_attributes[index],crds,no_changeturf,placeOnTop,turn_angle, swap_xy, invert_y, invert_x)
	//Restore initialization to the previous value
	SSatoms.map_loader_stop()

////////////////
//Helpers procs
////////////////

//Instance an atom at (x,y,z) and gives it the variables in attributes
/datum/dmm_parsed/proc/instance_atom(path,list/attributes, turf/crds, no_changeturf, placeOnTop, turn_angle = 0, swap_xy, invert_y, invert_x)
	world.preloader_setup(attributes, path, turn_angle, invert_x, invert_y, swap_xy)

	if(ispath(path, /turf))
		if(placeOnTop)
			. = crds.PlaceOnTop(null, path, CHANGETURF_DEFER_CHANGE | (no_changeturf ? CHANGETURF_SKIP : NONE))
		else if(!no_changeturf)
			. = crds.ChangeTurf(path, null, CHANGETURF_DEFER_CHANGE)
		else
			. = create_atom(path, crds)//first preloader pass
	else
		. = create_atom(path, crds)//first preloader pass

	if(GLOB.use_preloader)//second preloader pass, for those atoms that don't ..() in New()
		world.preloader_load(.)

	//custom CHECK_TICK here because we don't want things created while we're sleeping to not initialize
	if(TICK_CHECK)
		SSatoms.map_loader_stop()
		stoplag()
		SSatoms.map_loader_begin()

/**
 * create an atom at a location
 *
 * * don't use this for turfs
 * * use instance_atom, don't use this
 */
/datum/dmm_parsed/proc/create_atom(path, atom/where)
	set waitfor = FALSE
	. = new path(where)

/**
 * i don't know what this does but the old documentation says:
 *
 * text trimming (both directions) helper proc
 * optionally removes quotes before and after the text (for variable name)
 */
/datum/dmm_parsed/proc/trim_text(str, trim_quotes)
	return trim_quotes? trimQuotesRegex.Replace(str, "") : trimRegex.Replace(str, "")

//find the position of the next delimiter,skipping whatever is comprised between opening_escape and closing_escape
//returns 0 if reached the last delimiter
// todo: comment this more
/datum/dmm_parsed/proc/find_next_delimiter_position(text as text,initial_position as num, delimiter=",",opening_escape="\"",closing_escape="\"")
	var/position = initial_position
	var/next_delimiter = findtext(text,delimiter,position,0)
	var/next_opening = findtext(text,opening_escape,position,0)

	while((next_opening != 0) && (next_opening < next_delimiter))
		position = findtext(text,closing_escape,next_opening + 1,0)+1
		next_delimiter = findtext(text,delimiter,position,0)
		next_opening = findtext(text,opening_escape,position,0)

	return next_delimiter

//build a list from variables in text form (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
//return the filled list
// todo: parse / comment ths more
/datum/dmm_parsed/proc/readlist(text as text, delimiter=",")
	. = list()
	if (!text)
		return

	var/position
	var/old_position = 1

	while(position != 0)
		// find next delimiter that is not within  "..."
		position = find_next_delimiter_position(text,old_position,delimiter)

		// check if this is a simple variable (as in list(var1, var2)) or an associative one (as in list(var1="foo",var2=7))
		var/equal_position = findtext(text,"=",old_position, position)

		var/trim_left = trim_text(copytext(text,old_position,(equal_position ? equal_position : position)))
		var/left_constant = delimiter == ";" ? trim_left : parse_constant(trim_left)
		if(position)
			old_position = position + length(text[position])

		if(equal_position && !isnum(left_constant))
			// Associative var, so do the association.
			// Note that numbers cannot be keys - the RHS is dropped if so.
			var/trim_right = trim_text(copytext(text, equal_position + length(text[equal_position]), position))
			var/right_constant = parse_constant(trim_right)
			.[left_constant] = right_constant

		else  // simple var
			. += list(left_constant)

/**
 * parses the value of an attribute
 *
 * known limitations:
 * * text doesn't support \" and likely not most byond "text macros"
 * * lists don't support nested lists
 * * see: not parsed
 */
/datum/dmm_parsed/proc/parse_constant(text)
	// number
	var/num = text2num(text)
	if(isnum(num))
		return num

	// string
	if(text[1] == "\"")
		var/str = copytext(text, length(text[1]) + 1, findtext(text, "\"", length(text[1]) + 1))
		return textConstantProcessing.Replace(str, "$1")

	// list
	if(copytext(text, 1, 6) == "list(")//6 == length("list(") + 1
		return readlist(copytext(text, 6, -1))

	// typepath
	var/path = text2path(text)
	if(ispath(path))
		return path

	// file
	if(text[1] == "'")
		return file(copytext_char(text, 2, -1))

	// null
	if(text == "null")
		return null

	// not parsed:
	// - pops: /obj{name="foo"}
	// - new(), newlist(), icon(), matrix(), sound()

	// fallback: string
	return text

/datum/dmm_parsed/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(var_name == NAMEOF(src, dmmRegex) || var_name == NAMEOF(src, trimQuotesRegex) || var_name == NAMEOF(src, trimRegex))
		return FALSE
	return ..()
