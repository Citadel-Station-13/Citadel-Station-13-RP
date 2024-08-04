// todo: refactor everything for persistence

/obj/item/storage/photo_album
	name = "Photo album"
	icon = 'icons/modules/photography/album.dmi'
	icon_state = "album"
	worn_render_flags = WORN_RENDER_INHAND_ALLOW_DEFAULT
	inhand_default_type = INHAND_DEFAULT_ICON_STORAGE
	inhand_state = "briefcase"
	insertion_whitelist = list(
		/obj/item/photo,
	)
