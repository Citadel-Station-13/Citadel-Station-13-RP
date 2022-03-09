#define SKYBOX_PADDING	4	// How much larger we want the skybox image to be than client's screen (in turfs)
#define SKYBOX_PIXELS	736	// Size of skybox image in pixels
#define SKYBOX_TURFS	(SKYBOX_PIXELS/WORLD_ICON_SIZE)
#define SKYBOX_MAX_BOUND 736
// Skybox screen object.
/obj/screen/skybox
	name = "skybox"
	icon = null
	appearance_flags = TILE_BOUND|PIXEL_SCALE
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	screen_loc = "CENTER,CENTER"
	plane = SKYBOX_PLANE
	blend_mode = BLEND_MULTIPLY	// You actually need to do it this way or you see it in occlusion.
	screen_loc = "CENTER,CENTER"
	var/transform_animate_time = 0
	var/static/max_view_dim
	var/static/const/parallax_bleed_percent = 0.2 // 20% parallax offset when going from x=1 to x=max
	var/base_x_dim = 7
	var/base_y_dim = 7
	var/base_offset_x = -224 // -(world.view x dimension * world.icon_size)
	var/base_offset_y = -224 // -(world.view y dimension * world.icon_size)
/obj/screen/skybox/Initialize()
	screen_loc = "CENTER:[base_offset_x],CENTER:[base_offset_y]"
	. = ..()
// Adjust transform property to scale for client's view var. We assume the skybox is 736x736 px
/obj/screen/skybox/proc/scale_to_view(var/view)
	var/matrix/M = matrix()
	// Translate to center the icon over us!
	M.Translate(-(SKYBOX_PIXELS - WORLD_ICON_SIZE) / 2)
	// Scale appropriately based on view size.  (7 results in scale of 1)
	view = text2num(view) || 7 // Sanitize
	M.Scale(((min(MAX_CLIENT_VIEW, view) + SKYBOX_PADDING) * 2 + 1) / SKYBOX_TURFS)
	src.transform = M

/client
	var/obj/screen/skybox/skybox

/mob/Login()
	. = ..()
	client.update_skybox(TRUE)

/mob/onTransitZ(old_z, new_z)
	..()
	if(old_z != new_z)
		client?.update_skybox(TRUE)

/mob/Moved()
	. = ..()
	client?.update_skybox()

/mob/set_viewsize()
	. = ..()
	if (. && client)
		client.update_skybox()
		client.skybox?.scale_to_view(client.view)

#undef SKYBOX_PIXELS
#undef SKYBOX_TURFS
