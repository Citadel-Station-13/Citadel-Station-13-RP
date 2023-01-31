/atom/movable
	layer = OBJ_LAYER
	// todo: evaluate if we need TILE_BOUND
	SET_APPEARANCE_FLAGS(TILE_BOUND | PIXEL_SCALE)

	// todo: kill this (only used for elcetropacks)
	var/moved_recently = FALSE

	/// Used to specify the item state for the on-mob overlays.
	var/item_state = null

	///If we're cloaked or not.
	var/cloaked = FALSE
	/// The image we use for our client to let them see where we are.
	var/image/cloaked_selfimage

	/// Reference to atom being orbited.
	var/atom/orbit_target

	/// Movement types, see __DEFINES/flags/movement.dm
	var/movement_type = GROUND
	/// The orbiter component of the thing we're orbiting.
	var/datum/component/orbiter/orbiting
	///Used for the calculate_adjacencies proc for icon smoothing.
	var/can_be_unanchored = FALSE

	//! Intrinsics
	/// movable flags - see [code/__DEFINES/_flags/atoms.dm]
	var/movable_flags = NONE

	//! Movement
	/// Whatever we're pulling.
	var/atom/movable/pulling
	/// Who's currently pulling us
	var/atom/movable/pulledby
	/// If false makes [CanPass][/atom/proc/CanPass] call [CanPassThrough][/atom/movable/proc/CanPassThrough] on this type instead of using default behaviour
	var/generic_canpass = TRUE
	/// Pass flags.
	var/pass_flags = NONE
	/// 0: not doing a diagonal move. 1 and 2: doing the first/second step of the diagonal move
	var/moving_diagonally = 0
	/// attempt to resume grab after moving instead of before. This is what atom/movable is pulling us during move-from-pulling.
	var/atom/movable/moving_from_pull
	/// Direction of our last move.
	var/last_move_dir = NONE
	/// Our default glide_size. Null to use global default.
	var/default_glide_size

	//! Spacedrift
	/// Which direction we're drifting
	var/inertia_dir = NONE
	/// Only set while drifting, last location we were while drifting
	var/atom/inertia_last_loc
	/// If we're moving from no-grav drifting
	var/inertia_moving = FALSE
	/// Next world.time we should move from no-grav drifting
	var/inertia_next_move = 0
	/// Delay between each drifting move.
	var/inertia_move_delay = 5

	//! Perspectives
	/// our default perspective - if none, a temporary one will be generated when a mob requires it
	var/datum/perspective/self_perspective

	//! Buckling
	/// do we support the buckling system - if not, none of the default interactions will work, but comsigs will still fire!
	var/buckle_allowed = FALSE
	/// buckle flags, see [code/__DEFINES/_flags/atom_flags.dm]
	var/buckle_flags = NONE
	/// How many people can be buckled to us at once.
	var/buckle_max_mobs = 1
	/// if non-null, forces mob.lying to this. this is NOT a boolean.
	var/buckle_lying = 0
	/// direction to set buckled mobs to. null to not do that.
	var/buckle_dir
	/// buckled mobs, associated to their semantic mode if necessary
	var/list/mob/buckled_mobs
	/// restrained default unbuckle time (NOT TIME TO UN-RESTRAIN, this is time to UNBUCKLE from us)
	var/buckle_restrained_resist_time = 2 MINUTES

	//! move force, resist, anchoring
	/// anchored to ground? prevent movement absolutely if so
	var/anchored = FALSE
	/// movement force to resist
	var/move_resist = MOVE_RESIST_DEFAULT
	/// our movement force
	var/move_force = MOVE_FORCE_DEFAULT
	/// our pulling force
	var/pull_force = PULL_FORCE_DEFAULT
	/// pull force to resist
	var/pull_resist = PULL_FORCE_DEFAULT

	var/move_speed = 10
	var/l_move_time = 1

	//! Throwing
	var/datum/thrownthing/throwing
	/// default throw speed
	var/throw_speed = 2
	/// default throw range
	var/throw_range = 7
	/// default throw damage at a "standard" speed
	var/throw_force = 0
	/// default throw move force resist
	var/throw_resist = THROW_RESIST_DEFAULT
	/**
	 * throw damage scaling exponent
	 * see defines for information
	 * BE CAREFUL WITH THIS
	 * if you set this to 2 and make floor tiles that do 100+ damage a hit or something insane i warned you
	 */
	var/throw_damage_scaling_exponential = THROW_DAMAGE_SCALING_CONSTANT_DEFAULT
	/**
	 * throw speed scaling exponent
	 * see defines for information
	 * BE CAREFUL WITH THIS
	 */
	var/throw_speed_scaling_exponential = THROW_SPEED_SCALING_CONSTANT_DEFAULT

	//! Icon Scale
	/// Used to scale icons up or down horizonally in update_transform().
	var/icon_scale_x = 1
	/// Used to scale icons up or down vertically in update_transform().
	var/icon_scale_y = 1
	/// Used to rotate icons in update_transform()
	var/icon_rotation = 0

	//! Pixel Offsets
	/// Used to manually offset buckle pixel offsets. Ignored if we have a riding component.
	var/buckle_pixel_x = 0
	/// Used to manually offset buckle pixel offsets. Ignored if we have a riding component.
	var/buckle_pixel_y = 0

	//! Emissives
	/// Either FALSE, [EMISSIVE_BLOCK_GENERIC], or [EMISSIVE_BLOCK_UNIQUE]
	var/blocks_emissive = FALSE
	/// Internal holder for emissive blocker object, do not use directly use; use blocks_emissive
	var/atom/movable/emissive_blocker/em_block
	/// Internal holder for emissives. Definitely don't directly use, this is absolutely an insane Citadel Moment(tm).
	var/atom/movable/emissive_render/em_render

