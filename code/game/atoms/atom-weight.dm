//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An explicit instruction to immediately retally containing weight.
 * * This and its children should never sleep; these are only called if there's an error, so
 *   lagging the server is fine. If we sleep, things might move out of contents.
 */
/atom/proc/retally_containing_weight()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
