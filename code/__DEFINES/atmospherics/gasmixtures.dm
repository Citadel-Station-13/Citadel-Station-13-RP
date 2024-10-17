//* Helpers, so we're not up a creek if we ever decide to use something like auxmos. *//
//*    -- These are only necessary for things that aren't already proc-calls! --     *//

//* group multiplier dependent *//

/// Takes group_multiplier into account.
#define XGM_VOLUME(GM) (GM.volume * GM.group_multiplier)
/// Does not take group_multiplier into account.
#define XGM_VOLUME_SINGULAR(GM) (GM.volume)
/// Takes group_multiplier into account.
#define XGM_TOTAL_MOLES(GM) (GM.total_moles * GM.group_multiplier)
/// Does not take group_multiplier into account.
#define XGM_TOTAL_MOLES_SINGULAR(GM) (GM.total_moles)
/// Takes group_multiplier into account.
///
/// * In Joules
#define XGM_THERMAL_ENERGY(GM) (GM.heat_capacity() * GM.temperature)
/// Does not take group_multiplier into account.
///
/// * In Joules
#define XGM_THERMAL_ENERGY_SINGULAR(GM) (GM.heat_capacity_singular() * GM.temperature)

//* group multiplier independent *//

#define XGM_TEMPERATURE(GM) (GM.temperature)
#define XGM_PRESSURE(GM) ((GM.total_moles * R_IDEAL_GAS_EQUATION * GM.temperature) / GM.volume)
