/**
 * Represents an AI lawset
 *
 * * These are not /prototype's; copies are held for silicon mobs.
 *   They are stored by value, as there's little need to have a massive amount of
 *   'static' lawsets floating around in the game's data repositories.
 * * This does mean that storing too many copies of these is a memory drain.
 *   If the need arises, a `/datum/prototype/ai_lawset_preset` might be made
 *   to hold things..
 *
 * There's a few categories of laws.
 * They're more or less just a priority system. From highest to lowest priority;
 *
 * * Zeroth - this is just a 'you are an antagonist, you don't follow law' with fluff wording.
 * * Ion - these are injected by special events and whatnot
 * * Inherent - these are core laws that come before supplied laws.
 * * Supplied - these are additional laws that go below core laws.
 */
/datum/ai_lawset
	/// Our in-code name.
	var/name = "unknown lawset"
	/// Our player-facing name. [name] will be used if this is not set.
	var/display_name

/datum/ai_lawset/proc/append_ion_law(datum/ai_law/law_datum_or_text)
	var/next_index = length(ion_laws) + 1
	if(!istype(law_datum_or_text))
		law_datum_or_text = new /datum/ai_law(law_datum_or_text)
	law_datum_or_text.index = next_index
	if(law_datum_or_text in ion_laws)
		return FALSE
	ion_laws += law_datum_or_text
	return TRUE

/datum/ai_lawset/proc/append_inherent_law(datum/ai_law/law_datum_or_text)
	var/next_index = length(inherent_laws) + 1
	if(!istype(law_datum_or_text))
		law_datum_or_text = new /datum/ai_law(law_datum_or_text)
	law_datum_or_text.index = next_index
	if(law_datum_or_text in inherent_laws)
		return FALSE
	inherent_laws += law_datum_or_text
	return TRUE

/datum/ai_lawset/proc/append_supplied_law(datum/ai_law/law_datum_or_text)
	var/next_index = length(supplied_laws) + 1
	if(!istype(law_datum_or_text))
		law_datum_or_text = new /datum/ai_law(law_datum_or_text)
	law_datum_or_text.index = next_index
	if(law_datum_or_text in supplied_laws)
		return FALSE
	supplied_laws += law_datum_or_text
	return TRUE

//! legacy below
/datum/ai_lawset
	var/law_header = "Prime Directives"
	var/selectable = 0
	var/datum/ai_law/zero/zeroth_law = null
	var/datum/ai_law/zero/zeroth_law_borg = null
	var/list/datum/ai_law/ion_laws = list()
	var/list/datum/ai_law/inherent_laws = list()
	var/list/datum/ai_law/supplied_laws = list()
	var/list/datum/ai_law/sorted_laws = list()

	var/state_zeroth = 0
	var/list/state_ion = list()
	var/list/state_inherent = list()
	var/list/state_supplied = list()

/datum/ai_lawset/New()
	..()
	sort_laws()

/* General ai_law functions */
/datum/ai_lawset/proc/all_laws()
	sort_laws()
	return sorted_laws

/datum/ai_lawset/proc/laws_to_state()
	sort_laws()
	var/list/statements = new()
	for(var/datum/ai_law/law in sorted_laws)
		if(get_state_law(law))
			statements += law

	return statements

/datum/ai_lawset/proc/sort_laws()
	if(sorted_laws.len)
		return

	for(var/ion_law in ion_laws)
		sorted_laws += ion_law

	if(zeroth_law)
		sorted_laws += zeroth_law

	var/index = 1
	for(var/datum/ai_law/inherent_law in inherent_laws)
		inherent_law.index = index++
		if(supplied_laws.len < inherent_law.index || !istype(supplied_laws[inherent_law.index], /datum/ai_law))
			sorted_laws += inherent_law

	for(var/datum/ai_law/AL in supplied_laws)
		if(istype(AL))
			sorted_laws += AL

/datum/ai_lawset/proc/sync(var/mob/living/silicon/S, var/full_sync = 1)
	// Add directly to laws to avoid log-spam
	S.sync_zeroth(zeroth_law, zeroth_law_borg)

	if(full_sync || ion_laws.len)
		S.laws.clear_ion_laws()
	if(full_sync || inherent_laws.len)
		S.laws.clear_inherent_laws()
	if(full_sync || supplied_laws.len)
		S.laws.clear_supplied_laws()

	for (var/datum/ai_law/law in ion_laws)
		S.laws.add_ion_law(law.law)
	for (var/datum/ai_law/law in inherent_laws)
		S.laws.add_inherent_law(law.law)
	for (var/datum/ai_law/law in supplied_laws)
		if(law)
			S.laws.add_supplied_law(law.index, law.law)

/datum/ai_lawset/proc/set_zeroth_law(var/law, var/law_borg = null)
	if(!law)
		return

	zeroth_law = new(law)
	if(law_borg) //Making it possible for slaved borgs to see a different law 0 than their AI. --NEO
		zeroth_law_borg = new(law_borg)
	else
		zeroth_law_borg = null
	sorted_laws.Cut()

