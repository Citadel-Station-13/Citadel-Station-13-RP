# Utility regexes

random regexes, with varying levels of usefulness

## pulling a dir out of something with multiple dirs to force a /dir subtype instead

that ; at the end is bad and can lead to issues.

`/obj/machinery/air_alarm(.*)\{([a-zA-Z0-9\n\t "_=();]*)\n\tdir = 8;` -> `/obj/machinery/air_alarm$1/west{$2`

