//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

#warn qdel_stress_tester is compiled in. Please don't do this on live.

GLOBAL_REAL_VAR(__qdel_stress_tester) = new /datum/__qdel_stress_tester

/datum/__qdel_stress_tester
/datum/__qdel_stress_tester/New()
	spawn(0)
		call(src, PROC_REF(loop))()
/datum/__qdel_stress_tester/proc/loop()
	UNTIL(SSgarbage.initialized)
	var/static/list/allowed_types = list(
		/obj/item,
		/obj/item/aicard,
		/obj/item/gun,
		/obj/item/gun/projectile,
		/obj/item/gun/projectile/magic,
		/obj/item/gun/projectile/magnetic,
		/obj/item/gun/projectile/ballistic,
		/obj/item/gun/projectile/energy,
		/mob/living/simple_mob,
		/mob/living/carbon,
		/mob/living/carbon/human,
		/obj/vehicle/sealed/mecha/combat/fighter/allure,
		/obj/vehicle/sealed/mecha/combat/durand,
		/obj/structure/anomaly_container,
		/obj/structure/aquarium,
		/obj/structure/table/bananium,
		/obj/machinery/ai_slipper,
		/obj/machinery/reagentgrinder,
		/obj/machinery/recharge_station,
	)
	while(TRUE)
		var/path = pick(allowed_types)
		sleep(world.tick_lag)
		var/entity = new path
		var/before_refcount = refcount(entity)
		qdel(entity)
		var/after_refcount = refcount(entity)

		// attach debugger here
		pass()
