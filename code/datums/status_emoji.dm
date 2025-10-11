//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_LIST_INIT(status_emojis, init_status_emojis())

/proc/init_status_emojis()
	. = list()
	for(var/datum/status_emoji/path as anything in subtypesof(/datum/status_emoji))
		if(path.abstract_type == path)
			continue
		. += new path
	// quack. duck typing to the rescue (and chagrin of whoever has to fix this 2 years later)
	tim_sort(., /proc/cmp_name_asc)

/**
 * A status emoji to be flicked by mobs, primarily.
 * * That said, this contains alignment data that can be used to align it to any atom, so...
 * * Icon states are assumed to be aligned to top right of the icon size. Provide alignment offsets if needed.
 */
/datum/status_emoji
	abstract_type = /datum/status_emoji
	var/name
	var/icon = 'icons/screen/status_emojis.dmi'
	var/icon_state

	var/icon_size_x = 32
	var/icon_size_y = 32

	var/shift_x = 0
	var/shift_y = 0

/datum/status_emoji/annoyed
	name = "Annoyed"
	icon_state = "annoyed"

/datum/status_emoji/berserk
	name = "Berserk"
	icon_state = "berserk"

/datum/status_emoji/confused
	name = "Confused"
	icon_state = "confused"

/datum/status_emoji/depression
	name = "Depression"
	icon_state = "depression"
	shift_y = 3

/datum/status_emoji/frustration
	name = "Frustration"
	icon_state = "frustration"

/datum/status_emoji/joyous
	name = "Joyous"
	icon_state = "joyous"

/datum/status_emoji/panic
	name = "Panic"
	icon_state = "panic"

/datum/status_emoji/tired
	name = "Tired"
	icon_state = "tired"

/datum/status_emoji/nervous
	name = "Nervous"
	icon_state = "nervous"

/datum/status_emoji/idea
	name = "Idea"
	icon_state = "idea"

/datum/status_emoji/love
	name = "Love"
	icon_state = "love"

/datum/status_emoji/menacing
	name = "Menacing"
	icon_state = "menacing"
