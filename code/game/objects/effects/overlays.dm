/obj/effect/overlay
	name = "overlay"

/obj/effect/overlay/singularity_act()
	return

/obj/effect/overlay/singularity_pull()
	return

/obj/effect/overlay/vis
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	var/unused = 0 //When detected to be unused it gets set to world.time, after a while it gets removed
	var/cache_expiration = 2 MINUTES // overlays which go unused for 2 minutes get cleaned up

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	var/atom/BeamSource

/obj/effect/overlay/beam/Initialize()
	. = ..()
	QDEL_IN(src, 10)

/obj/effect/overlay/palmtree_r
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = TRUE
	layer = WALL_OBJ_LAYER
	anchored = TRUE

/obj/effect/overlay/palmtree_l
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = TRUE
	layer = WALL_OBJ_LAYER
	anchored = TRUE

/obj/effect/overlay/coconut
	gender = PLURAL
	name = "coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/sparkles
	gender = PLURAL
	name = "sparkles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	anchored = TRUE








/obj/effect/overlay
	name = "overlay"
	unacidable = 1
	var/i_attached//Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/bluespacify
	name = "Bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespacify"
	plane = ABOVE_PLANE

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	density = TRUE
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

/obj/effect/overlay/wallrot/New()
	..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)

/obj/effect/overlay/snow
	name = "snow"
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snow"
	mouse_opacity = MOUSE_OPACITY_ICON

// Todo: Add a version that gradually reaccumulates over time by means of alpha transparency. -Spades
/obj/effect/overlay/snow/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/shovel))
		user.visible_message("<span class='notice'>[user] begins to shovel away \the [src].</span>")
		if(do_after(user, 40))
			to_chat(user, "<span class='notice'>You have finished shoveling!</span>")
			qdel(src)
		return

/obj/effect/overlay/snow/floor
	icon_state = "snowfloor"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT //Don't block underlying tile interactions

/obj/effect/overlay/snow/floor/edges
	icon_state = "snow_edges"

/obj/effect/overlay/snow/floor/surround
	icon_state = "snow_surround"

/obj/effect/overlay/snow/airlock
	icon_state = "snowairlock"
	layer = DOOR_CLOSED_LAYER+0.01

/obj/effect/overlay/snow/floor/pointy
	icon_state = "snowfloorpointy"

/obj/effect/overlay/snow/wall
	icon_state = "snowwall"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

/obj/effect/overlay/holographic
	mouse_opacity = FALSE
	anchored = TRUE
	plane = ABOVE_PLANE

// Similar to the tesla ball but doesn't actually do anything and is purely visual.
/obj/effect/overlay/energy_ball
	name = "energy ball"
	desc = "An energy ball."
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball"
	plane = PLANE_LIGHTING_ABOVE
	pixel_x = -32
	pixel_y = -32
