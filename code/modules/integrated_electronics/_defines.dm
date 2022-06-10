// Base cost modifiers.

#define IC_COMPONENTS_BASE		25
#define IC_COMPLEXITY_BASE		75
#define IC_MATERIAL_MODIFIER 	1	// TBI when materials get updated.
/// Calculates the cost of a given assembly.
#define IC_ASSEMBLY_COST(ea)	(round((ea.max_components + ea.max_complexity) / 4))

// Base pin types.

#define IC_INPUT "input"
#define IC_OUTPUT "output"
#define IC_ACTIVATOR "activator"

// Pin functionality.
#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

// Categories that help differentiate circuits that can do different types of actions.

#define IC_ACTION_MOVEMENT		(1<<0) // If the circuit can move the assembly
#define IC_ACTION_COMBAT		(1<<1) // If the circuit can cause harm
#define IC_ACTION_LONG_RANGE	(1<<2) // If the circuit communicate with something outside of the assembly

// Displayed along with the pin name to show what type of pin it is.
#define IC_FORMAT_ANY			"\<ANY\>"
#define IC_FORMAT_STRING		"\<TEXT\>"
#define IC_FORMAT_CHAR			"\<CHAR\>"
#define IC_FORMAT_COLOR			"\<COLOR\>"
#define IC_FORMAT_NUMBER		"\<NUM\>"
#define IC_FORMAT_DIR			"\<DIR\>"
#define IC_FORMAT_BOOLEAN		"\<BOOL\>"
#define IC_FORMAT_REF			"\<REF\>"
#define IC_FORMAT_LIST			"\<LIST\>"
#define IC_FORMAT_INDEX			"\<INDEX\>"
#define IC_FORMAT_SELFREF		"\<SELF REF\>"

#define IC_FORMAT_PULSE			"\<PULSE\>"
#define IC_FORMAT_INPUT			"\<INPUT\>"
#define IC_FORMAT_OUTPUT		"\<OUTPUT\>"

// Used inside input/output list to tell the constructor what pin to make.
#define IC_PINTYPE_ANY				/datum/integrated_io
#define IC_PINTYPE_STRING			/datum/integrated_io/string
#define IC_PINTYPE_CHAR				/datum/integrated_io/char
#define IC_PINTYPE_COLOR			/datum/integrated_io/color
#define IC_PINTYPE_NUMBER			/datum/integrated_io/number
#define IC_PINTYPE_DIR				/datum/integrated_io/dir
#define IC_PINTYPE_BOOLEAN			/datum/integrated_io/boolean
#define IC_PINTYPE_REF				/datum/integrated_io/ref
#define IC_PINTYPE_LIST				/datum/integrated_io/lists
#define IC_PINTYPE_INDEX			/datum/integrated_io/index
#define IC_PINTYPE_SELFREF			/datum/integrated_io/selfref

#define IC_PINTYPE_PULSE_IN			/datum/integrated_io/activate
#define IC_PINTYPE_PULSE_OUT		/datum/integrated_io/activate/out

// Circuit limiters.

#define IC_MAX_LIST_LENGTH				500
#define IC_DEFAULT_COOLDOWN				1
#define IC_SMOKE_REAGENTS_MINIMUM_UNITS	10

// Printer limits.

#define MAX_CIRCUIT_CLONE_TIME 3 MINUTES //circuit slow-clones can only take up this amount of time to complete

var/list/all_integrated_circuits = list()

//Mostly deprecated, currently only used for circuit bags in integrated_electronics\core\tools.dm
/proc/initialize_integrated_circuits_list()
	for(var/thing in typesof(/obj/item/integrated_circuit))
		all_integrated_circuits += new thing()
