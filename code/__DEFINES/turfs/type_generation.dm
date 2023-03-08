
#define CREATE_STANDARD_TURFS(type) \
##type/indoors { \
	outdoors = FALSE; \
	initial_gas_mix = ATMOSPHERE_USE_INDOORS; \
} \
##type/outdoors { \
	outdoors = TRUE; \
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS; \
} \
##type/default { \
	outdoors = null; \
	initial_gas_mix = ATMOSPHERE_USE_AREA; \
} \
##type/overhang { \
	outdoors = FALSE; \
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS; \
}
