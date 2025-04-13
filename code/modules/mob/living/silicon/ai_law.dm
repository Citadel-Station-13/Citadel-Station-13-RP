/datum/ai_law
	var/law = ""
	var/index = 0

/datum/ai_law/New(law, index)
	src.law = law
	src.index = index

/datum/ai_law/proc/get_index()
	return index

/datum/ai_law/ion/get_index()
	return ionnum()

/datum/ai_law/zero/get_index()
	return 0

/datum/ai_law/proc/get_state_law(var/datum/ai_lawset/laws)

/datum/ai_law/zero/get_state_law(var/datum/ai_lawset/laws)
	if(src == laws.zeroth_law)
		return laws.state_zeroth

/datum/ai_law/ion/get_state_law(var/datum/ai_lawset/laws)
	return laws.get_state_internal(laws.ion_laws, laws.state_ion, src)

/datum/ai_law/inherent/get_state_law(var/datum/ai_lawset/laws)
	return laws.get_state_internal(laws.inherent_laws, laws.state_inherent, src)

/datum/ai_law/supplied/get_state_law(var/datum/ai_lawset/laws)
	return laws.get_state_internal(laws.supplied_laws, laws.state_supplied, src)

/datum/ai_law/proc/set_state_law(var/datum/ai_lawset/law, var/state)

/datum/ai_law/zero/set_state_law(var/datum/ai_lawset/laws, var/state)
	if(src == laws.zeroth_law)
		laws.state_zeroth = state

/datum/ai_law/ion/set_state_law(var/datum/ai_lawset/laws, var/state)
	laws.set_state_law_internal(laws.ion_laws, laws.state_ion, src, state)

/datum/ai_law/inherent/set_state_law(var/datum/ai_lawset/laws, var/state)
	laws.set_state_law_internal(laws.inherent_laws, laws.state_inherent, src, state)

/datum/ai_law/supplied/set_state_law(var/datum/ai_lawset/laws, var/state)
	laws.set_state_law_internal(laws.supplied_laws, laws.state_supplied, src, state)
