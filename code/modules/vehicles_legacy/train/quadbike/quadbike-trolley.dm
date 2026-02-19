
/*
 * Trailer bits and bobs.
 */

/obj/vehicle_old/train/trolley/trailer
	name = "all terrain trailer"
	icon = 'icons/obj/vehicles_64x64.dmi'
	icon_state = "quadtrailer"
	anchored = 0
	passenger_allowed = 1
	buckle_lying = 1
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 13
	mob_offset_y = 16

	pixel_x = -16

	paint_color = "#ffffff"

/obj/vehicle_old/train/trolley/trailer/random/Initialize(mapload)
	. = ..()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))

/obj/vehicle_old/train/trolley/trailer/proc/update_load()
	if(load)
		var/y_offset = load_offset_y
		if(istype(load, /mob/living))
			y_offset = mob_offset_y
		load.pixel_x = (initial(load.pixel_x) + 16 + load_offset_x + pixel_x) //Base location for the sprite, plus 16 to center it on the 'base' sprite of the trailer, plus the x shift of the trailer, then shift it by the same pixel_x as the trailer to track it.
		load.pixel_y = (initial(load.pixel_y) + y_offset + pixel_y) //Same as the above.
		return 1
	return 0

/obj/vehicle_old/train/trolley/trailer/Initialize(mapload)
	. = ..()
	update_icon()

/obj/vehicle_old/train/trolley/trailer/Move()
	..()
	if(lead)
		switch(dir) //Due to being a Big Boy sprite, it has to have special pixel shifting to look 'normal'.
			if(1)
				pixel_y = -10
				pixel_x = -16
			if(2)
				pixel_y = 0
				pixel_x = -16
			if(4)
				pixel_y = 0
				pixel_x = -25
			if(8)
				pixel_y = 0
				pixel_x = -5
	else
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)
	update_load()

/obj/vehicle_old/train/trolley/trailer/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T, dir)	//bump things away when hit

	if(istype(A, /mob/living))
		var/mob/living/M = A
		visible_message("<span class='danger'>[src] knocks over [M]!</span>")
		M.apply_effects(1, 1)
		M.apply_damages(8 / move_delay)
		if(load)
			M.apply_damages(4/move_delay)
		var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
		if(!emagged)
			throw_dirs -= dir
		var/turf/T2 = get_step(A, pick(throw_dirs))
		M.throw_at_old(T2, 1, 1, src)
		if(istype(load, /mob/living/carbon/human))
			var/mob/living/D = load
			to_chat(D, "<span class='danger'>You hit [M]!</span>")
			add_attack_logs(D,M,"Ran over with [src.name]")

/obj/vehicle_old/train/trolley/trailer/update_icon()
	..()
	cut_overlay()

	var/image/Bodypaint = new(icon = 'icons/obj/vehicles_64x64.dmi', icon_state = "[initial(icon_state)]_a", layer = src.layer)
	Bodypaint.color = paint_color
	add_overlay(Bodypaint)

/obj/vehicle_old/train/trolley/trailer/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool) && open)
		var/new_paint = input("Please select paint color.", "Paint Color", paint_color) as color|null
		if(new_paint)
			paint_color = new_paint
			update_icon()
			return
	..()
