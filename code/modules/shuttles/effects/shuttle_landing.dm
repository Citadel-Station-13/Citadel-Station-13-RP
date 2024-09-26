//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: maybe orchestrate this with lists and timers on shuttle_transit_cycle?
/obj/effect/temporary_effect/shuttle_landing
	name = "shuttle landing"
	desc = "A massive entity is about to land here. You should not be here."
	icon = 'icons/modules/shuttles/effects/shuttle_landing.dmi'
	icon_state = "still"
	time_to_die = 4.9 SECONDS

/obj/effect/temporary_effect/shuttle_landing/Initialize(mapload, time_to_dock)
	if(!isnull(time_to_dock))
		time_to_die = time_to_dock
	run_animation()
	return ..()

/obj/effect/temporary_effect/shuttle_landing/proc/run_animation()
	var/half_time = time_to_die / 2

	var/matrix/using_matrix = matrix()
	using_matrix.Scale(0.1, 0.1)

	transform = using_matrix
	alpha = 75

	using_matrix.Scale(10, 10)
	animate(src, time = half_time, transform = using_matrix, alpha = 150)

	animate(src, time = half_time, alpha = 255)
