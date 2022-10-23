// Inherits from /book/ so it can fit on bookshelves.
/obj/item/book/codex
	name = "The Traveler's Guide to Human Space: Virgo-Erigone Edition"
	desc = "Contains useful information about the world around you.  It seems to have been written for travelers to Virgo-Erigone, human or not. It also \
	has the words 'Don't Panic' in small, friendly letters on the cover."
	icon_state = "codex"
	unique = TRUE
	var/datum/codex_tree/tree = null
	var/root_type = /datum/lore/codex/category/main_virgo_lore	//Runtimes on codex_tree.dm, line 18 with a null here

/obj/item/book/codex/Initialize(mapload)
	tree = new(src, root_type)
	. = ..()

/obj/item/book/codex/attack_self(mob/user)
	if(!tree)
		tree = new(src, root_type)
	icon_state = "[initial(icon_state)]-open"
	tree.display(user)

/obj/item/book/codex/lore/vir
	name = "The Traveler's Guide to Human Space: Virgo-Erigone Edition"
	desc = "Contains useful information about the world around you.  It seems to have been written for travelers to Virgo-Erigone, human or not. It also \
	has the words 'Don't Panic' in small, friendly letters on the cover."
	icon_state = "codex"
	root_type = /datum/lore/codex/category/main_virgo_lore
	libcategory = "Reference"

/obj/item/book/codex/lore/robutt
	name = "A Buyer's Guide to Artificial Bodies"
	desc = "Recommended reading for the newly cyborgified, new positronics, and the upwardly-mobile FBP."
	icon_state = "codex_robutt"
	root_type = /datum/lore/codex/category/main_robutts
	libcategory = "Reference"

/obj/item/book/codex/lore/news
	name = "Daedalus Pocket Newscaster"
	desc = "A occasionally-updated compendium of articles on current events. Useful for keeping on the news in the vastness of the the Sigmar Concord."
	icon_state = "newscodex"
	w_class = ITEMSIZE_SMALL
	root_type = /datum/lore/codex/category/main_news
	libcategory = "Reference"
