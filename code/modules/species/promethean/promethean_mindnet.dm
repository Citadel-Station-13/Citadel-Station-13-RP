//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * State / ability holder for a Stargazer's mindnet system.
 *
 * * Remember Main Server's Stargazer slimes?
 *   This is that, but as a passive thing, and heavily reworked.
 * * Linkage is tracked by mind, not by mob. Owner is tracked by brain, not by mind.
 *   A mirrored Promethean loses their links, but a mirrored target does not get unlinked.
 *
 * ## What does this do?
 *
 * Prometheans with Stargazer capabilities are capable of what is considered
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
 */
/datum/promethean_mindnet
	/// owning slime core
	/// * Nullable; mindnets can be detached / transferred in-code, even if it's impossible in game.
	var/obj/item/organ/internal/brain/promethean/stargazer/owning_core
	/// Established mindlinks, by mind-ref
	/// * Key is `/datum/mind_ref`
	/// * Value is `/datum/promethean_mindlink`
	/// * Note that one mind = one mind ref; that is why this is sound behavior to use mind-ref's as keys.
	var/list/link_lookup

	/// passive attunement power for someone with some view of the Promethean's body
	var/attunement_power_visible_min = 25
	/// passive attunement power for someone with full view of the Promethean's body
	var/attunement_power_visible_max = 45

	/// passive attunement power gained by contact
	var/attunement_power_for_pull = 15
	/// passive attunement power gained per grab level
	/// * this is major and combined with visible allows prommies to
	///   do stuff like telepathically talk / health-scan people without them
	///   needing to accept it
	var/attunement_power_per_grab_level = 27.5

	var/attunement_power_proximity_radius_min = 1
	var/attunement_power_proximity_radius_max = 14
	/// linear interpolated between proximity radius min/max
	var/attunement_power_proximity_max_power = 20

	/// power needed to sense a mob as being nearby at all
	var/attunement_required_for_presence_sensing = 1

	/// overmap pixel distance for 'same overmap'
	/// * null = need to be in same sector, 0 = must contact
	var/overmap_pixel_distance_considered_same = WORLD_ICON_SIZE * 0.5

/datum/promethean_mindnet/New(obj/item/organ/internal/brian/promethean/stargazer/core)
	src.owning_core = core

/datum/promethean_mindnet/Destroy()
	if(owning_core)
		if(owning_core.mindnet == src)
			owning_core.mindnet = null
		owning_core = null
	return ..()


#warn impl

/datum/promethean_mindnet/proc/get_attunement_power_for_entity(mob/target)
	if(!istype(target))
		return 0
	return get_attunement_power_for_mind(target.mind)

/datum/promethean_mindnet/proc/get_attunement_power_for_mind(datum/mind/mind)
	. = 0
	. += attunement_power_global
	#warn rest

	var/datum/promethean_mindlink/link = link_lookup[mind]
	if(link)
		. += link.attunement_power_global

/datum/promethean_mindnet/proc/erase_mind_link(datum/mind/mind)

/datum/promethean_mindnet/proc/get_mind_link(datum/mind/mind)

/datum/promethean_mindnet/proc/create_mind_link(datum/mind/mind)

/datum/promethean_mindnet/proc/get_or_create_mind_link(datum/mind/mind)

/datum/promethean_mindnet/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()


/datum/promethean_mindnet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("invoke")
		if("rescan")

/datum/promethean_mindnet/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/promethean_mindnet/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()




