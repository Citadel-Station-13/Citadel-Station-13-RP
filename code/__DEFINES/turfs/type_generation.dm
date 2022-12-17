
#define CREATE_STANDARD_TURFS(type) \
##type/indoors; \
##type/indoors/outdoors = FALSE; \
##type/indoors/initial_gas_mix = ATMOSPHERE_USE_INDOORS; \
##type/outdoors/outdoors = TRUE; \
##type/outdoors/initial_gas_mix = ATMOSPHERE_USE_OUTDOORS; \
##type/default/outdoors = null; \
##type/default/initial_gas_mix = ATMOSPHERE_USE_AREA; \
##type/overhang/outdoors = FALSE; \
##type/overhand/initial_gas_mix = ATMOSPHERE_USE_OUTDOORS;
