//* Balancing - Efficiency *//

/// Global power efficiency of pumps - enforced by transfer helpers, not the machine!
#define ATMOS_ABSTRACT_PUMP_EFFICIENCY   2.5
/// Global power efficiency of scrubbing - enforced by transfer helpers, not the machine!
#define ATMOS_ABSTRACT_SCRUB_EFFICIENCY  2.5
/// Global power efficiency of filtering - enforced by transfer helpers, not the machine!
#define ATMOS_ABSTRACT_FILTER_EFFICIENCY 2.5

//* /obj/machinery/atmospherics/component atmos_component_ui_flags

/// allow toggling power
#define ATMOS_COMPONENT_UI_TOGGLE_POWER (1<<0)
/// allow setting power. implies SEE_POWER.
#define ATMOS_COMPONENT_UI_SET_POWER (1<<1)
/// render power usage
#define ATMOS_COMPONENT_UI_SEE_POWER (1<<2)

DEFINE_BITFIELD(atmos_component_ui_flags, list(
	BITFIELD(ATMOS_COMPONENT_UI_TOGGLE_POWER),
	BITFIELD(ATMOS_COMPONENT_UI_SET_POWER),
	BITFIELD(ATMOS_COMPONENT_UI_SEE_POWER),
))

//* /obj/machinery/portable_atmospherics atmos_portable_ui_flags

/// view flow
#define ATMOS_PORTABLE_UI_SEE_FLOW (1<<0)
/// toggle on/off
#define ATMOS_PORTABLE_UI_TOGGLE_POWER (1<<1)
/// adjust flow. implies SEE_FLOW.
#define ATMOS_PORTABLE_UI_SET_FLOW (1<<2)
/// adjust power. implies SEE_POWER.
#define ATMOS_PORTABLE_UI_SET_POWER (1<<3)
/// see power
#define ATMOS_PORTABLE_UI_SEE_POWER (1<<4)

DEFINE_BITFIELD(atmos_portable_ui_flags, list(
	BITFIELD(ATMOS_PORTABLE_UI_SEE_FLOW),
	BITFIELD(ATMOS_PORTABLE_UI_TOGGLE_POWER),
	BITFIELD(ATMOS_PORTABLE_UI_SET_FLOW),
	BITFIELD(ATMOS_PORTABLE_UI_SET_POWER),
	BITFIELD(ATMOS_PORTABLE_UI_SEE_POWER),
))
