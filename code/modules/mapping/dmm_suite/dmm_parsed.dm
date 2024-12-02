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
	return parsed.load(ll_x, ll_y, ll_z, no_changeturf = no_changeturf, place_on_top = place_on_top, orientation = orientation, area_cache = area_cache)

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

/**
 * This is a set of turfs, basically.
 *
 * todo: more documentation; which way does this sweep? is x/y/z bottom left?
 */
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
	/// parsed width - this is subject to cropping!
	var/tmp/width
	/// parsed height - this is subject to cropping!
	var/tmp/height
	/// parsed bounds - non-offset
	var/tmp/list/bounds
	/// template we belong to, if any - makes average case dels faster
	var/tmp/datum/map_template/template_host

	#ifdef TESTING
	var/turfsSkipped = 0
	#endif

	//* Loading *//
	/// last loaded bounds
	var/tmp/list/last_loaded_bounds

	//* Parsing *//
	/// parse successful?
	var/tmp/parsed = FALSE
	/// if exists, parse errors are inserted here
	///
	/// * parsing doesn't just happen in pre-load; build_cache() is only triggered during load.
	///
	/// todo: implement this and dmm_report so we can have reports of map validity.
	var/list/parse_error_out
	/// if exists, parse errors are limited to this amount to prevent OOMs
	var/parse_error_limit = 100
	/// build_cache: current model key being parsed
	///
	/// * this is here for context purposes so we know where we're at when an error occurs
	var/parsing_model_key

	//* Parsing - Regex *//

	// the actual regexes used to parse maps
	// you should probably not touch these
	// raw strings used to represent regexes more accurately
	// '' used to avoid confusing syntax highlighting
	var/static/regex/dmmRegex = new(@'"([a-zA-Z]+)" = \(((?:.|\n)*?)\)\n(?!\t)|\((\d+),(\d+),(\d+)\) = \{"([a-zA-Z\n]*)"\}', "g")
	var/static/regex/trimQuotesRegex = new(@'^[\s\n]+"?|"?[\s\n]+$|^"|"$', "g")
	var/static/regex/trimRegex = new(@'^[\s\n]+|[\s\n]+$', "g")
	/// used to parse out \[, \], \\ to their unescaped forms
	var/static/regex/text_constant_regex = new(@{"\\([\[\]\\])"}, "g")

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
 * * orientation - orientation to load. the 'natural' orientation is SOUTH. Any other orientation rotates it with respect from SOUTH to it.
 * * area_cache - override area cache and provide your own, used to make sure multiple loadings share the same areas if two areas are the same type.
 * * context - value to push to preloader's maploader context, used by atoms during preloading_instance() to perform various things like mangling their linkage IDs
 *
 * @return bounds list of load, or null if failed.
 */
/datum/dmm_parsed/proc/load(x, y, z, x_lower = -INFINITY, x_upper = INFINITY, y_lower = -INFINITY, y_upper = INFINITY, z_lower = -INFINITY, z_upper = INFINITY, no_changeturf, place_on_top, orientation = SOUTH, list/area_cache, datum/dmm_context/context)
	// we always have context, even if we don't
	if(isnull(context))
		context = create_dmm_context()
	. = context

	var/static/loading = FALSE
	UNTIL(!loading)
	Master.StartLoadingMap()
	loading = TRUE
	SSatoms.map_loader_begin(REF(src))

	_populate_orientation(context, orientation)
	context.loaded_dmm = src

	global.dmm_preloader.loading_context = context
	var/list/loaded_bounds = _load_impl(x, y, z, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, no_changeturf, place_on_top, area_cache, context)
	global.dmm_preloader.loading_orientation = null

	context.loaded_bounds = loaded_bounds
	context.success = !isnull(loaded_bounds)

	SSatoms.map_loader_stop(REF(src))
	loading = FALSE
	Master.StopLoadingMap()

/datum/dmm_parsed/proc/_populate_orientation(datum/dmm_context/context,orientation)
	var/datum/dmm_orientation/orientation_pattern = GLOB.dmm_orientations["[orientation]"]

	context.loaded_orientation = orientation
	context.loaded_orientation_invert_x = orientation_pattern.invert_x
	context.loaded_orientation_invert_y = orientation_pattern.invert_y
	context.loaded_orientation_swap_xy = orientation_pattern.swap_xy
	context.loaded_orientation_xi = orientation_pattern.xi
	context.loaded_orientation_yi = orientation_pattern.yi
	context.loaded_orientation_turn_angle = round(SIMPLIFY_DEGREES(orientation_pattern.turn_angle), 90)

