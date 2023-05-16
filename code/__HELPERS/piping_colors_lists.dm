// Pipe colors
#define	PIPE_COLOR_GREY		"#ffffff"	//yes white is grey
#define	PIPE_COLOR_RED		"#ff0000"
#define	PIPE_COLOR_BLUE		"#0000ff"
#define	PIPE_COLOR_CYAN		"#00ffff"
#define	PIPE_COLOR_GREEN	"#00ff00"
#define PIPE_COLOR_ORANGE	"#ff9900"
#define	PIPE_COLOR_YELLOW	"#ffcc00"
#define	PIPE_COLOR_BROWN	"#4e462f"
#define	PIPE_COLOR_BLACK	"#333333"
#define	PIPE_COLOR_PURPLE	"#5c1ec0"


///All colors available to pipes and atmos components
GLOBAL_LIST_INIT(pipe_paint_colors, list(
	"green" = PIPE_COLOR_GREEN,
	"blue" = PIPE_COLOR_BLUE,
	"red" = PIPE_COLOR_RED,
	"orange" = PIPE_COLOR_ORANGE,
	"cyan" = PIPE_COLOR_CYAN,
	"dark" = PIPE_COLOR_BLACK,
	"yellow" = PIPE_COLOR_YELLOW,
	"brown" = PIPE_COLOR_BROWN,
	"purple" = PIPE_COLOR_PURPLE,
	"omni" = PIPE_COLOR_GREY
))

///List that sorts the colors and is used for setting up the pipes layer so that they overlap correctly
GLOBAL_LIST_INIT(pipe_colors_ordered, tim_sort(list(
	PIPE_COLOR_BLUE = -5,
	PIPE_COLOR_BROWN = -4,
	PIPE_COLOR_CYAN = -3,
	PIPE_COLOR_BLACK = -2,
	PIPE_COLOR_GREEN = -1,
	PIPE_COLOR_GREY = 0,
	PIPE_COLOR_ORANGE = 1,
	PIPE_COLOR_PURPLE = 2,
	PIPE_COLOR_RED = 3,
	PIPE_COLOR_YELLOW = 4
), /proc/cmp_text_asc))

///Names shown in the examine for every colored atmos component
GLOBAL_LIST_INIT(pipe_color_name, tim_sort(list(
	PIPE_COLOR_GREY = "omni",
	PIPE_COLOR_BLUE = "blue",
	PIPE_COLOR_RED = "red",
	PIPE_COLOR_GREEN = "green",
	PIPE_COLOR_ORANGE = "orange",
	PIPE_COLOR_CYAN = "cyan",
	PIPE_COLOR_BLACK = "dark",
	PIPE_COLOR_YELLOW = "yellow",
	PIPE_COLOR_BROWN = "brown",
	PIPE_COLOR_PURPLE = "purple"
), /proc/cmp_text_asc))
