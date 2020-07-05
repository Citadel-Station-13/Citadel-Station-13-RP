// Pipe colors
#define	PIPE_COLOR_GREY		"#ffffff"	//yes white is grey
#define	PIPE_COLOR_RED		"#ff0000"
#define	PIPE_COLOR_BLUE		"#0000ff"
#define	PIPE_COLOR_CYAN		"#00ffff"
#define	PIPE_COLOR_GREEN	"#00ff00"
#define	PIPE_COLOR_YELLOW	"#ffcc00"
#define	PIPE_COLOR_BLACK	"#444444"
#define	PIPE_COLOR_PURPLE	"#5c1ec0"
//use this nerd
/*
GLOBAL_LIST_INIT(pipe_paint_colors, list(
		"amethyst" = rgb(130,43,255), //supplymain
		"blue" = rgb(0,0,255),
		"brown" = rgb(178,100,56),
		"cyan" = rgb(0,255,249),
		"dark" = rgb(69,69,69),
		"green" = rgb(30,255,0),
		"grey" = rgb(255,255,255),
		"orange" = rgb(255,129,25),
		"purple" = rgb(128,0,182),
		"red" = rgb(255,0,0),
		"violet" = rgb(64,0,128),
		"yellow" = rgb(255,198,0)
))
*/
//ZAS SPECIFIC

#define HUMAN_NEEDED_OXYGEN (MOLES_CELLSTANDARD * BREATH_PERCENTAGE * 0.16)
#define HUMAN_HEAT_CAPACITY 280000 //J/K For 80kg person

#define MOLES_O2ATMOS (MOLES_O2STANDARD * 50)
#define MOLES_N2ATMOS (MOLES_N2STANDARD * 50)

// Defines how much of certain gas do the Atmospherics tanks start with. Values are in kpa per tile (assuming 20C)
#define ATMOSTANK_NITROGEN      90000 // A lot of N2 is needed to produce air mix, that's why we keep 90MPa of it
#define ATMOSTANK_OXYGEN        40000 // O2 is also important for airmix, but not as much as N2 as it's only 21% of it.
#define ATMOSTANK_CO2           25000 // CO2 and PH are not critically important for station, only for toxins and alternative coolants, no need to store a lot of those.
#define ATMOSTANK_PHORON        25000
#define ATMOSTANK_NITROUSOXIDE  10000 // N2O doesn't have a real useful use, i guess it's on station just to allow refilling of sec's riot control canisters?.

//Flags for zone sleeping
#define ZONE_SLEEPING 0
#define ZONE_ACTIVE   1
