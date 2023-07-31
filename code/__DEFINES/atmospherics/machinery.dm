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
/// allow setting power
#define ATMOS_COMPONENT_UI_SET_POWER (1<<1)
/// render power usage
#define ATMOS_COMPONENT_UI_SEE_POWER (1<<2)
