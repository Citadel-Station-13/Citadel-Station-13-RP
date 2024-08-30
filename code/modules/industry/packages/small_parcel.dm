/obj/item/smallDelivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate3"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	var/obj/item/wrapped = null
	var/sortTag = null
	var/examtext = null
	var/nameset = 0
	var/tag_x

/obj/item/smallDelivery/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if (src.wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.loc = user.loc
		if(ishuman(user))
			user.put_in_hands(wrapped)
		else
			wrapped.loc = get_turf(src)

	qdel(src)
	return

/obj/item/smallDelivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/destTagger))
		var/obj/item/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, "<span class='notice'>You have labeled the destination as [O.currTag].</span>")
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
			else
				to_chat(user, "<span class='warning'>The package is already labeled for [O.currTag].</span>")
		else
			to_chat(user, "<span class='warning'>You need to set a destination first!</span>")

	else if(istype(W, /obj/item/pen))
		switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
			if("Title")
				var/str = sanitizeSafe(input(usr,"Label text?","Set label",""), MAX_NAME_LEN)
				if(!str || !length(str))
					to_chat(user, "<span class='warning'> Invalid text.</span>")
					return
				user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",\
				"<span class='notice'>You title \the [src]: \"[str]\"</span>",\
				"You hear someone scribbling a note.")
				name = "[name] ([str])"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1

			if("Description")
				var/str = sanitize(input(usr,"Label text?","Set label",""))
				if(!str || !length(str))
					to_chat(user, "<font color='red'>Invalid text.</font>")
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",\
				"<span class='notice'>You label \the [src]: \"[examtext]\"</span>",\
				"You hear someone scribbling a note.")
	return

/obj/item/smallDelivery/update_icon()
	cut_overlays()
	if((nameset || examtext) && icon_state != "deliverycrate1")
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycrate5")
			I.pixel_y = -1
		add_overlay(I)
	if(sortTag)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_tag")
		switch(icon_state)
			if("deliverycrate1")
				I.pixel_y = -5
			if("deliverycrate2")
				I.pixel_y = -2
			if("deliverycrate3")
				I.pixel_y = 0
			if("deliverycrate4")
				if(tag_x == null)
					tag_x = rand(0,5)
				I.pixel_x = tag_x
				I.pixel_y = 3
			if("deliverycrate5")
				I.pixel_y = -3
		add_overlay(I)

/obj/item/smallDelivery/examine(mob/user, dist)
	. = ..()
	if(sortTag)
		. += "<span class='notice'>It is labeled \"[sortTag]\"</span>"
	if(examtext)
		. += "<span class='notice'>It has a note attached which reads, \"[examtext]\"</span>"

/obj/item/packageWrap
	name = "package wrapper"
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	w_class = WEIGHT_CLASS_NORMAL
	var/amount = 25.0


/obj/item/packageWrap/afterattack(atom/movable/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)) return
	if(!istype(target))	//this really shouldn't be necessary (but it is).	-Pete
		return
	if(istype(target, /obj/item/smallDelivery) || istype(target,/obj/structure/bigDelivery) \
	|| istype(target, /obj/item/gift) || istype(target, /obj/item/evidencebag))
		return
	if(target.anchored)
		return
	if(target in user)
		return
	if(user in target) //no wrapping closets that you are inside - it's not physically possible
		return

	user.attack_log += "\[[time_stamp()]\] <font color=#4F49AF>Has used [name] on \ref[target]</font>"


	if (istype(target, /obj/item) && !(istype(target, /obj/item/storage) && !istype(target,/obj/item/storage/box)))
		var/obj/item/O = target
		if (src.amount > 1)
			var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(O.loc))	//Aaannd wrap it up!
			if(!istype(O.loc, /turf))
				if(user.client)
					user.client.screen -= O
			P.wrapped = O
			O.forceMove(P)
			P.set_weight_class(O.w_class)
			var/i = round(O.get_weight_class())
			if(i in list(1,2,3,4,5))
				P.icon_state = "deliverycrate[i]"
				switch(i)
					if(1) P.name = "tiny parcel"
					if(3) P.name = "normal-sized parcel"
					if(4) P.name = "large parcel"
					if(5) P.name = "huge parcel"
			if(i < 1)
				P.icon_state = "deliverycrate1"
				P.name = "tiny parcel"
			if(i > 5)
				P.icon_state = "deliverycrate5"
				P.name = "huge parcel"
			P.add_fingerprint(usr)
			O.add_fingerprint(usr)
			src.add_fingerprint(usr)
			src.amount -= 1
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
			"You hear someone taping paper around a small object.")
	else if (istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.icon_state = "deliverycrate"
			P.wrapped = O
			O.loc = P
			src.amount -= 3
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
			"You hear someone taping paper around a large object.")
		else if(src.amount < 3)
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else if (istype (target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.wrapped = O
			O.sealed = 1
			O.loc = P
			src.amount -= 3
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
			"You hear someone taping paper around a large object.")
		else if(src.amount < 3)
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else
		to_chat(user, "<font color=#4F49AF>The object you are trying to wrap is unsuitable for the sorting machinery!</font>")
	if (src.amount <= 0)
		new /obj/item/c_tube( src.loc )
		qdel(src)
		return
	return

/obj/item/packageWrap/examine(mob/user, dist)
	. = ..()
	. += "<font color=#4F49AF>There are [amount] units of package wrap left!</font>"
