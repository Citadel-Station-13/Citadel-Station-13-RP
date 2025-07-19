//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Binding for IdCard.tsx
 */
/obj/item/card/id/proc/ui_serialize_idcard()
	return list(
		"name" = name,
		"owner" = registered_name,
		"rank" = rank,
		"title" = assignment,
	)
