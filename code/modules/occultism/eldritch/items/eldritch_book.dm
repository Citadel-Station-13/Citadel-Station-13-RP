//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * research book for heretics
 * * Unlike /tg/'s, these are stateful.
 * * Losing this is a net loss of research speed, effectively.
 * * This can be shared between heretics.
 */
/obj/item/eldritch_book
	name = "Codex Cicatrix"
	#warn desc
	#warn icon

	/// knowledge IDs inscribed
	/// * lazy list
	var/list/knowledge_known_ids

#warn impl maybe?

/obj/item/eldritch_book/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/item/eldritch_book/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/item/eldritch_book/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/item/eldritch_book/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	. = ..()
	// TODO: use this instead of static data to send info on code.