/atom/movable/Initialize(mapload)
	. = ..()
	if (!mapload && loc)
		loc.Entered(src, null)
	switch(blocks_emissive)
		if(EMISSIVE_BLOCK_GENERIC)
			var/mutable_appearance/gen_emissive_blocker = mutable_appearance(icon, icon_state, plane = EMISSIVE_PLANE, alpha = src.alpha)
			gen_emissive_blocker.color = GLOB.em_block_color
			gen_emissive_blocker.dir = dir
			gen_emissive_blocker.appearance_flags |= appearance_flags
			add_overlay(gen_emissive_blocker)
		if(EMISSIVE_BLOCK_UNIQUE)
			add_emissive_blocker()

/atom/movable/Destroy(force)
	if(reagents)
		QDEL_NULL(reagents)
	unbuckle_all_mobs(BUCKLE_OP_FORCE)
	for(var/atom/movable/AM in contents)
		qdel(AM)
	var/turf/un_opaque
	if(opacity && isturf(loc))
		un_opaque = loc
	// kick perspectives before moving
	if(self_perspective)
		QDEL_NULL(self_perspective)

	throwing?.terminate()
	if(pulling)
		stop_pulling()

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

	. = ..()

	moveToNullspace()
	if(un_opaque)
		un_opaque.recalc_atom_opacity()

/atom/movable/CanAllowThrough(atom/movable/mover, turf/target)
	if(mover in buckled_mobs)
		return TRUE
	. = ..()
	if(locs && locs.len >= 2)	// If something is standing on top of us, let them pass.
		if(mover.loc in locs)
			. = TRUE
	return .

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = TRUE

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(z in GLOB.using_map.sealed_levels)
		return

	if(GLOB.using_map.use_overmap)
		overmap_spacetravel(get_turf(src), src)
		return

	var/move_to_z = src.get_transit_zlevel()
	if(move_to_z)
		var/new_z = move_to_z
		var/new_x
		var/new_y

		if(x <= TRANSITIONEDGE)
			new_x = world.maxx - TRANSITIONEDGE - 2
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			new_x = TRANSITIONEDGE + 1
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			new_y = world.maxy - TRANSITIONEDGE -2
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			new_y = TRANSITIONEDGE + 1
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		if(SSticker && istype(SSticker.mode, /datum/game_mode/nuclear))	// Only really care if the game mode is nuclear
			var/datum/game_mode/nuclear/G = SSticker.mode
			G.check_nuke_disks()

		var/turf/T = locate(new_x, new_y, new_z)
		if(istype(T))
			forceMove(T)

//by default, transition randomly to another zlevel
/atom/movable/proc/get_transit_zlevel()
	var/list/candidates = GLOB.using_map.accessible_z_levels.Copy()
	candidates.Remove("[src.z]")

	if(!candidates.len)
		return null
	return text2num(pickweight(candidates))

// Returns the current scaling of the sprite.
// Note this DOES NOT measure the height or width of the icon, but returns what number is being multiplied with to scale the icons, if any.
/atom/movable/proc/get_icon_scale_x()
	return icon_scale_x

/atom/movable/proc/get_icon_scale_y()
	return icon_scale_y

