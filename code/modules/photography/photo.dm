/obj/item/photo
	name = "photo"
	#warn icon/state
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

	/// scribble on the back
	var/scribble
	/// scribble spans for crayons and stuff
	var/scribble_spans
	/// our photograph id
	var/photograph_id

/obj/item/photo/proc/photograph()
	return SSphotography.resolve_photograph(photograph_id)

var/global/photo_count = 0

/obj/item/photo
	name = "photo"
	icon = 'icons/obj/items.dmi'
	icon_state = "photo"
	item_state = "paper"
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	var/id
	var/icon/img	//Big photo image
	var/scribble	//Scribble on the back.
	var/icon/tiny
	var/photo_size = 3

#warn parse all

/obj/item/photo/Initialize(mapload)
	. = ..()
	id = photo_count++

/obj/item/photo/attack_self(mob/user)
	. = ..()
	if(.)
		return
	user.examinate(src)

/obj/item/photo/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/pen))
		var/txt = sanitize(input(user, "What would you like to write on the back?", "Photo Writing", null)  as text, 128)
		if(loc == user && user.stat == 0)
			scribble = txt
	..()

/obj/item/photo/examine(mob/user)
	if(in_range(user, src))
		show(user)
		return ..()
	else
		to_chat(user, "<span class='notice'>It is too far away.</span>")

/obj/item/photo/proc/show(mob/user as mob)
	user << browse_rsc(img, "tmp_photo_[id].png")
	user << browse("<html><head><title>[name]</title></head>" \
		+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
		+ "<img src='tmp_photo_[id].png' width='[64*photo_size]' style='-ms-interpolation-mode:nearest-neighbor' />" \
		+ "[scribble ? "<br>Written on the back:<br><i>[scribble]</i>" : ""]"\
		+ "</body></html>", "window=book;size=[64*photo_size]x[scribble ? 400 : 64*photo_size]")
	onclose(user, "[name]")
	return

/obj/item/photo/verb/rename()
	set name = "Rename photo"
	set category = "Object"
	set src in usr

	var/n_name = sanitizeSafe(input(usr, "What would you like to label the photo?", "Photo Labelling", null)  as text, MAX_NAME_LEN)
	//loc.loc check is for making possible renaming photos in clipboards
	if(( (loc == usr || (loc.loc && loc.loc == usr)) && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "photo")]"
	add_fingerprint(usr)
	return
