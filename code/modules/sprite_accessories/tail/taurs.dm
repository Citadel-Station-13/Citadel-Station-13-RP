/datum/sprite_accessory/tail/taur
	abstract_type = /datum/sprite_accessory/tail/taur
	name = "You should not see this..."
	icon = 'icons/mob/sprite_accessories/taurs.dmi'
	do_colouration = 1 // Yes color, using tail color
	color_blend_mode = ICON_MULTIPLY  // The sprites for taurs are designed for ICON_MULTIPLY

	var/icon/suit_sprites = null //File for suit sprites, if any.

	var/can_ride = 1			//whether we're real rideable taur or just in that category

	//Could do nested lists but it started becoming a nightmare. It'd be more fun for lookups of a_intent and m_intent, but then subtypes need to
	//duplicate all the messages, and it starts getting awkward. These are singletons, anyway!

	//Messages to owner when stepping on/over
	var/msg_owner_help_walk		= "You carefully step over %prey."
	var/msg_owner_help_run		= "You carefully step over %prey."
	var/msg_owner_harm_walk		= "You methodically place your foot down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	var/msg_owner_harm_run		= "You carelessly step down onto %prey, crushing them!"
	var/msg_owner_disarm_walk	= "You firmly push your foot down on %prey, painfully but harmlessly pinning them to the ground!"
	var/msg_owner_disarm_run	= "You quickly push %prey to the ground with your foot!"
	var/msg_owner_grab_fail		= "You step down onto %prey, squishing them and forcing them down to the ground!"
	var/msg_owner_grab_success	= "You pin %prey down onto the floor with your foot and curl your toes up around their body, trapping them inbetween them!"

	//Messages to prey when stepping on/over
	var/msg_prey_help_walk		= "%owner steps over you carefully!"
	var/msg_prey_help_run		= "%owner steps over you carefully!"
	var/msg_prey_harm_walk		= "%owner methodically places their foot upon your body, slowly applying pressure, crushing you against the floor below!"
	var/msg_prey_harm_run		= "%owner steps carelessly on your body, crushing you!"
	var/msg_prey_disarm_walk	= "%owner firmly pushes their foot down on you, quite painfully but harmlessly pinning you to the ground!"
	var/msg_prey_disarm_run		= "%owner pushes you down to the ground with their foot!"
	var/msg_prey_grab_fail		= "%owner steps down and squishes you with their foot, forcing you down to the ground!"
	var/msg_prey_grab_success	= "%owner pins you down to the floor with their foot and curls their toes up around your body, trapping you inbetween them!"

	//Messages for smalls moving under larges
	var/msg_owner_stepunder		= "%owner runs between your legs." //Weird becuase in the case this is used, %owner is the 'bumper' (src)
	var/msg_prey_stepunder		= "You run between %prey's legs." //Same, inverse
	hide_body_parts	= list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT) //Exclude pelvis just in case.
	clip_mask_icon = 'icons/mob/sprite_accessories/taurs.dmi'
	clip_mask_state = "taur_clip_mask_def" //Used to clip off the lower part of suits & uniforms

// Species-unique long tails/taurhalves

/datum/sprite_accessory/tail/taur/shadekin_tail
	name = "Shadekin Tail"
	id = "tail_taur_shadekin"
	icon_state = "shadekin_s"
	can_ride = 0
	hide_body_parts = null
	clip_mask_icon = null
	clip_mask_state = null
	apply_restrictions = TRUE
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

/datum/sprite_accessory/tail/taur/shadekin_tail/shadekin_tail_2c
	name = "Shadekin Tail dual-color"
	id = "tail_taur_shadekin_colorable"
	extra_overlay = "shadekin_markings"

/datum/sprite_accessory/tail/taur/shadekin_tail/shadekin_tail_long
	name = "Shadekin Long Tail"
	id = "tail_taur_shadekin_long"
	icon_state = "shadekin_long_s"

/datum/sprite_accessory/tail/taur/shadekin_tail/shadekin_tail_long_2
	name = "Shadekin Striped Long Tail"
	id = "tail_taur_shadekin_long_stripes"
	icon_state = "shadekin_long_2"
	extra_overlay = "shadekin_long_marking_2"

/datum/sprite_accessory/tail/taur/shadekin_tail/shadekin_tail_small
	name = "Shadekin Small Tail"
	id = "tail_taur_shadekin_small"
	icon_state = "shadekin_s2"