// todo: verify that when rotating, things load in the same way when cropped e.g. aligned to lower left
//       as opposed to rotating to somewhere else
/datum/dmm_parsed/proc/_load_impl(x, y, z, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, no_changeturf, place_on_top, list/area_cache = list(), datum/dmm_context/context)
	var/list/model_cache = build_cache(no_changeturf)
	var/space_key = model_cache[SPACE_KEY]

	var/list/loaded_bounds = list(INFINITY, INFINITY, INFINITY, -INFINITY, -INFINITY, -INFINITY)

	var/invert_x = context.loaded_orientation_invert_x
	var/invert_y = context.loaded_orientation_invert_y
	var/swap_xy = context.loaded_orientation_swap_xy
	var/xi = context.loaded_orientation_xi
	var/yi = context.loaded_orientation_yi
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
					build_coordinate(area_cache, cache, locate(placement_x, placement_y, load_z), no_changeturf, place_on_top)

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
		log_debug("Maploader was stopped from expanding world.maxx/world.maxy. This shouldn't happen.")

	return loaded_bounds

/datum/dmm_parsed/proc/build_cache(no_changeturf, bad_paths=null)
	if(model_cache && !bad_paths)
		return model_cache
	. = model_cache = list()
	var/list/grid_models = src.grid_models
	for(var/model_key in grid_models)
		var/model = grid_models[model_key]
		// record position for logging errors
		parsing_model_key = model_key
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
				fields = parse_list(full_def, ";")
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
		// Basically, if we find an entry like this: "XXX" = (/turf/default, /area/inherit_area)
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

/datum/dmm_parsed/proc/build_coordinate(list/areaCache, list/model, turf/crds, no_changeturf, placeOnTop)
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
				world.preloader_setup(members_attributes[index], atype)
				instance = new atype(null)
				if(global.dmm_preloader_active)
					world.preloader_load(instance)
			areaCache[atype] = instance
		instance.contents.Add(crds)

	//then instance the /turf and, if multiple tiles are presents, simulates the DMM underlays piling effect
	var/first_turf_index = 1
	while(!ispath(members[first_turf_index], /turf)) //find first /turf object in members
		first_turf_index++

	//instanciate the first /turf
	var/turf/T
	if(members[first_turf_index] != /turf/template_noop)
		T = instance_atom(members[first_turf_index],members_attributes[first_turf_index],crds,no_changeturf,placeOnTop)

	if(T)
		//if others /turf are presents, simulates the underlays piling effect
		index = first_turf_index + 1
		while(index <= members.len - 1) // Last item is an /area
			var/underlay = T.appearance
			T = instance_atom(members[index],members_attributes[index],crds,no_changeturf,placeOnTop)//instance new turf
			T.underlays += underlay
			index++

	//finally instance all remainings objects/mobs
	for(index in 1 to first_turf_index-1)
		instance_atom(members[index],members_attributes[index],crds,no_changeturf,placeOnTop)

////////////////
//Helpers procs
////////////////

//Instance an atom at (x,y,z) and gives it the variables in attributes
/datum/dmm_parsed/proc/instance_atom(path,list/attributes, turf/crds, no_changeturf, placeOnTop)
	world.preloader_setup(attributes, path)

	if(ispath(path, /turf))
		if(placeOnTop)
			. = crds.PlaceOnTop(null, path, CHANGETURF_DEFER_CHANGE | (no_changeturf ? CHANGETURF_SKIP : NONE))
		else if(!no_changeturf)
			. = crds.ChangeTurf(path, null, CHANGETURF_DEFER_CHANGE)
		else
			. = create_atom(path, crds)//first preloader pass
	else
		. = create_atom(path, crds)//first preloader pass

	if(global.dmm_preloader_active) //second preloader pass, for those atoms that don't ..() in New()
		stack_trace("required a second preloader pass")
		world.preloader_load(.)

	//custom CHECK_TICK here because we don't want things created while we're sleeping to not initialize
	if(TICK_CHECK)
		SSatoms.map_loader_stop(REF(src))
		stoplag()
		SSatoms.map_loader_begin(REF(src))

