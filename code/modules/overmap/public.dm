/**
 * todo: rename to get_overmap_entity
 *
 * Gets the overmap entity an object is in. If a number is provided instead, we get the entity holding the zlevel.
 *
 * @params
 * * what - an /atom, or a z index
 *
 * @return overmap entity if found, null otherwise.
 */
/proc/get_overmap_sector(atom/what)
	RETURN_TYPE(/obj/overmap/entity/visitable)
	if(!isnum(what))
		what = get_z(what) // todo: this doesn't support shuttles :/
	if((LEGACY_MAP_DATUM).use_overmap)
		return map_sectors["[what]"]
	else
		return null
