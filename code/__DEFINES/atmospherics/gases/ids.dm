/**
 * !! THESE PREFIXES ARE RESERVED. !!
 * !! No touchies.                 !!
 * !! They're used for randomgen   !!
 * !! and we don't want collisions.!!
 * ?? These can be changed a will, ??
 * ?? as they will probably never  ??
 * ?? be directly mapped in.       ??
 */
/// prefix reserved for dynamic chemgas later
#define GAS_ID_PREFIX_REAGENTS "r_"
/// random generated gas
#define GAS_ID_PREFIX_PROCGEN "x_"

/**
 * !! Hardcoded Gas IDs !!
 * ?? Naming convention:                 ??
 * ?? Use chemical formula if based off  ??
 * ?? of a real gas, otherwise make      ??
 * ?? something that doesn't collide     ??
 * ?? with the dynamic prefixes that     ??
 * ?? makes sense like "fuel", "phoron". ??
 * !! These may not be changed at will.  !!
 * !! Maps can contain them sometimes,   !!
 * !! so changing them will break things !!
 */
#define GAS_ID_OXYGEN "o2"
#define GAS_ID_NITROGEN "n2"
#define GAS_ID_CARBON_DIOXIDE "co2"
#define GAS_ID_PHORON "phoron"
#define GAS_ID_VOLATILE_FUEL "fuel"
#define GAS_ID_NITROUS_OXIDE "n2o"
#define GAS_ID_HELIUM "he"
#define GAS_ID_CARBON_MONOXIDE "co"
#define GAS_ID_METHYL_BROMIDE "ch3br"
#define GAS_ID_NITROGEN_DIOXIDE "no2"
#define GAS_ID_NITRIC_OXIDE "no"
#define GAS_ID_METHANE "ch4"
#define GAS_ID_ARGON "ar"
#define GAS_ID_KRYPTON "kr"
#define GAS_ID_NEON "ne"
#define GAS_ID_AMMONIA "nh3"
#define GAS_ID_XENON "xe"
#define GAS_ID_CHLORINE "cl2"
#define GAS_ID_SULFUR_DIOXIDE "so2"
#define GAS_ID_HYDROGEN "h2"
#define GAS_ID_DEUTERIUM "2h2"
#define GAS_ID_TRITIUM "3h2"
#define GAS_ID_VIMUR "vimur"
