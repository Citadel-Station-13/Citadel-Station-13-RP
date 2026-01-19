#define BOOKCASE_UNANCHORED 0
#define BOOKCASE_ANCHORED 1
#define BOOKCASE_FINISHED 2

/obj/structure/bookcase
	name = "bookcase"
	desc = "A great place for storing knowledge."
	icon = 'icons/obj/library.dmi'
	icon_state = "book-0"
	anchored = FALSE
	density = TRUE
	opacity = FALSE
	integrity_flags = INTEGRITY_FLAMMABLE
	integrity_max = 200

	var/state = BOOKCASE_UNANCHORED
	/// When enabled, books_to_load number of random books will be generated for this bookcase
	var/load_random_books = FALSE
	/// The category of books to pick from when populating random books.
	var/random_category = BOOK_CATEGORY_RANDOM
	/// Probability that a category will be changed to random regardless of what it was set to.
	var/category_prob = 25
	/// How many random books to generate.
	var/books_to_load = 0
	/// Skin of the bookcase to use, either book or legalbook
	var/booktype = "book"

/obj/structure/bookcase/Initialize(mapload)
	. = ..()
	if(!mapload || QDELETED(src))
		return
	// Only mapload from here on
	set_anchored(TRUE)
	state = BOOKCASE_FINISHED
	for(var/obj/item/I in loc)
		if(!isbook(I))
			continue
		I.forceMove(src)
	update_appearance()

	if(SSlibrary.initialized)
		INVOKE_ASYNC(src, PROC_REF(load_shelf))
	else
		SSlibrary.shelves_to_load += src

///Loads the shelf, both by allowing it to generate random items, and by adding its contents to a list used by library machines
/obj/structure/bookcase/proc/load_shelf()
	//Loads a random selection of books in from the db, adds a copy of their info to a global list
	//To send to library consoles as a starting inventory
	if(load_random_books)
		var/randomizing_categories = prob(category_prob) || random_category == BOOK_CATEGORY_RANDOM
		// We only need to run this special logic if we're randomizing a non-adult bookshelf
		if(randomizing_categories && random_category != BOOK_CATEGORY_ADULT)
			// Category is manually randomized rather than using BOOK_CATEGORY_RANDOM
			// So we can exclude adult books in non-adult bookshelves
			// And also weight the prime category more heavily
			var/list/category_pool = list(
				BOOK_CATEGORY_FICTION,
				BOOK_CATEGORY_NONFICTION,
				BOOK_CATEGORY_REFERENCE,
				BOOK_CATEGORY_RELIGION,
			)
			if(random_category != BOOK_CATEGORY_RANDOM)
				category_pool += random_category
			var/sub_books_to_load = books_to_load
			while(sub_books_to_load > 0 && length(category_pool) > 0)
				var/cat_amount = min(rand(1, 2), sub_books_to_load)
				sub_books_to_load -= cat_amount
				create_random_books(amount = cat_amount, location = src, category = pick_n_take(category_pool))
		// Otherwise we can just let the proc handle everything, it will even do randomization for us
		else
			create_random_books(amount = books_to_load, location = src, category = randomizing_categories ? BOOK_CATEGORY_RANDOM : random_category)

		update_appearance() //Make sure you look proper

	var/area/our_area = get_area(src)
	var/area_type = our_area.type //Save me from the dark

	if(!SSlibrary.books_by_area[area_type])
		SSlibrary.books_by_area[area_type] = list()

	//Time to populate that list
	var/list/books_in_area = SSlibrary.books_by_area[area_type]
	for(var/obj/item/book/book in contents)
		var/datum/book_info/info = book.book_data
		books_in_area += info.return_copy()

