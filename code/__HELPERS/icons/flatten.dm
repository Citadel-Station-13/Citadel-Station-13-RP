//? File contains functions to generate flat /icon's from things.
//? This is obviously expensive. Very, very expensive.
//? new getFlatIcon is faster, but, really, don't use these unless you need to.
//? Chances are unless you are:
//? - sending to html/browser (for non character preview purposes)
//? - taking photos
//? - doing complex icon operations that can't be done with filters/overlays
//? you probably don't need to use these.

/**
 * Generates an icon with all 4 directions of something.
 *
 * @params
 * - A - appearancelike object.
 * - no_anim - flatten out animations
 */
/proc/getCompoundIcon(atom/A, no_anim)
	var/mutable_appearance/N = new
	N.appearance = A
	N.dir = NORTH
	var/icon/north = getFlatIcon(N, NORTH, no_anim = no_anim)
	N.dir = SOUTH
	var/icon/south = getFlatIcon(N, SOUTH, no_anim = no_anim)
	N.dir = EAST
	var/icon/east = getFlatIcon(N, EAST, no_anim = no_anim)
	N.dir = WEST
	var/icon/west = getFlatIcon(N, WEST, no_anim = no_anim)
	qdel(N)
	//Starts with a blank icon because of byond bugs.
	var/icon/full = icon('icons/system/blank_32x32.dmi', "")
	full.Insert(north, dir = NORTH)
	full.Insert(south, dir = SOUTH)
	full.Insert(east, dir = EAST)
	full.Insert(west, dir = WEST)
	qdel(north)
	qdel(south)
	qdel(east)
	qdel(west)
	return full

/proc/getFlatIcon(appearance/appearancelike, dir, no_anim)
	if(!dir && isloc(appearancelike))
		dir = appearancelike.dir
	return getFlatIcon_new_actual(appearancelike, dir, no_anim, null, TRUE)

