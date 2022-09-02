/// Return this from `/datum/component/Initialize` or `datum/component/OnTransfer` to have the component be deleted if it's applied to an incorrect type.
/// `parent` must not be modified if this is to be returned.
/// This will be noted in the runtime logs
#define COMPONENT_INCOMPATIBLE (1<<0)
/// Returned in PostTransfer to prevent transfer, similar to `COMPONENT_INCOMPATIBLE`
#define COMPONENT_NOTRANSFER (1<<1)

/// Return value to cancel attaching
#define ELEMENT_INCOMPATIBLE (1<<0)

// /datum/element flags
/// Causes the detach proc to be called when the host object is being deleted
#define ELEMENT_DETACH (1 << 0)
/**
 * Only elements created with the same arguments given after `id_arg_index` share an element instance
 * The arguments are the same when the text and number values are the same and all other values have the same ref
 */
#define ELEMENT_BESPOKE (1 << 1)
/// Causes all detach arguments to be passed to detach instead of only being used to identify the element
/// When this is used your Detach proc should have the same signature as your Attach proc
#define ELEMENT_COMPLEX_DETACH (1 << 2)

// How multiple components of the exact same type are handled in the same datum
/// old component is deleted (default)
#define COMPONENT_DUPE_HIGHLANDER 0
/// duplicates allowed
#define COMPONENT_DUPE_ALLOWED 1
/// new component is deleted
#define COMPONENT_DUPE_UNIQUE 2
/// old component is given the initialization args of the new
#define COMPONENT_DUPE_UNIQUE_PASSARGS 4
/// each component of the same type is consulted as to whether the duplicate should be allowed
#define COMPONENT_DUPE_SELECTIVE 5

//Redirection component init flags
#define REDIRECT_TRANSFER_WITH_TURF 1

//Arch
///Probability for each item
#define ARCH_PROB "probability"
///each item's max drop amount
#define ARCH_MAXDROP "max_drop_amount"
//Ouch my toes!
#define CALTROP_BYPASS_SHOES (1 << 0)
#define CALTROP_IGNORE_WALKERS (1 << 1)
#define CALTROP_SILENT (1 << 2)
#define CALTROP_NOSTUN (1 << 3)
#define CALTROP_NOCRAWL (1 << 4)

//Ingredient type in datum/component/customizable_reagent_holder
#define CUSTOM_INGREDIENT_TYPE_EDIBLE 1
#define CUSTOM_INGREDIENT_TYPE_DRYABLE 2

//Icon overlay type in datum/component/customizable_reagent_holder
#define CUSTOM_INGREDIENT_ICON_NOCHANGE 0
#define CUSTOM_INGREDIENT_ICON_FILL 1
#define CUSTOM_INGREDIENT_ICON_SCATTER 2
#define CUSTOM_INGREDIENT_ICON_STACK 3
#define CUSTOM_INGREDIENT_ICON_LINE 4
#define CUSTOM_INGREDIENT_ICON_STACKPLUSTOP 5

// Conflict element IDs
#define CONFLICT_ELEMENT_CRUSHER "crusher"
#define CONFLICT_ELEMENT_KA "kinetic_accelerator"

//! riding handler flags
/// ephemeral - delete on last mob unbuckled
#define CF_RIDING_HANDLER_EPHEMERAL					(1<<0)
/// allow us to be one away from valid turfs
#define CF_RIDING_HANDLER_ALLOW_BORDER				(1<<1)
/// always allow spacemove
#define CF_RIDING_HANDLER_FORCED_SPACEMOVE			(1<<2)
/// allow "piloting" of the thing we're riding at all
#define CF_RIDING_HANDLER_IS_CONTROLLABLE			(1<<3)
/// for allow borders, do not allow crossing
#define CF_RIDING_HANDLER_FORBID_BORDER_CROSS		(1<<4)

DEFINE_BITFIELD(riding_handler_flags, list(
	BITFIELD(CF_RIDING_HANDLER_EPHEMERAL),
	BITFIELD(CF_RIDING_HANDLER_ALLOW_BORDER),
	BITFIELD(CF_RIDING_HANDLER_FORCED_SPACEMOVE),
	BITFIELD(CF_RIDING_HANDLER_IS_CONTROLLABLE),
	BITFIELD(CF_RIDING_HANDLER_FORBID_BORDER_CROSS),
))

//! riding check flags
/// if unconscious
#define CF_RIDING_CHECK_UNCONSCIOUS					(1<<0)
/// if restrained
#define CF_RIDING_CHECK_RESTRAINED					(1<<1)
/// if no arms - behavior depends on component
#define CF_RIDING_CHECK_ARMS						(1<<2)
/// if no legs - behavior depends on component
#define CF_RIDING_CHECK_LEGS						(1<<3)

DEFINE_BITFIELD(rider_check_flags, list(
	BITFIELD(CF_RIDING_CHECK_UNCONSCIOUS),
	BITFIELD(CF_RIDING_CHECK_RESTRAINED),
	BITFIELD(CF_RIDING_CHECK_ARMS),
	BITFIELD(CF_RIDING_CHECK_LEGS),
))
DEFINE_BITFIELD(ridden_check_flags, list(
	BITFIELD(CF_RIDING_CHECK_UNCONSCIOUS),
	BITFIELD(CF_RIDING_CHECK_RESTRAINED),
	BITFIELD(CF_RIDING_CHECK_ARMS),
	BITFIELD(CF_RIDING_CHECK_LEGS),
))
