/**
 * These are opaque decals designed to be mixed together.
 */
/obj/effect/turf_decal/tile
	name = "steel tile decal"
	icon = 'icons/turf/tiles/steel.dmi'
	icon_state = "tile"
	layer = DECAL_LAYER

/obj/effect/turf_decal/tile/Initialize(mapload)
	if (check_holidays(APRIL_FOOLS))
		color = "#[random_short_color()]"
	else if (check_holidays(PRIDE_WEEK))
		var/datum/holiday/pride_week/pride_week = GLOB.holidays[PRIDE_WEEK]
		color = pride_week.get_floor_tile_color(src)

	return ..()

//! Steel tiles

/obj/effect/turf_decal/tile/steel
	name = "steel tile decal"
	color = null

/obj/effect/turf_decal/tile/steel/tile_border
	icon_state = "tile_border"
	name = "steel borders decal"

/obj/effect/turf_decal/tile/steel/tile_corner
	icon_state = "tile_corner"
	name = "steel corners decal"

/obj/effect/turf_decal/tile/steel/tile_diagonal
	icon_state = "tile_diagonal"
	name = "steel diagonal decal"

/obj/effect/turf_decal/tile/steel/monotile
	icon_state = "mono"
	name = "steel monotiles decal"

/obj/effect/turf_decal/tile/steel/monotile_border
	icon_state = "mono_border"
	name = "steel mono borders decal"

/obj/effect/turf_decal/tile/steel/minitile
	icon_state = "mini"
	name = "steel minitile decal"

/obj/effect/turf_decal/tile/steel/diagonaltile
	icon_state = "diagonal"
	name = "steel diagonal tile decal"

/obj/effect/turf_decal/tile/steel/brick
	icon_state = "brick"
	name = "steel bricks decal"

//! Textured Steel Tiles

/obj/effect/turf_decal/tile/steel_textured
	name = "textured steel tile decal"
	icon = 'icons/turf/tiles/steel_textured.dmi'
	color = null

/obj/effect/turf_decal/tile/steel_textured/tile_border
	icon_state = "tile_border"
	name = "textured steel borders decal"

/obj/effect/turf_decal/tile/steel_textured/tile_corner
	icon_state = "tile_corner"
	name = "textured steel corners decal"

/obj/effect/turf_decal/tile/steel_textured/tile_diagonal
	icon_state = "tile_diagonal"
	name = "textured steel diagonal decal"

/obj/effect/turf_decal/tile/steel_textured/monotile
	icon_state = "mono"
	name = "textured steel monotiles decal"

/obj/effect/turf_decal/tile/steel_textured/monotile_border
	icon_state = "mono_border"
	name = "textured steel mono borders decal"

//! Blue tiles

/obj/effect/turf_decal/tile/blue
	name = "blue tile decal"
	color = "#52B4E9"

/obj/effect/turf_decal/tile/blue/tile_border
	icon_state = "tile_border"
	name = "blue borders decal"

/obj/effect/turf_decal/tile/blue/tile_corner
	icon_state = "tile_corner"
	name = "blue corners decal"

/obj/effect/turf_decal/tile/blue/tile_diagonal
	icon_state = "tile_diagonal"
	name = "blue diagonal decal"

/obj/effect/turf_decal/tile/blue/monotile
	icon_state = "mono"
	name = "blue monotiles decal"

/obj/effect/turf_decal/tile/blue/monotile_border
	icon_state = "mono_border"
	name = "blue mono borders decal"

/obj/effect/turf_decal/tile/blue/minitile
	icon_state = "mini"
	name = "blue minitile decal"

/obj/effect/turf_decal/tile/blue/diagonaltile
	icon_state = "diagonal"
	name = "blue diagonal tile decal"

/obj/effect/turf_decal/tile/blue/brick
	icon_state = "brick"
	name = "blue bricks decal"

//! Dark blue tiles

/obj/effect/turf_decal/tile/dark_blue
	name = "dark blue tile decal"
	color = "#486091"

/obj/effect/turf_decal/tile/dark_blue/tile_corner
	icon_state = "tile_corner"
	name = "dark blue corners decal"

