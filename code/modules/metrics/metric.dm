//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Describes a feedback variable.
 *
 * * All metrics should be well-formed and described in DM-code, as the DM
 *   code is the root of trust for what something actually is.
 */
/datum/metric
	/// id
	///
	/// * must be unique; this should never change
	/// * changes require databaes migrations
	var/id
	/// fancy name
	///
	/// * not recorded to database; external renders/access reserve the right to use
	///   their own names
	var/name
	/// category; string value.
	///
	/// * this corrosponds to database-level enums, be careful with this
	var/category
