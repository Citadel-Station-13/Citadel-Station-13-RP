// todo: /obj/item/small_parcel
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

/obj/item/smallDelivery/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if (wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		if(ishuman(user))
			user.put_in_hands_or_drop(wrapped)
		else
			wrapped.forceMove(drop_location())
		wrapped = null

	qdel(src)

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
