//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/soundbyte/talksound
	abstract_type = /datum/soundbyte/talksound
	is_sfx = TRUE

/datum/soundbyte/talksound/goon_say
	name = "Talksound - Goon Say"
	id = "talksound-goon-say"
	path = list(
		'sound/soundbytes/talksounds/goon/speak_1.ogg',
		'sound/soundbytes/talksounds/goon/speak_2.ogg',
		'sound/soundbytes/talksounds/goon/speak_3.ogg',
		'sound/soundbytes/talksounds/goon/speak_4.ogg',
	)

/datum/soundbyte/talksound/goon_ask
	name = "Talksound - Goon Ask"
	id = "talksound-goon-ask"
	path = list(
		'sound/soundbytes/talksounds/goon/speak_1_ask.ogg',
		'sound/soundbytes/talksounds/goon/speak_2_ask.ogg',
		'sound/soundbytes/talksounds/goon/speak_3_ask.ogg',
		'sound/soundbytes/talksounds/goon/speak_4_ask.ogg',
	)

/datum/soundbyte/talksound/goon_exclaim
	name = "Talksound - Goon Exclaim"
	id = "talksound-goon-exclaim"
	path = list(
		'sound/soundbytes/talksounds/goon/speak_1_exclaim.ogg',
		'sound/soundbytes/talksounds/goon/speak_2_exclaim.ogg',
		'sound/soundbytes/talksounds/goon/speak_3_exclaim.ogg',
		'sound/soundbytes/talksounds/goon/speak_4_exclaim.ogg',
	)

/datum/soundbyte/talksound/generic_emote_1
	name = "Talksound - Generic Emote 1"
	id = "talksound-generic-emote-1"
	path = list(
		'sound/soundbytes/talksounds/generic/me_a.ogg',
		'sound/soundbytes/talksounds/generic/me_b.ogg',
		'sound/soundbytes/talksounds/generic/me_c.ogg',
		'sound/soundbytes/talksounds/generic/me_d.ogg',
		'sound/soundbytes/talksounds/generic/me_e.ogg',
		'sound/soundbytes/talksounds/generic/me_f.ogg',
	)

/datum/soundbyte/talksound/generic_subtle_emote_1
	name = "Talksound - Generic Subtle Emote 1"
	id = "talksound-generic-subtle-emote-1"
	path = list(
		'sound/soundbytes/talksounds/generic/subtle_sound.ogg',
	)