/proc/getFlatIcon_new_actual(image/A, defdir, no_anim, deficon, start)
	// start with blank image
	var/static/icon/template = icon('icons/system/blank_32x32.dmi', "")

	#define BLANK icon(template)

	#define INDEX_X_LOW 1
	#define INDEX_X_HIGH 2
	#define INDEX_Y_LOW 3
	#define INDEX_Y_HIGH 4

	#define flatX1 flat_size[INDEX_X_LOW]
	#define flatX2 flat_size[INDEX_X_HIGH]
	#define flatY1 flat_size[INDEX_Y_LOW]
	#define flatY2 flat_size[INDEX_Y_HIGH]
	#define addX1 add_size[INDEX_X_LOW]
	#define addX2 add_size[INDEX_X_HIGH]
	#define addY1 add_size[INDEX_Y_LOW]
	#define addY2 add_size[INDEX_Y_HIGH]

	// invis? skip.
	if(!A || A.alpha <= 0)
		return BLANK

	// detect if state exists
	var/icon/icon = A.icon || deficon
	var/state = A.icon_state
	var/none = !icon
	if(!none)
		var/list/states = icon_states(icon)
		if(!(state in states))
			if(!("" in states))
				none = TRUE
			else
				state = ""

	// determine if there's directionals
	// propagate forced direcitons down if and only if A has a direction
	// todo: this results in a mismatch if someone is facing east but their overlays are facing south.
	var/dir
	if(start || !A.dir)
		dir = defdir
	else
		dir = A.dir
	var/ourdir = dir
	if(!none && ourdir != SOUTH)
		if(length(icon_states(icon(icon, state, NORTH))))
		else if(length(icon_states(icon(icon, state, EAST))))
		else if(length(icon_states(icon(icon, state, WEST))))
		else
			ourdir = SOUTH

	// start generating
	if(!A.overlays.len && !A.underlays.len)
		// we don't even have ourselves!
		if(none)
			return BLANK
		// no overlays/underlays, we're done, just mix in ourselves
		var/icon/self_icon = icon(icon(icon, state, ourdir), "", SOUTH, no_anim? 1 : null)
		if(A.alpha < 255)
			self_icon.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)
		if(A.color)
			if(islist(A.color))
				self_icon.MapColors(arglist(A.color))
			else
				self_icon.Blend(A.color, ICON_MULTIPLY)
		return self_icon

	// safety/performance check
	if((A.overlays.len + A.underlays.len) > 80)
		// we use fucking insertion check
		// > 80 = death.
		CRASH("getflaticon tried to process more than 80 layers")

	// otherwise, we have to blend in all overlays/underlays.
	var/icon/flat = BLANK
	var/list/appearance/gathered = list()
	var/appearance/copying
	var/appearance/comparing
	var/i
	var/appearance/self
	var/current_layer

	if(!none)
		// add the atom itself
		self = image(icon = icon, icon_state = state, layer = A.layer, dir = ourdir)
		self.color = A.color
		self.alpha = A.alpha
		self.blend_mode = A.blend_mode
		gathered[self] = A.layer

	// gather
	for(copying as anything in A.overlays)
		// todo: better handling
		if(copying.plane != FLOAT_PLANE && copying.plane != A.plane)
			// we don't care probably HUD or something lol
			continue
		current_layer = copying.layer
		// if it's float layer, shove it right above atom.
		if(current_layer < 0)
			if(current_layer < -1000)
				CRASH("who the hell is using -1000 or below on float layers?")
			current_layer = A.layer + (1000 + current_layer) / 1000
		// else, add 1 so it doesn't potentially collide on float
		else
			++current_layer

		// inject with insertion sort
		for(i in 1 to gathered.len)
			comparing = gathered[i]
			if(current_layer < gathered[comparing])
				gathered.Insert(i, copying)
		// associate
		gathered[copying] = current_layer

	for(copying as anything in A.underlays)
		// todo: better handling
		if(copying.plane != FLOAT_PLANE && copying.plane != A.plane)
			// we don't care probably HUD or something lol
			continue
		current_layer = copying.layer
		// if it's float layer, shove it right below atom.
		if(current_layer < 0)
			if(current_layer < -1000)
				CRASH("who the hell is using -1000 or below on float layers?")
			current_layer = A.layer - (1000 + current_layer) / 1000
		// else, subtract 1 so it doesn't potentially collide on float
		else
			--current_layer

		// inject with insertion sort
		for(i in 1 to gathered)
			comparing = gathered[i]
			if(current_layer < gathered[comparing])
				gathered.Insert(i, copying)
		// associate
		gathered[copying] = current_layer

	// adding icon we're mixing in
	var/icon/adding
	// current dimensions
	var/list/flat_size = list(1, flat.Width(), 1, flat.Height())
	// adding dimensions
	var/list/add_size[4]
	// blend mode
	var/blend_mode

	// blend in layers
	for(copying as anything in gathered)
		// if invis, skip
		if(copying.alpha == 0)
			continue

		// detect if it's literally ourselves
		if(copying == self)
			// blend in normally (no sense doing otherwise unless we're on map)
			// we can't assume we're on map.
			blend_mode = BLEND_OVERLAY
			adding = icon(icon, state, ourdir)
		else
			// use full getflaticon
			blend_mode = copying.blend_mode
			adding = getFlatIcon_new_actual(copying, defdir, no_anim, icon)

		// if we got nothing, skip
		if(!adding)
			continue

		// detect adding size, taking into account copying overlay's pixel offsets
		add_size[INDEX_X_LOW] = min(flatX1, copying.pixel_x + 1)
		add_size[INDEX_X_HIGH] = max(flatX2, copying.pixel_x + adding.Width())
		add_size[INDEX_Y_LOW] = min(flatY1, copying.pixel_y + 1)
		add_size[INDEX_Y_HIGH] = max(flatY2, copying.pixel_y + adding.Height())

		// resize flat to fit if necessary
		if(flat_size ~! add_size)
			flat.Crop(
				addX1 - flatX1 + 1,
				addY1 - flatY1 + 1,
				addX2 - flatX1 + 1,
				addY2 - flatY1 + 1
			)
			flat_size = add_size.Copy()

		// blend the overlay/underlay in
		flat.Blend(adding, blendMode2iconMode(blend_mode), copying.pixel_x + 2 - flatX1, copying.pixel_y + 2 - flatY1)

	// apply colors
	if(A.color)
		if(islist(A.color))
			flat.MapColors(arglist(A.color))
		else
			flat.Blend(A.color, ICON_MULTIPLY)

	// apply alpha
	if(A.alpha < 255)
		flat.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)

	// finalize
	if(no_anim)
		// clean up frames
		var/icon/cleaned = icon()
		cleaned.Insert(flat, "", SOUTH, 1, 0)
		return cleaned
	else
		// just return flat as SOUTH
		return icon(flat, "", SOUTH)

	#undef flatX1
	#undef flatX2
	#undef flatY1
	#undef flatY2
	#undef addX1
	#undef addX2
	#undef addY1
	#undef addY2

	#undef INDEX_X_LOW
	#undef INDEX_X_HIGH
	#undef INDEX_Y_LOW
	#undef INDEX_Y_HIGH

	#undef BLANK