/obj/effect/turf_decal/tile/dark_blue/tile_border
	icon_state = "tile_border"
	name = "dark blue borders decal"

/obj/effect/turf_decal/tile/dark_blue/tile_diagonal
	icon_state = "tile_diagonal"
	name = "dark blue diagonal decal"

/obj/effect/turf_decal/tile/dark_blue/monotile
	icon_state = "mono"
	name = "dark blue monotiles decal"

/obj/effect/turf_decal/tile/dark_blue/monotile_border
	icon_state = "mono_border"
	name = "dark blue mono borders decal"

/obj/effect/turf_decal/tile/dark_blue/minitile
	icon_state = "mini"
	name = "dark blue minitile decal"

/obj/effect/turf_decal/tile/dark_blue/diagonaltile
	icon_state = "diagonal"
	name = "dark blue diagonal tile decal"

/obj/effect/turf_decal/tile/dark_blue/brick
	icon_state = "brick"
	name = "dark blue bricks decal"

//! Green tiles

/obj/effect/turf_decal/tile/green
	name = "green tile decal"
	color = "#9FED58"

/obj/effect/turf_decal/tile/green/tile_corner
	icon_state = "tile_corner"
	name = "green corners decal"

/obj/effect/turf_decal/tile/green/tile_border
	icon_state = "tile_border"
	name = "green borders decal"

/obj/effect/turf_decal/tile/green/tile_diagonal
	icon_state = "tile_diagonal"
	name = "green diagonal decal"

/obj/effect/turf_decal/tile/green/monotile
	icon_state = "mono"
	name = "green monotiles decal"

/obj/effect/turf_decal/tile/green/monotile_border
	icon_state = "mono_border"
	name = "green mono borders decal"

/obj/effect/turf_decal/tile/green/minitile
	icon_state = "mini"
	name = "green minitile decal"

/obj/effect/turf_decal/tile/green/diagonaltile
	icon_state = "diagonal"
	name = "green diagonal tile decal"

/obj/effect/turf_decal/tile/green/brick
	icon_state = "brick"
	name = "green bricks decal"

//! Dark green tiles

/obj/effect/turf_decal/tile/dark_green
	name = "dark green tile decal"
	color = "#439C1E"

/obj/effect/turf_decal/tile/dark_green/tile_corner
	icon_state = "tile_corner"
	name = "dark green corners decal"

/obj/effect/turf_decal/tile/dark_green/tile_border
	icon_state = "tile_border"
	name = "dark green borders decal"

/obj/effect/turf_decal/tile/dark_green/tile_diagonal
	icon_state = "tile_diagonal"
	name = "dark green diagonal decal"

/obj/effect/turf_decal/tile/dark_green/monotile
	icon_state = "mono"
	name = "dark green monotiles decal"

/obj/effect/turf_decal/tile/dark_green/monotile_border
	icon_state = "mono_border"
	name = "dark green mono borders decal"

/obj/effect/turf_decal/tile/dark_green/minitile
	icon_state = "mini"
	name = "dark green minitile decal"

/obj/effect/turf_decal/tile/dark_green/diagonaltile
	icon_state = "diagonal"
	name = "dark green diagonal tile decal"

/obj/effect/turf_decal/tile/dark_green/brick
	icon_state = "brick"
	name = "dark green bricks decal"

//! Yellow tiles

/obj/effect/turf_decal/tile/yellow
	name = "yellow tile decal"
	color = "#EFB341"

/obj/effect/turf_decal/tile/yellow/tile_corner
	icon_state = "tile_corner"
	name = "yellow corners decal"

/obj/effect/turf_decal/tile/yellow/tile_border
	icon_state = "tile_border"
	name = "yellow borders decal"

/obj/effect/turf_decal/tile/yellow/tile_diagonal
	icon_state = "tile_diagonal"
	name = "yellow diagonal decal"

/obj/effect/turf_decal/tile/yellow/monotile
	icon_state = "mono"
	name = "yellow monotiles decal"

/obj/effect/turf_decal/tile/yellow/monotile_border
	icon_state = "mono_border"
	name = "yellow mono borders decal"

/obj/effect/turf_decal/tile/yellow/minitile
	icon_state = "mini"
	name = "yellow minitile decal"

