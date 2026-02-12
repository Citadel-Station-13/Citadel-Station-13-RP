//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * State / ability holder for a Stargazer mindnet system.
 *
 * * Remember Main Server's Stargazer slimes?
 *   This is that, but as a passive thing, and heavily reworked, and also generic.
 * * Linkage is tracked by mind, not by mob. Owner is tracked by brain, not by mind.
 *   A mirrored Promethean / Xenochimera / whatnot loses their links,
 *   but a mirrored target does not get unlinked.
 *
 * ## What does this do?
 *
 * Stargazers are capable of what is considered
 * 'cooperative' telepathy. They can send telepathic messages, and sometimes
 * get it back, but the receiving end has to want to; basically, no mind-reading,
 * no mind-control, no locating people who don't want to be located (outside of
 * a very course-level system that allows you to sense if they're alive).
 *
 * The only exception is when attunement strength is very, very high. At high
 * enough values, sensing is no longer cooperative; in reality, gameplay-wise,
 * it's impossible to actually use this to hunt someone down
 * until you get to within a few tiles of them.
 *
 * ## Attunement Strengths
 *
 * Attunement strength is the main numerical tuning parameter. A lot of abilities
 * require a certain attunement strength to work.
 *
 * Attunement strength is not necessarily something that requires attunement to exist.
 *
 * Temporary attunement is assumed in cases like 1. someone seeing the Promethean,
 * 2. someone being in proximity to them, 3. someone being in contact with them, etc,
 * allowing for this to work without them needing to specially attune to them.
 *
 * ## Mindlinking
 *
 * Mindlinking allows a Promethean to maintain a level of static attunement with someone.
 * This is how you can do things like sense if someone's alive, etc; static attunement
 * is based on distance but generally has a minimum level that always works as long
 * as you're on the same overmap sector.
 *
 * Mindlinking is considered a hostile action by things like mindshields and anti-magic
 * sources, as is all mind-involving things.
 *
 * ## Entity Scanning
 *
 * Technically, the system supports arbitrary scan range, but,
 * for the sake of not killing the server's performance,
 * the actual scan is based on spatial grids and only mindlinked entities can be
 * detected cross-overmap.
 *
 * This is however, by default. The [scan_] variables control scanning behavior;
 * the system is allowed to slow down scans if there's too many things to scan,
 * as well as do things like only scanning players.
 */
/datum/stargazer_mindnet
	/// Established mindlinks, by mind-ref
	/// * Key is `/datum/mind_ref`
	/// * Value is `/datum/stargazer_mindnet_link`
	/// * Note that one mind = one mind ref; that is why this is sound behavior to use mind-ref's as keys.
	/// * mindlinks are always scanned
	var/list/link_lookup
	var/link_type = /datum/stargazer_mindnet_link
	/// abilities by id
	/// * Usually, things like abilities are global singletons, but for now let's
	///   not overcomplicate.
	var/list/ability_lookup

	/// mind_ref by string name
	/// * if null / doesn't exist, we generate a description.
	var/list/named_presences

	/// Passive attunement always
	/// * FOR THE LOVE OF ALL THAT IS HOLY LEAVE THIS AT ZERO
	var/attunement_power_global = 0
	/// passive attunement power for someone with some view of the owner's body
	var/attunement_power_see_owner_min = 15
	/// passive attunement power for someone with full view of the owner's body
	var/attunement_power_see_owner_max = 25
	var/attunement_power_see_target_min = 0
	var/attunement_power_see_target_max = 0

	/// passive attunement power gained by contact
	var/attunement_power_for_pull = 15
	/// passive attunement power gained per grab level
	/// * this is major and combined with visible allows prommies to
	///   do stuff like telepathically talk / health-scan people without them
	///   needing to accept it
	var/attunement_power_per_grab_level = 15

	var/attunement_power_proximity_radius_min = 3
	var/attunement_power_proximity_radius_max = 14
	/// linear interpolated between proximity radius min/max
	var/attunement_power_proximity_max_power = 20

	/// scan literally everything if TRUE
	var/scan_global = FALSE
	/// scan overmap range (in pixels) if non-null
	var/scan_overmap_range = null
	/// scan overmap entity if TRUE
	var/scan_overmap_entity = FALSE
	/// scan the entire map if TRUE
	var/scan_map = FALSE
	/// scan proximity range on same zlevel
	/// * directly used in spatial grids to see how far we can scan
	var/scan_level_range = 14
	var/scan_last
	var/scan_throttle = 3 SECONDS
	/// list of mind_ref's associated to attunements
	var/tmp/list/scan_results
	var/tmp/scan_parent_turf

	/// attunement required to sense someone's nearby
	/// * this applies to mindlinks as well; mindlinks are in 'unknown' state if this isn't met
	var/minimum_attunement_for_presence = 15

	/// overmap pixel distance for 'same overmap'
	/// * this applies to mindlinks as well
	/// * null = need to be in same (enclosing) entity location, 0 = must contact
	var/overmap_pixel_distance_considered_same = WORLD_ICON_SIZE * 0.5

	/// executing functions
	var/list/datum/stargazer_mindnet_exec/executing

	/// cached visibility attunements
	/// * mind_ref to ratio from 0 to 1
	/// * 0 = owner cannot see them but they can see owner, 1 = owner can see them very well
	var/tmp/list/cached_visibility
	/// ratio owner is considered seen
	/// * 0 to 1
	var/tmp/cached_visibility_owner_ratio
	var/tmp/cached_visibility_last_update
	var/tmp/cached_visibility_update_interval = 3 SECONDS

