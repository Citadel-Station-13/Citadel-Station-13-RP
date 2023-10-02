//! helpers for if we end up doing auxmos

#define GAS_MIXTURE_VOLUME(GM) (GM.volume * GM.group_multiplier)
#define GAS_MIXTURE_VOLUME_SINGULAR(GM) (GM.volume)
#define GAS_MIXTURE_PRESSURE(GM) (GM.return_pressure())
#define GAS_MIXTURE_TEMPERATURE(GM) (GM.temperature)
#define GAS_MIXTURE_TOTAL_MOLES(GM) (GM.total_moles * GM.group_multiplier)
#define GAS_MIXTURE_TOTAL_MOLES_SINGULAR(GM) (GM.total_moles)
#define GAS_MIXTURE_HEAT_CAPACITY(GM) (GM.heat_capacity())