/obj/structure/bookcase/examine(mob/user)
	. = ..()
	if(!anchored)
		. += SPAN_NOTICE("The <i>bolts</i> on the bottom are unsecured.")
	else
		. += SPAN_NOTICE("It's secured in place with <b>bolts</b>.")
	switch(state)
		if(BOOKCASE_UNANCHORED)
			. += SPAN_NOTICE("There's a <b>small crack</b> visible on the back panel.")
		if(BOOKCASE_ANCHORED)
			. += SPAN_NOTICE("There's space inside for a <i>wooden</i> shelf.")
		if(BOOKCASE_FINISHED)
			. += SPAN_NOTICE("There's a <b>small crack</b> visible on the shelf.")

/obj/structure/bookcase/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return
	state = anchorvalue
	if(!anchorvalue) //in case we were vareditted or uprooted by a hostile mob, ensure we drop all our books instead of having them disappear till we're rebuild.
		var/atom/Tsec = drop_location()
		for(var/obj/I in contents)
			if(!isbook(I))
				continue
			I.forceMove(Tsec)
	update_appearance()

/obj/structure/bookcase/attackby(obj/item/attacking_item, mob/user, list/params, clickchain_flags, damage_multiplier, datum/event_args/actor/clickchain/clickchain)
	if(state == BOOKCASE_UNANCHORED)
		if(attacking_item.use_wrench(src, clickchain, delay = 20))
			balloon_alert(user, "wrenched in place")
			set_anchored(TRUE)
			return

		if(attacking_item.use_crowbar(src, clickchain, delay = 20))
			balloon_alert(user, "pried apart")
			deconstruct(TRUE)
			return
		return ..()

	if(state == BOOKCASE_ANCHORED)
		if(istype(attacking_item, /obj/item/stack/material/wood))
			var/obj/item/stack/material/wood/W = attacking_item
			if(W.get_amount() < 2)
				balloon_alert(user, "not enough wood")
				return
			W.use(2)
			balloon_alert(user, "shelf added")
			state = BOOKCASE_FINISHED
			update_appearance()
			return

		if(attacking_item.use_wrench(src, clickchain, delay = 0))
			balloon_alert(user, "unwrenched the frame")
			set_anchored(FALSE)
			return
		return ..()

	if(isbook(attacking_item))
		if(!user.transfer_item_to_loc(attacking_item, src))
			return ..()
		update_appearance()
		return

	if(attacking_item.is_crowbar())
		if(length(contents))
			balloon_alert(user, "remove the books first")
			return
		if(attacking_item.use_crowbar(src, clickchain))
			balloon_alert(user, "pried the shelf out")
			new /obj/item/stack/material/wood(drop_location(), 2)
			state = BOOKCASE_ANCHORED
			update_appearance()
			return

	// old writing proc
	if(istype(attacking_item, /obj/item/pen))
		var/newname = sanitizeSafe(input("What would you like to title this bookshelf?"), MAX_NAME_LEN)
		if(!newname)
			return
		else
			name = ("bookcase ([newname])")
		return

	return ..()

/obj/structure/bookcase/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	. = ..()
	if(.)
		return
	if(!istype(user))
		return
	if(!length(contents))
		return
	var/obj/item/book/choice = tgui_input_list(user, "Book to remove from the shelf", "Remove Book", sortNames(contents.Copy()))
	if(isnull(choice))
		return
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE) || user.stat != CONSCIOUS || !in_range(loc, user))
		return
	if(ishuman(user))
		if(!user.get_active_held_item())
			user.put_in_hands(choice)
	else
		choice.forceMove(drop_location())
	update_appearance()

/obj/structure/bookcase/drop_products(method, atom/where)
	. = ..()
	new /obj/item/stack/material/wood(where, 4)
	for(var/obj/item/I in contents)
		if(!isbook(I)) //Wake me up inside
			continue
		I.forceMove(where)

/obj/structure/bookcase/update_icon_state()
	if(state == BOOKCASE_UNANCHORED || state == BOOKCASE_ANCHORED)
		icon_state = "[booktype]-0"
		return ..()
	var/amount = length(contents)
	icon_state = "[booktype]-[clamp(amount, 0, 5)]"
	return ..()

/obj/structure/bookcase/manuals/medical
	name = "Medical Manuals bookcase"

