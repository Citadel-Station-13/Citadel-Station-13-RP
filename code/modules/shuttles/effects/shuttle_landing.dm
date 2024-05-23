// todo: refactor this a bit; is it possible to have this be more managed?
/obj/effect/temporary_effect/shuttle_landing
	name = "shuttle landing"
	desc = "You better move if you don't want to go splat!"
	icon_state = "shuttle_warning_still"
	time_to_die = 4.9 SECONDS

/obj/effect/temporary_effect/shuttle_landing/Initialize(mapload)
	flick("shuttle_warning", src) // flick() forces the animation to always begin at the start.
	. = ..()
