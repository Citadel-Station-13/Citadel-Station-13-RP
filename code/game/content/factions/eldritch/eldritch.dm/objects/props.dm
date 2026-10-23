/obj/item/eldritch/prop/codex
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "book"
	name = "bound book"
	desc = "A heavy book that has been crafted out of purple leather and bound with a chain made of metal you don't recognize. A variety of runes have been etched into the cover."
	anchored = 0
	density = 0
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR | SUIT_STORAGE_CLASS_SOFTWEAR

/obj/item/eldritch/prop/medallion
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "eye_medalion"
	name = "medallion"
	desc = "A medallion that appears to resemble an eye."
	anchored = 0
	density = 0

/obj/item/eldritch/prop/flask
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "eldritch_flask"
	name = "strange flask"
	desc = "A flask made of some type of green glass. A variety of runes have been etched into the material, but it seems empty."

/obj/item/eldritch/prop/lantern
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "lantern"
	name = "lantern"
	desc = "A glowing light held within a cage of iron which never dares to dim. A stalwart shield against the encroaching darkness."
	light_color = "#e79771"
	light_power = 0.8
	light_range = 6
	light_wedge = LIGHT_OMNI
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'code/game/content/factions/eldritch/eldritch.dmi/object_inhands/lefthand.dmi',
		SLOT_ID_RIGHT_HAND = 'code/game/content/factions/eldritch/eldritch.dmi/object_inhands/righthand.dmi'
	)
