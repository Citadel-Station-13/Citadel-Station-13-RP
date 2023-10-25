// An Authentic Katana Holder! How fun!
/obj/structure/kake
	name = "katana kake"
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person."
	icon = 'icons/obj/katana_kake.dmi'
	icon_state = "holder_red"
	anchored = 1
	density = 0
	var/katana_held = FALSE
	var/wakizashi_held = FALSE
	var/kstate = "katana_low"
	var/wstate = "wakizashi_low"

/obj/structure/kake/attackby(obj/item/I, mob/user)
	var/image/K = new/image('icons/obj/katana_kake.dmi',"[kstate]")
	var/image/W = new/image('icons/obj/katana_kake.dmi',"[wstate]")
	if(istype(I,/obj/item/material/sword/katana))
		if(katana_held)
			to_chat(user, SPAN_WARNING("There is already a katana on this stand!"))
			return
		else
			add_overlay(K)
			to_chat(user, SPAN_NOTICE("You place [I] upon the stand."))
			I.forceMove(src)
			katana_held = TRUE

	if(istype(I,/obj/item/material/sword/wakizashi))
		if(wakizashi_held)
			to_chat(user, SPAN_WARNING("There is already a wakizashi on this stand!"))
			return
		else
			add_overlay(W)
			to_chat(user, SPAN_NOTICE("You place [I] upon the stand."))
			I.forceMove(src)
			wakizashi_held = TRUE

/obj/structure/kake/attack_hand(mob/user, list/params)
	. = ..()
	var/list/kake_contents = list("Katana","Wakizashi")
	var/image/katana = new/image('icons/obj/katana_kake.dmi',"[kstate]")
	var/image/wakizashi = new/image('icons/obj/katana_kake.dmi',"[wstate]")
	var/choice = input(user, "What would you like to remove from the stand?") as null|anything in kake_contents
	switch(choice)
		if("Katana")
			var/obj/item/material/sword/katana/K = locate() in src
			if(K)
				cut_overlay(katana)
				to_chat(user, SPAN_NOTICE("You remove [K] from the stand."))
				user.put_in_hands(K)
				katana_held = FALSE
				return
			else
				to_chat(user, SPAN_WARNING("There is no [choice] on this stand!"))
				return
		if("Wakizashi")
			var/obj/item/material/sword/wakizashi/W = locate() in src
			if(W)
				cut_overlay(wakizashi)
				to_chat(user, SPAN_NOTICE("You remove [W] from the stand."))
				user.put_in_hands(W)
				wakizashi_held = FALSE
				return
			else
				to_chat(user, SPAN_WARNING("There is no [choice] on this stand!"))
				return

// Colored/Marked Subtypes
/obj/structure/kake/landscape
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person. A mountainous landscape has been intricately burned into the backboard."
	icon_state = "holder_red_mark1"

/obj/structure/kake/crest
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person. An unknown family crest has been carefully burned into the backboard."
	icon_state = "holder_red_mark2"

/obj/structure/kake/black
	icon_state = "holder_black"

/obj/structure/kake/black/landscape
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person. A mountainous landscape has been intricately burned into the backboard."
	icon_state = "holder_black_mark1"

/obj/structure/kake/black/crest
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person. An unknown family crest has been carefully burned into the backboard."
	icon_state = "holder_black_mark2"

// Wall Mounted Variants
/obj/structure/kake/wall
	name = "wall-mounted katana kake"
	desc = "This lacquered wooden wall mount is designed to hold a katana and wakizashi when not on the owner's person."
	icon_state = "wallholder_red"
	kstate = "katana_high"
	wstate = "wakizashi_high"

// Colored/Marked Subtypes
/obj/structure/kake/wall/landscape
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person. A mountainous landscape has been intricately burned into the backboard."
	icon_state = "wallholder_red_mark1"

/obj/structure/kake/wall/crest
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person. An unknown family crest has been carefully burned into the backboard."
	icon_state = "wallholder_red_mark2"

/obj/structure/kake/wall/black
	icon_state = "wallholder_black"

/obj/structure/kake/wall/black/landscape
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person. A mountainous landscape has been intricately burned into the backboard."
	icon_state = "wallholder_black_mark1"

/obj/structure/kake/wall/black/crest
	desc = "This lacquered wooden stand is designed to hold a katana and wakizashi when not on the owner's person. An unknown family crest has been carefully burned into the backboard."
	icon_state = "wallholder_black_mark2"
