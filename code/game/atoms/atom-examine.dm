/**
 * @params
 * * examine - examiner args
 * * examine_for - examining for flags so we don't compute stuff we don't need to
 * * examine_from - examining from flags to communicate where the examine is coming from
 *
 * @return /datum/event_args/examine_output or null to not allow examine.
 */
/atom/proc/examine_new(datum/event_args/examine/examine, examine_for)
	var/datum/event_args/examine_output/output = new
	output.name = get_examine_name(examine.examiner_atom)
	output.desc = get_examine_desc(examine.examiner_atom, examine.seer_dist)
	return output

/atom/proc/get_examine_name(mob/user)
	. = "\a <b>[src]</b>"
	var/list/override = list(gender == PLURAL ? "some" : "a", " ", "[name]")

	var/should_override = FALSE

	if(SEND_SIGNAL(src, COMSIG_ATOM_GET_EXAMINE_NAME, user, override) & COMPONENT_EXNAME_CHANGED)
		should_override = TRUE


	if(blood_DNA && !istype(src, /obj/effect/decal))
		override[EXAMINE_POSITION_BEFORE] = " blood-stained "
		should_override = TRUE

	if(should_override)
		. = override.Join("")

/atom/proc/get_examine_desc(mob/user, dist)
	return desc

/// Generate the full examine string of this atom (including icon for goonchat)
/atom/proc/get_examine_string(mob/user, thats = FALSE)
	return "[icon2html(src, user)] [thats? "That's ":""][get_examine_name(user)]"

/// Used to insert text after the name but before the description in examine()
/atom/proc/get_name_chaser(mob/user, list/name_chaser = list())
	return name_chaser

/**
 * Called when a mob examines (shift click or verb) this atom
 *
 * Default behaviour is to get the name and icon of the object and it's reagents where
 * the [TRANSPARENT] flag is set on the reagents holder
 *
 * Produces a signal [COMSIG_PARENT_EXAMINE]
 *
 * @params
 * * user - who's examining. can be null
 * * dist - effective distance of examine, usually from user to src.
 */
// todo: examine(datum/event_args/examine/e_args)
// todo: standard controls / ui/ux help
// todo: examine_more()?
/atom/proc/examine(mob/user, dist = 1)
	var/examine_string = get_examine_string(user, thats = TRUE)
	if(examine_string)
		. = list("[examine_string].")
	else
		. = list()

	. += get_name_chaser(user)
	if(desc)
		. += "<hr>[get_examine_desc(user, dist)]"
	if(get_description_info() || get_description_fluff() || length(get_description_interaction(user)))
		. += SPAN_TINYNOTICE("<a href='byond://winset?command=.statpanel_goto_tab \"Examine\"'>For more information, click here.</a>") //This feels VERY HACKY but eh its PROBABLY fine
	if(integrity_flags & INTEGRITY_INDESTRUCTIBLE)
		. += SPAN_NOTICE("It doesn't look like it can be damaged through common means.")

	if(reagents)
		if(reagents.reagents_holder_flags & TRANSPARENT)
			. += "It contains:"
			if(reagents.total_volume)
				var/has_alcohol = FALSE
				if(user.can_see_reagents()) //Show each individual reagent
					for(var/datum/reagent/current_reagent as anything in reagents.get_reagent_datums())
						if(!has_alcohol && istype(current_reagent,/datum/reagent/ethanol))
							has_alcohol = TRUE
						. += "&bull; [round(reagents.reagent_volumes[current_reagent.id], 0.01)] units of [current_reagent.name]"
				else //Otherwise, just show the total volume
					var/total_volume = 0
					for(var/datum/reagent/current_reagent as anything in reagents.get_reagent_datums())
						if(!has_alcohol && istype(current_reagent,/datum/reagent/ethanol))
							has_alcohol = TRUE
						total_volume += reagents.reagent_volumes[current_reagent.id]
					. += "[total_volume] units of various reagents"
				if(has_alcohol)
					. += "It smells of alcohol."
			else
				. += "Nothing."
		else if(reagents.reagents_holder_flags & AMOUNT_VISIBLE)
			if(reagents.total_volume)
				. += SPAN_NOTICE("It has [reagents.total_volume] unit\s left.")
			else
				. += SPAN_DANGER("It's empty.")

	MATERIAL_INVOKE(src, MATERIAL_TRAIT_EXAMINE, on_examine, ., user, dist)

	// todo: this shouldn't be in main examine(), format this crap better too.
	var/datum/event_args/examine/examining = new /datum/event_args/examine
	examining.seer_atom = user
	examining.seer_distance = dist
	examining.examiner_atom = user
	var/list/usage_hints = examine_query_usage_hints(examining)
	if(length(usage_hints))
		. += "<b>Usage:</b>"
		for(var/hint in usage_hints)
			. += "<li>[hint]</li>"
	var/list/stat_hints = examine_query_stat_hints(examining)
	if(length(stat_hints))
		. += "<b>Stats:</b>"
		for(var/key in stat_hints)
			var/value = stat_hints[key]
			. += "<li>[key] - [value]</li>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/**
 * Called when a mob examines (shift click or verb) this atom twice (or more) within EXAMINE_MORE_WINDOW (default 1 second)
 *
 * This is where you can put extra information on something that may be superfluous or not important in critical gameplay
 * moments, while allowing people to manually double-examine to take a closer look
 *
 * Produces a signal [COMSIG_PARENT_EXAMINE_MORE]
 *
 * todo: hook into examine, maybe rework
 */
/atom/proc/examine_more(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	. = list()
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE_MORE, user, .)

/**
 * Gets a list of usage tips that players should be able to see.
 *
 * * These should not depend on the user's inhand items / worn equipment / whatever.
 * * These are fully HTML-formatted
 * * These will be formatted into list entries by the caller.
 *
 * @return list
 */
/atom/proc/examine_query_usage_hints(datum/event_args/examine/examining)
	return list()

/**
 * Gets a list of introspected data, like recharge delays, that players should be able to see.
 *
 * * These should not depend on the user's inhand items / worn equipment / whatever.
 * * These are fully HTML-formatted
 * * This can return either key-values or just strings.
 * * These will be formatted into list entries by the caller.
 *
 * @return list(key = value, key only, ...)
 */
/atom/proc/examine_query_stat_hints(datum/event_args/examine/examining)
	return list()