/atom/movable/proc/update_transform()
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Turn(icon_rotation)
	src.transform = M

// Use this to set the object's scale.
/atom/movable/proc/adjust_scale(new_scale_x, new_scale_y)
	if(isnull(new_scale_y))
		new_scale_y = new_scale_x
	if(new_scale_x != 0)
		icon_scale_x = new_scale_x
	if(new_scale_y != 0)
		icon_scale_y = new_scale_y
	update_transform()

/atom/movable/proc/adjust_rotation(new_rotation)
	icon_rotation = new_rotation
	update_transform()

// Called when touching a lava tile.
/atom/movable/proc/lava_act()
	fire_act(null, 10000, 1000)

//Called when touching an acid pool.
/atom/movable/proc/acid_act()

//Called when touching a blood pool.
/atom/movable/proc/blood_act()
	// blood_act(null, 500, 50)

/**
  * Sets our movement type.
  */
/atom/movable/proc/set_movement_type(new_movetype)
	movement_type = new_movetype

/atom/movable/proc/Bump_vr(var/atom/A, yes)
	return

// Procs to cloak/uncloak
/atom/movable/proc/cloak()
	if(cloaked)
		return FALSE
	cloaked = TRUE
	. = TRUE // We did work

	var/static/animation_time = 1 SECOND
	cloaked_selfimage = get_cloaked_selfimage()

	//Wheeee
	cloak_animation(animation_time)

	//Needs to be last so people can actually see the effect before we become invisible
	if(cloaked) // Ensure we are still cloaked after the animation delay
		plane = CLOAKED_PLANE

/atom/movable/proc/uncloak()
	if(!cloaked)
		return FALSE
	cloaked = FALSE
	. = TRUE // We did work

	var/static/animation_time = 1 SECOND
	QDEL_NULL(cloaked_selfimage)

	//Needs to be first so people can actually see the effect, so become uninvisible first
	plane = initial(plane)

	//Oooooo
	uncloak_animation(animation_time)


// Animations for cloaking/uncloaking
/atom/movable/proc/cloak_animation(var/length = 1 SECOND)
	//Save these
	var/initial_alpha = alpha

	//Animate alpha fade
	animate(src, alpha = 0, time = length)

	//Animate a cloaking effect
	var/our_filter = filters.len+1 //Filters don't appear to have a type that can be stored in a var and accessed. This is how the DM reference does it.
	filters += filter(type="wave", x = 0, y = 16, size = 0, offset = 0, flags = WAVE_SIDEWAYS)
	animate(filters[our_filter], offset = 1, size = 8, time = length, flags = ANIMATION_PARALLEL)

	//Wait for animations to finish
	sleep(length+5)

	//Remove those
	filters -= filter(type="wave", x = 0, y = 16, size = 8, offset = 1, flags = WAVE_SIDEWAYS)

	//Back to original alpha
	alpha = initial_alpha

/atom/movable/proc/uncloak_animation(var/length = 1 SECOND)
	//Save these
	var/initial_alpha = alpha

	//Put us back to normal, but no alpha
	alpha = 0

	//Animate alpha fade up
	animate(src, alpha = initial_alpha, time = length)

	//Animate a cloaking effect
	var/our_filter = filters.len+1 //Filters don't appear to have a type that can be stored in a var and accessed. This is how the DM reference does it.
	filters += filter(type="wave", x=0, y = 16, size = 8, offset = 1, flags = WAVE_SIDEWAYS)
	animate(filters[our_filter], offset = 0, size = 0, time = length, flags = ANIMATION_PARALLEL)

	//Wait for animations to finish
	sleep(length+5)

	//Remove those
	filters -= filter(type="wave", x=0, y = 16, size = 0, offset = 0, flags = WAVE_SIDEWAYS)


// So cloaked things can see themselves, if necessary
/atom/movable/proc/get_cloaked_selfimage()
	var/icon/selficon = icon(icon, icon_state)
	selficon.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1) //White
	var/image/selfimage = image(selficon)
	selfimage.color = "#0000FF"
	selfimage.alpha = 100
	selfimage.layer = initial(layer)
	selfimage.plane = initial(plane)
	selfimage.loc = src

	return selfimage

