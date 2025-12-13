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
		/obj/item/gun/projectile/ballistic/nt_expedition/heavy_sidearm/smg,
		/obj/item/gun/projectile/energy,
		/obj/item/gun/projectile/energy/nt_isd/sidearm,
		/obj/item/gun/projectile/energy/nt_protolaser/carbine,
		/obj/item/ammo_casing,
		/obj/item/ammo_casing/a12_7mm,
		/obj/item/ammo_magazine/a10mm,
		/obj/item/ammo_magazine/a10mm/clip,
		/obj/projectile/beam/antigravbeamwraith,
		/obj/projectile/bullet/pellet/fragment/rubber,
		/obj/item/melee/baton/stunsword,
		/obj/item/melee/transforming/energy/sword,
		/obj/item/reagent_containers,
		/obj/item/reagent_containers/blood/ABMinus,
		/obj/item/reagent_containers/borghypo/crisis,
		/obj/item/reagent_containers/cartridge/dispenser/large,
		/obj/item/reagent_containers/dropper/ashlander,
		/obj/item/reagent_containers/food/drinks/drinkingglass/cola,
		/obj/item/reagent_containers/food/drinks/metaglass,
		/obj/item/reagent_containers/food/snacks/amanitajelly,
		/obj/item/reagent_containers/food/snacks/sliceable/bluecheesewheel,
		/obj/item/reagent_containers/glass/beaker/bluespace,
		/obj/item/reagent_containers/pill/airlock,
		/mob/living/simple_mob,
		/mob/living/simple_mob/animal,
		/mob/living/simple_mob/animal/giant_spider,
		/mob/living/simple_mob/animal/giant_spider/nurse,
		/mob,
		/mob/observer,
		/mob/observer/dead,
		/mob/living,
		/mob/living/carbon,
		/mob/living/carbon/human,
		/mob/living/carbon/human/dummy,
		/mob/living/carbon/human/dummy/mannequin,
		/obj/vehicle/sealed/mecha/combat/fighter/allure,
		/obj/vehicle/sealed/mecha/combat/durand,
		/obj/vehicle/sealed/mecha/combat/phazon,
		/obj/vehicle/sealed,
		/obj/vehicle,
		/obj/structure/anomaly_container,
		/obj/structure/aquarium,
		/obj/structure/table/bananium,
		/obj/machinery/ai_slipper,
		/obj/machinery/reagentgrinder,
		/obj/machinery/recharge_station,
		/obj/machinery/sleeper,
		/obj/machinery/sleep_console,
		/obj/item/integrated_circuit/arithmetic/absolute,
		/obj/item/integrated_circuit/built_in/self_sensor,
		/obj/item/integrated_electronics/analyzer,
		/obj/item/integrated_circuit_printer/upgraded,
		/obj/item/integrated_circuit/output/access_displayer,
		/obj/item/electronic_assembly/clothing/large,
		/obj/item/integrated_circuit/built_in/action_button,
		/obj/item/clothing/ears/circuitry,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/suit/storage/bladerunner,
		/obj/item/clothing/suit/armor/pcarrier/ballistic,
		/obj/effect/temp_visual/explosion/fast,
		/obj/effect/temporary_effect/cleave_attack,
		/obj/effect/plant,
		/obj/effect/floormimic,
		/obj/effect/forcefield/cult,
	)
	var/list/min_post_destroy_refcounts = list()
	var/list/min_pre_destroy_refcounts = list()
	var/list/min_delayed_refcounts = list()
	var/list/max_post_destroy_refcounts = list()
	var/list/max_pre_destroy_refcounts = list()
	var/list/max_delayed_refcounts = list()

	var/list/weakrefs = list()

	var/create_path_index = 0

	while(TRUE)
		sleep(world.tick_lag)
		// create / destroy something
		do
			create_path_index++
			if(create_path_index > length(allowed_types))
				create_path_index = 1
			var/path = allowed_types[create_path_index]
			var/datum/entity = new path
			var/list/weakref_pack = new /list(5)
			weakref_pack[1] = WEAKREF(entity)
			weakref_pack[2] = world.time
			weakref_pack[3] = path

			var/before_refcount = refcount(entity)
			qdel(entity)
			var/after_refcount = refcount(entity)
			weakref_pack[4] = before_refcount
			weakref_pack[5] = after_refcount
			weakrefs[++weakrefs.len] = weakref_pack
		while(FALSE)

		// sweep weakrefs
		do
			var/i = 1
			var/const/delay = 2 MINUTES
			while(i <= length(weakrefs))
				var/list/pack = weakrefs[i]
				if(pack[2] > world.time - delay)
					break
				++i
				var/datum/weakref/weak = pack[1]
				var/datum/maybe_resolved = weak.hard_resolve()
				if(!maybe_resolved)
					// did we win or did SSgarbage harddel it? who knows..
					continue
				// should only be one in here and in SSgarbage, ideally
				var/delayed_refcount = refcount(maybe_resolved)
				var/path = pack[3]
				var/before_refcount = pack[4]
				var/after_refcount = pack[5]
				// one for this proc one for ssgarbage queue
				if(delayed_refcount > 2)
					min_pre_destroy_refcounts[path] = isnull(min_pre_destroy_refcounts[path]) ? before_refcount : \
						min(min_pre_destroy_refcounts[path], before_refcount)
					max_pre_destroy_refcounts[path] = isnull(max_pre_destroy_refcounts[path]) ? before_refcount : \
						max(max_pre_destroy_refcounts[path], before_refcount)
					min_post_destroy_refcounts[path] = isnull(min_post_destroy_refcounts[path]) ? after_refcount : \
						min(min_post_destroy_refcounts[path], after_refcount)
					max_post_destroy_refcounts[path] = isnull(max_post_destroy_refcounts[path]) ? after_refcount : \
						max(max_post_destroy_refcounts[path], after_refcount)
					min_delayed_refcounts[path] = isnull(min_delayed_refcounts[path]) ? delayed_refcount : \
						min(min_delayed_refcounts[path], delayed_refcount)
					max_delayed_refcounts[path] = isnull(max_delayed_refcounts[path]) ? delayed_refcount : \
						max(max_delayed_refcounts[path], delayed_refcount)
			weakrefs.Cut(1, i)
		while(FALSE)

		// attach debugger here
		pass()
