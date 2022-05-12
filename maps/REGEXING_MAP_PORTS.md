# Regexing Map Ports

// TODO: ADD PYTHON SCRIPT TO AUTOMATE THIS

Yeah so we're (me) all a bunch of idiots (insane).
As such we have a *ton* of path replacements.

Apply regexes in this order:

`/obj/effect/map_helper`-`/atom/movable/map_helper`

// TODO: tape roll
// todo: devices/weapons

// TODO: ADD JOB REGEXES
// TODO: OBSERVER START

// TODO: MAKE SURE NO / AFTER COSTUME
`/atom/movable/landmark/costume`-`/atom/movable/landmark/costume/random`
`/atom/movable/landmark/mobcorpse`-`/atom/movable/spawner/corpse`

// ATMOSPHERICS
`obj/machinery/atmospherics/omni`-`obj/machinery/atmospherics/component/quaternary`
`obj/machinery/atmospherics/(unary|binary|trinary)`-`obj/machinery/atmospherics/component/$1`
