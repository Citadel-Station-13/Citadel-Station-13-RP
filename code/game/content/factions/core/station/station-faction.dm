//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/world_faction/core/station
	name = "Station"
	id = "station"
	desc = "The main map. You shouldn't be able to see this. This is always active."

	c_economy = /datum/economy_faction/station

/datum/world_faction/core/station/post_prime()
	// todo: pull based on the active map
	var/datum/world_faction/station_sponsor = SSgame_world.resolve_faction(/datum/world_faction/corporation/nanotrasen)
	var/datum/economy_faction/station_sponsor_economy = station_sponsor.c_economy

	var/datum/economy_account/station_account = SSeconomy.allocate_account(
		for_faction = c_economy,
		with_key = "station",
	)
	station_account.fluff_owner_name = "Station Account"
	station_account.randomize_credentials()
	var/station_account_starting_balance = ECONOMY_BASE_BALANCE_FOR_STATION
	var/datum/economy_transaction/station_account_transaction = new(station_account_starting_balance)
	station_account_transaction.audit_terminal_as_unsafe_html = station_sponsor_economy.random_ephemeral_terminal_name()
	station_account_transaction.audit_purpose_as_unsafe_html = "Account creation"
	station_account_transaction.audit_peer_name_as_unsafe_html = "[station_sponsor.name]"
	station_account_transaction.execute_system_transaction(station_account)

	for(var/datum/department/station/station_department in SSjob.department_datums)
		var/datum/economy_account/department_account = SSeconomy.allocate_account(
			for_faction = c_economy,
			with_key = "station",
		)
		department_account.randomize_credentials()
		department_account.fluff_owner_name = "[station_department.name] Account"
		var/department_account_starting_balance = ECONOMY_BASE_BALANCE_FOR_DEPARTMENT
		var/datum/economy_transaction/department_account_transaction = new(department_account_starting_balance)
		department_account_transaction.audit_terminal_as_unsafe_html = station_sponsor_economy.random_ephemeral_terminal_name()
		department_account_transaction.audit_purpose_as_unsafe_html = "Account creation"
		department_account_transaction.audit_peer_name_as_unsafe_html = "[station_sponsor.name]"
		department_account_transaction.execute_system_transaction(department_account)

#warn impl