// Tails/taurhalves for everyone

/datum/sprite_accessory/tail/taur/wolf
	name = "Wolf (Taur)"
	id = "tail_taur_wolf"
	icon_state = "wolf_s"
	suit_sprites = 'icons/mob/clothing/taursuits_wolf.dmi'

//TFF 22/11/19 - CHOMPStation port of fat taur sprites
/datum/sprite_accessory/tail/taur/fatwolf
	name = "Fat Wolf (Taur)"
	id = "tail_taur_wolf_fat"
	icon_state = "fatwolf_s"

/datum/sprite_accessory/tail/taur/wolf/wolf_2c
	name = "Wolf dual-color (Taur)"
	id = "tail_taur_wolf_colorable"
	icon_state = "wolf_s"
	extra_overlay = "wolf_markings"

//TFF 22/11/19 - CHOMPStation port of fat taur sprites
/datum/sprite_accessory/tail/taur/wolf/fatwolf_2c
	name = "Fat Wolf dual-color (Taur)"
	id = "tail_taur_wolf_fat_colorable"
	icon_state = "fatwolf_s"
	extra_overlay = "fatwolf_markings"

/datum/sprite_accessory/tail/taur/wolf/synthwolf
	name = "SynthWolf dual-color (Taur)"
	id = "tail_taur_wolf_synth_colorable"
	icon_state = "synthwolf_s"
	extra_overlay = "synthwolf_markings"

/datum/sprite_accessory/tail/taur/naga
	name = "Naga (Taur)"
	id = "tail_taur_naga"
	icon_state = "naga_s"
	suit_sprites = 'icons/mob/clothing/taursuits_naga.dmi'

	msg_owner_help_walk = "You carefully slither around %prey."
	msg_prey_help_walk = "%owner's huge tail slithers past beside you!"

	msg_owner_help_run = "You carefully slither around %prey."
	msg_prey_help_run = "%owner's huge tail slithers past beside you!"

	msg_owner_disarm_run = "Your tail slides over %prey, pushing them down to the ground!"
	msg_prey_disarm_run = "%owner's tail slides over you, forcing you down to the ground!"

	msg_owner_disarm_walk = "You push down on %prey with your tail, pinning them down under you!"
	msg_prey_disarm_walk = "%owner pushes down on you with their tail, pinning you down below them!"

	msg_owner_harm_run = "Your heavy tail carelessly slides past %prey, crushing them!"
	msg_prey_harm_run = "%owner quickly goes over your body, carelessly crushing you with their heavy tail!"

	msg_owner_harm_walk = "Your heavy tail slowly and methodically slides down upon %prey, crushing against the floor below!"
	msg_prey_harm_walk = "%owner's thick, heavy tail slowly and methodically slides down upon your body, mercilessly crushing you into the floor below!"

	msg_owner_grab_success = "You slither over %prey with your large, thick tail, smushing them against the ground before coiling up around them, trapping them within the tight confines of your tail!"
	msg_prey_grab_success = "%owner slithers over you with their large, thick tail, smushing you against the ground before coiling up around you, trapping you within the tight confines of their tail!"

	msg_owner_grab_fail = "You squish %prey under your large, thick tail, forcing them onto the ground!"
	msg_prey_grab_fail = "%owner pins you under their large, thick tail, forcing you onto the ground!"

	msg_prey_stepunder = "You jump over %prey's thick tail."
	msg_owner_stepunder = "%owner bounds over your tail."

/datum/sprite_accessory/tail/taur/naga/naga_2c
	name = "Naga dual-color (Taur)"
	id = "tail_taur_naga_colorable"
	icon_state = "naga_s"
	extra_overlay = "naga_markings"
	
/datum/sprite_accessory/tail/taur/naga/naga_2c_alt
	name = "Naga dual-color alt (Taur)"
	id = "tail_taur_naga_colorable_alt"
	icon_state = "altnaga_s"
	extra_overlay = "altnaga_markings"

/datum/sprite_accessory/tail/taur/horse
	name = "Horse (Taur)"
	id = "tail_taur_horse"
	icon_state = "horse_s"
	suit_sprites = 'icons/mob/clothing/taursuits_horse.dmi'

	msg_owner_disarm_run = "You quickly push %prey to the ground with your hoof!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their hoof!"

	msg_owner_disarm_walk = "You firmly push your hoof down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their hoof down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your hoof down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their hoof upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey to the ground before scooping them up with your hooves!"
	msg_prey_grab_success = "%owner pins you to the ground before scooping you up with their hooves!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their hoof, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/horse/synthhorse
	name = "SynthHorse dual-color (Taur)"
	id = "tail_taur_horse_synth_colorable"
	icon_state = "synthhorse_s"
	extra_overlay = "synthhorse_markings"

