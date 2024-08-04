//? for /datum/event_args/actor

#define WRAP_MOB_TO_ACTOR_EVENT_ARGS(VARNAME) VARNAME = ismob(VARNAME)? new /datum/event_args/actor(VARNAME) : VARNAME

//? for /datum/event_args/actor/clickchain

#define WRAP_MOB_TO_CLICKCHAIN_EVENT_ARGS(VARNAME) VARNAME = ismob(VARNAME)? new /datum/event_args/actor/clickchain(VARNAME) : VARNAME
