//
// Constants and standard colors for the holomap
//

/// Icon file to start with when drawing holomaps (to get a 480x480 canvas).
#define HOLOMAP_ICON 'icons/480x480.dmi'
/// Pixel width & height of the holomap icon.  Used for auto-centering etc.
#define HOLOMAP_ICON_SIZE 480
/// Screen location of the holomap "hud"
#define ui_holomap "CENTER-7, CENTER-7"
// Holomap colors
/// Color of walls and barriers
#define HOLOMAP_OBSTACLE	"#FFFFFFDD"
/// Color of floors
#define HOLOMAP_PATH		"#66666699"
/// Color of mineral walls
#define HOLOMAP_ROCK		"#66666644"
/// Whole map is multiplied by this to give it a green holoish look
#define HOLOMAP_HOLOFIER	"#79FF79"
#define HOLOMAP_AREACOLOR_COMMAND		"#0000F099"
#define HOLOMAP_AREACOLOR_SECURITY		"#AE121299"
#define HOLOMAP_AREACOLOR_MEDICAL		"#447FC299"
#define HOLOMAP_AREACOLOR_SCIENCE		"#A154A699"
#define HOLOMAP_AREACOLOR_ENGINEERING	"#F1C23199"
#define HOLOMAP_AREACOLOR_CARGO			"#E06F0099"
#define HOLOMAP_AREACOLOR_HALLWAYS		"#FFFFFF66"
#define HOLOMAP_AREACOLOR_ARRIVALS		"#0000FFCC"
#define HOLOMAP_AREACOLOR_ESCAPE		"#FF0000CC"
#define HOLOMAP_AREACOLOR_DORMS			"#CCCC0099"

// Handy defines to lookup the pixel offsets for this Z-level.  Cache these if you use them in a loop tho.
#define HOLOMAP_PIXEL_OFFSET_X(zLevel) (SSmapping.fetch_level_datum(zLevel)?.holomap_offset_x || 0)
#define HOLOMAP_PIXEL_OFFSET_Y(zLevel) (SSmapping.fetch_level_datum(zLevel)?.holomap_offset_y || 0)
#define HOLOMAP_LEGEND_X(zLevel) (SSmapping.fetch_level_datum(zLevel).holomap_legend_x || 96)
#define HOLOMAP_LEGEND_Y(zLevel) (SSmapping.fetch_level_datum(zLevel).holomap_legend_y || 96)

// VG stuff we probably won't use
// #define HOLOMAP_FILTER_DEATHSQUAD				1
// #define HOLOMAP_FILTER_ERT						2
// #define HOLOMAP_FILTER_NUKEOPS					4
// #define HOLOMAP_FILTER_ELITESYNDICATE			8
// #define HOLOMAP_FILTER_VOX						16
// #define HOLOMAP_FILTER_STATIONMAP				32
// #define HOLOMAP_FILTER_STATIONMAP_STRATEGIC		64//features markers over the captain's office, the armory, the SMES

// #define HOLOMAP_MARKER_SMES				"smes"
// #define HOLOMAP_MARKER_DISK				"diskspawn"
// #define HOLOMAP_MARKER_SKIPJACK			"skipjack"
// #define HOLOMAP_MARKER_SYNDISHUTTLE		"syndishuttle"

#define HOLOMAP_EXTRA_STATIONMAP			"stationmapformatted"
#define HOLOMAP_EXTRA_STATIONMAPAREAS		"stationareas"
#define HOLOMAP_EXTRA_STATIONMAPSMALL		"stationmapsmall"
