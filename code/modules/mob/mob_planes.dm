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
	plane_masters[VIS_LIGHTING] 	= new /atom/movable/screen/plane_master/lighting						//Lighting system (but different
	plane_masters[VIS_EMISSIVE]     = new /atom/movable/screen/plane_master/emissive
	plane_masters[VIS_GHOSTS] 		= new /atom/movable/screen/plane_master/ghosts							//Ghosts!
	plane_masters[VIS_AI_EYE]		= new /atom/movable/screen/plane_master{plane = OBSERVER_PLANE}			//AI Eye!

	plane_masters[VIS_STATUS]		= new /atom/movable/screen/plane_master{plane = PLANE_STATUS}			//Status indicators that show over mob heads.

	plane_masters[VIS_MESONS]		= new /atom/movable/screen/plane_master{plane = VERTICALITY_PLANE} 			//Meson-specific things like open ceilings.

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
