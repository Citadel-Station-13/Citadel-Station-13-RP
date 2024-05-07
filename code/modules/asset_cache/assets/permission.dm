/datum/asset_pack/simple/permissions
	assets = list(
		"search.js" = 'html/admin/search.js',
		"panels.css" = 'html/admin/panels.css'
	)

/datum/asset_pack/group/permissions
	children = list(
		/datum/asset_pack/simple/permissions,
		/datum/asset_pack/simple/namespaced/common
	)
