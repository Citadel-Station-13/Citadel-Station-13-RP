/obj/item/fishing_line
	name = "fishing line reel"
	desc = "Simple fishing line."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "reel_blue"
	var/fishing_line_traits = NONE
	/// Color of the fishing line
	var/line_color = "#808080"

/obj/item/fishing_line/reinforced
	name = "reinforced fishing line reel"
	desc = "Essential for fishing in extreme environments."
	icon_state = "reel_green"
	fishing_line_traits = FISHING_LINE_REINFORCED
	line_color = "#2b9c2b"

/obj/item/fishing_line/cloaked
	name = "cloaked fishing line reel"
	desc = "Even harder to notice than the common variety."
	icon_state = "reel_white"
	fishing_line_traits = FISHING_LINE_CLOAKED
	line_color = "#82cfdd"

/obj/item/fishing_line/bouncy
	name = "flexible fishing line reel"
	desc = "This specialized line is much harder to snap."
	icon_state = "reel_red"
	fishing_line_traits = FISHING_LINE_BOUNCY
	line_color = "#99313f"

/obj/item/fishing_line/sinew
	name = "fishing sinew"
	desc = "An all-natural fishing line made of stretched out sinew."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "reel_sinew"
	line_color = "#d1cca3"
