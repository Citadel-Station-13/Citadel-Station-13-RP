/**
 * ID mod module
 *
 * Procs you have to override:
 * * auth_access_edit
 * * auth_rank
 * * auth_demote
 * * auth_account_edit
 * * auth_rename
 * * query_access_ids
 * * query_access_types
 * * query_access_regions
 * * query_ranks
 * * edit_target
 *
 * You should update UI static data when:
 * * When the editing or authing ID is being switched
 * * When the authing ID has its access or rank change
 * * When the editing ID has its access or rank change
 *
 * Additional params for static data:
 * * editing - /obj/item/card/id that's being edited
 * * authing - /obj/item/card/id that's being used to auth
 *
 * Additional params for data:
 * * editing - /obj/item/card/id that's being edited
 * * authing - /obj/item/card/id that's being used to auth
 */
/datum/tgui_module/card_mod
	tgui_id = "TGUICardMod"

/**
 * are we allowed to edit the given accesses?
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * accesses - (optional) accesses being edited as list
 *
 * @return values we were allowed to edit
 */
/datum/tgui_module/card_mod/proc/auth_access_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/accesses)
	return list()

/**
 * are we allowed to switch someone to a rank?
 *
 * called with rank / assignments as null for a generic "can we edit at all"
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * old_rank - (optional) old rank to edit from
 * * new_rank - (optional) new rank to edit to
 * * old_assignment - (optional) old assignment to edit from
 * * new_assignment - (optional) new assignment to edit to
 */
/datum/tgui_module/card_mod/proc/auth_rank(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank, new_rank, old_assignment, new_assignment)
	return FALSE

/**
 * are we allowed to demote someone to Unassigned?
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * old_rank - (optional) old rank being demoted from
 */
/datum/tgui_module/card_mod/proc/auth_demote(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank)
	return FALSE

/**
 * what are the valid ranks we can grant?
 *
 * @return list of department name = list(rank names)
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 */
/datum/tgui_module/card_mod/proc/query_ranks(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	return list()

/**
 * are we allowed to edit accounts? both params null for UI check
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * old_number - (optional) old account number
 * * new_number - (optional) new account number
 */
/datum/tgui_module/card_mod/proc/auth_account_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_number, new_number)
	return FALSE

/**
 * are we allowed to edit names? both params null for UI check
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * old_name - (optional) old name
 * * new_name - (optional) new name
 */
/datum/tgui_module/card_mod/proc/auth_rename(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_name, new_name)
	return FALSE

/**
 * return list of accesses we can edit in addition to our type / region
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * direct - (optional) direct list of relevant access ids to check for speed
 */
