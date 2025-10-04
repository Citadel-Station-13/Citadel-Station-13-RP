#define POSITIVE_MODE 1
#define NEUTRAL_MODE 2
#define NEGATIVE_MODE 3
#define ALL_MODE 4

/datum/preferences
	var/custom_species	// Custom species name, can't be changed due to it having been used in savefiles already.
	var/custom_base		// What to base the custom species on
	var/blood_color = "#A10808"

	var/custom_say = null
	var/custom_whisper = null
	var/custom_ask = null
	var/custom_exclaim = null

	var/list/pos_traits	= list()	// What traits they've selected for their custom species
	var/list/neu_traits = list()
	var/list/neg_traits = list()

	var/list/id_hidden_traits = list()

	var/traits_cheating = 0 //Varedit by admins allows saving new maximums on people who apply/etc
	var/starting_trait_points = STARTING_SPECIES_POINTS
	var/max_traits = MAX_SPECIES_TRAITS

/datum/traits_available_trait
	var/internal_name
	var/datum/trait/real_record
	var/cost
	var/forbidden_reason
	var/list/exclusive_with

/datum/traits_constraints
	var/max_traits
	var/max_points


// Definition of the stuff for Ears
/datum/category_item/player_setup_item/vore/traits
	name = "Traits"
	sort_order = 8

/datum/category_item/player_setup_item/vore/traits/load_character(var/savefile/S)
	S["custom_species"]	>> pref.custom_species
	S["custom_base"]	>> pref.custom_base
	S["pos_traits"]		>> pref.pos_traits
	S["neu_traits"]		>> pref.neu_traits
	S["neg_traits"]		>> pref.neg_traits
	S["hidden_traits"]	>> pref.id_hidden_traits
	S["blood_color"]	>> pref.blood_color

	S["traits_cheating"]>> pref.traits_cheating
	S["max_traits"]		>> pref.max_traits
	S["trait_points"]	>> pref.starting_trait_points

	S["custom_say"]		>> pref.custom_say
	S["custom_whisper"]	>> pref.custom_whisper
	S["custom_ask"]		>> pref.custom_ask
	S["custom_exclaim"]	>> pref.custom_exclaim

/datum/category_item/player_setup_item/vore/traits/save_character(var/savefile/S)
	S["custom_species"]	<< pref.custom_species
	S["custom_base"]	<< pref.custom_base
	S["pos_traits"]		<< pref.pos_traits
	S["neu_traits"]		<< pref.neu_traits
	S["neg_traits"]		<< pref.neg_traits
	S["hidden_traits"]	<< pref.id_hidden_traits
	S["blood_color"]	<< pref.blood_color

	S["traits_cheating"]<< pref.traits_cheating
	S["max_traits"]		<< pref.max_traits
	S["trait_points"]	<< pref.starting_trait_points

	S["custom_say"]		<< pref.custom_say
	S["custom_whisper"]	<< pref.custom_whisper
	S["custom_ask"]		<< pref.custom_ask
	S["custom_exclaim"]	<< pref.custom_exclaim

/datum/category_item/player_setup_item/vore/traits/sanitize_character()
	if(!pref.pos_traits) pref.pos_traits = list()
	if(!pref.neu_traits) pref.neu_traits = list()
	if(!pref.neg_traits) pref.neg_traits = list()
	if(!pref.id_hidden_traits) pref.id_hidden_traits = list()

	pref.blood_color = sanitize_hexcolor(pref.blood_color, 6, TRUE, default = "#A10808")

	if(!pref.traits_cheating)
		pref.starting_trait_points = STARTING_SPECIES_POINTS
		pref.max_traits = MAX_SPECIES_TRAITS

	// sanitize traits
	var/available_traits = compute_available_traits()
	var/constraints = compute_constraints()

	apply_traits(TRUE, pref.pos_traits.Copy() + pref.neu_traits.Copy() + pref.neg_traits.Copy(), available_traits, constraints)

	for(var/path in pref.id_hidden_traits)
		var/datum/trait/T = all_traits[path]
		if(!istype(T) || !T.extra_id_info_optional)
			pref.id_hidden_traits -= path
			continue
		if(!(path in (pref.pos_traits + pref.neu_traits + pref.neg_traits)))
			pref.id_hidden_traits -= path

	var/datum/species/selected_species = pref.real_species_datum()
	if(selected_species.selects_bodytype)
		// Allowed!
	else if(!pref.custom_base || !(pref.custom_base in SScharacters.custom_species_bases))
		pref.custom_base = SPECIES_HUMAN

	pref.custom_say = lowertext(trim(pref.custom_say))
	pref.custom_whisper = lowertext(trim(pref.custom_whisper))
	pref.custom_ask = lowertext(trim(pref.custom_ask))
	pref.custom_exclaim = lowertext(trim(pref.custom_exclaim))


