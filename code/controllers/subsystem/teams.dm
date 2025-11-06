/**
 * Handles tracking arbitrary teams for grouping players and entities together.
 * These are not "factions" they are groups we divide players into such as the crews of individual ships. A faction might have multiple arbitrary teams.
 * This is intended to be a cornerstone system so it is built to fail spectacularly.
 * Teams will always be valid and last the entire round. None of this data is serializable.
 * It is the responsibilty of everything else to record its own team id. This system only verifies that a arbitrary_team exists and returns blurbs about them.
 *
 * "How do I add teams?" - try_register_team()
 * "How do I edit teams details?" - try_edit_team()
 * "How do I edit teams id?" - you dont.
 * "How do I delete teams?" - restart the game.
 * "How do I confirm a team is real?" - is_team_registered()
 * "How do I get teams details?" - try_get_team_name() try_get_team_desc()
 * "What if I need all the team ids?" - get_all_ids()
 */
SUBSYSTEM_DEF(teams)
	name = "Teams"
	init_order = INIT_ORDER_TEAMS
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

/datum/controller/subsystem/teams
	//! Temporary hard-coded defines. See warning at bottom of file for this.
	/// NEVER EVER TOUCH THIS - Holds all arbitrary teams we've registered this round.
	var/tmp/alist/teams = alist(
		"TeamNanotrasen" = /datum/arbitrary_team/nanotrasen,
		"TeamCentcom" = /datum/arbitrary_team/centcom,
		"TeamTrader" = /datum/arbitrary_team/trader,
		"TeamScorian" = /datum/arbitrary_team/scorian,
		"TeamRogue" = /datum/arbitrary_team/rogue,
		"TeamUnknown" = /datum/arbitrary_team/unknown
		)

///A very basic datum for holding team information. Don't overengineer this.
/datum/arbitrary_team
	/// Unique string entity id for this datum. Must be filled. MUST BE TEXT!
	var/tmp/id = ""
	/// The name of this group. Must be filled. MUST BE TEXT!
	var/tmp/display_name = ""
	/// Optional description of this group. MUST BE TEXT!
	var/tmp/display_desc = ""

/datum/arbitrary_team/New(new_id, new_display_name, new_display_desc)
	id = new_id
	display_name = new_display_name
	display_desc = new_display_desc

/**
 * Try to register a new team with SSteams. Will crash spectacularly if you give it bad inputs.
 *
 * @params
 * - id - Mandatory: A unique string id, must be text.
 * - display_name - Mandatory: A name for this group, must be text.
 * - display_desc - Optional: A description for this group. must be text.
 *
 * @return - returns FALSE if team already exists. returns TRUE if it registers the team. Crashes on non-string input.
 */
/datum/controller/subsystem/teams/proc/try_register_team(id, display_name, display_desc)
	if(!istext(id) || !id || !istext(display_name) || !display_name)
		//It really wasnt that hard to avoid this.
		CRASH("Tried to register in SSteams with bad inputs ID:[id], name:[display_name], desc:[display_desc]")
	//display_desc is optional, but must be text.
	if(display_desc && !istext(display_desc))
		CRASH("Tried to register in SSteams with bad inputs ID:[id], name:[display_name], desc:[display_desc]")

	if(id in teams)
		return FALSE

	var/datum/arbitrary_team/new_team = new(id, display_name, display_desc)
	teams[id] = new_team
	return TRUE

/**
 * Try to edit a teams name and/or description. Empty or bad input variables will not be changed.
 *
 * @params
 * - id - Mandatory: The id of the team you want to edit.
 * - display_name - Must be text. What you want to change the display name to, leave null to not edit.
 * - display_desc - Must be text. What you want to change the display description to, leave null to not edit.
 *
 * @return - returns FALSE if team doesn't exist. returns TRUE otherwise.
 */
/datum/controller/subsystem/teams/proc/try_edit_team(id, display_name, display_desc)
	if(id in teams)
		var/datum/arbitrary_team/target = teams[id]
		if(istext(display_name))
			target.display_name = display_name
		if(istext(display_text))
			target.display_desc = display_desc
		return TRUE
	return FALSE

/**
 * Try to get a teams name. Returns null if team doesn't exist.
 */
/datum/controller/subsystem/teams/proc/try_get_team_name(id)
	if(id in teams)
		var/datum/arbitrary_team/target = teams[id]
		return target.display_name
	return null

/**
 * Try to get a teams description. Returns null if team doesn't exist or there is no description
 */
/datum/controller/subsystem/teams/proc/try_get_team_desc(id)
	if(id in teams)
		var/datum/arbitrary_team/target = teams[id]
		return target.display_desc
	return null

/**
 * Get a list of all team IDs
 */
/datum/controller/subsystem/teams/proc/get_all_ids()
	var/list/all_teams = list()
	for (var/id, value in teams)
		all_teams[all_teams.len += 1] = id
	return all_teams

/**
 * Check if a team id is registered
 */
/datum/controller/subsystem/teams/proc/is_team_registered(id)
	if(id in teams)
		return TRUE
	return FALSE



//!Shitcode ahead!
//! These are here to temporarilly tie this system to others until SSRoles is completed. Ideally all teams are generated dynamically from load as needed or loaded from map files. But until the egg is programmed in we have to manually type the chicken. I will build every team I think we may need up front. Assume these will disapear magically when you most need them.
//! IF YOU MAKE MORE OF THESE OUTSIDE THIS FILE 10000 YEARS BAD LUCK!!
/datum/arbitrary_team/nanotrasen
	id = "TeamNanotrasen"
	display_name = "Nanotrasen Crew"
	display_desc = "The crew of a local Nanotrasen operation"

/datum/arbitrary_team/centcom
	id = "TeamCentcom"
	display_name = "Central Command"

/datum/arbitrary_team/trader
	id = "TeamTrader"
	display_name = "Nebula Gas"
	display_desc = "Local traders and merchants"

/datum/arbitrary_team/scorian
	id = "TeamScorian"
	display_name = "Scorians"

/datum/arbitrary_team/rogue
	id = "TeamRogue"
	display_name = "Independents"

/datum/arbitrary_team/unknown
	id = "TeamUnknown"
	display_name = "Unknown"
