//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An individual transaction made in economy system
 */
/datum/economy_transaction
	//*                      book-keeping                        *//
	//* these are handled by internals and may not be falsified. *//

	/// source account number, if any
	var/acct_num_src
	/// destination account number, if any
	var/acct_num_dest

	/// amount of change to the source
	/// * if the destination is specified, this is, by default, the opposite change of source!
	///   this means that if this is '50', it means source gained 50 and destination lost 50
	/// * confusing, i know.
	var/balance_change_to_source = 0

	//*                        auditing                 *//
	//* these are fluff fields and may be falsified.    *//

	/// stated purpose, as html
	/// * this is unsanitized html, do not allow player input without an encode!
	var/audit_purpose_as_unsafe_html
	/// stated origin machine
	/// * this is unsanitized html, do not allow player input without an encode!
	/// * this should generally indicate to the player a hint on where it came from
	/// * avoid magic strings! these should be auto-generated in code for standardization,
	///   as IC investigations may end up using this!
	///
	/// examples:
	/// * Nanotrasen Corporate Accounting
	/// * Vey-Med (Vendor #xxxxxxxx)
	/// * Hephaestus Industries Terminal #xxxxxxxxx
	var/audit_terminal_as_unsafe_html
	/// stated destination name
	/// * this is unsanitized html, do not allow player input without an encode!
	/// * being an audit field, this is not a systems book-keeping field.
	var/audit_dest_name_as_unsafe_html

	/// stated date / tiem
	/// * plaintext ISO-8601: "YYYY-MM-DD"
	/// * in universal galactic time
	var/audit_date
	/// stated date / time
	/// * plaintext ISO-8601: "HH:MM:SS"
	/// * in universal galactic time
	var/audit_time


#warn impl
