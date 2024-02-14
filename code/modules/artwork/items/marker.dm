/obj/item/pen/crayon/marker
	name = "marker"
	desc = "A chisel-tip permanent marker. Hopefully non-toxic."
	icon = 'icons/modules/artwork/items/markers.dmi'
	icon_state = "markerred"
	crayon_name = "marker"
	crayon_color_name = "red"
	crayon_reagent_type = /datum/reagent/marker_ink
	debris_path = /obj/effect/debris/cleanable/crayon/marker

/obj/item/pen/crayon/marker/black
	icon_state = "markerblack"
	pen_color = "#2D2D2D"
	crayon_color_name = "black"

/obj/item/pen/crayon/marker/red
	icon_state = "markerred"
	pen_color = "#DA0000"
	crayon_color_name = "red"

/obj/item/pen/crayon/marker/orange
	icon_state = "markerorange"
	pen_color = "#FF9300"
	crayon_color_name = "orange"

/obj/item/pen/crayon/marker/yellow
	icon_state = "markeryellow"
	pen_color = "#FFF200"
	crayon_color_name = "yellow"

/obj/item/pen/crayon/marker/green
	icon_state = "markergreen"
	pen_color = "#A8E61D"
	crayon_color_name = "green"

/obj/item/pen/crayon/marker/blue
	icon_state = "markerblue"
	pen_color = "#00B7EF"
	crayon_color_name = "blue"

/obj/item/pen/crayon/marker/purple
	icon_state = "markerpurple"
	pen_color = "#DA00FF"
	crayon_color_name = "purple"

/obj/item/pen/crayon/marker/mime
	icon_state = "markermime"
	desc = "A very sad-looking marker."
	pen_color = "#FFFFFF"
	crayon_color_name = "mime"
	remaining = null
	crayon_pickable_colors = list(
		"#FFFFFF",
		"#000000",
	)

/obj/item/pen/crayon/marker/rainbow
	icon_state = "markerrainbow"
	pen_color = "#FFF000"
	crayon_color_name = "rainbow"
	remaining = null
	crayon_free_recolor = TRUE
