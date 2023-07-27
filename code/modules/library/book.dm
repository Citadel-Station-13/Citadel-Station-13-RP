/obj/item/book
	name = "book"
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	throw_speed = 1
	throw_range = 5
	atom_flags = NOCONDUCT
	worn_render_flags = WORN_RENDER_INHAND_NO_RENDER | WORN_RENDER_SLOT_NO_RENDER
	w_class = ITEMSIZE_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	var/dat			 // Actual page content
	var/due_date = 0 // Game time in 1/10th seconds
	var/author		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/libcategory = "Miscellaneous"	// The library category this book sits in. "Fiction", "Non-Fiction", "Adult", "Reference", "Religion"
	var/unique = 0   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title		 // The real name of the book.
	var/carved = 0	 // Has the book been hollowed out for use as a secret storage item?
	var/obj/item/store	//What's in the book?
	drop_sound = 'sound/items/drop/book.ogg'
	pickup_sound = 'sound/items/pickup/book.ogg'

/obj/item/book/attack_self(mob/user)
	. = ..()
	if(.)
		return
	on_read(user)

/obj/item/book/proc/on_read(mob/user)
	if(carved)
		if(store)
			to_chat(user, "<span class='notice'>[store] falls out of [title]!</span>")
			store.forceMove(drop_location())
			store = null
			return
		else
			to_chat(user, "<span class='notice'>The pages of [title] have been cut out!</span>")
			return
	if(src.dat)
		user << browse("<TT><I>Penned by [author].</I></TT> <BR>" + "[dat]", "window=book")
		user.visible_message("[user] opens a book titled \"[src.title]\" and begins reading intently.")
		onclose(user, "book")
	else
		to_chat(user, "This book is completely blank!")

/obj/item/book/attackby(obj/item/W, mob/user)
	if(carved)
		if(!store)
			if(W.w_class < ITEMSIZE_LARGE)
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				store = W
				to_chat(user, "<span class='notice'>You put [W] in [title].</span>")
				return
			else
				to_chat(user, "<span class='notice'>[W] won't fit in [title].</span>")
				return
		else
			to_chat(user, "<span class='notice'>There's already something in [title]!</span>")
			return
	if(istype(W, /obj/item/pen))
		if(unique)
			to_chat(user, "These pages don't seem to take the ink well. Looks like you can't modify it.")
			return
		var/choice = input("What would you like to change?") in list("Title", "Contents", "Author", "Cancel")
		switch(choice)
			if("Title")
				var/newtitle = reject_bad_text(sanitizeSafe(input("Write a new title:")))
				if(!newtitle)
					to_chat(usr, "The title is invalid.")
					return
				else
					src.name = newtitle
					src.title = newtitle
			if("Contents")
				var/content = sanitize(input("Write your book's contents (HTML NOT allowed):") as message|null, MAX_BOOK_MESSAGE_LEN)
				if(!content)
					to_chat(usr, "The content is invalid.")
					return
				else
					src.dat += content
			if("Author")
				var/newauthor = sanitize(input(usr, "Write the author's name:"))
				if(!newauthor)
					to_chat(usr, "The name is invalid.")
					return
				else
					src.author = newauthor
			else
				return
	else if(istype(W, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = W
		if(!scanner.computer)
			to_chat(user, "[W]'s screen flashes: 'No associated computer found!'")
		else
			switch(scanner.mode)
				if(0)
					scanner.book = src
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer.'")
				if(1)
					scanner.book = src
					scanner.computer.buffer_book = src.name
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Book title stored in associated computer buffer.'")
				if(2)
					scanner.book = src
					for(var/datum/borrowbook/b in scanner.computer.checkouts)
						if(b.bookname == src.name)
							scanner.computer.checkouts.Remove(b)
							to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Book has been checked in.'")
							return
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. No active check-out record found for current title.'")
				if(3)
					scanner.book = src
					for(var/obj/item/book in scanner.computer.inventory)
						if(book == src)
							to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Title already present in inventory, aborting to avoid duplicate entry.'")
							return
					scanner.computer.inventory.Add(src)
					to_chat(user, "[W]'s screen flashes: 'Book stored in buffer. Title added to general inventory.'")
	else if(istype(W, /obj/item/material/knife) || W.is_wirecutter())
		if(carved)	return
		to_chat(user, "<span class='notice'>You begin to carve out [title].</span>")
		if(do_after(user, 30))
			to_chat(user, "<span class='notice'>You carve out the pages from [title]! You didn't want to read it anyway.</span>")
			carved = 1
			return
	else
		..()

/obj/item/book/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(user.zone_sel.selecting == O_EYES)
		user.visible_message("<span class='notice'>You open up the book and show it to [target]. </span>", \
			"<span class='notice'> [user] opens up a book and shows it to [target]. </span>")
		target << browse("<TT><I>Penned by [author].</I></TT> <BR>" + "[dat]", "window=book")
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

/*
* Book Bundle (Multi-page book)
*/

/obj/item/book/bundle
	var/page = 1 //current page
	var/list/pages = list() //the contents of each page

/obj/item/book/bundle/proc/show_content(mob/user as mob)
	var/dat
	var/obj/item/W = pages[page]
	// first
	if(page == 1)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Front</A></DIV>"
		dat+= "<DIV STYLE='float:right; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
	// last
	else if(page == pages.len)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:right; text-align:right; with:33.33333%'><A href='?src=\ref[src];next_page=1'>Back</A></DIV><BR><HR>"
	// middle pages
	else
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:right; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
	if(istype(pages[page], /obj/item/paper))
		var/obj/item/paper/P = W
		if(!(istype(usr, /mob/living/carbon/human) || isobserver(usr) || istype(usr, /mob/living/silicon)))
			dat += "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>"
		else
			dat += "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>"
		user << browse(dat, "window=[name]")
	else if(istype(pages[page], /obj/item/photo))
		var/obj/item/photo/P = W
		dat += P.html(user)
		user << browse(dat, "window=[name]")
	else if(!isnull(pages[page]))
		if(!(istype(usr, /mob/living/carbon/human) || isobserver(usr) || istype(usr, /mob/living/silicon)))
			dat += "<HTML><HEAD><TITLE>Page [page]</TITLE></HEAD><BODY>[stars(pages[page])]</BODY></HTML>"
		else
			dat += "<HTML><HEAD><TITLE>Page [page]</TITLE></HEAD><BODY>[pages[page]]</BODY></HTML>"
		user << browse(dat, "window=[name]")

/obj/item/book/bundle/on_read(mob/user)
	show_content(user)
	add_fingerprint(usr)
	update_icon()

/obj/item/book/bundle/Topic(href, href_list)
	if(..())
		return 1
	if((src in usr.contents) || (istype(src.loc, /obj/item/folder) && (src.loc in usr.contents)))
		usr.set_machine(src)
		if(href_list["next_page"])
			if(page != pages.len)
				page++
				playsound(src.loc, "pageturn", 50, 1)
		if(href_list["prev_page"])
			if(page > 1)
				page--
				playsound(src.loc, "pageturn", 50, 1)
		src.attack_self(usr)
		updateUsrDialog()
	else
		to_chat(usr, "<span class='notice'>You need to hold it in your hands!</span>")