/*

--- Why is this code still here?
--- Because I don't trust myself, so, I'll leave the old reference code here incase this breaks later.

/proc/getFlatIcon(A, defdir, no_anim)
	getFlatIcon_old(A, defdir, null, null, null, null, no_anim)
	return getFlatIcon_new(A, defdir, no_anim)

/proc/getFlatIconTest(A, B, C)
	var/icon/_A = getFlatIcon_old(A, B, null, null, null, null, C)
	var/icon/_B = getFlatIcon_new(A, B, C)
	to_chat(world, "[icon2html(_A, world)]")
	to_chat(world, "[icon2html(_B, world)]")

// todo: rework
// Creates a single icon from a given /atom or /image.  Only the first argument is required.
/proc/getFlatIcon_old(image/A, defdir, deficon, defstate, defblend, start = TRUE, no_anim = FALSE)
	//Define... defines.
	var/static/icon/flat_template = icon('icons/effects/effects.dmi', "nothing")

	#define BLANK icon(flat_template)
	#define SET_SELF(SETVAR) do { \
		var/icon/SELF_ICON=icon(icon(curicon, curstate, base_icon_dir),"",SOUTH,no_anim?1:null); \
		if(A.alpha<255) { \
			SELF_ICON.Blend(rgb(255,255,255,A.alpha),ICON_MULTIPLY);\
		} \
		if(A.color) { \
			if(islist(A.color)){ \
				SELF_ICON.MapColors(arglist(A.color))} \
			else{ \
				SELF_ICON.Blend(A.color,ICON_MULTIPLY)} \
		} \
		##SETVAR=SELF_ICON;\
		} while (0)

	#define INDEX_X_LOW 1
	#define INDEX_X_HIGH 2
	#define INDEX_Y_LOW 3
	#define INDEX_Y_HIGH 4

	#define flatX1 flat_size[INDEX_X_LOW]
	#define flatX2 flat_size[INDEX_X_HIGH]
	#define flatY1 flat_size[INDEX_Y_LOW]
	#define flatY2 flat_size[INDEX_Y_HIGH]
	#define addX1 add_size[INDEX_X_LOW]
	#define addX2 add_size[INDEX_X_HIGH]
	#define addY1 add_size[INDEX_Y_LOW]
	#define addY2 add_size[INDEX_Y_HIGH]

	if(!A || A.alpha <= 0)
		return BLANK

	var/noIcon = FALSE
	if(start)
		if(!defdir)
			defdir = A.dir
		if(!deficon)
			deficon = A.icon
		if(!defstate)
			defstate = A.icon_state
		if(!defblend)
			defblend = A.blend_mode

	var/curicon = A.icon || deficon
	var/curstate = A.icon_state || defstate

	if(!((noIcon = (!curicon))))
		var/curstates = icon_states(curicon)
		if(!(curstate in curstates))
			if("" in curstates)
				curstate = ""
			else
				noIcon = TRUE // Do not render this object.

	var/curdir
	var/base_icon_dir	//We'll use this to get the icon state to display if not null BUT NOT pass it to overlays as the dir we have

	//These should use the parent's direction (most likely)
	if(!A.dir || A.dir == SOUTH)
		curdir = defdir
	else
		curdir = A.dir

	//Try to remove/optimize this section ASAP, CPU hog.
	//Determines if there's directionals.
	if(!noIcon && curdir != SOUTH)
		var/exist = FALSE
		var/static/list/checkdirs = list(NORTH, EAST, WEST)
		for(var/i in checkdirs)		//Not using GLOB for a reason.
			if(length(icon_states(icon(curicon, curstate, i))))
				exist = TRUE
				break
		if(!exist)
			base_icon_dir = SOUTH
	//

	if(!base_icon_dir)
		base_icon_dir = curdir

	ASSERT(!BLEND_DEFAULT)		//I might just be stupid but lets make sure this define is 0.

	var/curblend = A.blend_mode || defblend

	if(A.overlays.len || A.underlays.len)
		var/icon/flat = BLANK
		// Layers will be a sorted list of icons/overlays, based on the order in which they are displayed
		var/list/layers = list()
		var/image/copy
		// Add the atom's icon itself, without pixel_x/y offsets.
		if(!noIcon)
			copy = image(icon=curicon, icon_state=curstate, layer=A.layer, dir=base_icon_dir)
			copy.color = A.color
			copy.alpha = A.alpha
			copy.blend_mode = curblend
			layers[copy] = A.layer

		// Loop through the underlays, then overlays, sorting them into the layers list
		for(var/process_set in 0 to 1)
			var/list/process = process_set? A.overlays : A.underlays
			for(var/i in 1 to process.len)
				var/image/current = process[i]
				if(!current)
					continue
				if(current.plane != FLOAT_PLANE && current.plane != A.plane)
					continue
				var/current_layer = current.layer
				if(current_layer < 0)
					if(current_layer <= -1000)
						return flat
					current_layer = process_set + A.layer + current_layer / 1000

				for(var/p in 1 to layers.len)
					var/image/cmp = layers[p]
					if(current_layer < layers[cmp])
						layers.Insert(p, current)
						break
				layers[current] = current_layer

		//sortTim(layers, /proc/cmp_image_layer_asc)

		var/icon/add // Icon of overlay being added

		// Current dimensions of flattened icon
		var/list/flat_size = list(1, flat.Width(), 1, flat.Height())
		// Dimensions of overlay being added
		var/list/add_size[4]

		for(var/V in layers)
			var/image/I = V
			if(I.alpha == 0)
				continue

			if(I == copy) // 'I' is an /image based on the object being flattened.
				curblend = BLEND_OVERLAY
				add = icon(I.icon, I.icon_state, base_icon_dir)
			else // 'I' is an appearance object.
				add = getFlatIcon_old(image(I), curdir, curicon, curstate, curblend, FALSE, no_anim)
			if(!add)
				continue
			// Find the new dimensions of the flat icon to fit the added overlay
			add_size = list(
				min(flatX1, I.pixel_x+1),
				max(flatX2, I.pixel_x+add.Width()),
				min(flatY1, I.pixel_y+1),
				max(flatY2, I.pixel_y+add.Height())
			)

			if(flat_size ~! add_size)
				// Resize the flattened icon so the new icon fits
				flat.Crop(
				addX1 - flatX1 + 1,
				addY1 - flatY1 + 1,
				addX2 - flatX1 + 1,
				addY2 - flatY1 + 1
				)
				flat_size = add_size.Copy()

			// Blend the overlay into the flattened icon
			flat.Blend(add, blendMode2iconMode(curblend), I.pixel_x + 2 - flatX1, I.pixel_y + 2 - flatY1)

		if(A.color)
			if(islist(A.color))
				flat.MapColors(arglist(A.color))
			else
				flat.Blend(A.color, ICON_MULTIPLY)

		if(A.alpha < 255)
			flat.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)

		if(no_anim)
			//Clean up repeated frames
			var/icon/cleaned = new /icon()
			cleaned.Insert(flat, "", SOUTH, 1, 0)
			. = cleaned
		else
			. = icon(flat, "", SOUTH)
	else	//There's no overlays.
		if(!noIcon)
			SET_SELF(.)

	//Clear defines
	#undef flatX1
	#undef flatX2
	#undef flatY1
	#undef flatY2
	#undef addX1
	#undef addX2
	#undef addY1
	#undef addY2

	#undef INDEX_X_LOW
	#undef INDEX_X_HIGH
	#undef INDEX_Y_LOW
	#undef INDEX_Y_HIGH

	#undef BLANK
	#undef SET_SELF
*/
