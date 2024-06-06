//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// from base of _tool_act: (I, user, function, flags, hint) where I = item, e_args = clickchain data, function = tool behaviour, flags = tool operation flags, hint = set by dynamic tool system
/// return CLICKCHAIN_COMPONENT_SIGNAL_HANDLED to abort normal tool_act handling.
#define COMSIG_ATOM_TOOL_ACT "tool_act"
/// from base of dynamic_tool_query: (I, datum/event_args/actor/clickchain/e_args, functions) where I = item, e_args = clickchain data.
/// inject by merging into functions
/// remember to use merge_double_lazy_assoc_list() to merge function lists!
#define COMSIG_ATOM_TOOL_QUERY "tool_functions"