/datum/sprite_accessory/tail/taur/cow
	name = "Cow (Taur)"
	id = "tail_taur_cow"
	icon_state = "cow_s"
	suit_sprites = 'icons/mob/clothing/taursuits_cow.dmi'

	msg_owner_disarm_run = "You quickly push %prey to the ground with your hoof!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their hoof!"

	msg_owner_disarm_walk = "You firmly push your hoof down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their hoof down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your hoof down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their hoof upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey to the ground before scooping them up with your hooves!"
	msg_prey_grab_success = "%owner pins you to the ground before scooping you up with their hooves!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their hoof, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/deer
	name = "Deer dual-color (Taur)"
	id = "tail_taur_deer_colorable"
	icon_state = "deer_s"
	extra_overlay = "deer_markings"
	suit_sprites = 'icons/mob/clothing/taursuits_deer.dmi'

	msg_owner_disarm_run = "You quickly push %prey to the ground with your hoof!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their hoof!"

	msg_owner_disarm_walk = "You firmly push your hoof down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their hoof down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your hoof down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their hoof upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey to the ground before scooping them up with your hooves!"
	msg_prey_grab_success = "%owner pins you to the ground before scooping you up with their hooves!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their hoof, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/lizard
	name = "Lizard (Taur)"
	id = "tail_taur_lizard"
	icon_state = "lizard_s"
	suit_sprites = 'icons/mob/clothing/taursuits_lizard.dmi'

/datum/sprite_accessory/tail/taur/lizard/lizard_2c
	name = "Lizard dual-color (Taur)"
	id = "tail_taur_lizard_colorable"
	icon_state = "lizard_s"
	extra_overlay = "lizard_markings"

/datum/sprite_accessory/tail/taur/lizard/synthlizard
	name = "SynthLizard dual-color (Taur)"
	id = "tail_taur_lizard_synth"
	icon_state = "synthlizard_s"
	extra_overlay = "synthlizard_markings"

/datum/sprite_accessory/tail/taur/spider
	name = "Spider (Taur)"
	id = "tail_taur_spider"
	icon_state = "spider_s"
	suit_sprites = 'icons/mob/clothing/taursuits_spider.dmi'

	msg_owner_disarm_run = "You quickly push %prey to the ground with your leg!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their leg!"

	msg_owner_disarm_walk = "You firmly push your leg down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their leg down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your leg down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their leg upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey down on the ground with your front leg before using your other leg to pick them up, trapping them between two of your front legs!"
	msg_prey_grab_success = "%owner pins you down on the ground with their front leg before using their other leg to pick you up, trapping you between two of their front legs!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their leg, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/tents
	name = "Tentacles (Taur)"
	id = "tail_taur_tentacles"
	icon_state = "tent_s"
	can_ride = 0

	msg_prey_stepunder = "You run between %prey's tentacles."
	msg_owner_stepunder = "%owner runs between your tentacles."

	msg_owner_disarm_run = "You quickly push %prey to the ground with some of your tentacles!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with some of their tentacles!"

	msg_owner_disarm_walk = "You push down on %prey with some of your tentacles, pinning them down firmly under you!"
	msg_prey_disarm_walk = "%owner pushes down on you with some of their tentacles, pinning you down firmly below them!"

	msg_owner_harm_run = "Your tentacles carelessly slide past %prey, crushing them!"
	msg_prey_harm_run = "%owner quickly goes over your body, carelessly crushing you with their tentacles!"

	msg_owner_harm_walk = "Your tentacles methodically apply pressure on %prey's body, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner's thick tentacles methodically apply pressure on your body, crushing you into the floor below!"

	msg_owner_grab_success = "You slide over %prey with your tentacles, smushing them against the ground before wrapping one up around them, trapping them within the tight confines of your tentacles!"
	msg_prey_grab_success = "%owner slides over you with their tentacles, smushing you against the ground before wrapping one up around you, trapping you within the tight confines of their tentacles!"

	msg_owner_grab_fail = "You step down onto %prey with one of your tentacles, forcing them onto the ground!"
	msg_prey_grab_fail = "%owner steps down onto you with one of their tentacles, squishing you and forcing you onto the ground!"