#warn impl

/datum/stargazer_mindnet/proc/add_ability_path(path)
	#warn impl

/**
 * Rescan for nearby mobs.
 *
 * @params
 * * force_update - ignore delay. Very dangerous.
 *
 * @return TRUE if scanned, FALSE otherwise
 */
/datum/stargazer_mindnet/proc/scan(force_update)
	if(scan_last > world.time - scan_throttle)
		return FALSE
	scan_last = world.time
	scan_impl()
	push_scan_results()
	return TRUE

/datum/stargazer_mindnet/proc/scan_impl()
	scan_parent_turf = get_parent_turf()
	var/list/mob/scanning = scan_collect_mobs()
	#warn impl

/**
 * * This will only get /living (path) and non-dead (status) mobs.
 */
/datum/stargazer_mindnet/proc/scan_collect_mobs()
	. = list()
	var/turf/our_turf = scan_parent_turf
	if(scan_global)
		for(var/mob/living/target in GLOB.mob_list)
			if(IS_DEAD(target))
				continue
			. += target
	else if(scan_overmap_range)
		if(our_turf)
			var/obj/overmap/entity/our_entity = SSovermaps.get_enclosing_overmap_entity(our_turf)
			if(our_entity)
				for(var/obj/overmap/entity/entity as anything in SSspatial_grids.overmap_entities.pixel_query(our_entity, scan_overmap_range))
					for(var/z in entity.location?.get_z_indices())
						for(var/mob/living/target as anything in SSspatial_grids.living.all_atoms(level.z_index))
							if(IS_DEAD(target))
								continue
							. += target
	else if(scan_overmap_entity)
		if(our_turf)
			var/obj/overmap/entity/our_entity = SSovermaps.get_enclosing_overmap_entity(our_turf)
			if(our_entity)
				for(var/z in our_entity.location?.get_z_indices())
					for(var/mob/living/target as anything in SSspatial_grids.living.all_atoms(level.z_index))
						if(IS_DEAD(target))
							continue
						. += target
	else if(scan_map)
		if(our_turf)
			for(var/datum/map_level/level as anything in SSmapping.ordered_levels[our_turf.z].parent_map?.levels)
				for(var/mob/living/target as anything in SSspatial_grids.living.all_atoms(level.z_index))
					if(IS_DEAD(target))
						continue
					. += target
	else if(scan_level_range)
		if(our_turf)
			for(var/mob/living/target as anything in SSspatial_grids.living.range_query(our_turf, scan_level_range))
				if(IS_DEAD(target))
					continue
				. += target

/datum/stargazer_mindnet/proc/scan_target(datum/mind_ref/target, defer_update)
	#warn impl

/datum/stargazer_mindnet/proc/scan_remove_target(datum/mind_ref/target, defer_update)
	#warn impl

/datum/stargazer_mindnet/proc/scan_remove_all(defer_update)
	#warn impl

/datum/stargazer_mindnet/proc/push_scan_results()
	#warn impl

/datum/stargazer_mindnet/proc/push_scan_target_add(datum/mind_ref/target)
	#warn impl

