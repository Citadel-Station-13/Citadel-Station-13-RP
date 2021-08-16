/**
 * Infinite sources
 */
/obj/effect/fluid_source
	name = "fluid source"
	desc = "Why are you seeing this?"
	invisibility = INVISIBILITY_MAXIMUM

	/// Amount to spawn every cycle
	var/amount = 100
	/// Maximum to flood to
	var/maximum = FLUID_DEEP
	/// Reagent to spawn
	var/reagent = /datum/reagent/water

/obj/effect/fluid_source/examine(mob/user)
	. = ..()
	. += "It is spawning [amount] of [reagent] per process, up to a maximum on-turf of [maximum]."

/obj/effect/fluid_source/proc/flood(current_cycle)
	var/datum/reagents/R = GetFluid()
	var/curr = 0
	if(R)
		curr = R.total_volume
	AddFluid(reagent, clamp(amount, 0, maximum - curr))
