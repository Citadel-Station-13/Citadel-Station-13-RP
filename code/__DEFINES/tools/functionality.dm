//? Tool Behaviours - make these human readable!

//* Engineering
#define TOOL_CROWBAR 		"crowbar"
#define TOOL_MULTITOOL 		"multitool"
#define TOOL_SCREWDRIVER 	"screwdriver"
#define TOOL_WIRECUTTER 	"wirecutter"
#define TOOL_WRENCH 		"wrench"
#define TOOL_WELDER 		"welder"
#define TOOL_ANALYZER		"analyzer"
//* Mining
#define TOOL_MINING			"mining"
#define TOOL_SHOVEL			"shovel"
//* Surgery
#define TOOL_RETRACTOR	 	"retractor"
#define TOOL_HEMOSTAT 		"hemostat"
#define TOOL_CAUTERY 		"cautery"
#define TOOL_DRILL			"drill"
#define TOOL_SCALPEL		"scalpel"
#define TOOL_SAW			"saw"
//* Glassworking
#define TOOL_BLOW			"blowing-rod"
#define TOOL_GLASS_CUT		"glass-kit"
#define TOOL_BONESET		"bone-setter"

/**
 * Hardcoded tool behaviors.
 */
GLOBAL_REAL_VAR(tool_behaviors_hardcoded) = list(
	// engineering
	TOOL_CROWBAR,
	TOOL_MULTITOOL,
	TOOL_SCREWDRIVER,
	TOOL_WIRECUTTER,
	TOOL_WRENCH,
	TOOL_WELDER,
	TOOL_ANALYZER,
	// mining
	TOOL_MINING,
	TOOL_SHOVEL,
	// surgery
	TOOL_RETRACTOR,
	TOOL_HEMOSTAT,
	TOOL_CAUTERY,
	TOOL_DRILL,
	TOOL_SCALPEL,
	TOOL_SAW,
	// glassworking
	TOOL_BLOW,
	TOOL_GLASS_CUT,
	TOOL_BONESET,
)

/**
 * Remaps for tool behavior names.
 */
GLOBAL_REAL_LIST(tool_behavior_name_remaps) = list()

/**
 * Gets the human-friendly name of a tool behavior.
 */
/proc/tool_behavior_name(behavior)
	return global.tool_behavior_name_remaps[behavior] || behavior

/// Yes, this is a real global. No, you shouldn't touch this for no reason.
/// Add tools to this when they get states in the default icon file for:
/// - neutral (no append)
/// - forwards (append _up)
/// - backwards (append _down)
GLOBAL_REAL_VAR(_dyntool_image_states) = list(
	null = "unknown",
	TOOL_CROWBAR = "crowbar",
	TOOL_SCREWDRIVER = "screwdriver",
)

//? Tool usage flags

// ----------- broad -----------------------

/// repairing
#define TOOL_USAGE_REPAIR (1<<0)
/// initial construction
#define TOOL_USAGE_CONSTRUCT (1<<1)
/// deconstruct
#define TOOL_USAGE_DECONSTRUCT (1<<2)

// ----------- kind ------------------------

/// superstructure, making / breaking turfs, etc
#define TOOL_USAGE_BUILDING_SUPERSTRUCTURE (1<<3)
/// making railings, catwalks, wires, etc
#define TOOL_USAGE_BUILDING_FRAMEWORK (1<<4)
/// making tables, detailed furnishings, etc
#define TOOL_USAGE_BUILDING_FURNISHINGS (1<<5)

//? tool_locked var

/// unlocked - use dynamic tool system
#define TOOL_LOCKING_DYNAMIC 1
/// use static behavior
#define TOOL_LOCKING_STATIC 2
/// automatically, if we only have one dynamic behavior, use that
#define TOOL_LOCKING_AUTO 3

//? Tool directions - used as hints.

#define TOOL_DIRECTION_FORWARDS "forwards"
#define TOOL_DIRECTION_BACKWARDS "backwards"
#define TOOL_DIRECTION_NEUTRAL "neutral"
