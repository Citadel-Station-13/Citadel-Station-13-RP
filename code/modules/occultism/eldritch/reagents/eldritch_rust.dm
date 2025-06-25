//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/reagent/eldritch_rust
	id = "eldritch-rust"

#warn impl

/datum/reagent/eldritch_rust/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()

/datum/reagent/eldritch_rust/on_touch_mob(mob/target, remaining, allocated, data, zone)
	. = ..()

/datum/reagent/eldritch_rust/on_touch_obj(obj/target, remaining, allocated, data)
	. = ..()

/datum/reagent/eldritch_rust/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	. = ..()

/datum/reagent/eldritch_rust/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	. = ..()

/datum/reagent/eldritch_rust/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	. = ..()

#warn ticking
