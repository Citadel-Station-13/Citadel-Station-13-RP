//////////////////////////////////////////////
// These planemaster objects are created on mobs when a client logs into them (lazy). We'll use them to adjust the visibility of objects, among other things.
//

// todo: refactor all of this so we can use subtypesof like on main like on any SANE CODEBASE

/datum/plane_holder
	var/mob/my_mob
	var/list/plane_masters[VIS_COUNT]

/datum/plane_holder/New(mob/this_guy)
	ASSERT(ismob(this_guy))
	my_mob = this_guy
	//It'd be nice to lazy init these but some of them are important to just EXIST. Like without ghost planemaster, you can see ghosts. Go figure.

	// 'Utility' planes
	plane_masters[VIS_FULLBRIGHT] 	= new /atom/movable/screen/plane_master/fullbright						//Lighting system (lighting_overlay objects)
	plane_masters[VIS_LIGHTING] 	= new /atom/movable/screen/plane_master/lighting							//Lighting system (but different
	plane_masters[VIS_GHOSTS] 		= new /atom/movable/screen/plane_master/ghosts							//Ghosts!
	plane_masters[VIS_AI_EYE]		= new /atom/movable/screen/plane_master{plane = PLANE_AI_EYE}			//AI Eye!

	plane_masters[VIS_STATUS]		= new /atom/movable/screen/plane_master{plane = PLANE_STATUS}			//Status indicators that show over mob heads.

	plane_masters[VIS_ADMIN1] 		= new /atom/movable/screen/plane_master{plane = PLANE_ADMIN1}			//For admin use
	plane_masters[VIS_ADMIN2] 		= new /atom/movable/screen/plane_master{plane = PLANE_ADMIN2}			//For admin use
	plane_masters[VIS_ADMIN3] 		= new /atom/movable/screen/plane_master{plane = PLANE_ADMIN3}			//For admin use

	plane_masters[VIS_MESONS]		= new /atom/movable/screen/plane_master{plane = PLANE_MESONS} 			//Meson-specific things like open ceilings.

	// Real tangible stuff planes
	plane_masters[VIS_TURFS]	= new /atom/movable/screen/plane_master/main{plane = TURF_PLANE}
	plane_masters[VIS_OBJS]		= new /atom/movable/screen/plane_master/main{plane = OBJ_PLANE}
	plane_masters[VIS_MOBS]		= new /atom/movable/screen/plane_master/main{plane = MOB_PLANE}
	plane_masters[VIS_CLOAKED]	= new /atom/movable/screen/plane_master/cloaked								//Cloaked atoms!

	plane_masters[VIS_AUGMENTED]		= new /atom/movable/screen/plane_master/augmented(null, my_mob)					//Augmented reality

	// this code disgusts me but we're stuck with it until we refactor planes :/
	// i hate baycode
	plane_masters[VIS_PARALLAX] = new /atom/movable/screen/plane_master/parallax{plane = PARALLAX_PLANE}
	plane_masters[VIS_SPACE] = new /atom/movable/screen/plane_master/parallax_white{plane = SPACE_PLANE}
	plane_masters[VIS_SONAR] = new /atom/movable/screen/plane_master{plane = SONAR_PLANE}

/datum/plane_holder/Destroy()
	my_mob = null
	QDEL_LIST_NULL(plane_masters) //Goodbye my children, be free
	return ..()

/datum/plane_holder/proc/set_vis(var/which = null, var/state = FALSE)
	ASSERT(which)
	var/atom/movable/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		stack_trace("Tried to alter [which] in plane_holder on [my_mob]!")

	if(my_mob.alpha <= EFFECTIVE_INVIS)
		state = FALSE

	PM.set_visibility(state)
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			set_vis(which = SP, state = state)
	var/plane = PM.plane
	if(state && !(plane in my_mob.planes_visible))
		LAZYADD(my_mob.planes_visible, plane)
	else if(!state && (plane in my_mob.planes_visible))
		LAZYREMOVE(my_mob.planes_visible, plane)

/*
/datum/plane_holder/proc/set_desired_alpha(var/which = null, var/new_alpha)
	ASSERT(which)
	var/atom/movable/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		stack_trace("Tried to alter [which] in plane_holder on [my_mob]!")
	PM.set_desired_alpha(new_alpha)
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			set_vis(which = SP, new_alpha = new_alpha)
*/

/datum/plane_holder/proc/set_ao(var/which = null, var/enabled = FALSE)
	ASSERT(which)
	var/atom/movable/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		stack_trace("Tried to set_ao [which] in plane_holder on [my_mob]!")
	PM.set_ambient_occlusion(enabled)
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			set_ao(SP, enabled)

/datum/plane_holder/proc/alter_values(var/which = null, var/list/values = null)
	ASSERT(which)
	var/atom/movable/screen/plane_master/PM = plane_masters[which]
	if(!PM)
		stack_trace("Tried to alter [which] in plane_holder on [my_mob]!")
	PM.alter_plane_values(arglist(values))
	if(PM.sub_planes)
		var/list/subplanes = PM.sub_planes
		for(var/SP in subplanes)
			alter_values(SP, values)

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

/atom/movable/screen/plane_master/proc/alter_plane_values()
	return //Stub

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
