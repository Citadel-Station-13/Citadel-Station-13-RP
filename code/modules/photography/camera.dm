// todo: refactor everything

/obj/item/camera
	name = "camera"
	icon = 'icons/modules/photography/camera.dmi'
	icon_state = "camera"
	worn_state = "camera"
	worn_render_flags = NONE
	desc = "A polaroid camera. 10 photos left."
	item_flags = ITEM_NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	materials = list(MAT_STEEL = 2000)
	var/pictures_max = 10
	var/pictures_left = 10
	var/on = 1
	var/icon_on = "camera"
	var/icon_off = "camera_off"
	var/size = 3
	var/list/picture_planes = list()

/obj/item/camera/verb/change_size()
	set name = "Set Photo Focus"
	set category = "Object"
	var/nsize = input("Photo Size","Pick a size of resulting photo.") as null|anything in list(1,3,5,7)
	if(nsize)
		size = nsize
		to_chat(usr, "<span class='notice'>Camera will now take [size]x[size] photos.</span>")

/obj/item/camera/attack_self(mob/user)
	. = ..()
	if(.)
		return
	on = !on
	if(on)
		src.icon_state = icon_on
	else
		src.icon_state = icon_off
	to_chat(user, "You switch the camera [on ? "on" : "off"].")
	return

/obj/item/camera/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/camera_film))
		var/obj/item/camera_film/film = I
		if(pictures_left >= pictures_max)
			to_chat(user, "<span class='notice'>[src] still has a lot of film in it!</span>")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		pictures_left += film.amount
		return
	..()


/obj/item/camera/proc/get_icon(list/turfs, turf/center)

	//Bigger icon base to capture those icons that were shifted to the next tile
	//i.e. pretty much all wall-mounted machinery
	var/icon/res = icon('icons/effects/96x96.dmi', "")
	res.Scale(size*32, size*32)
	// Initialize the photograph to black.
	res.Blend("#000", ICON_OVERLAY)

	var/atoms[] = list()
	for(var/turf/the_turf in turfs)
		// Add outselves to the list of stuff to draw
		atoms.Add(the_turf);
		// As well as anything that isn't invisible.
		for(var/atom/A in the_turf)
			if(A.invisibility) continue
			if(A.plane > 0 && !(A.plane in picture_planes)) continue
			atoms.Add(A)

	// Sort the atoms into their layers
	var/list/sorted = sort_atoms_by_layer(atoms)
	var/center_offset = (size-1)/2 * 32 + 1
	for(var/i; i <= sorted.len; i++)
		var/atom/A = sorted[i]
		if(A)
			var/icon/img = get_flat_icon(A)

			// If what we got back is actually a picture, draw it.
			if(istype(img, /icon))
				// Check if we're looking at a mob that's lying down
				if(istype(A, /mob/living) && A:lying)
					// If they are, apply that effect to their picture.
					img.BecomeLying()
				// Calculate where we are relative to the center of the photo
				var/xoff = (A.x - center.x) * 32 + center_offset
				var/yoff = (A.y - center.y) * 32 + center_offset
				if (istype(A,/atom/movable))
					xoff+=A:step_x
					yoff+=A:step_y
				res.Blend(img, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)

	// Lastly, render any contained effects on top.
	for(var/turf/the_turf in turfs)
		// Calculate where we are relative to the center of the photo
		var/xoff = (the_turf.x - center.x) * 32 + center_offset
		var/yoff = (the_turf.y - center.y) * 32 + center_offset
		res.Blend(get_flat_icon(the_turf.loc), blendMode2iconMode(the_turf.blend_mode),xoff,yoff)
	// trample animations
	return icon(res, dir = SOUTH, frame = 1)

/obj/item/camera/proc/get_mobs(turf/the_turf as turf)
	var/mob_detail
	for(var/mob/living/carbon/A in the_turf)
		if(A.invisibility) continue
		var/holding = list()

		for(var/obj/item/held as anything in A.get_held_items())
			holding += "\a [held]"

		if(!mob_detail)
			mob_detail = "You can see [A] on the photo[A:health < 75 ? " - [A] looks hurt":""].[length(holding)? " They are holding [english_list(holding)]":"."]. "
		else
			mob_detail += "You can also see [A] on the photo[A:health < 75 ? " - [A] looks hurt":""].[length(holding)? " They are holding [english_list(holding)]":"."]."

	return mob_detail

/obj/item/camera/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!on || !pictures_left || ismob(target.loc)) return
	captureimage(target, user, (clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))

	playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)

	pictures_left--
	desc = "A polaroid camera. It has [pictures_left] photos left."
	to_chat(user, "<span class='notice'>[pictures_left] photos left.</span>")
	icon_state = icon_off
	on = 0
	spawn(64)
		icon_state = icon_on
		on = 1

/obj/item/camera/proc/can_capture_turf(turf/T, mob/user)
	var/viewer = user
	if(user.client)		//To make shooting through security cameras possible
		viewer = user.client.eye
	var/can_see = (T in view(viewer))

	return can_see

/obj/item/camera/proc/captureimage(atom/target, mob/user, flag)
	var/x_c = target.x - (size-1)/2
	var/y_c = target.y + (size-1)/2
	var/z_c	= target.z
	var/list/turfs = list()
	var/mobs = ""
	for(var/i = 1 to size)
		for(var/j = 1 to size)
			var/turf/T = locate(x_c, y_c, z_c)
			if(can_capture_turf(T, user))
				turfs.Add(T)
				mobs += get_mobs(T)
			x_c++
		y_c--
		x_c = x_c - size

	var/obj/item/photo/p = createpicture(target, user, turfs, mobs, flag)

	printpicture(user, p)

/obj/item/camera/proc/createpicture(atom/target, mob/user, list/turfs, mobs, flag)
	var/icon/photoimage = get_icon(turfs, target)
	var/datum/photograph/photograph = new
	photograph.from_image(photoimage)
	photograph.desc = mobs
	SSphotography.save_photograph(photograph)
	return create_photo(from_what = photograph)

/obj/item/camera/proc/printpicture(mob/user, obj/item/photo/p)
	p.loc = user.loc
	if(!user.get_inactive_held_item())
		user.put_in_inactive_hand(p)

/obj/item/camera/spooky
	name = "camera obscura"
	desc = "A polaroid camera, some say it can see ghosts!"