/obj/effect/turf_decal/tile/yellow/diagonaltile
	icon_state = "diagonal"
	name = "yellow diagonal tile decal"

/obj/effect/turf_decal/tile/yellow/brick //! You should follow them. @Zandario
	icon_state = "brick"
	name = "yellow bricks decal"

//! Red tiles

/obj/effect/turf_decal/tile/red
	name = "red tile decal"
	color = "#DE3A3A"

/obj/effect/turf_decal/tile/red/tile_corner
	icon_state = "tile_corner"
	name = "red corners decal"

/obj/effect/turf_decal/tile/red/tile_border
	icon_state = "tile_border"
	name = "red borders decal"

/obj/effect/turf_decal/tile/red/tile_diagonal
	icon_state = "tile_diagonal"
	name = "red diagonal decal"

/obj/effect/turf_decal/tile/red/monotile
	icon_state = "mono"
	name = "red monotiles decal"

/obj/effect/turf_decal/tile/red/monotile_border
	icon_state = "mono_border"
	name = "red mono borders decal"

/obj/effect/turf_decal/tile/red/minitile
	icon_state = "mini"
	name = "red minitile decal"

/obj/effect/turf_decal/tile/red/diagonaltile
	icon_state = "diagonal"
	name = "red diagonal tile decal"

/obj/effect/turf_decal/tile/red/brick
	icon_state = "brick"
	name = "red bricks decal"

//! Dark red tiles

/obj/effect/turf_decal/tile/dark_red
	name = "dark red tile decal"
	color = "#B11111"

/obj/effect/turf_decal/tile/dark_red/tile_corner
	icon_state = "tile_corner"
	name = "dark_red corners decal"

/obj/effect/turf_decal/tile/dark_red/tile_border
	icon_state = "tile_border"
	name = "dark red borders decal"

/obj/effect/turf_decal/tile/dark_red/tile_diagonal
	icon_state = "tile_diagonal"
	name = "dark red diagonal decal"

/obj/effect/turf_decal/tile/dark_red/monotile
	icon_state = "mono"
	name = "dark red monotiles decal"

/obj/effect/turf_decal/tile/dark_red/monotile_border
	icon_state = "mono_border"
	name = "dark red mono borders decal"

/obj/effect/turf_decal/tile/dark_red/minitile
	icon_state = "mini"
	name = "dark red minitile decal"

/obj/effect/turf_decal/tile/dark_red/diagonaltile
	icon_state = "diagonal"
	name = "dark red diagonal tile decal"

/obj/effect/turf_decal/tile/dark_red/brick
	icon_state = "brick"
	name = "dark red bricks decal"

//! Bar tiles

/obj/effect/turf_decal/tile/bar
	name = "bar tile decal"
	color = "#791500"

/obj/effect/turf_decal/tile/bar/tile_corner
	icon_state = "tile_corner"
	name = "bar corners decal"

/obj/effect/turf_decal/tile/bar/tile_border
	icon_state = "tile_border"
	name = "bar borders decal"

/obj/effect/turf_decal/tile/bar/tile_diagonal
	icon_state = "tile_diagonal"
	name = "bar diagonal decal"

/obj/effect/turf_decal/tile/bar/monotile
	icon_state = "mono"
	name = "bar monotiles decal"

/obj/effect/turf_decal/tile/bar/monotile_border
	icon_state = "mono_border"
	name = "bar mono borders decal"

/obj/effect/turf_decal/tile/bar/minitile
	icon_state = "mini"
	name = "bar minitile decal"

/obj/effect/turf_decal/tile/bar/diagonaltile
	icon_state = "diagonal"
	name = "bar diagonal tile decal"

/obj/effect/turf_decal/tile/bar/brick
	icon_state = "brick"
	name = "bar bricks decal"

//! Purple tiles

/obj/effect/turf_decal/tile/purple
	name = "purple tile decal"
	color = "#D381C9"

/obj/effect/turf_decal/tile/purple/tile_corner
	icon_state = "tile_corner"
	name = "purple corners decal"

/obj/effect/turf_decal/tile/purple/tile_border
	icon_state = "tile_border"
	name = "purple borders decal"

