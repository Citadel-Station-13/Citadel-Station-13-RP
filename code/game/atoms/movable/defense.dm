//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * called when we're run over by a shuttle
 * we must do something here or we'll just stand still in place!
 *
 * @params
 * * shuttle - the shuttle datum
 * * target - which turf we've been computed to be rammed into
 * * annihilate - shuttle has nowhere to put us, we should get destroyed
 */
/atom/movable/proc/shuttle_crushed(datum/shuttle/shuttle, turf/target, annihilate)
	forceMove(target)
	#warn impl on obj and mob - don't forget throw lmao
