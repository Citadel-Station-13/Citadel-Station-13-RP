/obj/effect/projectile_visual
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	atom_flags = ATOM_ABSTRACT
	appearance_flags = TILE_MOVER

/obj/effect/projectile_visual/emissive
	plane = EMISSIVE_PLANE
	color = EMISSIVE_COLOR
	layer = MANGLE_PLANE_AND_LAYER(MOB_PLANE, ABOVE_MOB_LAYER)

/obj/projectile/proc/hitscan_muzzle_effect(turf/where, p_x, p_y, angle, duration)
	var/obj/effect/projectile_visual/created = new(where)
	var/matrix/transformation = new
	transformation.Translate(p_x, p_y)
	transformation.Turn(angle)
	created.transform = transformation
	created.icon = hitscan_icon
	created.icon_state = "[hitscan_state]_muzzle"
	QDEL_IN(created, duration)
	if(hitscan_glow_range > 0)
		var/obj/effect/projectile_visual/emissive/glow = new(where)
		glow.transform = transformation
		glow.icon = created.icon
		glow.icon_state = created.icon_state
		QDEL_IN(glow, duration)

/obj/projectile/proc/hitscan_impact_effect(turf/where, p_x, p_y, angle, duration)
	var/obj/effect/projectile_visual/created = new(where)
	created.pixel_x = p_x
	created.pixel_y = p_y
	var/matrix/transformation = new
	transformation.Turn(angle)
	created.transform = transformation
	created.icon_state = "[hitscan_state]_tracer"
	QDEL_IN(created, duration)
	if(hitscan_glow_range > 0)
		var/obj/effect/projectile_visual/emissive/glow = new(where)
		glow.transform = transformation
		glow.icon = created.icon
		glow.icon_state = created.icon_state
		QDEL_IN(glow, duration)

/obj/projectile/proc/hitscan_tracer_effect(datum/point/starting, datum/point/ending, duration = 0.3 SECONDS)
	var/datum/point/midpoint = midpoint_between_points(starting, ending)
	var/obj/effect/projectile_visual/created = new(midpoint)
	created.icon = hitscan_icon
	created.icon_state = "[hitscan_state]_tracer"
	var/matrix/transformation = new
	transformation.Scale(distance_between_points(starting, ending))
	transformation.Turn(angle_between_points(starting, ending))
	created.transform = transformation
	QDEL_IN(created, duration)
	if(hitscan_glow_range > 0)
		var/obj/effect/projectile_visual/emissive/glow = new(midpoint)
		glow.transform = transformation
		glow.icon = created.icon
		glow.icon_state = created.icon_state
		var/list/applying = drop_shadow_filter(x = 0, y = 0, size = hitscan_glow_range, color = istext(hitscan_color)? hitscan_color : "#ffffff")
		glow.filters += filter(arglist(applying))
		QDEL_IN(glow, duration)
