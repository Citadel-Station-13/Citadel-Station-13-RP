/**
 * gets all entities in x overmaps distance from us
 *
 * this is expensive; use sparingly!
 *
 * use high_accuracy when you absolutely need an accurate range
 * otherwise, we reserve the right to freely trample accuracy up to a few seconds and a tilie or two
 * in the name of performance
 *
 * high_accuracy off will usually be accurate *enough*, but using it will force the system to not apply
 * any potentially destructive optimizationis!
 */
/atom/movable/overmap_object/entity/proc/get_entities_in_range(dist, high_accuracy)
	#warn impl


/**
 * get all entities that we are touching, **including ourselves**
 */
/atom/movable/overmap_object/entity/proc/get_entities_overlapping()
	. = list()
	for(var/atom/movable/overmap_object/entity/E in loc)
		. += E
