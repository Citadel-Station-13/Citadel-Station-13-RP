//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/robot/proc/accepts_cell(obj/item/cell/cell, datum/event_args/actor/actor, silent)
	return cell.cell_type ? (cell.cell_type & cell_accept) : cell_accept_nonstandard
