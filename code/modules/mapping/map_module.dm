/**
 * map modules
 * lets you encapsulate behavior that you can't shove in a map's .json
 * hooks are called by subsystems
 */
/datum/map_module

/**
 * called at roundstart
 */
/datum/map_module/proc/on_roundstart()

/**
 * called right before main levels load
 *
 * this is usually where you set up dependencies that the primary levels need.
 */
/datum/map_module/proc/pre_mapload()

/**
 * called right after main levels are loaded
 *
 * this is usually where you set up dependencies lateload stuff need that don't exist until primary levels are loaded.
 */
/datum/map_module/proc/post_mapload()

/**
 * called right after "bundled"/referenced map levels are loaded
 *
 * this is usually where you want to do special maploading/generation
 */
/datum/map_module/proc/post_lateload()

/**
 * called right before "bundled"/referenced map levels are loaded
 */
/datum/map_module/proc/pre_lateload()

/**
 * called right after main mapgen is done
 *
 * this is usually where you want to do touchups
 *
 * planet generation is not included
 */
/datum/map_module/proc/post_mapgen()

/**
 * called right before main mapgen is done
 *
 * planet generation is not included
 */
/datum/map_module/proc/pre_mapgen()
