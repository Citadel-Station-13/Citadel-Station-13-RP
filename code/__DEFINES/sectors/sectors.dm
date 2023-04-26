
//? sector_updates flags
/// weather, including graphics/atmospherics updates involved, is potentially changing
#define SECTOR_UPDATE_WEATHER (1<<0)
/// sunlight, including ambient lighting, is potentially changing
#define SECTOR_UPDATE_SUNLIGHT (1<<1)
/// planetary gasmixture is potentially changing
#define SECTOR_UPDATE_ATMOS (1<<2)
/// time is being changed
#define SECTOR_UPDATE_TIME (1<<3)