/datum/stargazer_mindnet/proc/push_scan_target_update(datum/mind_ref/target)
	#warn impl

/datum/stargazer_mindnet/proc/push_scan_target_remove(datum/mind_ref/target)
	#warn impl


/datum/stargazer_mindnet/proc/get_attunement_power_for_entity(mob/target)
	if(!istype(target))
		return 0
	return get_attunement_power_for_mind(target.mind)

/datum/stargazer_mindnet/proc/get_attunement_power_for_mind(datum/mind/mind)
	var/mob/resolved_mob = mind.current

	update_cached_visibility()

	. = 0
	. += attunement_power_global
	#warn rest

	var/datum/stargazer_mindnet_link/link = link_lookup[mind]
	if(link)
		. += link.get_attunement_power()

/datum/stargazer_mindnet/proc/erase_mind_link(datum/mind/mind)
	var/datum/mind_ref/mind_ref = mind.get_mind_ref()
	if(!link_lookup[mind_ref])
		return
	link_lookup[mind_ref] = null
	update_static_data()

/datum/stargazer_mindnet/proc/get_mind_link(datum/mind/mind)
	var/datum/mind_ref/mind_ref = mind.get_mind_ref()
	return link_lookup[mind_ref]

/datum/stargazer_mindnet/proc/get_or_create_mind_link(datum/mind/mind)
	var/datum/mind_ref/mind_ref = mind.get_mind_ref()
	if(link_lookup[mind_ref])
		return link_lookup[mind_ref]
	link_lookup[mind_ref] = new link_type(src, mind_ref)
	update_static_data()
	return link_lookup[mind_ref]

/datum/stargazer_mindnet/proc/create_exec(dedupe_key)
	LAZYINITLIST(executing)
	var/datum/stargazer_mindnet_exec/exec = new(src, dedupe_key)
	executing[dedupe_key] = exec
	return exec

/datum/stargazer_mindnet/proc/has_ongoing_exec(dedupe_key)
	return executing?[dedupe_key]

/datum/stargazer_mindnet/proc/get_mind_presence_name(datum/mind/target)
	#warn impl

/datum/stargazer_mindnet/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "misc/StargazerMindnet")
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/stargazer_mindnet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("invoke")
			var/ability_id = params["id"]
			var/target_ref = params["targetRef"]
		if("rescan")

/datum/stargazer_mindnet/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	#warn impl

/datum/stargazer_mindnet/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/list/serialized_abilities = list()
	for(var/id in ability_lookup)
		var/datum/stargazer_mindnet_ability/ability = ability_lookup[id]
		serialized_abilities[id] = ability.ui_mindnet_ability_data()
	.["abilities"] = serialized_abilities
	#warn impl

/datum/stargazer_mindnet/proc/emit_raw_message_to_owner(html)
	#warn impl

/datum/stargazer_mindnet/proc/emit_message_to_owner(html)
	emit_raw_message_to_owner(SPAN_ALIEN("MINDNET: [html]"))

/datum/stargazer_mindnet/proc/update_cached_visibility(force_update)
	#warn impl

/datum/stargazer_mindnet/proc/update_cached_visibility_impl()

/**
 * Default variant for Prometheans
 */
/datum/stargazer_mindnet/promethean
	/// owning slime core
	/// * Nullable; mindnets can be detached / transferred in-code, even if it's impossible in game.
	var/obj/item/organ/internal/brain/promethean/owning_core

/datum/stargazer_mindnet/promethean/New(obj/item/organ/internal/brain/promethean/core)
	src.owning_core = core

/datum/stargazer_mindnet/promethean/Destroy()
	if(owning_core)
		if(owning_core.mindnet == src)
			owning_core.mindnet = null
		owning_core = null
	return ..()

/**
 * Default variant for Xenochimerae
 */
/datum/stargazer_mindnet/xenochimera
	/// owning slime core
	/// * Nullable; mindnets can be detached / transferred in-code, even if it's impossible in game.
	var/obj/item/organ/internal/brain/xenochimera/owning_core

/datum/stargazer_mindnet/xenochimera/New(obj/item/organ/internal/brain/xenochimera/core)
	src.owning_core = core

/datum/stargazer_mindnet/xenochimera/Destroy()
	if(owning_core)
		if(owning_core.mindnet == src)
			owning_core.mindnet = null
		owning_core = null
	return ..()

// TODO: abstract organ variant for adminbus