/**
 * create an atom at a location
 *
 * * don't use this for turfs
 * * use instance_atom, don't use this
 */
/datum/dmm_parsed/proc/create_atom(path, atom/where)
	set waitfor = FALSE
	. = new path(where)

//* Parsing - Internal *//

/**
 * parses the value of an attribute
 *
 * known limitations:
 * * text doesn't support \" and likely not most byond "text macros"
 * * nexted list support is not tested
 * * anonymous types: /obj{name="foo"}
 * * new(), newlist(), icon(), matrix(), sound()
 */
/datum/dmm_parsed/proc/parse_constant(text)
	// number
	var/num = text2num(text)
	if(isnum(num))
		return num

	// null
	if(text == "null")
		return null

	// typepath
	if(text[1] == "/")
		var/path = text2path(text)
		if(path)
			return path
		else
			if(parse_error_out && length(parse_error_out) < parse_error_limit)
				parse_error_out += "[parsing_model_key || "null"]: bad path \"[text]\""
			return null

	// string
	if(text[1] == "\"")
		// pray that the last character is actually a ""
		return text_constant_regex.Replace(copytext(text, 2, -1), "$1")

	// list
	if(copytext(text, 1, 6) == "list(")//6 == length("list(") + 1
		return parse_list(copytext(text, 6, -1))

	// file
	if(text[1] == "'")
		var/filepath = copytext_char(text, 2, -1)
		if(!filepath_is_safe(filepath, global.safe_content_file_access_roots))
			if(parse_error_out && length(parse_error_out) < parse_error_limit)
				parse_error_out += "[parsing_model_key || "null"]: unsafe filepath \"[filepath]\""
			var/static/no_admin_spam = 0
			if(world.time > no_admin_spam + 2 SECONDS)
				// be extra scary because people need to not be stupid with paths!
				message_admins("[src] ([html_encode(original_path)]) attempted to parse unsafe filepath \"[html_encode(filepath)]\"; please consult with a coder for why this happened as this might be a security issue.")
				no_admin_spam = world.time
			return null
		return file(filepath)

	// fallback: string
	if(parse_error_out && length(parse_error_out) < parse_error_limit)
		parse_error_out += "[parsing_model_key || "null"]: unrecognized value [text]"
	return text_constant_regex.Replace(text, "$1")

/**
 * Used to parse a text-encoded list of variables into a real list.
 *
 * * used to grab the variable list from a model
 * * used to build a "list()" definition inside a variable
 *
 * todo: comment this proc more, it probably doesn't work right with nested ;'s and "'s.
 *
 * @params
 * * text - the text-encoded list
 * * delimiter - the delimiter between list elements. for a list() def it's `,`. for a model variable list it's `;`.
 *
 * @return parsed list()
 */
/datum/dmm_parsed/proc/parse_list(text, delimiter = ",")
	RETURN_TYPE(/list)
	. = list()
	if (!text)
		return

	// current position
	var/position
	// last position
	var/last_position = 1

	while(position != 0)
		// find next delimiter that is not within  "..."
		position = find_next_delimiter_position(text, last_position, delimiter)

		// check if this is a simple variable (as in list(var1, var2)) or an associative one (as in list(var1="foo",var2=7))
		var/equal_position = findtext(text,"=",last_position, position)

		var/trim_left = trim_text(copytext(text, last_position, (equal_position ? equal_position : position)))
		var/left_constant = delimiter == ";" ? trim_left : parse_constant(trim_left)
		if(position)
			last_position = position + length(text[position])

		if(equal_position && !isnum(left_constant))
			// Associative var, so do the association.
			// Note that numbers cannot be keys - the RHS is dropped if so.
			var/trim_right = trim_text(copytext(text, equal_position + length(text[equal_position]), position))
			var/right_constant = parse_constant(trim_right)
			.[left_constant] = right_constant

		else  // simple var
			. += list(left_constant)

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

//* VV hooks / Security *//

/datum/dmm_parsed/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, dmmRegex))
			return FALSE
		if(NAMEOF(src, trimQuotesRegex))
			return FALSE
		if(NAMEOF(src, trimRegex))
			return FALSE
		if(NAMEOF(src, text_constant_regex))
			return FALSE
	return ..()
