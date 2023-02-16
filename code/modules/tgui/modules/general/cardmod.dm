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
	tgui_id = "UICardMod"

/**
 * are we allowed to edit the given accesses?
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * accesses - (optional) accesses being edited as list
 */
/datum/tgui_module/card_mod/proc/auth_access_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/accesses)
	return FALSE

/**
 * are we allowed to switch someone to a rank?
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 * * old_rank - (optional) old rank to edit from
 * * new_rank - (optional) new rank to edit to
 */
/datum/tgui_module/card_mod/proc/auth_rank(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank, new_rank)
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
 */
/datum/tgui_module/card_mod/proc/query_access_ids(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	return list()

/**
 * return access type flags we can edit
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 */
/datum/tgui_module/card_mod/proc/query_access_types(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	return ACCESS_TYPE_NONE

/**
 * return access region flags we can edit
 *
 * @params
 * * user - user of UI
 * * editing - (optional) card being edited
 * * authing - (optional) card authorizing the edit
 */
/datum/tgui_module/card_mod/proc/query_access_regions(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	return ACCESS_REGION_NONE

/**
 * returns target id to edit
 */
/datum/tgui_module/cardmod/proc/edit_target()
	return null

/datum/tgui_module/card_mod/static_data(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	. = ..()
	.["access"] = SSjob.tgui_access_data()
	.["modify_type"] = query_access_types(user, editing, authing)
	.["modify_region"] = query_access_regions(user, editing, authing)
	.["modify_ids"] = query_access_ids(user, editing, authing)
	.["modify_account"] = auth_account_edit(user, editing, authing)
	.["can_demote"] = auth_demote(user, editing, authing)
	.["can_rename"] = auth_rename(user, editing, authing)
	.["rank"] = query_ranks(user, editing, authing)

/datum/tgui_module/card_mod/data(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	. = ..()
	.["card_account"] = editing.associated_account_number
	.["card_name"] = editing.registered_name
	.["card_rank"] = editing.rank
	.["granted"] = editing.access

/datum/tgui_module/card_mod/standard

/datum/tgui_module/card_mod/standard/query_access_ids(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	. = ..()

/datum/tgui_module/card_mod/standard/query_access_types(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	. = ..()

/datum/tgui_module/card_mod/standard/query_access_regions(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	. = ..()

/datum/tgui_module/card_mod/standard/query_ranks(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	. = ..()

/datum/tgui_module/card_mod/standard/auth_access_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/accesses)
	. = ..()

/datum/tgui_module/card_mod/standard/auth_account_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_number, new_number)
	. = ..()

/datum/tgui_module/card_mod/standard/auth_demote(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank)
	. = ..()

/datum/tgui_module/card_mod/standard/auth_rank(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank, new_rank)
	. = ..()

/datum/tgui_module/card_mod/standard/id_computer
	expected_type = /obj/machinery/computer/card

/datum/tgui_module/card_mod/standard/id_computer/edit_target()
	var/obj/machinery/computer/card/target = host
	return target.editing

/datum/tgui_module/card_mod/admin

/datum/tgui_module/card_mod/admin/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.admin_state


/datum/tgui_module/card_mod/admin/query_access_ids(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	return SSjob.access_ids()

/datum/tgui_module/card_mod/admin/query_access_types(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	return ACCESS_TYPE_ALL

/datum/tgui_module/card_mod/admin/query_access_regions(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	return ACCESS_REGION_ALL

/datum/tgui_module/card_mod/admin/query_ranks(mob/user, obj/item/card/id/editing, obj/item/card/id/authing)
	#warn impl

/datum/tgui_module/card_mod/admin/auth_access_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, list/accesses)
	return TRUE

/datum/tgui_module/card_mod/admin/auth_account_edit(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_number, new_number)
	return TRUE

/datum/tgui_module/card_mod/admin/auth_demote(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank)
	return TRUE

/datum/tgui_module/card_mod/admin/auth_rank(mob/user, obj/item/card/id/editing, obj/item/card/id/authing, old_rank, new_rank)
	return TRUE

/datum/tgui_module/card_mod/admin/vv
	ephemeral = TRUE
	autodel = TRUE
	expected_type = /obj/item/card/id

/datum/tgui_module/card_mod/admin/vv/edit_target()
	return host
