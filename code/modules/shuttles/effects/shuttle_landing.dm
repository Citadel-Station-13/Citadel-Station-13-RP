// todo: refactor this a bit; is it possible to have this be more managed?
/obj/effect/temporary_effect/shuttle_landing
	name = "shuttle landing"
	desc = "A massive entity is about to land here. You should not be here."
	icon_state = "shuttle_warning_still"
	time_to_die = 4.9 SECONDS

/obj/effect/temporary_effect/shuttle_landing/Initialize(mapload, time_to_dock)
	// todo: instead of flicking we can just animate
	flick("shuttle_warning", src)
	if(!isnull(time_to_dock))
		time_to_die = time_to_dock
	. = ..()