/atom/movable/proc/ghost_tag(text)
	var/atom/movable/ghost_tag_container/G = locate() in vis_contents
	if(!length(text) || !istext(text))
		if(G)
			qdel(G)
		return
	if(!G)
		G = new(src)
	G.master = src
	// for the love of god macro this when we get runechat
	G.maptext = "<center><span style=\"font-family: 'Small Fonts'; font-size: 7px; -dm-text-outline: 1px black; color: white; line-height: 1.1;\">[text]</span></center>"
	G.maptext_height = 256
	G.maptext_width = 256
	G.maptext_x = -128 + (world.icon_size * 0.5)
	G.maptext_y = 32
	G.plane = PLANE_GHOSTS
	G.loc = null		// lol
	vis_contents += G
	return G

/atom/movable/ghost_tag_container
	// no mouse opacity
	name = ""
	var/atom/movable/master
	SET_APPEARANCE_FLAGS(RESET_COLOR | RESET_ALPHA | PIXEL_SCALE | TILE_BOUND)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/ghost_tag_container/Destroy()
	if(istype(master))
		master.vis_contents -= src
		master = null
	return ..()

/atom/movable/proc/get_bullet_impact_effect_type()
	return BULLET_IMPACT_NONE

//! Perspectives
/**
 * get perspective to use when shifting eye to us,
 */
/atom/movable/proc/get_perspective()
	return self_perspective || temporary_perspective()

/**
 * gets a tempoerary perspective for ourselves
 */
/atom/movable/proc/temporary_perspective()
	var/datum/perspective/self/temporary/P = new
	P.eye = src
	return P

/**
 * make a permanent self perspective
 */
/atom/movable/proc/make_perspective()
	ASSERT(!self_perspective)
	. = self_perspective = new /datum/perspective/self
	self_perspective.eye = src

/**
 * ensure we have a self perspective
 */
/atom/movable/proc/ensure_self_perspective()
	if(!self_perspective)
		make_perspective()

//! Layers
/atom/movable/set_base_layer(new_layer)
	. = ..()
	update_emissive_layers()

/atom/movable/set_relative_layer(new_layer)
	. = ..()
	update_emissive_layers()

//! Pixel Offsets
/atom/movable/get_centering_pixel_x_offset(dir, atom/aligning)
	. = ..()
	. *= icon_scale_x

/atom/movable/get_centering_pixel_y_offset(dir, atom/aligning)
	. = ..()
	. *= icon_scale_y

//! Emissives
/atom/movable/proc/update_emissive_layers()
	em_block?.layer = MANGLE_PLANE_AND_LAYER(plane, layer - LAYER_RESOLUTION_FULL)
	em_render?.layer = MANGLE_PLANE_AND_LAYER(plane, layer - LAYER_RESOLUTION_FULL)

/atom/movable/proc/add_emissive_blocker(full_copy = TRUE)
	if(em_block)
		em_block.render_source = full_copy? render_target : null
		update_emissive_blocker()
		return
	if(render_target && render_target != REF(src))
		CRASH("already had render target; refusing to overwrite.")
	render_target = REF(src)
	em_block = new(src, full_copy? render_target : null)
	vis_contents += em_block
	update_emissive_blocker()

/atom/movable/proc/update_emissive_blocker()
	if(!em_block)
		return
	// layer it BELOW us incase WE wanna be fuh-nee with our own emissives
	em_block.layer = MANGLE_PLANE_AND_LAYER(plane, layer - LAYER_RESOLUTION_FULL)

/atom/movable/proc/remove_emissive_blocker()
	if(!em_block)
		return
	vis_contents -= em_block
	qdel(em_block)
	em_block = null

/atom/movable/proc/add_emissive_render(full_copy = TRUE)
	if(em_render)
		em_render.render_source = full_copy? render_target : null
		update_emissive_render()
		return
	if(render_target && render_target != REF(src))
		CRASH("already had render target; refusing to overwrite.")
	render_target = REF(src)
	em_render = new(src, full_copy? render_target : null)
	vis_contents += em_render
	update_emissive_render()

/atom/movable/proc/add_or_update_emissive_render()
	if(!em_render)
		add_emissive_render()
	else
		update_emissive_render()

/atom/movable/proc/update_emissive_render()
	if(!em_render)
		return
	// layer it at our layer
	em_render.layer = MANGLE_PLANE_AND_LAYER(plane, layer - LAYER_RESOLUTION_FULL)

/atom/movable/proc/remove_emissive_render()
	if(!em_render)
		return
	vis_contents -= em_render
	qdel(em_render)
	em_render = null

// todo: we should probably have a way to just copy an appearance clone or something without render-targeting

/**
 * Checks if we can avoid things like landmine, lava, etc, whether beneficial or harmful.
 */
/atom/movable/proc/is_avoiding_ground()
    return (movement_type != GROUND) || throwing
