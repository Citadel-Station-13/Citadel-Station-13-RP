//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Stores how to access a bank account in our memories.
 */
/datum/mind/proc/store_memory_of_economy_account(datum/economy_account/account, account_description = "Unknown Account")
	// TODO: /datum/memory
	var/list/assembled = list()
	assembled += "<div>"
	assembled += "You remember the funds a bank account for '[account_description]'.<br>"
	assembled += "<b>Account ID:</b> [account.account_id]"
	assembled += "<b>Account PIN:</b> [account.security_passkey]"
	assembled += "<b>Account Balance:</b> [account.balance]"
	assembled += "</div>"
	memory += jointext(assembled, "")
	return TRUE
