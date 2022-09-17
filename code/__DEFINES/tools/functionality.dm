//! Tool Behaviours - these should be human readable!

//? Engineering
#define TOOL_CROWBAR 		"crowbar"
#define TOOL_MULTITOOL 		"multitool"
#define TOOL_SCREWDRIVER 	"screwdriver"
#define TOOL_WIRECUTTER 	"wirecutter"
#define TOOL_WRENCH 		"wrench"
#define TOOL_WELDER 		"welder"
#define TOOL_ANALYZER		"analyzer"
//? Mining
#define TOOL_MINING			"mining"
#define TOOL_SHOVEL			"shovel"
//? Surgery
#define TOOL_RETRACTOR	 	"retractor"
#define TOOL_HEMOSTAT 		"hemostat"
#define TOOL_CAUTERY 		"cautery"
#define TOOL_DRILL			"drill"
#define TOOL_SCALPEL		"scalpel"
#define TOOL_SAW			"saw"
//? Glassworking
#define TOOL_BLOW			"blowing_rod"
#define TOOL_GLASS_CUT		"glasskit"
#define TOOL_BONESET		"bonesetter"

/// Yes, this is a real global. No, you shouldn't touch this for no reason.
/// Add tools to this when they get states in the default icon file for:
/// - neutral (no append)
/// - forwards (append _up)
/// - backwards (append _down)
GLOBAL_REAL_VAR(_dyntool_image_states) = list(
	null = "unknown",
	TOOL_CROWBAR = "crowbar",
	TOOL_SCREWDRIVER = "screwdriver"
)

//! Tool usage flags

//? None yet! Waiting on skill-system design.

//! Tool hints - while not needing to be defined, this lets us easily display messages
//! if the item in question is doing a specific thing by overriding feedback builder procs!

#define TOOL_HINT_UNSCREWING_WINDOW_FRAME "Unfasten Frame"
#define TOOL_HINT_SCREWING_WINDOW_FRAME "Fasten Frame"
#define TOOL_HINT_UNSCREWING_WINDOW_PANE "Unfasten Window"
#define TOOL_HINT_SCREWING_WINDOW_PANE "Unfasten Frame"
#define TOOL_HINT_CROWBAR_WINDOW_IN "Pry In Window"
#define TOOL_HINT_CROWBRA_WINDOW_OUT "Pry Out Window"
