var/global/const/base_law_type = /datum/ai_lawset/nanotrasen

/mob/living/silicon/proc/sync_zeroth(var/datum/ai_law/zeroth_law, var/datum/ai_law/zeroth_law_borg)
	if (!is_malf_or_traitor(src))
		if(zeroth_law_borg)
			laws.set_zeroth_law(zeroth_law_borg.law)
		else if(zeroth_law)
			laws.set_zeroth_law(zeroth_law.law)

/mob/living/silicon/ai/sync_zeroth(var/datum/ai_law/zeroth_law, var/datum/ai_law/zeroth_law_borg)
	if(zeroth_law)
		laws.set_zeroth_law(zeroth_law.law, zeroth_law_borg ? zeroth_law_borg.law : null)

