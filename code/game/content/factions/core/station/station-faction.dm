//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/world_faction/core/station
	name = "Station"
	id = "station"
	desc = "The main map. You shouldn't be able to see this. This is always active."

/datum/world_faction/core/station/create_economy_faction()
	var/datum/economy_faction/creating = ..()

	#warn impl
	var/datum/economy_account/station_account = SSeconomy.allocate_account(src, /datum/world_faction/core/station::id)
	var/station_account_starting_balance = ECONOMY_BASE_BALANCE_FOR_STATION
	var/datum/economy_transaction/station_account_transaction = new(station_account_starting_balance)

	for(var/datum/department/station/station_department in SSjob.department_datums)
		var/datum/economy_account/department_account = SSeconomy.allocate_account(src, station_department.id)
		var/department_account_starting_balance = ECONOMY_BASE_BALANCE_FOR_DEPARTMENT
		var/datum/economy_transaction/department_account_transaction = new(department_account_starting_balance)

#warn impl
