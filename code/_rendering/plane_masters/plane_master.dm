/atom/movable/screen/plane_master
	screen_loc = "CENTER"
	plane = -100 //Dodge just in case someone instantiates one of these accidentally, don't end up on 0 with plane_master
	appearance_flags = PLANE_MASTER
	mouse_opacity = 0	//Normally unclickable
	alpha = 0	//Hidden from view

	/// only on clients
	var/client_global = FALSE
	/// special - managed, like parallax holders
	var/special_managed = FALSE
	/// defaults to disabled (aka invisible)
	var/default_invisible = FALSE
	/// default alpha
	var/default_alpha = 255

/atom/movable/screen/plane_master/proc/set_fake_ambient_occlusion(enabled)
	if(enabled)
		filters += AMBIENT_OCCLUSION
	else
		filters -= AMBIENT_OCCLUSION

//* KEEP THESE SORTED

/atom/movable/screen/plane_master/clickcatcher
	plane = CLICKCATCHER_PLANE

/atom/movable/screen/plane_master/space
	plane = SPACE_PLANE
	alpha = 255
	mouse_opacity = 1
	client_global = TRUE
	special_managed = TRUE

/atom/movable/screen/plane_master/parallax
	plane = PARALLAX_PLANE
	blend_mode = BLEND_MULTIPLY
	alpha = 255
	client_global = TRUE
	special_managed = TRUE

/atom/movable/screen/plane_master/turfs
	plane = TURF_PLANE
	render_target = TURF_PLANE_RENDER_TARGET

/atom/movable/screen/plane_master/objs
	plane = OBJ_PLANE
	render_target = OBJ_PLANE_RENDER_TARGET

/atom/movable/screen/plane_master/mobs
	plane = MOB_PLANE
	render_target = MOB_PLANE_RENDER_TARGET

//Cloaked atoms are visible to ghosts (or for other reasons?)
/atom/movable/screen/plane_master/cloaked
	plane = CLOAKED_PLANE
	default_alpha = 80
	color = "#0000FF"

// todo: remove
/atom/movable/screen/plane_master/above
	plane = ABOVE_PLANE

/atom/movable/screen/plane_master/byond
	plane = BYOND_PLANE

/atom/movable/screen/plane_master/weather
	plane = WEATHER_PLANE

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

/atom/movable/screen/plane_master/lighting
	plane = LIGHTING_PLANE
	blend_mode = BLEND_MULTIPLY
	render_target = LIGHTING_RENDER_TARGET
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

/atom/movable/screen/plane_master/darkvision_plate
	plane = DARKVISION_PLATE_PLANE
	render_target = DARKVISION_PLATE_RENDER_TARGET

/atom/movable/screen/plane_master/darkvision_plate/Initialize(mapload)
	. = ..()
	add_filter("turf_render", 1, layering_filter(render_source = TURF_PLANE_RENDER_TARGET))
	add_filter("obj_render", 2, layering_filter(render_source = OBJ_PLANE_RENDER_TARGET))
	add_filter("mob_render", 3, layering_filter(render_source = MOB_PLANE_RENDER_TARGET))

/atom/movable/screen/plane_master/darkvision
	plane = DARKVISION_PLANE

/atom/movable/screen/plane_master/darkvision/Initialize(mapload)
	. = ..()
	add_filter("turf_render", 1, layering_filter(render_source = TURF_PLANE_RENDER_TARGET))
	add_filter("obj_render", 2, layering_filter(render_source = OBJ_PLANE_RENDER_TARGET))
	add_filter("mob_render", 3, layering_filter(render_source = MOB_PLANE_RENDER_TARGET))

#warn redo this shit

/atom/movable/screen/plane_master/

/atom/movable/screen/plane_master/above_lighting
	plane = ABOVE_LIGHTING_PLANE

/atom/movable/screen/plane_master/sonar
	plane = SONAR_PLANE
	default_invisible = TRUE

/atom/movable/screen/plane_master/observer
	plane = OBSERVER_PLANE
	default_invisible = TRUE

/atom/movable/screen/plane_master/verticality
	plane = VERTICALITY_PLANE
	default_invisible = TRUE
	special_managed = TRUE
	client_global = TRUE

/atom/movable/screen/plane_master/augmented
	plane = AUGMENTED_PLANE
	default_invisible = TRUE

/atom/movable/screen/plane_master/fullscreen
	plane = FULLSCREEN_PLANE

/atom/movable/screen/plane_master/hud
	plane = HUD_PLANE

/atom/movable/screen/plane_master/inventory
	plane = INVENTORY_PLANE

/atom/movable/screen/plane_master/above_hud
	plane = ABOVE_HUD_PLANE