/datum/ai_lawset/proc/add_ion_law(var/law)
	if(!law)
		return

	for(var/datum/ai_law/AL in ion_laws)
		if(AL.law == law)
			return

	var/new_law = new/datum/ai_law/ion(law)
	ion_laws += new_law
	if(state_ion.len < ion_laws.len)
		state_ion += 1

	sorted_laws.Cut()

/datum/ai_lawset/proc/add_inherent_law(var/law)
	if(!law)
		return

	for(var/datum/ai_law/AL in inherent_laws)
		if(AL.law == law)
			return

	var/new_law = new/datum/ai_law/inherent(law)
	inherent_laws += new_law
	if(state_inherent.len < inherent_laws.len)
		state_inherent += 1

	sorted_laws.Cut()

/datum/ai_lawset/proc/add_supplied_law(var/number, var/law)
	if(!law)
		return

	if(supplied_laws.len >= number)
		var/datum/ai_law/existing_law = supplied_laws[number]
		if(existing_law && existing_law.law == law)
			return

	if(supplied_laws.len >= number && supplied_laws[number])
		delete_law(supplied_laws[number])

	while (src.supplied_laws.len < number)
		src.supplied_laws += ""
		if(state_supplied.len < supplied_laws.len)
			state_supplied += 1

	var/new_law = new/datum/ai_law/supplied(law, number)
	supplied_laws[number] = new_law
	if(state_supplied.len < supplied_laws.len)
		state_supplied += 1

	sorted_laws.Cut()

/datum/ai_lawset/proc/delete_law(var/datum/ai_law/law)
	if(istype(law))
		law.delete_law(src)

/datum/ai_law/proc/delete_law(var/datum/ai_lawset/laws)

/datum/ai_law/zero/delete_law(var/datum/ai_lawset/laws)
	laws.clear_zeroth_laws()

/datum/ai_law/ion/delete_law(var/datum/ai_lawset/laws)
	laws.internal_delete_law(laws.ion_laws, laws.state_ion, src)

/datum/ai_law/inherent/delete_law(var/datum/ai_lawset/laws)
	laws.internal_delete_law(laws.inherent_laws, laws.state_inherent, src)

/datum/ai_law/supplied/delete_law(var/datum/ai_lawset/laws)
	var/index = laws.supplied_laws.Find(src)
	if(index)
		laws.supplied_laws[index] = ""
		laws.state_supplied[index] = 1

/datum/ai_lawset/proc/internal_delete_law(var/list/datum/ai_law/laws, var/list/state, var/list/datum/ai_law/law)
	var/index = laws.Find(law)
	if(index)
		laws -= law
		for(index, index < state.len, index++)
			state[index] = state[index+1]
	sorted_laws.Cut()

/datum/ai_lawset/proc/clear_zeroth_laws()
	zeroth_law = null
	zeroth_law_borg = null

/datum/ai_lawset/proc/clear_ion_laws()
	ion_laws.Cut()
	sorted_laws.Cut()

/datum/ai_lawset/proc/clear_inherent_laws()
	inherent_laws.Cut()
	sorted_laws.Cut()

/datum/ai_lawset/proc/clear_supplied_laws()
	supplied_laws.Cut()
	sorted_laws.Cut()

/datum/ai_lawset/proc/show_laws(var/who)
	sort_laws()
	for(var/datum/ai_law/law in sorted_laws)
		if(law == zeroth_law_borg)
			continue
		if(law == zeroth_law)
			to_chat(who, "<span class='danger'>[law.get_index()]. [law.law]</span>")
		else
			to_chat(who, "[law.get_index()]. [law.law]")

/datum/ai_lawset/proc/get_state_law(var/datum/ai_law/law)
	return law.get_state_law(src)

/datum/ai_lawset/proc/get_state_internal(var/list/datum/ai_law/laws, var/list/state, var/list/datum/ai_law/law)
	var/index = laws.Find(law)
	if(index)
		return state[index]
	return 0

/datum/ai_lawset/proc/set_state_law(var/datum/ai_law/law, var/state)
	law.set_state_law(src, state)

/datum/ai_lawset/proc/set_state_law_internal(var/list/datum/ai_law/laws, var/list/state, var/list/datum/ai_law/law, var/do_state)
	var/index = laws.Find(law)
	if(index)
		state[index] = do_state

//! legacy above

/**
 * Preset AI laws.
 */
/datum/ai_lawset/preset
	VAR_PROTECTED/list/preset_ion_laws
	VAR_PROTECTED/list/preset_inherent_laws
	VAR_PROTECTED/list/preset_supplied_laws

/datum/ai_lawset/preset/New()
	..()
	init_default_laws()

/datum/ai_lawset/preset/proc/init_default_laws()
	for(var/i in preset_ion_laws)
		append_ion_law(i)
	preset_ion_laws = null
	for(var/i in preset_inherent_laws)
		append_inherent_law(i)
	preset_inherent_laws = null
	for(var/i in preset_supplied_laws)
		append_supplied_law(i)
	preset_supplied_laws = null
