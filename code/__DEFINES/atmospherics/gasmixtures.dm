//* Helpers, so we're not up a creek if we ever decide to use something like auxmos. *//

//? group multiplier dependent ?//

/// Takes group_multiplier into account.
#define XGM_VOLUME(GM) (GM.volume * GM.group_multiplier)
/// Does not take group_multiplier into account.
#define XGM_VOLUME_SINGULAR(GM) (GM.volume)
/// Takes group_multiplier into account.
#define XGM_TOTAL_MOLES(GM) (GM.total_moles * GM.group_multiplier)
/// Does not take group_multiplier into account.
#define XGM_TOTAL_MOLES_SINGULAR(GM) (GM.total_moles)
/// Takes group_multiplier into account.
#define XGM_HEAT_CAPACITY(GM) (GM.heat_capacity())
/// Does not take group_multiplier into account.
#define XGM_HEAT_CAPACITY_SINGULAR(GM) (GM.heat_capacity() / GM.group_multiplier)

//? uniform properties ?//

#define XGM_PRESSURE(GM) (GM.return_pressure())
#define XGM_TEMPERATURE(GM) (GM.temperature)
