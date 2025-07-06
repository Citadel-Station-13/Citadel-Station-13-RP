//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Log entry on accounts.
 */
/datum/economy_account_log
	/// terminal ID, if any
	/// * nullable
	var/audit_terminal_as_unsafe_html
	/// purpose, if any
	/// * nullable
	var/audit_purpose_as_unsafe_html
	/// peer name, if any
	/// * nullable
	var/audit_peer_name_as_unsafe_html
	/// balance change, if any
	/// * nullable
	var/audit_balance_change_as_unsafe_html
	/// timestamp, if any
	/// * nullable
	var/audit_timestamp_as_unsafe_html
