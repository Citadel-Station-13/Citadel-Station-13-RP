//*      Specific Heat Definitions           *//
//*     These are all in J / (K * mol).      *//

#define SPECIFIC_HEAT_STP (/datum/gas/oxygen::specific_heat * 0.2 + /datum/gas/nitrogen::specific_heat * 0.8)

//*   Heat Capacity Definitions      *//
//*     These are all in J / K.      *//

#define HEAT_CAPACITY_STP (SPECIFIC_HEAT_STP * ((ONE_ATMOSPHERE * CELL_VOLUME) / (R_IDEAL_GAS_EQUATION * T20C)))

//*   Thermal Energy Definitions      *//
//*     These are all in J .          *//

#define THERMAL_ENERGY_STP_FOR_CHANGE(IN_KELVIN) (IN_KELVIN * HEAT_CAPACITY_STP)
