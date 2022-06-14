# Regexing Map Ports

// TODO: ADD PYTHON SCRIPT TO AUTOMATE THIS

Yeah so we're (me) all a bunch of idiots (insane).
As such we have a *ton* of path replacements.
All of these regexes are for VSC. They are not necessarily optimized, so, if you're good at regexes, do help!

Apply regexes in this order:

`/obj/effect/map_helper`-`/atom/movable/map_helper`

// TODO: tape roll
// todo: devices/weapons

// Landmarks
`/obj/effect/landmark`-`/obj/landmark`
// Specific landmarks
`/obj/landmark\{\n\tname = "Observer-Start"\n\t\}`-`/obj/landmark/observer_spawn`
// Preliminary job landmarks
`/obj/landmark/start\{\n\tname = "([A-z]+)"\n\t\}`-`/obj/landmark/spawnpoint/job/\L$1`
`/obj/landmark/start\{\n\tname = "([A-z]+) ([A-z]+)"\n\t\}`-`/obj/landmark/spawnpoint/job/\L$1_\L$2`
`/obj/landmark/start\{\n\tname = "([A-z]+) ([A-z]+) ([A-z]+)"\n\t\}`-`/obj/landmark/spawnpoint/job/\L$1_\L$2_\L$3`
/// Specific job landmarks
`/obj/landmark/spawnpoint/job/search_and_rescue`-`/obj/landmark/spawnpoint/job/field_medic`
`/obj/landmark/spawnpoint/job/facility_director`-`/obj/landmark/spawnpoint/job/captain`
`/obj/landmark/spawnpoint/job/internal_affairs_agent`-`/obj/landmark/spawnpoint/job/lawyer`
`/obj/landmark/spawnpoint/job/gardener`-`/obj/landmark/spawnpoint/job/botanist`

// TODO: MAKE SURE NO / AFTER COSTUME
`/obj/landmark/costume`-`/obj/landmark/costume/random`
`/obj/landmark/mobcorpse`-`/atom/movable/spawner/corpse`

// ATMOSPHERICS
`/obj/machinery/atmospherics/omni`-`/obj/machinery/atmospherics/component/quaternary`
`/obj/machinery/atmospherics/(unary|binary|trinary)`-`/obj/machinery/atmospherics/component/$1`
