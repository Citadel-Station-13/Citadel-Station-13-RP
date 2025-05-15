//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* FX *//

/mob/living/get_combat_fx_classifier(attack_type, datum/attack_source, target_zone)
	return COMBAT_IMPACT_FX_METAL

//* Misc Effects *//

/mob/living/silicon/inflict_electrocute_damage(damage, agony, flags, hit_zone)
	take_overall_damage(0, damage, null, "electrical overload")

/mob/living/silicon/on_electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard)
	. = ..()

	if(damage > 0)
		var/datum/effect_system/spark_spread/spark_emitter = new /datum/effect_system/spark_spread
		spark_emitter.set_up(5, 1, loc)
		spark_emitter.start()
		visible_message(
			SPAN_WARNING("[src] emits a burst of sparks[source ? " as they make contact with [source]" : ""]!"),
			SPAN_DANGER("Energy pulse detected[source ? " from [source]" : ""]!"),
			SPAN_WARNING("You hear an electrical crack."),
		)