/datum/sprite_accessory/tail/taur/feline
	name = "Feline (Taur)"
	id = "tail_taur_feline"
	icon_state = "feline_s"
	suit_sprites = 'icons/mob/clothing/taursuits_feline.dmi'

/datum/sprite_accessory/tail/taur/fatfeline
	name = "Fat Feline (Taur)"
	id = "tail_taur_feline_fat"
	icon_state = "fatfeline_s"

/datum/sprite_accessory/tail/taur/fatfeline_wag
	name = "Fat Feline (Taur) (vwag)"
	id = "tail_taur_feline_fat_waggable"
	icon_state = "fatfeline_s"
	ani_state = "fatfeline_w"

/datum/sprite_accessory/tail/taur/feline/feline_2c
	name = "Feline dual-color (Taur)"
	id = "tail_taur_feline_colorable"
	icon_state = "feline_s"
	extra_overlay = "feline_markings"

/datum/sprite_accessory/tail/taur/feline/fatfeline_2c
	name = "Fat Feline dual-color (Taur)"
	id = "tail_taur_feline_fat_colorable"
	icon_state = "fatfeline_s"
	extra_overlay = "fatfeline_markings"

/datum/sprite_accessory/tail/taur/feline/synthfeline
	name = "SynthFeline dual-color (Taur)"
	id = "tail_taur_feline_synth_colorable"
	icon_state = "synthfeline_s"
	extra_overlay = "synthfeline_markings"

/datum/sprite_accessory/tail/taur/slug
	name = "Slug (Taur)"
	id = "tail_taur_slug"
	icon_state = "slug_s"
	suit_sprites = 'icons/mob/clothing/taursuits_slug.dmi'

	msg_owner_help_walk = "You carefully slither around %prey."
	msg_prey_help_walk = "%owner's huge tail slithers past beside you!"

	msg_owner_help_run = "You carefully slither around %prey."
	msg_prey_help_run = "%owner's huge tail slithers past beside you!"

	msg_owner_disarm_run = "Your tail slides over %prey, pushing them down to the ground!"
	msg_prey_disarm_run = "%owner's tail slides over you, forcing you down to the ground!"

	msg_owner_disarm_walk = "You push down on %prey with your tail, pinning them down under you!"
	msg_prey_disarm_walk = "%owner pushes down on you with their tail, pinning you down below them!"

	msg_owner_harm_run = "Your heavy tail carelessly slides past %prey, crushing them!"
	msg_prey_harm_run = "%owner quickly goes over your body, carelessly crushing you with their heavy tail!"

	msg_owner_harm_walk = "Your heavy tail slowly and methodically slides down upon %prey, crushing against the floor below!"
	msg_prey_harm_walk = "%owner's thick, heavy tail slowly and methodically slides down upon your body, mercilessly crushing you into the floor below!"

	msg_owner_grab_success = "You slither over %prey with your large, thick tail, smushing them against the ground before coiling up around them, trapping them within the tight confines of your tail!"
	msg_prey_grab_success = "%owner slithers over you with their large, thick tail, smushing you against the ground before coiling up around you, trapping you within the tight confines of their tail!"

	msg_owner_grab_fail = "You squish %prey under your large, thick tail, forcing them onto the ground!"
	msg_prey_grab_fail = "%owner pins you under their large, thick tail, forcing you onto the ground!"

	msg_prey_stepunder = "You jump over %prey's thick tail."
	msg_owner_stepunder = "%owner bounds over your tail."

/datum/sprite_accessory/tail/taur/frog
	name = "Frog (Taur)"
	id = "tail_taur_frog"
	icon_state = "frog_s"

/datum/sprite_accessory/tail/taur/drake //Enabling on request, no suit compatibility but then again see 2 above.
	name = "Drake (Taur)"
	id = "tail_taur_drake"
	icon_state = "drake_s"
	extra_overlay = "drake_markings"
	suit_sprites = 'icons/mob/clothing/taursuits_drake.dmi'

/datum/sprite_accessory/tail/taur/otie
	name = "Otie (Taur)"
	id = "tail_taur_otie"
	icon_state = "otie_s"
	extra_overlay = "otie_markings"
	suit_sprites = 'icons/mob/clothing/taursuits_otie.dmi'

