SUBSYSTEM_DEF(economy)
	name = "Economy"

	/// account by text id of account number
	var/list/account_lookup
	/// faction primary account lookup - uses faction id
	var/list/faction_lookup
	/// department primary account lookup - uses department id
	var/list/department_lookup

/datum/controller/subsystem/economy/Recover()
	src.account_lookup = SSeconomy.account_lookup || list()
	return ..()

/datum/controller/subsystem/economy/proc/available_account_number()
	var/found = rand(111111, 999999)
	while(account_lookup[num2text(found, 100)])
		found = rand(111111, 999999)
	return found

/datum/controller/subsystem/economy/proc/create_account()
	var/datum/economy_account/created = new
	created.account_number = available_account_number()
	var/text_id = num2text(created.account_number, 100)
	ASSERT(isnull(account_lookup[text_id]))
	account_lookup[text_id] = created
	return created

/datum/controller/subsystem/economy/proc/fetch_account(number)
	return account_lookup[num2text(number, 100)]

/**
 * fetches the account of a department
 * 
 * returns null if the department does not exist, or the faction is not loaded, or the faction
 * has no economic faction
 */
/datum/controller/subsystem/economy/proc/fetch_department_account(datum/department/path_instance)

/**
 * fetches the account of a faction
 * 
 * returns null if the faction is not loaded, or the faction has no economic faction
 */
/datum/controller/subsystem/economy/proc/fetch_faction_account(datum/faction/id_path_instance)

#warn AAAAAAAAAAAAAAAa

