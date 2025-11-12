# Mapping Subsystem

Better README is a todo.

I promise there's a method to the madness.

## structure

* / - all 'modules' stay here.
* /level - level helpers. These generally take a z-index and return something about it. 99% of the time you should use this instead of manually looking up level datums, but doing so is okay if you really need performance. Procs should begin with `level_`.
* /spatial - spatial helpers. These generally take a turf, coordinate, or something akin to that and grabs data based on it. These are namespaced on SSmapping for speed. Procs should begin with `spatial_`.
* /virtual - virtual helpers that more or less replace basic BYOND procs like get dir, range, etc. These are to get 'real' distance/whatnot when we're in a map struct. Use this for things that should be aware of it, which is most IC things. Procs should begin with `virtual_`.
