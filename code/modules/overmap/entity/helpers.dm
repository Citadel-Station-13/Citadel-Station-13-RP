// always use this in this for get entities in range, etc etc

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
	if(!overmap)
		return list()
	if(dist < OVERMAP_ENTITY_QUERY_BUILTIN_RANGE)
		return overmap.bounds_entity_query(x, y, dist)
	return overmap.entity_query(x, y, dist)

/**
 * get distance to another object
 *
 * this is from our center to theirs.
 *
 * returns null if we're not on the same map
 */
/atom/movable/overmap_object/entity/proc/distance_to(atom/movable/overmap_object/O)
	return overmap? overmap.get_entity_distance(src, O) : null

/**
 * get all entities that we are touching, **including ourselves**
 */
/atom/movable/overmap_object/entity/proc/get_entities_overlapping()
	. = list()
	for(var/atom/movable/overmap_object/entity/E in loc)
		. += E