/obj/effect/turf_decal/tile/purple/tile_diagonal
	icon_state = "tile_diagonal"
	name = "purple diagonal decal"

/obj/effect/turf_decal/tile/purple/monotile
	icon_state = "mono"
	name = "purple monotiles decal"

/obj/effect/turf_decal/tile/purple/monotile_border
	icon_state = "mono_border"
	name = "purple mono borders decal"

/obj/effect/turf_decal/tile/purple/minitile
	icon_state = "mini"
	name = "purple minitile decal"

/obj/effect/turf_decal/tile/purple/diagonaltile
	icon_state = "diagonal"
	name = "bar diagonal tile decal"

/obj/effect/turf_decal/tile/purple/brick
	icon_state = "brick"
	name = "purple bricks decal"

//! Brown tiles

/obj/effect/turf_decal/tile/brown
	name = "brown tile decal"
	color = "#A46106"

/obj/effect/turf_decal/tile/brown/tile_corner
	icon_state = "tile_corner"
	name = "brown corners decal"

/obj/effect/turf_decal/tile/brown/tile_border
	icon_state = "tile_border"
	name = "brown borders decal"

/obj/effect/turf_decal/tile/brown/tile_diagonal
	icon_state = "tile_diagonal"
	name = "brown diagonal decal"

/obj/effect/turf_decal/tile/brown/monotile
	icon_state = "mono"
	name = "brown monotiles decal"

/obj/effect/turf_decal/tile/brown/monotile_border
	icon_state = "mono_border"
	name = "brown mono borders decal"

/obj/effect/turf_decal/tile/brown/minitile
	icon_state = "mini"
	name = "brown minitile decal"

/obj/effect/turf_decal/tile/brown/diagonaltile
	icon_state = "diagonal"
	name = "brown diagonal tile decal"

/obj/effect/turf_decal/tile/brown/brick
	icon_state = "brick"
	name = "brown bricks decal"

//! White tiles

/obj/effect/turf_decal/tile/white
	name = "white tile decal"
	icon = 'icons/turf/tiles/white.dmi'

/obj/effect/turf_decal/tile/white/tile_border
	icon_state = "tile_border"
	name = "white borders decal"

/obj/effect/turf_decal/tile/white/tile_corner
	icon_state = "tile_corner"
	name = "white corners decal"

/obj/effect/turf_decal/tile/white/tile_diagonal
	icon_state = "tile_diagonal"
	name = "white diagonal decal"

/obj/effect/turf_decal/tile/white/monotile
	icon_state = "mono"
	name = "white monotiles decal"

/obj/effect/turf_decal/tile/white/monotile_border
	icon_state = "mono_border"
	name = "white mono borders decal"

/obj/effect/turf_decal/tile/white/minitile
	icon_state = "mini"
	name = "white minitile decal"

/obj/effect/turf_decal/tile/white/diagonaltile
	icon_state = "diagonal"
	name = "white diagonal tile decal"

/obj/effect/turf_decal/tile/white/brick
	icon_state = "brick"
	name = "white brick tile decal"

//! Textured White tiles

/obj/effect/turf_decal/tile/white_textured
	name = "textured white tile decal"
	icon = 'icons/turf/tiles/white.dmi'

/obj/effect/turf_decal/tile/white_textured/tile_border
	icon_state = "tile_border"
	name = "textured white borders decal"

/obj/effect/turf_decal/tile/white_textured/tile_corner
	icon_state = "tile_corner"
	name = "textured white corners decal"

/obj/effect/turf_decal/tile/white_textured/tile_diagonal
	icon_state = "tile_diagonal"
	name = "textured white diagonal decal"

/obj/effect/turf_decal/tile/white_textured/monotile
	icon_state = "mono"
	name = "textured white monotiles decal"

/obj/effect/turf_decal/tile/white_textured/monotile_border
	icon_state = "mono_border"
	name = "textured white mono borders decal"

//! Black tiles

/obj/effect/turf_decal/tile/black
	name = "black tile decal"
	icon = 'icons/turf/tiles/black.dmi'

/obj/effect/turf_decal/tile/black/tile_corner
	icon_state = "tile_corner"
	name = "black corners decal"

