/obj/effect/temporary_effect/item_pickup_ghost
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	time_to_die = 0.5 SECONDS
	var/lifetime = 0.25 SECONDS //so it doesn't die before animation ends

/obj/effect/temporary_effect/item_pickup_ghost/Initialize(mapload, obj/item/from_item, atom/towards_target)
	. = ..()
	if(from_item)
		assumeform(from_item)
	if(towards_target)
		animate_towards(towards_target)

/obj/effect/temporary_effect/item_pickup_ghost/proc/assumeform(var/obj/item/picked_up)
	icon = picked_up.icon
	icon_state = picked_up.icon_state
	pixel_x = picked_up.pixel_x
	pixel_y = picked_up.pixel_y
	color = picked_up.color

/obj/effect/temporary_effect/item_pickup_ghost/proc/animate_towards(var/atom/target)
	var/new_pixel_x = pixel_x + (target.x - src.x) * 32
	var/new_pixel_y = pixel_y + (target.y - src.y) * 32
	animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, transform = matrix()*0, time = lifetime)
