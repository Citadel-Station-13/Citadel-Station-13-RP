//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// from base of _tool_act: (I, user, function, flags, hint) where I = item, user = user, function = tool behaviour, flags = tool operation flags, hint = set by dynamic tool system
/// return CLICKCHAIN_COMPONENT_SIGNAL_HANDLED to abort normal tool_act handling.
#define COMSIG_ATOM_TOOL_ACT "tool_act"
/// from base of dynamic_tool_functions: (functions, I, user) where I = item, user = user
#define COMSIG_ATOM_TOOL_QUERY "tool_query"

#warn a way to return iamges