/datum/category_item/player_setup_item/vore/traits/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	character.custom_species = pref.custom_species
	character.custom_say     = lowertext(trim(pref.custom_say))
	character.custom_ask     = lowertext(trim(pref.custom_ask))
	character.custom_whisper = lowertext(trim(pref.custom_whisper))
	character.custom_exclaim = lowertext(trim(pref.custom_exclaim))

	var/datum/species/S = character.species
	var/SB = S.selects_bodytype ? (pref.custom_base || /datum/species/human) : pref.real_species_datum()
	S.copy_from(SB, pref.pos_traits + pref.neu_traits + pref.neg_traits, character)

	//Any additional non-trait settings can be applied here
	S.blood_color = pref.blood_color

	if(pref.real_species_id() == SPECIES_ID_CUSTOM)
		if(PREF_COPYING_TO_CHECK_IS_SPAWNING(flags))
			//Statistics for this would be nice
			var/english_traits = english_list(S.traits, and_text = ";", comma_text = ";")
			log_game("TRAITS [pref.client_ckey]/([character]) with: [english_traits]") //Terrible 'fake' key_name()... but they aren't in the same entity yet
	return TRUE

/datum/category_item/player_setup_item/vore/traits/content(datum/preferences/prefs, mob/user, data)
	. += "<b>Custom Species Name:</b> "
	. += "<a href='?src=\ref[src];custom_species=1'>[pref.custom_species ? pref.custom_species : "-Input Name-"]</a><br>"

	var/datum/species/selected_species = pref.real_species_datum()
	if(selected_species.selects_bodytype)
		. += "<b>Icon Base: </b> "
		. += "<a href='?src=\ref[src];custom_base=1'>[pref.custom_base ? pref.custom_base : SPECIES_HUMAN]</a><br>"

	var/traits_left = pref.max_traits - length(pref.pos_traits) - length(pref.neg_traits)
	. += "<b>Traits Left:</b> [traits_left >= 0? traits_left : "<font color='red'>[traits_left]</font>"]<br>"
	if(pref.real_species_id() == SPECIES_ID_CUSTOM)
		var/points_left = pref.starting_trait_points
		for(var/T in pref.pos_traits + pref.neg_traits)
			points_left -= traits_costs[T]

		. += "<b>Points Left:</b> [points_left >= 0 ? points_left : "<font color='red'>[points_left]</font>"]<br>"
		if(points_left < 0 || traits_left < 0 || !pref.custom_species)
			. += "<span style='color:red;'><b>^ Fix things! ^</b></span><br>"

		. += "<a href='?src=\ref[src];add_trait=[POSITIVE_MODE]'>Positive Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.pos_traits)
			var/datum/trait/trait = positive_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_pos_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
		. += "</ul>"

		. += "<a href='?src=\ref[src];add_trait=[NEGATIVE_MODE]'>Negative Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.neg_traits)
			var/datum/trait/trait = negative_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_neg_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
		. += "</ul>"

		. += "<a href='?src=\ref[src];add_trait=[NEUTRAL_MODE]'>Neutral Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.neu_traits)
			var/datum/trait/trait = neutral_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_neu_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
		. += "</ul>"
	else
		. += "<a href='?src=\ref[src];add_trait=[ALL_MODE]'>Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.neu_traits)
			var/datum/trait/trait = neutral_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_neu_trait=[T]'>[trait.name]</a></li>"
		for(var/T in pref.neg_traits)
			var/datum/trait/trait = negative_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_neg_trait=[T]'>[trait.name]</a></li>"
		. += "</ul>"

	var/list/id_traits = list()
	for(var/path in pref.pos_traits + pref.neg_traits + pref.neu_traits)
		var/datum/trait/T = all_traits[path]
		if(istype(T) && T.extra_id_info)
			id_traits |= T

	if(length(id_traits))
		. += "<b>ID-visible Traits</b>"
		. += "<ul>"
		for(var/datum/trait/T in id_traits)
			if(T.extra_id_info_optional)
				. += "<li>- <a href='?src=\ref[src];id_info_toggle=[T.type]'>[T.name][(T.type in pref.id_hidden_traits) ? " (HIDDEN)" : ""]</a></li>"
			else
				. += "<li>- [T.name]</li>"
		. += "</ul>"
		. += "<br>"

	. += "<b>Blood Color: </b>" //People that want to use a certain species to have that species traits (xenochimera/promethean/spider) should be able to set their own blood color.
	. += "<a href='?src=\ref[src];blood_color=1'>Set Color</a>"
	. += "<a href='?src=\ref[src];blood_reset=1'>R</a><br>"
	. += "<br>"

	. += "<b>Custom Say: </b>"
	. += "<a href='?src=\ref[src];custom_say=1'>Set Say Verb</a><br>"
	. += "<b>Custom Whisper: </b>"
	. += "<a href='?src=\ref[src];custom_whisper=1'>Set Whisper Verb</a><br>"
	. += "<b>Custom Ask: </b>"
	. += "<a href='?src=\ref[src];custom_ask=1'>Set Ask Verb</a><br>"
	. += "<b>Custom Exclaim: </b>"
	. += "<a href='?src=\ref[src];custom_exclaim=1'>Set Exclaim Verb</a><br>"

