//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

// --- Defines for 'jigsaw' module, a procedural dungeon / map generator. ---

//* Priorities *//

/**
 * Set this if your templates should yield to other templates.
 */
#define JIGSAW_PRIORITY_YIELD_OTHERS -100

#define JIGSAW_PRIORITY_DEFAULT 0

/**
 * Set this if your templates should trample over other templates.
 */
#define JIGSAW_PRIORITY_TRAMPLE_OTHERS 100

//* Common match / require / exclude tags *//

/**
 * This means;
 * * This side of the template is entirely contained within the grid bounds
 */
#define JIGSAW_MATCH_INSIDE_WALL "inside-wall"

/**
 * This means;
 * * This side of the template has a wall one outside the grid bounds.
 */
#define JIGSAW_MATCH_OUTSIDE_WALL "outside-wall"

/**
 * This means;
 * * This side of the template may be arbitrarily joined on the center 2 tiles
 *   of the inside/outside wall (depending on which other 'match' is set)
 */
#define JIGSAW_MATCH_CENTER_JOIN_2 "center-join-2"

/**
 * This means;
 * * This side of the template may be arbitrarily joined on the center 4 tiles
 *   of the inside/outside wall (depending on which other 'match' is set)
 */
#define JIGSAW_MATCH_CENTER_JOIN_4 "center-join-4"

/**
 * This means;
 * * This side of the template will always be airtight sealed on the join point,
 *   whether with doors or windows or walls.
 * * The lack of JOIN_LEAKY doesn't imply JOIN_AIRTIGHT.
 */
#define JIGSAW_MATCH_JOIN_AIRTIGHT "join-airtight"

/**
 * This means;
 * * This side of the template will always *not* be airtight.
 * * The lack of JOIN_AIRTIGHT doesn't imply JOIN_LEAKY.
 */
#define JIGSAW_MATCH_JOIN_LEAKY "join-leaky"
