/datum/asset_pack/spritesheet/fish
	name = "fish"
/datum/asset_pack/spritesheet/fish/generate()
	for (var/path in subtypesof(/obj/item/fish))
		var/obj/item/fish/fish_type = path
		var/fish_icon = initial(fish_type.icon)
		var/fish_icon_state = initial(fish_type.icon_state)
		var/id = sanitize_css_class_name("[fish_icon][fish_icon_state]")
		if(sprites[id]) //no dupes
			continue
		insert(id, fish_icon, fish_icon_state)


/datum/asset_pack/simple/fishing_minigame
	assets = list(
		"fishing_background_default" = 'icons/interface/fishing/default.png',
		"fishing_background_lavaland" = 'icons/interface/fishing/lavaland.png'
	)
