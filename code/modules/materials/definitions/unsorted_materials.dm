
//Vaudium products
/datum/material/bananium
	id = "bananium"
	name = "bananium"
	stack_type = /obj/item/stack/material/bananium
	integrity = 150
	conductivity = 0 // Weird rubber metal.
	protectiveness = 10 // 33%
	icon_colour = "#d6c100"

/datum/material/sandstone/silencium
	id = "silencium"
	name = "silencium"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/silencium

/datum/material/fluff //This is to allow for 2 handed weapons that don't want to have a prefix.
	id = "fluff"
	name = " "
	display_name = ""
	icon_colour = "#000000"
	sheet_singular_name = "fluff"
	sheet_plural_name = "fluffs"
	hardness = 60
	weight = 20 //Strong as iron.

// what the fuck?
/datum/material/darkglass
	id = "glass_dark"
	name = "darkglass"
	display_name = "darkglass"
	icon_base = "darkglass"
	icon_colour = "#FFFFFF"

// what the fuck?
/datum/material/fancyblack
	id = "black_fancy"
	name = "fancyblack"
	display_name = "fancyblack"
	icon_base = "fancyblack"
	icon_colour = "#FFFFFF"