/datum/category_item/player_setup_item/vore/traits/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return PREFERENCES_NOACTION

	else if(href_list["custom_species"])
		/*if(pref.species != SPECIES_CUSTOM)
			alert("You cannot set a custom species name unless you set your character to use the 'Custom Species' \
			species on the 'General' tab. If you have this set to something, it's because you had it set before the \
			Trait system was implemented. If you wish to change it, set your species to 'Custom Species' and configure \
			the species completely.")
			return PREFERENCES_REFRESH*/ //There was no reason to have this.
		var/raw_choice = sanitize(input(user, "Input your custom species name:",
			"Character Preference", pref.custom_species) as null|text, MAX_NAME_LEN)
		if (CanUseTopic(user))
			pref.custom_species = raw_choice
		return PREFERENCES_REFRESH

	else if(href_list["custom_base"])
		var/list/choices = SScharacters.custom_species_bases
		if(pref.real_species_id() != SPECIES_CUSTOM)
			choices = (choices | pref.real_species_name())
		var/text_choice = input("Pick an icon set for your species:","Icon Base") in choices
		if(text_choice in choices)
			pref.custom_base = text_choice
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_color"])
		var/color_choice = input("Pick a blood color (does not apply to synths)","Blood Color",pref.blood_color) as color
		if(color_choice)
			pref.blood_color = sanitize_hexcolor(color_choice, 6, TRUE, default = "#A10808")
		return PREFERENCES_REFRESH

	else if(href_list["blood_reset"])
		var/choice = alert("Reset blood color to human default (#A10808)?","Reset Blood Color","Reset","Cancel")
		if(choice == "Reset")
			pref.blood_color = "#A10808"
		return PREFERENCES_REFRESH

	else if(href_list["clicked_pos_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_pos_trait"])
		var/choice = alert("Remove [initial(trait.name)] and regain [initial(trait.cost)] points?","Remove Trait","Remove","Cancel")
		if(choice == "Remove")
			pref.pos_traits -= trait
		return PREFERENCES_REFRESH

	else if(href_list["clicked_neu_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neu_trait"])
		var/choice = alert("Remove [initial(trait.name)]?","Remove Trait","Remove","Cancel")
		if(choice == "Remove")
			pref.neu_traits -= trait
		return PREFERENCES_REFRESH

	else if(href_list["clicked_neg_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neg_trait"])
		var/choice = alert("Remove [initial(trait.name)] and lose [initial(trait.cost)] points?","Remove Trait","Remove","Cancel")
		if(choice == "Remove")
			pref.neg_traits -= trait
		return PREFERENCES_REFRESH

	else if(href_list["id_info_toggle"])
		var/datum/trait/trait = all_traits[text2path(href_list["id_info_toggle"])]
		if(!istype(trait))
			to_chat(user, SPAN_WARNING("???"))
			return PREFERENCES_REFRESH
		if(!(trait.type in pref.id_hidden_traits))
			pref.id_hidden_traits |= trait.type
			to_chat(user, SPAN_NOTICE("[trait.name] is now hidden from your ID."))
		else
			pref.id_hidden_traits -= trait.type
			to_chat(user, "<span class='notice'>[trait.name] will now be shown on your ID. It will read as: \"</span>[trait.extra_id_info]<span class='notice'>\"</span>")
		return PREFERENCES_REFRESH

	else if(href_list["custom_say"])
		var/say_choice = sanitize(input(usr, "This word or phrase will appear instead of 'says': [pref.real_name] says, \"Hi.\"", "Custom Say", pref.custom_say) as null|text, 12)
		if(say_choice)
			pref.custom_say = say_choice
		return PREFERENCES_REFRESH

	else if(href_list["custom_whisper"])
		var/whisper_choice = sanitize(input(usr, "This word or phrase will appear instead of 'whispers': [pref.real_name] whispers, \"Hi...\"", "Custom Whisper", pref.custom_whisper) as null|text, 12)
		if(whisper_choice)
			pref.custom_whisper = whisper_choice
		return PREFERENCES_REFRESH

	else if(href_list["custom_ask"])
		var/ask_choice = sanitize(input(usr, "This word or phrase will appear instead of 'asks': [pref.real_name] asks, \"Hi?\"", "Custom Ask", pref.custom_ask) as null|text, 12)
		if(ask_choice)
			pref.custom_ask = ask_choice
		return PREFERENCES_REFRESH

	else if(href_list["custom_exclaim"])
		var/exclaim_choice = sanitize(input(usr, "This word or phrase will appear instead of 'exclaims', 'shouts' or 'yells': [pref.real_name] exclaims, \"Hi!\"", "Custom Exclaim", pref.custom_exclaim) as null|text, 12)
		if(exclaim_choice)
			pref.custom_exclaim = exclaim_choice
		return PREFERENCES_REFRESH

	else if(href_list["add_trait"])
		var/mode = text2num(href_list["add_trait"])

		var/available_traits = compute_available_traits()
		var/constraints = compute_constraints()
		var/tgui_data = compute_tgui_data(mode, available_traits, constraints)
		var/traits_submission = tgui_trait_select(user, tgui_data)
		if (traits_submission != null)
			apply_traits(FALSE, traits_submission, available_traits, constraints)

		return PREFERENCES_REFRESH

	return ..()