/datum/tgui_module/card_mod/proc/query_access_ids(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	return list()

/**
 * return access type flags we can edit
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * direct - (optional) direct list of relevant access ids to check for speed
 */
/datum/tgui_module/card_mod/proc/query_access_types(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	return ACCESS_TYPE_NONE

/**
 * return access region flags we can edit
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * direct - (optional) direct list of relevant access ids to check for speed
 */
/datum/tgui_module/card_mod/proc/query_access_regions(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	return ACCESS_REGION_NONE

/**
 * return access categories we can edit
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * direct - (optional) direct list of relevant access ids to check for speed
 */
/datum/tgui_module/card_mod/proc/query_access_categories(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	return list()

/**
 * returns target id to edit
 */
/datum/tgui_module/card_mod/proc/edit_target()
	return null

/**
 * return source id to auth with
 */
/datum/tgui_module/card_mod/proc/auth_source()
	return null

/datum/tgui_module/card_mod/static_data(mob/user, obj/item/card/id/editing = edit_target(), obj/item/card/id/authing = auth_source())
	. = ..()
	.["access"] = SSjob.tgui_access_data()
	var/list/direct_cache = ((authing?.access || list()) & SSjob.cached_access_edit_relevant)
	.["modify_type"] = query_access_types(user, editing, authing, direct_cache)
	.["modify_region"] = query_access_regions(user, editing, authing, direct_cache)
	.["modify_ids"] = query_access_ids(user, editing, authing, direct_cache)
	.["modify_cats"] = query_access_categories(user, editing, authing, direct_cache)
	.["modify_account"] = auth_account_edit(user, editing, authing)
	.["can_rename"] = auth_rename(user, editing, authing)
	.["can_rank"] = auth_rank(user, editing, authing)
	var/list/ranks_by_department = query_ranks(user, editing, authing)
	var/list/built_department = list()
	.["ranks"] = built_department
	for(var/department in ranks_by_department)
		built_department += list(list(
			"name" = department,
			"ranks" = ranks_by_department[department],
		))

/datum/tgui_module/card_mod/data(mob/user, obj/item/card/id/editing = edit_target(), obj/item/card/id/authing = auth_source())
	. = ..()
	.["card_account"] = editing?.associated_account_number
	.["card_name"] = editing?.registered_name
	.["card_rank"] = editing?.rank
	.["card_assignment"] = editing?.assignment
	.["granted"] = editing?.access
	.["can_demote"] = auth_demote(user, editing, authing, editing.rank)

/datum/tgui_module/card_mod/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/obj/item/card/id/target = edit_target()
	var/obj/item/card/id/source = auth_source()
	switch(action)
		if("account")
			if(!target)
				return TRUE
			var/number = text2num(params["set"])
			if(auth_account_edit(usr, target, source, target.associated_account_number, number))
				target.associated_account_number = number
			return TRUE
		if("name")
			if(!target)
				return TRUE
			var/new_name = params["set"]
			if(auth_rename(usr, target, source, target.registered_name, new_name))
				reassign_name(target, target.registered_name, new_name)
			return TRUE
		if("demote")
			if(!target)
				return TRUE
			if(auth_demote(usr, target, source, target.rank))
				reassign_rank(target, "Unassigned", "Unassigned", target.registered_name)
				target.access = list()
			return TRUE
		if("rank")
			if(!target)
				return TRUE
			var/rank = params["rank"]
			if(auth_rank(usr, target, source, old_rank = target.rank, new_rank = rank))
				reassign_rank(target, rank, rank, target.registered_name)
				target.access = SSjob.job_by_title(rank)?.get_access() || list()
			return TRUE
		if("rank_custom")
			if(!target)
				return TRUE
			var/rank = params["rank"]
			if(auth_rank(usr, target, source, old_rank = target.rank, new_rank = rank))
				reassign_rank(target, rank, rank, target.registered_name)
			return TRUE
		if("assignment")
			if(!target)
				return TRUE
			var/assignment = params["set"]
			if(auth_rank(usr, target, source, old_assignment = target.assignment, new_assignment = assignment))
				reassign_rank(target, target.rank, assignment, target.registered_name)
			return TRUE
		if("grant")
			if(!target)
				return TRUE
			var/cat = params["cat"]
			var/list/resultant = auth_access_edit(usr, target, source, cat? SSjob.access_ids_of_category(cat) : SSjob.access_ids())
			LAZYINITLIST(target.access)
			target.access |= resultant
			return TRUE
		if("deny")
			if(!target)
				return TRUE
			var/cat = params["cat"]
			var/list/resultant = auth_access_edit(usr, target, source, cat? SSjob.access_ids_of_category(cat) : SSjob.access_ids())
			LAZYINITLIST(target.access)
			target.access -= resultant
			return TRUE
		if("toggle")
			if(!target)
				return TRUE
			var/id = text2num(params["access"])
			if(!id)
				return TRUE
			var/list/resultant = auth_access_edit(usr, target, source, list(id))
			LAZYINITLIST(target.access)
			target.access ^= resultant
			return TRUE

/datum/tgui_module/card_mod/proc/reassign_rank(obj/item/card/id/the_card, new_rank, new_assignment, their_name)
	data_core.manifest_modify(their_name, new_assignment, new_rank)
	the_card.set_registered_rank(new_rank, new_assignment)

/datum/tgui_module/card_mod/proc/reassign_name(obj/item/card/id/the_card, old_name, new_name)
	the_card.set_registered_name(new_name)

/**
 * standard implementation of card_mod modules
 * uses standard checks for ID edit auth.
 */
/datum/tgui_module/card_mod/standard

/datum/tgui_module/card_mod/standard/query_access_ids(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	. = list()
	for(var/id in direct || (((authing?.access || list())) & SSjob.cached_access_edit_relevant))
		var/datum/access/A = SSjob.access_lookup(id)
		if(isnull(A.access_edit_list))
			continue
		. |= A.access_edit_list

/datum/tgui_module/card_mod/standard/query_access_types(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	. = NONE
	for(var/id in direct || (((authing?.access || list())) & SSjob.cached_access_edit_relevant))
		var/datum/access/A = SSjob.access_lookup(id)
		. |= A.access_edit_type

/datum/tgui_module/card_mod/standard/query_access_categories(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	. = list()
	for(var/id in direct || (((authing?.access || list())) & SSjob.cached_access_edit_relevant))
		var/datum/access/A = SSjob.access_lookup(id)
		. |= A.access_edit_category

/datum/tgui_module/card_mod/standard/query_access_regions(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	. = NONE
	for(var/id in direct || (((authing?.access || list())) & SSjob.cached_access_edit_relevant))
		var/datum/access/A = SSjob.access_lookup(id)
		if(isnull(A.access_edit_region))
			continue
		. |= A.access_edit_region

/datum/tgui_module/card_mod/standard/query_ranks(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	. = list()
	if(ACCESS_COMMAND_CARDMOD in authing?.access)
		for(var/datum/role/job/J as anything in SSjob.all_jobs(JOB_FACTION_STATION))
			var/dep_name = (length(J.departments) && J.departments[1]) || "Miscellaneous"
			LAZYINITLIST(.[dep_name])
			.[dep_name] += J.title
	else
		var/datum/role/job/J = SSjob.job_by_title(authing?.rank)
		for(var/dep_name in J?.departments_managed)
			var/datum/department/D = SSjob.department_datums[dep_name]
			if(isnull(D))
				continue
			var/list/ranks = list()
			.[D.name] = ranks
			for(var/title in D.primary_jobs)
				ranks += title

/datum/tgui_module/card_mod/standard/auth_access_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/accesses)
	. = list()
	var/list/left = accesses.Copy()
	for(var/id in authing?.access)
		var/list/allowed = SSjob.editable_access_ids_by_id(id)
		if(isnull(allowed))
			continue
		var/list/got = allowed & accesses
		if(!length(got))
			continue
		left -= got
		. += got

/datum/tgui_module/card_mod/standard/auth_account_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_number, new_number)
	return (ACCESS_COMMAND_BANKING in authing?.access)

/datum/tgui_module/card_mod/standard/auth_rename(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_name, new_name)
	return (ACCESS_COMMAND_CARDMOD in authing?.access)

/datum/tgui_module/card_mod/standard/auth_demote(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank)
	if(isnull(authing))
		return FALSE
	if(ACCESS_COMMAND_CARDMOD in authing.access)
		return TRUE
	var/datum/role/job/authing_job = SSjob.job_by_title(authing.rank)
	if(isnull(authing_job))
		return FALSE
	var/datum/role/job/victim_job = SSjob.job_by_title(old_rank)
	if(isnull(victim_job))
		return FALSE
	return victim_job.departments & authing_job.departments_managed

/datum/tgui_module/card_mod/standard/auth_rank(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank, new_rank, old_assignment, new_assignment)
	if(isnull(authing))
		return FALSE
	if(ACCESS_COMMAND_CARDMOD in authing.access)
		return TRUE
	if(isnull(new_rank)) // generic query
		return FALSE
	var/datum/role/job/authing_job = SSjob.job_by_title(authing.rank)
	if(isnull(authing_job))
		return FALSE
	var/datum/role/job/old_job = SSjob.job_by_title(old_rank)
	if(isnull(old_job))
		return FALSE
	if(!length(old_job.departments & authing_job.departments_managed))
		return FALSE
	var/datum/role/job/new_job = SSjob.job_by_title(new_rank)
	if(isnull(new_job))
		return FALSE
	if(!length(new_job.departments & authing_job.departments_managed))
		return FALSE
/datum/tgui_module/card_mod/standard/id_computer
	expected_type = /obj/machinery/computer/card

/datum/tgui_module/card_mod/standard/id_computer/edit_target()
	var/obj/machinery/computer/card/target = host
	return target.editing

/datum/tgui_module/card_mod/standard/id_computer/auth_source()
	var/obj/machinery/computer/card/target = host
	return target.authing

/**
 * admin implementation of card_mod modules
 * allows editing of anything.
 */
/datum/tgui_module/card_mod/admin

/datum/tgui_module/card_mod/admin/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.admin_state


/datum/tgui_module/card_mod/admin/query_access_ids(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	return SSjob.access_ids()

/datum/tgui_module/card_mod/admin/query_access_types(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	return ACCESS_TYPE_ALL

/datum/tgui_module/card_mod/admin/query_access_regions(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/direct)
	return ACCESS_REGION_ALL

/datum/tgui_module/card_mod/admin/query_ranks(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	. = list()
	for(var/datum/role/job/J as anything in SSjob.all_jobs())
		var/dep_name = (length(J.departments) && J.departments[1]) || "Miscellaneous"
		LAZYINITLIST(.[dep_name])
		.[dep_name] += J.title

/datum/tgui_module/card_mod/admin/auth_access_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/accesses)
	return accesses

/datum/tgui_module/card_mod/admin/auth_account_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_number, new_number)
	return TRUE

/datum/tgui_module/card_mod/admin/auth_demote(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank)
	return TRUE

/datum/tgui_module/card_mod/admin/auth_rank(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank, new_rank, old_assignment, new_assignment)
	return TRUE

/datum/tgui_module/card_mod/admin/auth_rename(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_name, new_name)
	return TRUE

/**
 * used for vv on id cards
 */
/datum/tgui_module/card_mod/admin/card_vv
	ephemeral = TRUE
	autodel = TRUE
	expected_type = /obj/item/card/id

/datum/tgui_module/card_mod/admin/card_vv/edit_target()
	return host