/datum/sprite_accessory/tail/taur/wasp
	name = "Wasp (dual color)"
	id = "tail_taur_wasp"
	icon_state = "wasp_s"
	extra_overlay = "wasp_markings"
	clip_mask_state = "taur_clip_mask_wasp"

	msg_owner_disarm_run = "You quickly push %prey to the ground with your leg!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their leg!"

	msg_owner_disarm_walk = "You firmly push your leg down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their leg down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your leg down upon %prey's body, slowly applying pressure, crushing them against the floor!"
	msg_prey_harm_walk = "%owner methodically places their leg upon your body, slowly applying pressure, crushing you against the floor!"

	msg_owner_grab_success = "You pin %prey down on the ground with your front leg before using your other leg to pick them up, trapping them between two of your front legs!"
	msg_prey_grab_success = "%owner pins you down on the ground with their front leg before using their other leg to pick you up, trapping you between two of their front legs!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their leg, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/mantis
	name = "Mantis (Taur)"
	id = "tail_taur_mantis"
	icon_state = "mantis_s"
	clip_mask_state = "taur_clip_mask_mantis"

	msg_owner_disarm_run = "You quickly push %prey to the ground with your leg!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their leg!"

	msg_owner_disarm_walk = "You firmly push your leg down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their leg down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your leg down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their leg upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey down on the ground with your front leg before using your other leg to pick them up, trapping them between two of your front legs!"
	msg_prey_grab_success = "%owner pins you down on the ground with their front leg before using their other leg to pick you up, trapping you between two of their front legs!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their leg, forcing you down to the ground!"

// Special snowflake tails/taurhalves

// todo: remove
/datum/sprite_accessory/tail/taur/alraune
	abstract_type = /datum/sprite_accessory/tail/taur/alraune
	name = "Alraune (natje) (Taur)"
	icon_state = "alraune_s"
	ani_state = "alraune_closed_s"
	ckeys_allowed = list("natje")
	do_colouration = 0
	can_ride = 0
	clip_mask_state = "taur_clip_mask_alraune"


	msg_prey_stepunder = "You run between %prey's vines."
	msg_owner_stepunder = "%owner runs between your vines."

	msg_owner_disarm_run = "You quickly push %prey to the ground with some of your vines!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with some of their vines!"

	msg_owner_disarm_walk = "You push down on %prey with some of your vines, pinning them down firmly under you!"
	msg_prey_disarm_walk = "%owner pushes down on you with some of their vines, pinning you down firmly below them!"

	msg_owner_harm_run = "Your vines carelessly slide past %prey, crushing them!"
	msg_prey_harm_run = "%owner quickly goes over your body, carelessly crushing you with their vines!"

	msg_owner_harm_walk = "Your vines methodically apply pressure on %prey's body, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner's thick vines methodically apply pressure on your body, crushing you into the floor below!"

	msg_owner_grab_success = "You slide over %prey with your vines, smushing them against the ground before wrapping one up around them, trapping them within the tight confines of your vines!"
	msg_prey_grab_success = "%owner slides over you with their vines, smushing you against the ground before wrapping one up around you, trapping you within the tight confines of their vines!"

	msg_owner_grab_fail = "You step down onto %prey with one of your vines, forcing them onto the ground!"
	msg_prey_grab_fail = "%owner steps down onto you with one of their vines, squishing you and forcing you onto the ground!"

/datum/sprite_accessory/tail/taur/alraune/alraune_2c
	name = "Alraune (dual color)"
	id = "tail_taur_alraune_colorable"
	icon_state = "alraunecolor_s"
	ani_state = "alraunecolor_closed_s"
	ckeys_allowed = null
	do_colouration = 1
	extra_overlay = "alraunecolor_markings"
	extra_overlay_w = "alraunecolor_closed_markings"
	clip_mask_state = "taur_clip_mask_alraune"

/datum/sprite_accessory/tail/taur/long_lizard
	name = "Large Dragon Tail"
	id = "tail_taur_dragon_large"
	icon_state = "big_liz"
	can_ride = 0
	hide_body_parts = null
	clip_mask_icon = null
	clip_mask_state = null

/datum/sprite_accessory/tail/taur/long_lizard/scaled
	name = "Large Dragon Tail/W scales"
	id = "tail_taur_dragon_large_scales"
	extra_overlay = "big_liz_mark"