/datum/category_item/player_setup_item/vore/traits/proc/trait_exclusions(var/possible_traits)
	// NOTE: This should ideally be cached
	var/list/var_exclude_groups = list()
	for (var/trait_path in possible_traits)
		var/datum/trait/trait = possible_traits[trait_path]
		for(var/v in trait.var_changes)
			if (!var_exclude_groups[v])
				var_exclude_groups[v] = list()
			var_exclude_groups[v] += trait_path

	var/list/explicit_excludes = list()
	for (var/trait_path in possible_traits)
		explicit_excludes[trait_path] = list()

	for (var/trait_path in possible_traits)
		var/datum/trait/trait = possible_traits[trait_path]
		for(var/other_path in trait.excludes)
			var other = possible_traits[other_path]

			if (other)
				explicit_excludes[trait_path] += list(other_path)
				explicit_excludes[other_path] += list(trait_path)

	var/list/total_excludes = list()
	for (var/trait_path in possible_traits)
		var/datum/trait/trait = possible_traits[trait_path]
		total_excludes[trait_path] = list()

		for (var/other_path in explicit_excludes[trait_path])
			total_excludes[trait_path][other_path] = TRUE

		for (var/v in trait.var_changes)
			for (var/other_path in var_exclude_groups[v])
				if (other_path == trait_path)
					continue

				total_excludes[trait_path][other_path] = TRUE

	return total_excludes

