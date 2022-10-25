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
	/// key for saves; if null, we're not on disk and cannot be on disk
	var/save_key

	//! assets
	/// when not editing, this is used for ui data so we don't have to send data with slow byondisms
	var/entity_pack_name

	//! editing
	/// dirty? we will pack and flush next store if so
	var/dirty = FALSE
	/// editing mode
	var/volatile = FALSE
	/// only stored while editing; associate ID to entities
	var/list/entity_by_id

	//! data packing
	/// center x; computed based on entities
	var/overall_center_x = 0
	/// center y; computed based on entities
	var/overall_center_y = 0
	/// **estimated** max distance to furthest entity; computed based on entities
	var/overall_edge_dist = 100

	//! ui
	/// active views
	var/list/datum/starmap_view/views

/datum/starmap/proc/Initialize()
	if(!save_key)
		return
	assert_storage()
	build_assets()
