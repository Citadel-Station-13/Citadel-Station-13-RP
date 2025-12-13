//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

#warn qdel_stress_tester is compiled in. Please don't do this on live.

GLOBAL_REAL_VAR(__qdel_stress_tester) = new /datum/__qdel_stress_tester

/datum/__qdel_stress_tester
/datum/__qdel_stress_tester/New()
	spawn(0)
		call(src, PROC_REF(loop))()
/datum/__qdel_stress_tester/proc/loop()
	UNTIL(SSgarbage.initialized && SSatoms.initialized)
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
	var/list/min_post_destroy_refcounts = list()
	var/list/min_pre_destroy_refcounts = list()
	var/list/max_post_destroy_refcounts = list()
	var/list/max_pre_destroy_refcounts = list()

	while(TRUE)
		var/path = pick(allowed_types)
		sleep(world.tick_lag)
		var/entity = new path

		var/before_refcount = refcount(entity)
		min_pre_destroy_refcounts[path] = isnull(min_pre_destroy_refcounts[path]) ? before_refcount : \
			min(min_pre_destroy_refcounts[path], before_refcount)
		max_pre_destroy_refcounts[path] = isnull(max_pre_destroy_refcounts[path]) ? before_refcount : \
			max(max_pre_destroy_refcounts[path], before_refcount)

		qdel(entity)

		var/after_refcount = refcount(entity)
		min_post_destroy_refcounts[path] = isnull(min_post_destroy_refcounts[path]) ? after_refcount : \
			min(min_post_destroy_refcounts[path], after_refcount)
		max_post_destroy_refcounts[path] = isnull(max_post_destroy_refcounts[path]) ? after_refcount : \
			max(max_post_destroy_refcounts[path], after_refcount)

		// attach debugger here
		pass()
