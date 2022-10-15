/**
 * tgui starmaps
 *
 * only support disk-saved maps;
 * sending non-saved maps regularly is considered
 * too expensive to encourage.
 */
/datum/starmap
	//! intrinsics
	/// name
	var/name
	/// map id
	var/id
	/// key for saves
	var/save_key

	//! caching
	/// entities; only populated when needed
	var/list/datum/starmap_entity/entities
	/// if entities aren't populated, this is used
	var/entities_pack_name

	//! editing
	/// dirty? we will pack and flush next store if so
	var/dirty = FALSE
	/// editing mode
	var/volatile = FALSE
	/// while is_saved is FALSE, we are assumed to be editing; associate entites to ID
	var/list/entity_by_id

	//! data packing
	/// center x; computed based on entities
	var/overall_center_x = 0
	/// center y; computed based on entities
	var/overall_center_y = 0
	/// max distance to furthest entity; computed based on entities
	var/overall_edge_dist = 0


/datum/starmap/proc/Initialize()
	rebuild_assets()