/obj/structure/bookcase/manuals/medical/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/medical_cloning(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	new /obj/item/book/manual/medical_diagnostics_manual(src)
	update_appearance()

/obj/structure/bookcase/manuals/engineering
	name = "Engineering Manuals bookcase"

/obj/structure/bookcase/manuals/engineering/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/wiki/engineering_construction(src)
	new /obj/item/book/manual/wiki/engineering_hacking(src)
	new /obj/item/book/manual/wiki/engineering_guide(src)
	new /obj/item/book/manual/engineering_particle_accelerator(src)
	new /obj/item/book/manual/atmospipes(src)
	new /obj/item/book/manual/engineering_singularity_safety(src)
	new /obj/item/book/manual/evaguide(src)
	update_appearance()

/obj/structure/bookcase/manuals/research_and_development
	name = "\improper R&D manuals bookcase"

/obj/structure/bookcase/manuals/research_and_development/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/research_and_development(src)
	update_appearance()

/obj/structure/bookcase/legal
	booktype = "legalbook"

/obj/structure/bookcase/legal/sop
	name = "Legal Manuals bookcase"
	icon_state = "legalbook-0"

/obj/structure/bookcase/legal/sop/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/legal/sop_vol1
	new /obj/item/book/manual/legal/sop_vol2
	new /obj/item/book/manual/legal/sop_vol3
	new /obj/item/book/manual/legal/sop_vol4
	new /obj/item/book/manual/legal/sop_vol5_1
	new /obj/item/book/manual/legal/sop_vol5_2
	new /obj/item/book/manual/legal/sop_vol5_3
	new /obj/item/book/manual/legal/sop_vol5_4
	new /obj/item/book/manual/legal/sop_vol5_5
	new /obj/item/book/manual/legal/sop_vol5_6
	new /obj/item/book/manual/legal/sop_vol5_7
	update_appearance()

/obj/structure/bookcase/legal/corpreg
	name = "Corporate Regulations bookcase"
	icon_state = "legalbook-0"

/obj/structure/bookcase/legal/corpreg/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/legal/cr_vol1
	new /obj/item/book/manual/legal/cr_vol2
	new /obj/item/book/manual/legal/cr_vol3
	new /obj/item/book/manual/legal/cr_vol4
	new /obj/item/book/manual/legal/cr_vol5
	update_appearance()

/obj/structure/bookcase/legal/combo
	name = "Policy Reference bookcase"
	icon_state = "legalbook-0"

/obj/structure/bookcase/legal/combo/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/legal/sop_vol1
	new /obj/item/book/manual/legal/sop_vol2
	new /obj/item/book/manual/legal/sop_vol3
	new /obj/item/book/manual/legal/sop_vol4
	new /obj/item/book/manual/legal/sop_vol5_1
	new /obj/item/book/manual/legal/sop_vol5_2
	new /obj/item/book/manual/legal/sop_vol5_3
	new /obj/item/book/manual/legal/sop_vol5_4
	new /obj/item/book/manual/legal/sop_vol5_5
	new /obj/item/book/manual/legal/sop_vol5_6
	new /obj/item/book/manual/legal/sop_vol5_7
	new /obj/item/book/manual/legal/cr_vol1
	new /obj/item/book/manual/legal/cr_vol2
	new /obj/item/book/manual/legal/cr_vol3
	new /obj/item/book/manual/legal/cr_vol4
	new /obj/item/book/manual/legal/cr_vol5
	update_appearance()

/obj/structure/bookcase/lore
	name = "reviewed Books bookcase"

/obj/structure/bookcase/lore/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	var/list/obj/item/book/lore/types = subtypesof(/obj/item/book/lore)
	for(var/i = 5; i>= 0; i--)
		var/t_picked = pick(types)
		new t_picked(src)
		LAZYREMOVE(types, t_picked)
		if(length(types) <= 0)
			break
	update_appearance()

#undef BOOKCASE_UNANCHORED
#undef BOOKCASE_ANCHORED
#undef BOOKCASE_FINISHED
