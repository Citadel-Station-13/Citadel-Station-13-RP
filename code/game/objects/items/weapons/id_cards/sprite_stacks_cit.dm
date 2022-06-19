// This is a defines file for card sprite stacks. If a new card set comes in, this file can just be disabled and a new one made to match the new sprites.
// Generally, if the icon file is card_xxx.dmi, this filename should be sprite_stacks_xxx.dm
// Please make sure that only the relevant sprite_stacks_xxx.file is included, if more are made.



/obj/item/card
	icon = 'icons/obj/card_cit.dmi' // These are redefined here so that changing sprites is as easy as clicking the checkbox.
	base_icon = 'icons/obj/card_cit.dmi'

	// New sprite stacks can be defined here. You could theoretically change icon-states as well but right now this file compiles before station_ids.dm so those wouldn't be affected.

/obj/item/card/id/silver/secretary
	initial_sprite_stack = list("base-stamp", "top-command", "letter-n-command")

/obj/item/card/id/silver/hop
	initial_sprite_stack = list("base-stamp-silver", "top-command", "letter-n-command", "pips-gold")

/obj/item/card/id/medical/chemist
	initial_sprite_stack = list("", "pips-engineering")

/obj/item/card/id/medical/geneticist
	initial_sprite_stack = list("base-stamp", "top-medical", "letter-n-science", "pips-science")

/obj/item/card/id/medical/head
	initial_sprite_stack = list("base-stamp-silver", "top-command-medical", "letter-n-command", "pips-medical")

/obj/item/card/id/security/warden
	initial_sprite_stack = list("", "pips-gold")

/obj/item/card/id/security/head
	initial_sprite_stack = list("base-stamp-silver", "top-command-security", "letter-n-command", "pips-security")

/obj/item/card/id/engineering/atmos
	initial_sprite_stack = list("", "pips-medical")
/obj/item/card/id/engineering/head
	initial_sprite_stack = list("base-stamp-silver", "top-command-engineering", "letter-n-command", "pips-engineering")

/obj/item/card/id/science/head
	initial_sprite_stack = list("base-stamp-silver", "top-command-science", "letter-n-command", "pips-science")

/obj/item/card/id/cargo/head
	initial_sprite_stack = list("", "pips-gold")

/obj/item/card/id/civilian/chaplain
	initial_sprite_stack = list("base-stamp-silver", "top-dark", "letter-cross", "pips-mime")

/obj/item/card/id/civilian/internal_affairs_agent
	initial_sprite_stack = list("base-stamp", "top-internal-affairs", "letter-n-command")

/obj/item/card/id/civilian/clown
	initial_sprite_stack = list("base-stamp", "top-clown", "letter-n-clown")

/obj/item/card/id/civilian/mime
	initial_sprite_stack = list("base-stamp", "top-mime", "letter-n-mime")

/obj/item/card/id/civilian/head //Not used but I'm defining it anyway.
	initial_sprite_stack = list("base-stamp-silver", "top-command", "letter-n-command", "pips-civilian")

// The following are defined in southern_cross_jobs.dm for some reason. Despite being part of the main game now. Nonetheless, they stay here until folded in right.
/obj/item/card/id/medical/sar
	initial_sprite_stack = list("", "pips-science")
/obj/item/card/id/civilian/pilot
	initial_sprite_stack = list("", "pips-science")
/obj/item/card/id/science/explorer
	initial_sprite_stack = list("", "top-science-explorer")

//Ditto in southern_cross_jobs_vr.dm
/obj/item/card/id/explorer/head/pathfinder
	initial_sprite_stack = list("", "top-science-explorer", "pips-gold")