/datum/category_item/player_setup_item/vore/traits/proc/compute_available_traits()
	var/species = pref.real_species_name()
	var/species_id = pref.real_species_id()
	var/possible_traits = positive_traits.Copy() + neutral_traits.Copy() + negative_traits.Copy()

	var/list/available_traits = list()

	var/exclusions = trait_exclusions(possible_traits)

	for (var/trait_path in possible_traits)
		var/datum/trait/trait = possible_traits[trait_path]
		var/datum/traits_available_trait/available_trait = new

		available_trait.internal_name = trait_path
		available_trait.real_record = trait
		available_trait.cost = trait.cost

		var/species_is_not_in_allowed = LAZYLEN(trait.allowed_species) && !(species in trait.allowed_species)
		var/species_is_in_excluded = LAZYLEN(trait.excluded_species) && (species in trait.excluded_species)
		if (species_is_not_in_allowed || species_is_in_excluded)
			available_trait.forbidden_reason = "This trait is not allowed for your species."

		// NOTE: For some reason, this is only actually used for neutral traits??? Weird.
		if (species_id != SPECIES_ID_CUSTOM)
			if ((trait_path in positive_traits) || ((trait_path in neutral_traits) && trait.custom_only))
				available_trait.forbidden_reason = "This trait is only allowed for custom species."

		available_trait.exclusive_with = exclusions[trait_path]

		available_traits[trait_path] = available_trait

	return available_traits

/datum/category_item/player_setup_item/vore/traits/proc/compute_constraints()
	var/datum/traits_constraints/constraints = new

	constraints.max_traits = pref.max_traits
	constraints.max_points = pref.starting_trait_points

	return constraints

/datum/category_item/player_setup_item/vore/traits/proc/compute_tgui_data(mode, list/available_traits, datum/traits_constraints/constraints)
	var/initial_traits_json = list()
	var/list/trait_groups_json = list()
	var/list/available_traits_json = list()
	var/constraints_json = list()

	initial_traits_json = pref.neg_traits.Copy() + pref.neu_traits.Copy() + pref.pos_traits.Copy()

	for (var/trait_group_path in all_trait_groups)
		var/datum/trait_group/trait_group = all_trait_groups[trait_group_path]
		var/list/trait_group_json = list()

		trait_group_json["internal_name"] = trait_group_path
		trait_group_json["name"] = trait_group.name
		trait_group_json["description"] = trait_group.desc
		trait_group_json["sort_key"] = trait_group.sort_key

		trait_groups_json[trait_group_path] = trait_group_json

	for (var/trait_path in available_traits)
		var/datum/traits_available_trait/trait = available_traits[trait_path]
		var/list/available_trait_json = list()

		available_trait_json["internal_name"] = trait.internal_name
		available_trait_json["name"] = trait.real_record.name
		available_trait_json["group"] = trait.real_record.group
		available_trait_json["group_short_name"] = trait.real_record.group_short_name
		available_trait_json["sort_key"] = trait.real_record.sort_key
		available_trait_json["description"] = trait.real_record.desc
		available_trait_json["cost"] = trait.cost
		available_trait_json["forbidden_reason"] = trait.forbidden_reason
		available_trait_json["show_when_forbidden"] = trait.real_record.show_when_forbidden
		available_trait_json["exclusive_with"] = trait.exclusive_with

		available_traits_json[trait_path] = available_trait_json

	// NOTE: Confusingly, only positive or negative traits are counted towards pref.max_traits
	constraints_json["max_traits"] = constraints.max_traits
	constraints_json["max_points"] = constraints.max_points

	. = list()
	.["initial_traits"] = initial_traits_json
	.["trait_groups"] = trait_groups_json
	.["available_traits"] = available_traits_json
	.["constraints"] = constraints_json

