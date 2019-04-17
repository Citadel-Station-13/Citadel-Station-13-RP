

#define CELLCHARGE_DEVICE_NORMAL 480
#define CELLCHARGE_WEAPON_NORMAL 2400

//calculates the amount of energy to use per shot to have that many shots with a normal weapon cell
#define SCALE_ENERGY_WEAPON_NORMAL(A) (CELLCHARGE_WEAPON_NORMAL / A)
