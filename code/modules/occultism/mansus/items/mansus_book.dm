//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * research book for heretics
 * * Unlike /tg/'s, these are stateful.
 * * Losing this is a net loss of research speed, effectively.
 * * This can be shared between heretics.
 */
/obj/item/mansus_book
	name = "Codex Cicatrix"
	#warn desc
	#warn icon

	/// knowledge IDs inscribed
	/// * lazy list
	var/list/knowledge_known_ids

#warn impl maybe?
