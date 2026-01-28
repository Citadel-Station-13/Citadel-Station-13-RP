/obj/item/book
	name = "book"
	desc = "Crack it open, inhale the musk of its pages, and learn something new."
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	atom_flags = NOCONDUCT
	integrity_flags = INTEGRITY_FLAMMABLE
	worn_render_flags = WORN_RENDER_INHAND_NO_RENDER | WORN_RENDER_SLOT_NO_RENDER
	drop_sound = 'sound/items/drop/book.ogg'
	pickup_sound = 'sound/items/pickup/book.ogg'

	/// Maximum icon state number. We start at 8
	var/maximum_book_state = 16
	/// Game time in 1/10th seconds
	var/due_date = 0
	/// false - Normal book, true - Should not be treated as normal book, unable to be copied, unable to be modified
	var/unique = FALSE
	/// Whether or not we have been carved out.
	var/carved = FALSE
	/// The typepath for the storage datum we use when carved out.
	var/carved_storage_type = /datum/object_system/storage/carved_book

	/// The initial author, for use in var editing and such
	var/starting_author
	/// The initial bit of content, for use in var editing and such
	var/starting_content
	/// The initial title, for use in var editing and such
	var/starting_title
	/// The packet of information that describes this book
	var/datum/book_info/book_data

/obj/item/book/Initialize(mapload)
	. = ..()
	book_data = new(starting_title, starting_author, starting_content)

/obj/item/book/examine(mob/user)
	. = ..()
	if(carved)
		. += SPAN_NOTICE("[src] has been hollowed out.")

/obj/item/book/ui_static_data(mob/user)
	var/list/data = list()
	data["author"] = book_data.get_author()
	data["title"] = book_data.get_title()
	data["content"] = book_data.get_content()
	return data

/obj/item/book/ui_interact(mob/living/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MarkdownViewer", name)
		ui.open()

/// Proc that handles sending the book information to the user, as well as some housekeeping stuff.
/obj/item/book/proc/display_content(mob/living/user)
	ui_interact(user)

/// Proc that checks if the user is capable of reading the book, for UI interactions and otherwise. Returns TRUE if they can, FALSE if they can't.
/obj/item/book/proc/can_read_book(mob/living/user)
	if(user.is_blind())
		to_chat(user, SPAN_WARNING("You are blind and can't read anything!"))
		return FALSE

	// if(!user.can_read(src))
	// 	return FALSE

	if(carved)
		balloon_alert(user, "book is carved out!")
		return FALSE

	if(!length(book_data.get_content()))
		balloon_alert(user, "book is blank!")
		return FALSE

	return TRUE

/obj/item/book/attack_self(mob/user)
	if(!can_read_book(user))
		return

	user.visible_message(SPAN_NOTICE("[user] opens a book titled \"[book_data.title]\" and begins reading intently."))
	display_content(user)

/obj/item/book/proc/is_carving_tool(obj/item/tool)
	PRIVATE_PROC(TRUE)
	if(tool.is_sharp())
		return TRUE
	if(tool.is_wirecutter())
		return TRUE
	return FALSE

/// Checks for whether we can vandalize this book, to ensure we still can after each input.
/// Uses to_chat over balloon alerts to give more detailed information as to why.
/obj/item/book/proc/can_vandalize(mob/living/user, obj/item/tool)
	// if(!user.can_perform_action(src) || !user.can_write(tool, TRUE))
	// 	return FALSE
	if(user.is_blind())
		to_chat(user, SPAN_WARNING("As you are trying to write on the book, you suddenly feel very stupid!"))
		return FALSE
	if(unique)
		to_chat(user, SPAN_WARNING("These pages don't seem to take the ink well! Looks like you can't modify it."))
		return FALSE
	if(carved)
		to_chat(user, SPAN_WARNING("The book has been carved out! There is nothing to be vandalized."))
		return FALSE
	return TRUE

/obj/item/book/attackby(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/pen))
		return writing_utensil_act(user, tool)
	if(is_carving_tool(tool))
		return carving_act(user, tool)
	return ..()

/// Called when user clicks on the book with a writing utensil. Attempts to vandalize the book.
/obj/item/book/proc/writing_utensil_act(mob/living/user, obj/item/tool)
	if(!can_vandalize(user, tool))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	var/choice = tgui_input_list(usr, "What would you like to change?", "Book Alteration", list("Title", "Contents", "Author", "Cancel"))
	if(isnull(choice))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!can_vandalize(user, tool))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	switch(choice)
		if("Title")
			return vandalize_title(user, tool)
		if("Contents")
			return vandalize_contents(user, tool)
		if("Author")
			return vandalize_author(user, tool)

	return NONE

/obj/item/book/proc/vandalize_title(mob/living/user, obj/item/tool)
	var/newtitle = reject_bad_text(tgui_input_text(user, "Write a new title", "Book Title", max_length = 30))
	if(!newtitle)
		balloon_alert(user, "invalid input!")
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(length_char(newtitle) > 30)
		balloon_alert(user, "too long!")
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!can_vandalize(user, tool))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	name = newtitle
	book_data.set_title(html_decode(newtitle)) //Don't want to double encode here
	// playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
	return CLICKCHAIN_DID_SOMETHING

/obj/item/book/proc/vandalize_contents(mob/living/user, obj/item/tool)
	var/content = tgui_input_text(user, "Write your book's contents (HTML NOT allowed)", "Book Contents", max_length = 5000, multiline = TRUE)
	if(!content)
		balloon_alert(user, "invalid input!")
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!can_vandalize(user, tool))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	book_data.set_content(html_decode(content))
	// playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
	return CLICKCHAIN_DID_SOMETHING

/obj/item/book/proc/vandalize_author(mob/living/user, obj/item/tool)
	var/author = tgui_input_text(user, "Write the author's name", "Author Name", max_length = MAX_NAME_LEN)
	if(!author)
		balloon_alert(user, "invalid input!")
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!can_vandalize(user, tool))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	book_data.set_author(html_decode(author)) //Setting this encodes, don't want to double up
	// playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
	return CLICKCHAIN_DID_SOMETHING

/// Called when user clicks on the book with a carving utensil. Attempts to carve the book.
/obj/item/book/proc/carving_act(mob/living/user, obj/item/tool)
	if(carved)
		balloon_alert(user, "already carved!")
		return CLICKCHAIN_DO_NOT_PROPAGATE

	balloon_alert(user, "carving out...")
	if(!do_after(user, 3 SECONDS, target = src))
		balloon_alert(user, "interrupted!")
		return CLICKCHAIN_DO_NOT_PROPAGATE

	balloon_alert(user, "carved out")
	// playsound(src, 'sound/effects/cloth_rip.ogg', vol = 75, vary = TRUE)
	carve_out()
	return CLICKCHAIN_DID_SOMETHING

/// Handles setting everything a carved book needs.
/obj/item/book/proc/carve_out()
	carved = TRUE
	init_storage(carved_storage_type)

/// Generates a random icon state for the book
/obj/item/book/proc/gen_random_icon_state()
	icon_state = "book[rand(8, maximum_book_state)]"

/obj/item/book/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(user.zone_sel.selecting == O_EYES)
		user.visible_message("<span class='notice'>You open up the book and show it to [target]. </span>", \
			"<span class='notice'> [user] opens up a book and shows it to [target]. </span>")
		display_content(target)
		user.setClickCooldownLegacy(DEFAULT_QUICK_COOLDOWN) //to prevent spam

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

// /obj/item/book/bundle/on_read(mob/user)
// 	show_content(user)
// 	add_fingerprint(usr)
// 	update_icon()

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
