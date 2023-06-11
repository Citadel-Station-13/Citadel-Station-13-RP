/obj/item/photo
	name = "photo"
	icon = 'icons/modules/photography/photo.dmi'
	icon_state = "photo"
	worn_render_flags = WORN_RENDER_INHAND_ALLOW_DEFAULT
	inhand_default_type = INHAND_DEFAULT_ICON_GENERAL
	inhand_state = "paper"
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
	return SSphotography.load_photograph(photograph_id)

/obj/item/photo/serialize()
	. = ..()
	.["photo"] = photograph_id
	.["scribble"] = scribble
	.["spans"] = scribble_spans

/obj/item/photo/deserialize(list/data)
	. = ..()
	scribble = data["scribble"]
	scribble_spans = data["spans"]
	photograph_id = data["photo"]

/obj/item/photo/attack_self(mob/user)
	user.examinate(src)
	return ..()

/obj/item/photo/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	// todo: pen_act?
	if(istype(I, /obj/item/pen))
		var/str = input(user, "What would you like to write on the back?", "Scribble", scribble) as text|null
		str = sanitize(str, MAX_SCRIBBLE_LEN)
		scribble = str
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/photo/examine(mob/user, dist)
	. = ..()
	if(dist <= 1)
		show(user)
	else
		. += SPAN_NOTICE("It is too far away to look at.")

/obj/item/photo/proc/show(mob/user)
	// todo: tgui?
	var/img_url = SSphotography.url_for_photograph(photograph_id, user.client)
	var/built = {"<html><head><title>[name]</title></head><body style='overflow:hidden;margin:0;text-align:center'>
	<img src='[img_url]' style='width:auto;height:100%;-ms-interpolation-mode:nearest-neighbor' />
	[isnull(scribble)? "" : "<br>Written on the back:<br><i>[scribble]</i>"]
	</body></html>"}
	user << browse(built, "window=picture_[rand(1, 1000)];size=480x[scribble? 640 : 480]")

// todo: refactor
/obj/item/photo/verb/rename()
	set name = "Rename photo"
	set category = "Object"
	set src in usr

	var/n_name = sanitizeSafe(input(usr, "What would you like to label the photo?", "Photo Labelling", null) as text, MAX_NAME_LEN)
	//loc.loc check is for making possible renaming photos in clipboards
	if(( (loc == usr || (loc.loc && loc.loc == usr)) && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "photo")]"
	add_fingerprint(usr)
	return

/obj/item/photo/proc/copy(include_markup)
	var/obj/item/photo/clone = new
	clone.name = name
	clone.desc = desc
	if(include_markup)
		clone.scribble = scribble
		clone.scribble_spans = scribble_spans
	clone.photograph_id = photograph_id
	return clone
