//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_panel/economy_manager
	name = "Economy Manager"
	tgui_interface = "AdminEconomyManager"

/datum/admin_panel/economy_manager/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_panel/economy_manager/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_panel/economy_manager/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_panel/economy_manager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/target_account_id = params["accountId"]
	var/target_account_key = params["accountKey"]
	var/target_faction_id = params["factionId"]

	switch(action)
		if("setAccBalance", "adjustAccBalance")
		if("setAccSecurityPasskey")
		if("setAccSecurityLevel")
		if("setAccSecurityLock")
		if("setAccProtected")
		if("setAccFaction")
		if("setAccFactionKey")
		if("setAccFluffOwnerName")
		// swiss army knife, erases audit logs and condenses balance changes to make it
		// seem like a continuous history
		if("truncateAccAuditLogs")

#warn impl
