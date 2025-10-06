//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: how to handle 'handled' state? we dont' want double-interactions if something 'consumes' the click.

/// From base of obj/item/attack_self(): (/datum/event_args/actor/actor)
#define COMSIG_ITEM_ACTIVATE_INHAND "item_activate_inhand"
	#define RAISE_ITEM_ACTIVATE_INHAND_HANDLED (1<<0)
/// From base of obj/item/unique_action(): (/datum/event_args/actor/actor)
#define COMSIG_ITEM_UNIQUE_ACTION "item_unique_action"
	#define RAISE_ITEM_UNIQUE_ACTION_HANDLED (1<<0)
/// From base of obj/item/defensive_toggle(): (/datum/event_args/actor/actor)
#define COMSIG_ITEM_DEFENSIVE_TOGGLE "item_defensive_toggle"
	#define RAISE_ITEM_DEFENSIVE_TOGGLE_HANDLED (1<<0)
/// From base of obj/item/defensive_trigger(): (/datum/event_args/actor/actor)
#define COMSIG_ITEM_DEFENSIVE_TRIGGER "item_defensive_trigger"
	#define RAISE_ITEM_DEFENSIVE_TRIGGER_HANDLED (1<<0)
