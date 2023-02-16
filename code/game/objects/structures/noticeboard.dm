/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning important notices upon."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	density = 0
	anchored = 1
	var/notices = 0

/obj/structure/noticeboard/Initialize(mapload, dir, building = FALSE)
	if(building)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -32 : 32)
		pixel_y = (dir & 3)? (dir ==1 ? -27 : 27) : 0
		update_icon()
	if(mapload)
		for(var/obj/item/I in loc)
			if(notices > 4)
				break
			if(istype(I, /obj/item/paper))
				I.forceMove(src)
				notices++
	icon_state = "nboard0[notices]"
	. = ..()

//attaching papers!!
/obj/structure/noticeboard/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/paper))
		if(notices < 5)
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			O.add_fingerprint(user)
			add_fingerprint(user)
			notices++
			icon_state = "nboard0[notices]"	//update sprite
			to_chat(user, "<span class='notice'>You pin the paper to the noticeboard.</span>")
		else
			to_chat(user, "<span class='notice'>You reach to pin your paper to the board but hesitate. You are certain your paper will not be seen among the many others already attached.</span>")
	if(O.is_wrench())
		to_chat(user, "<span class='notice'>You start to unwrench the noticeboard.</span>")
		playsound(src.loc, O.tool_sound, 50, 1)
		if(do_after(user, 15 * O.tool_speed))
			to_chat(user, "<span class='notice'>You unwrench the noticeboard.</span>")
			new /obj/item/frame/noticeboard( src.loc )
			qdel(src)

/obj/structure/noticeboard/attack_hand(var/mob/user)
	user.do_examinate(src)

// Since Topic() never seems to interact with usr on more than a superficial
// level, it should be fine to let anyone mess with the board other than ghosts.
/obj/structure/noticeboard/examine(mob/user) //why the fuck is this shit on examine
	if(!user)
		user = usr
	if(user.Adjacent(src))
		var/dat = "<B>Noticeboard</B><BR>"
		for(var/obj/item/paper/P in src)
			dat += "<A href='?src=\ref[src];read=\ref[P]'>[P.name]</A> <A href='?src=\ref[src];write=\ref[P]'>Write</A> <A href='?src=\ref[src];remove=\ref[P]'>Remove</A><BR>"
		user << browse("<HEAD><TITLE>Notices</TITLE></HEAD>[dat]","window=noticeboard")
		onclose(user, "noticeboard")
	else
		..()

/obj/structure/noticeboard/Topic(href, href_list)
	..()
	usr.set_machine(src)
	if(href_list["remove"])
		if((usr.stat || usr.restrained()))	//For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["remove"])
		if(P && P.loc == src)
			P.loc = get_turf(src)	//dump paper on the floor because you're a clumsy fuck
			P.add_fingerprint(usr)
			add_fingerprint(usr)
			notices--
			icon_state = "nboard0[notices]"
	if(href_list["write"])
		if((usr.stat || usr.restrained())) //For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["write"])
		if((P && P.loc == src)) //ifthe paper's on the board
			var/mob/living/M = usr
			if(istype(M))
				var/obj/item/pen/E = M.get_held_item_of_type(/obj/item/pen)
				if(E)
					add_fingerprint(M)
					P.attackby(E, usr)
				else
					to_chat(M, "<span class='notice'>You'll need something to write with!</span>")
	if(href_list["read"])
		var/obj/item/paper/P = locate(href_list["read"])
		if((P && P.loc == src))
			usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY><TT>[P.info]</TT></BODY></HTML>", "window=[P.name]")
			onclose(usr, "[P.name]")
	return
