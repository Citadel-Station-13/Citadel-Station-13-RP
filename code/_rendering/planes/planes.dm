////////////////////
// The Plane Master
////////////////////
/atom/movable/screen/plane_master
	screen_loc = "CENTER"
	plane = -100 //Dodge just in case someone instantiates one of these accidentally, don't end up on 0 with plane_master
	appearance_flags = PLANE_MASTER
	mouse_opacity = 0	//Normally unclickable
	alpha = 0	//Hidden from view
	var/desired_alpha = 255	//What we go to when we're enabled
	var/invis_toggle = FALSE
	var/list/sub_planes

/atom/movable/screen/plane_master/proc/set_desired_alpha(var/new_alpha)
	if(new_alpha != alpha && new_alpha > 0 && new_alpha <= 255)
		desired_alpha = new_alpha
		if(alpha) //If we're already visible, update it now.
			alpha = new_alpha

/atom/movable/screen/plane_master/proc/set_visibility(var/want = FALSE)
	//Invisibility-managed
	if(invis_toggle)
		if(want && invisibility)
			invisibility = 0 //Does not need a mouse_opacity toggle because these are for effects
		else if(!want && !invisibility)
			invisibility = 101
	//Alpha-managed
	else
		if(want && !alpha)
			alpha = desired_alpha
			mouse_opacity = 1 //Not bool, don't replace with true/false
		else if(!want && alpha)
			alpha = 0
			mouse_opacity = 0

/atom/movable/screen/plane_master/proc/set_alpha(var/new_alpha = 255)
	if(new_alpha != alpha)
		new_alpha = sanitize_integer(new_alpha, 0, 255, 255)
		alpha = new_alpha

/atom/movable/screen/plane_master/proc/set_ambient_occlusion(var/enabled = FALSE)
	filters -= AMBIENT_OCCLUSION
	if(enabled)
		filters += AMBIENT_OCCLUSION

////////////////////
// Special masters
////////////////////

/////////////////
//Lighting is weird and has matrix shenanigans. Think of this as turning on/off darkness.
/atom/movable/screen/plane_master/fullbright
	plane = LIGHTING_PLANE
	layer = LAYER_HUD_BASE+1 // This MUST be above the lighting plane_master
	color = null //To break lighting when visible (this is sorta backwards)
	alpha = 0 //Starts full opaque
	invisibility = 101
	invis_toggle = TRUE

/atom/movable/screen/plane_master/lighting
	plane = LIGHTING_PLANE
	blend_mode = BLEND_MULTIPLY
	alpha = 255

/*!
 * This system works by exploiting BYONDs color matrix filter to use layers to handle emissive blockers.
 *
 * Emissive overlays are pasted with an atom color that converts them to be entirely some specific color.
 * Emissive blockers are pasted with an atom color that converts them to be entirely some different color.
 * Emissive overlays and emissive blockers are put onto the same plane.
 * The layers for the emissive overlays and emissive blockers cause them to mask eachother similar to normal BYOND objects.
 * A color matrix filter is applied to the emissive plane to mask out anything that isn't whatever the emissive color is.
 * This is then used to alpha mask the lighting plane.
 */

/atom/movable/screen/plane_master/lighting/Initialize(mapload)
	. = ..()
	add_filter("emissives", 1, alpha_mask_filter(render_source = EMISSIVE_RENDER_TARGET, flags = MASK_INVERSE))
	// add_filter("object_lighting", 2, alpha_mask_filter(render_source = O_LIGHTING_VISUAL_RENDER_TARGET, flags = MASK_INVERSE))

/**
 * Handles emissive overlays and emissive blockers.
 */
/atom/movable/screen/plane_master/emissive
	name = "emissive plane master"
	plane = EMISSIVE_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_RENDER_TARGET
	alpha = 255

/atom/movable/screen/plane_master/emissive/Initialize(mapload)
	. = ..()
	add_filter("em_block_masking", 1, color_matrix_filter(GLOB.em_mask_matrix))

/////////////////
//Ghosts has a special alpha level
/atom/movable/screen/plane_master/ghosts
	plane = PLANE_GHOSTS
	desired_alpha = 127 //When enabled, they're like half-transparent

/////////////////
//Cloaked atoms are visible to ghosts (or for other reasons?)
/atom/movable/screen/plane_master/cloaked
	plane = CLOAKED_PLANE
	desired_alpha = 80
	color = "#0000FF"

////////////////
// parallax
/atom/movable/screen/plane_master/parallax
	plane = PARALLAX_PLANE
	blend_mode = BLEND_MULTIPLY
	alpha = 255

////////////////
// space
/atom/movable/screen/plane_master/parallax_white
	plane = SPACE_PLANE
	alpha = 255
	mouse_opacity = 1

/////////////////
//The main game planes start normal and visible
/atom/movable/screen/plane_master/main
	alpha = 255
	mouse_opacity = 1

/////////////////
//AR planemaster does some special image handling
/atom/movable/screen/plane_master/augmented
	plane = PLANE_AUGMENTED
	var/state = FALSE //Saves cost with the lists
	var/mob/my_mob

/atom/movable/screen/plane_master/augmented/Initialize(mapload, mob/new_mob)
	. = ..()
	my_mob = new_mob

/atom/movable/screen/plane_master/augmented/Destroy()
	my_mob = null
	return ..()

/atom/movable/screen/plane_master/augmented/set_visibility(var/want = FALSE)
	. = ..()
	state = want
	apply()

/atom/movable/screen/plane_master/augmented/proc/apply()
	// if(!my_mob.client)
	// 	return

	/**
	 * preserving this for when we get generic augmented hud
	 */
	// if(state)
	// 	entopic_users |= my_mob
	// 	if(my_mob.client)
	// 		my_mob.client.images |= entopic_images
	// else
	// 	entopic_users -= my_mob
	// 	if(my_mob.client)
	// 		my_mob.client.images -= entopic_images

//? Sectors & Weather

/**
 * normal sector weather effects renders onto this plane
 */
/atom/movable/screen/plane_master/sector_graphics
	plane = WEATHER_PLANE
	alpha = 255

/**
 * sector occlusion plane - alphamasked onto particles plane when user is indoors
 */
/atom/movable/screen/plane_master/sector_occlusion
	plane = WEATHER_OCCLUSION_PLANE
	alpha = 255

/**
 * particles for sector weather renders onto this plane
 */
/atom/movable/screen/plane_master/sector_particles
	plane = WEATHER_PARTICLE_PLANE
	alpha = 255

#warn alphamask

//? Dynamic

/atom/movable/screen/plane_master/dynamic
	alpha = 255