/datum/category_item/player_setup_item/vore/traits/proc/apply_traits(allow_invalid, new_trait_paths, available_traits, datum/traits_constraints/constraints)
	// allow_invalid: used by sanitize_character()
	// if true, try as hard as possible to fix the traits rather than rejecting the update if it's bad

	// dedupe traits and deal with exclusion, forbiddenness, and so on
	// new traits
	var/list/traits_to_apply = list()
	var/list/excluded = list()

	// set to true if the input is invalid
	var/input_was_invalid = FALSE

	for (var/new_trait_path in new_trait_paths)
		var/datum/traits_available_trait/new_trait_record = available_traits[new_trait_path]
		if (!new_trait_record)
			input_was_invalid = TRUE
			continue

		if(new_trait_record.forbidden_reason)
			// skip forbidden traits
			input_was_invalid = TRUE
			continue

		if(excluded[new_trait_path])
			// and excluded traits
			input_was_invalid = TRUE
			continue

		// each trait excludes itself (to deduplicate)
		excluded[new_trait_path] = TRUE
		for(var/i in new_trait_record.exclusive_with)
			excluded[i] = TRUE

		traits_to_apply += list(new_trait_path)

	var/n_traits = 0
	var/total_cost = 0
	for (var/new_trait_path in traits_to_apply)
		// neutral traits don't count towards number
		if (new_trait_path in neutral_traits)
			continue

		n_traits += 1

	for (var/new_trait_path in traits_to_apply)
		var/datum/traits_available_trait/new_trait_record = available_traits[new_trait_path]
		total_cost += new_trait_record.cost

	if (n_traits > constraints.max_traits)
		input_was_invalid = TRUE

	if (total_cost > constraints.max_points)
		input_was_invalid = TRUE

	if (input_was_invalid)
		if (!allow_invalid)
			return

	pref.pos_traits = list()
	pref.neu_traits = list()
	pref.neg_traits = list()
	for (var/trait in traits_to_apply)
		if (positive_traits[trait])
			pref.pos_traits += trait
		else if (neutral_traits[trait])
			pref.neu_traits += trait
		else if (negative_traits[trait])
			pref.neg_traits += trait
		else
			// ???: Should this alert somehow?

/datum/category_item/player_setup_item/vore/traits/proc/tgui_trait_select(mob/user, trait_data)
	var/datum/tgui_trait_selector/selector = new(user, trait_data)

	selector.ui_interact(user)
	selector.wait()
	if (selector)
		. = selector.submission
		qdel(selector)


/datum/tgui_trait_selector
	/// The selector input data
	var/list/input_data
	/// The user's submitted trait choices
	var/submission
	/// Boolean field describing if the tgui_trait-selector was closed by the user.
	var/closed

/datum/tgui_trait_selector/New(mob/user, input_data)
	src.input_data = input_data

/datum/tgui_trait_selector/Destroy()
	SStgui.close_uis(src)
	. = ..()

/datum/tgui_trait_selector/proc/wait()
	while (!submission && !closed)
		stoplag(1)

/datum/tgui_trait_selector/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new (user, src, "TraitSelectorModal")
		ui.open()

/datum/tgui_trait_selector/on_ui_close(mob/user, datum/tgui/ui, embedded)
	. = ..()
	closed = TRUE

/datum/tgui_trait_selector/ui_state()
	return GLOB.always_state

/datum/tgui_trait_selector/ui_static_data(mob/user, datum/tgui/ui)
	. = src.input_data

/datum/tgui_trait_selector/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if (.)
		return
	switch(action)
		if("submit")
			if (!validate_and_use_submission(params["entry"]))
				return
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

/datum/tgui_trait_selector/proc/validate_and_use_submission(submission_text)
	// Validate basic format: actual validity of choices is up to our host
	var/possible_submission = json_decode(submission_text)
	if (!islist(possible_submission))
		return

	var/traits = possible_submission["traits"]
	if (traits == null)  // distinguish null from empty list
		return

	var/trait_paths = list()
	for (var/trait_text in traits)  // list must be all text
		if (!istext(trait_text))
			return

		var/trait_path = text2path(trait_text)
		if (!trait_path)
			return
		trait_paths += trait_path

	submission = trait_paths
	return TRUE

#undef POSITIVE_MODE
#undef NEUTRAL_MODE
#undef NEGATIVE_MODE
#undef ALL_MODE
