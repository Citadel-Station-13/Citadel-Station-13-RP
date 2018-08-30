/datum/objective/consume

/datum/objective/consume/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in ticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2) && (possible_target.current.vantag_pref == VANTAG_VORE))
			possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	if(target && target.current)
		explanation_text = "[target.current.real_name], the [target.assigned_role], needs to be taught their place. Make sure they're inside someone's gut by the end of the shift. Preferably yours."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/consume/find_target_by_role(role, role_type=0)
	for(var/datum/mind/possible_target in ticker.minds)
		if((possible_target != owner) && ishuman(possible_target.current) && ((role_type ? possible_target.special_role : possible_target.assigned_role) == role) && (possible_target.current.vantag_pref == VANTAG_VORE))
			target = possible_target
			break
	if(target && target.current)
		explanation_text = "[target.current.real_name], the [!role_type ? target.assigned_role : target.special_role], needs to be taught their place. Make sure they're inside someone's gut by the end of the shift. Preferably yours."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/consume/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current)) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 0
		if(isbelly(target.loc))
			return 1
	return 0
