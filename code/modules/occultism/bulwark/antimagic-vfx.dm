//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Usage: new /atom/movable/render/antimagic(target, intensity = 0 to 100, ...)
 */
/atom/movable/render/antimagic

/atom/movable/render/antimagic/Initialize(mapload, atom/binding, intensity)
	var/list/modified_args = args.Copy()
	modified_args[1] = loc
	QDEL_IN(src, run(arglist(modified_args)))
	return INITIALIZE_HINT_NORMAL

/**
 * @return delete in ds
 */
/atom/movable/render/antimagic/proc/run(atom/target, intensity, ...)
	return 0

/atom/movable/render/antimagic/rune_flicker

/atom/movable/render/antimagic/rune_flicker/run(atom/binding, intensity, color)

#warn impl
