//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// make sure a var that is either event_args/actor or a single mob/user is event args; if it's not
#define E_ARGS_WRAP_USER_TO_ACTOR(USER) USER = ismob(USER)? new /datum/event_args/actor(USER) : USER
