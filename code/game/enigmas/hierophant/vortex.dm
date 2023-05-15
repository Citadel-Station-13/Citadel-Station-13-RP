/**
 * holder for hierophant abilities
 */
/datum/vortex_magic
	/// created walls
	var/list/obj/effect/vortex/wall/walls = list()
	/// active blasts
	var/list/obj/effect/vortex/blast/blasts = list()

/datum/vortex_magic/Destroy()
	cancel_everything()
	return ..()

/datum/vortex_magic/proc/cancel_everything(fadeout = FALSE)

/datum/vortex_magic/proc/cardinal_blast(atom/target, dist = 7, damage = 10)

/datum/vortex_magic/proc/diagonal_blast(atom/target, dist = 7, damage = 10)

/datum/vortex_magic/proc/alldir_blast(atom/target, dist = 7, damage = 10)

/datum/vortex_magic/proc/tracer(turf/starting, atom/movable/target, lifetime = 10 SECONDS, speed = 2, damage = 10)

/datum/vortex_magic/proc/square_blast(turf/center, safe_radius = 0, outer_radius = 2, delay = 0, damage = 10)

/datum/vortex_magic/proc/box_arena(turf/center, radius = 14, decay_after)

/datum/vortex_magic/proc/teleport(turf/where, damage = 30)

#warn impl all
