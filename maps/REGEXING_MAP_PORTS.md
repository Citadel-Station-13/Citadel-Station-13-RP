# Regexing Map Ports

// TODO: ADD PYTHON SCRIPT TO AUTOMATE THIS

Yeah so we're (me) all a bunch of idiots (insane).
As such we have a *ton* of path replacements.
All of these regexes are for VSC. They are not necessarily optimized, so, if you're good at regexes, do help!

Apply regexes in this order:

// TODO: tape roll
// todo: devices/weapons

`/obj/effect/landmark`-`/atom/movable/landmark`
`/atom/movable/landmark/start\{\n\tname = "([A-z]+)"\n\t\}`-`/atom/movable/landmark/spawnpoint/job/\L$1`
`/atom/movable/landmark/start\{\n\tname = "([A-z]+) ([A-z]+)"\n\t\}`-`/atom/movable/landmark/spawnpoint/job/\L$1_\L$2`
`/atom/movable/landmark/start\{\n\tname = "([A-z]+) ([A-z]+) ([A-z]+)"\n\t\}`-`/atom/movable/landmark/spawnpoint/job/\L$1_\L$2_\L$3`

// TODO: ADD JOB REGEXES
// TODO: OBSERVER START

// TODO: MAKE SURE NO / AFTER COSTUME
`/atom/movable/landmark/costume` `/atom/movable/landmark/costume/random`