/obj/effect/turf_decal/tile/black/tile_border
	icon_state = "tile_border"
	name = "black borders decal"

/obj/effect/turf_decal/tile/black/tile_diagonal
	icon_state = "tile_diagonal"
	name = "black diagonal decal"

/obj/effect/turf_decal/tile/black/monotile
	icon_state = "mono"
	name = "black monotiles decal"

/obj/effect/turf_decal/tile/black/monotile_border
	icon_state = "mono_border"
	name = "black mono borders decal"

/obj/effect/turf_decal/tile/black/minitile
	icon_state = "mini"
	name = "black minitile decal"

/obj/effect/turf_decal/tile/black/diagonaltile
	icon_state = "diagonal"
	name = "black diagonal tile decal"

/obj/effect/turf_decal/tile/black/brick
	icon_state = "brick"
	name = "black brick tile decal"

//! Textured Black tiles

/obj/effect/turf_decal/tile/black_textured
	name = "textured black tile decal"
	icon = 'icons/turf/tiles/black_textured.dmi'

/obj/effect/turf_decal/tile/black_textured/tile_corner
	icon_state = "tile_corner"
	name = "textured black corners decal"

/obj/effect/turf_decal/tile/black_textured/tile_border
	icon_state = "tile_border"
	name = "textured black borders decal"

/obj/effect/turf_decal/tile/black_textured/tile_diagonal
	icon_state = "tile_diagonal"
	name = "textured black diagonal decal"

/obj/effect/turf_decal/tile/black_textured/monotile
	icon_state = "mono"
	name = "textured black monotiles decal"

/obj/effect/turf_decal/tile/black_textured/monotile_border
	icon_state = "mono_border"
	name = "textured black mono borders decal"

//! Random tiles

/obj/effect/turf_decal/tile/random // so many colors
	name = "colorful tile decal"
	icon = 'icons/turf/tiles/special.dmi'
	icon_state = "random" // Rainbow sprite for mappers.

/obj/effect/turf_decal/tile/random/Initialize(mapload)
	icon = 'icons/turf/tiles/steel.dmi'
	color = "#[random_short_color()]"
	. = ..()

/obj/effect/turf_decal/tile/random/tile_corner
	icon_state = "tile_corner"
	name = "colorful corners decal"

/obj/effect/turf_decal/tile/random/tile_border
	icon_state = "tile_border"
	name = "colorful borders decal"

/obj/effect/turf_decal/tile/random/tile_diagonal
	icon_state = "tile_diagonal"
	name = "colorful diagonal decal"

/obj/effect/turf_decal/tile/random/monotile
	icon_state = "mono"
	name = "colorful monotiles decal"

/obj/effect/turf_decal/tile/random/monotile_border
	icon_state = "mono_border"
	name = "colorful mono borders decal"

/obj/effect/turf_decal/tile/random/minitile
	icon_state = "mini"
	name = "colorful minitile decal"

/obj/effect/turf_decal/tile/random/diagonaltile
	icon_state = "diagonal"
	name = "colorful diagonal tile decal"

//! Checkered Tiles

/obj/effect/turf_decal/tile/checkered
	name = "checkered tile decal"
	icon = 'icons/turf/tiles/checkered.dmi'

/obj/effect/turf_decal/tile/checkered/minitile
	icon_state = "mini"
	name = "checkered minitile decal"

/obj/effect/turf_decal/tile/checkered/diagonaltile
	icon_state = "mini"
	name = "checkered diagonal tile decal"

/obj/effect/turf_decal/tile/checkered/brick
	icon_state = "brick"
	name = "checkered brick tile decal"

//! Brick Tiles
/obj/effect/turf_decal/tile/brick
	name = "brick tile decal"
	icon = 'icons/turf/tiles/brick.dmi'

/obj/effect/turf_decal/tile/brick/minitile
	icon_state = "mini"
	name = "brick minitile decal"

/obj/effect/turf_decal/tile/brick/diagonaltile
	icon_state = "mini"
	name = "brick diagonal tile decal"

/obj/effect/turf_decal/tile/brick/diagonaltile //! Ah yes, this brick is made of brick. @Zandario
	icon_state = "brick"
	name = "brick brick tile decal"
