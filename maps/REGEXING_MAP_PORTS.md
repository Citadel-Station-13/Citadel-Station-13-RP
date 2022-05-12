# Regexing Map Ports

// TODO: ADD PYTHON SCRIPT TO AUTOMATE THIS

Yeah so we're (me) all a bunch of idiots (insane).
As such we have a *ton* of path replacements.

Apply regexes in this order:

`/obj/effect/map_helper`-`/atom/movable/map_helper`

// TODO: tape roll
// todo: devices/weapons

// Landmarks
`/obj/effect/landmark`-`/atom/movable/landmark`
// Specific landmarks
`/atom/movable/landmark\{\n\tname = "Observer-Start"\n\t\}`-`/atom/movable/landmark/observer_spawn`
// Preliminary job landmarks
`/atom/movable/landmark/start\{\n\tname = "([A-z]+)"\n\t\}`-`/atom/movable/landmark/spawnpoint/job/\L$1`
`/atom/movable/landmark/start\{\n\tname = "([A-z]+) ([A-z]+)"\n\t\}`-`/atom/movable/landmark/spawnpoint/job/\L$1_\L$2`
`/atom/movable/landmark/start\{\n\tname = "([A-z]+) ([A-z]+) ([A-z]+)"\n\t\}`-`/atom/movable/landmark/spawnpoint/job/\L$1_\L$2_\L$3`
/// Specific job landmarks
`/atom/movable/spawnpoint/job/search_and_rescue`-`/atom/movable/spawnpoint/job/field_medic`
`/atom/movable/spawnpoint/job/facility_director`-`/atom/movable/spawnpoint/job/captain`
`/atom/movable/spawnpoint/job/internal_affairs_agent`-`/atom/movable/spawnpoint/job/lawyer`
`/atom/movable/spawnpoint/job/gardener`-`/atom/movable/spawnpoint/job/botanist`

// TODO: MAKE SURE NO / AFTER COSTUME
`/atom/movable/landmark/costume`-`/atom/movable/landmark/costume/random`
`/atom/movable/landmark/mobcorpse`-`/atom/movable/spawner/corpse`

// ATMOSPHERICS
`obj/machinery/atmospherics/omni`-`obj/machinery/atmospherics/component/quaternary`
`obj/machinery/atmospherics/(unary|binary|trinary)`-`obj/machinery/atmospherics/component/$1`
