
/// How much shoes slow you down by default. Negative values speed you up.
#define SHOES_SLOWDOWN          0
/// For how bright candles are.
#define CANDLE_LUM 3

// Bitmasks for the /obj/item/var/flags_inv variable. These determine when a piece of clothing hides another, i.e. a helmet hiding glasses.
// WARNING: The following flags apply only to the external suit!
#define HIDEGLOVES      	(1<<0)
#define HIDESUITSTORAGE 	(1<<1)
#define HIDEJUMPSUIT    	(1<<2)
#define HIDESHOES       	(1<<3)
#define HIDETAIL        	(1<<4)
#define HIDETIE         	(1<<5)
///Some clothing hides holsters, but not all accessories
#define HIDEHOLSTER     	(1<<6)
// WARNING: The following flags apply only to the helmets and masks!
#define HIDEMASK 			(1<<7)
/// Headsets and such.
#define HIDEEARS			(1<<8)
/// Glasses.
#define HIDEEYES			(1<<9)
/// Dictates whether we appear as "Unknown".
#define HIDEFACE			(1<<10)
/// Hides the user's hair overlay. Leaves facial hair.
#define BLOCKHEADHAIR		(1<<11)
/// Hides the user's hair, facial and otherwise.
#define BLOCKHAIR			(1<<12)


// Bitflags for clothing parts.
#define HEAD        0x1
#define FACE        0x2
#define EYES        0x4
#define UPPER_TORSO 0x8
#define LOWER_TORSO 0x10
#define LEG_LEFT    0x20
#define LEG_RIGHT   0x40
///  LEG_LEFT | LEG_RIGHT
#define LEGS        0x60
#define FOOT_LEFT   0x80
#define FOOT_RIGHT  0x100
/// FOOT_LEFT | FOOT_RIGHT
#define FEET        0x180
#define ARM_LEFT    0x200
#define ARM_RIGHT   0x400
///  ARM_LEFT | ARM_RIGHT
#define ARMS        0x600
#define HAND_LEFT   0x800
#define HAND_RIGHT  0x1000
/// HAND_LEFT | HAND_RIGHT
#define HANDS       0x1800
#define FULL_BODY   0xFFFF

// Bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection().
// The values here should add up to 1, e.g., the head has 30% protection.
#define THERMAL_PROTECTION_HEAD        0.3
#define THERMAL_PROTECTION_UPPER_TORSO 0.15
#define THERMAL_PROTECTION_LOWER_TORSO 0.15
#define THERMAL_PROTECTION_LEG_LEFT    0.075
#define THERMAL_PROTECTION_LEG_RIGHT   0.075
#define THERMAL_PROTECTION_FOOT_LEFT   0.025
#define THERMAL_PROTECTION_FOOT_RIGHT  0.025
#define THERMAL_PROTECTION_ARM_LEFT    0.075
#define THERMAL_PROTECTION_ARM_RIGHT   0.075
#define THERMAL_PROTECTION_HAND_LEFT   0.025
#define THERMAL_PROTECTION_HAND_RIGHT  0.025

// Pressure limits.
/// This determines at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant)
#define  HAZARD_HIGH_PRESSURE 550
/// This determines when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
#define WARNING_HIGH_PRESSURE 325
/// This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
#define WARNING_LOW_PRESSURE  50
/// This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)
#define  HAZARD_LOW_PRESSURE  20
/// This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define TEMPERATURE_DAMAGE_COEFFICIENT  1.5
/// This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_DIVISOR   12
/// Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_AUTORECOVERY_MINIMUM   1
/// Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_COLD_DIVISOR           6
/// Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR           6
/// The maximum number of degrees that your body can cool down in 1 tick, when in a cold area.
#define BODYTEMP_COOLING_MAX           -30
/// The maximum number of degrees that your body can heat up in 1 tick,   when in a hot  area.
#define BODYTEMP_HEATING_MAX            30
/// The limit the human body can take before it starts taking damage from heat.
#define BODYTEMP_HEAT_DAMAGE_LIMIT 360.15
/// The limit the human body can take before it starts taking damage from coldness.
#define BODYTEMP_COLD_DAMAGE_LIMIT 260.15
/// What min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE 2.0
/// What min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define   SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE 2.0
/// For normal helmets.
#define       HELMET_MIN_COLD_PROTECTION_TEMPERATURE 160
/// For armor.
#define        ARMOR_MIN_COLD_PROTECTION_TEMPERATURE 160
/// For some gloves.
#define       GLOVES_MIN_COLD_PROTECTION_TEMPERATURE 2.0
/// For shoes.
#define         SHOE_MIN_COLD_PROTECTION_TEMPERATURE 2.0
/// These need better heat protect, but not as good heat protect as firesuits.
#define  SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE 5000
/// What max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
#define    FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE 30000
/// For fire-helmet quality items. (Red and white hardhats)
#define FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 30000
/// For normal helmets.
#define      HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 600
/// For armor.
#define       ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE 600
/// For some gloves.
#define      GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE 1500
/// For shoes.
#define        SHOE_MAX_HEAT_PROTECTION_TEMPERATURE 1500
// Fire.
#define FIRE_MIN_STACKS          -20
#define FIRE_MAX_STACKS           25
/// If the number of stacks goes above this firesuits won't protect you anymore. If not, you can walk around while on fire like a badass.
#define FIRE_MAX_FIRESUIT_STACKS  20
/// The throwing speed value at which the throwforce multiplier is exactly 1.
#define THROWFORCE_SPEED_DIVISOR    5
/// The minumum speed of a w_class 2 thrown object that will cause living mobs it hits to be knocked back. Heavier objects can cause knockback at lower speeds.
#define THROWNOBJ_KNOCKBACK_SPEED   15
/// Affects how much speed the mob is knocked back with.
#define THROWNOBJ_KNOCKBACK_DIVISOR 2
// Suit sensor levels
#define SUIT_SENSOR_OFF      0
#define SUIT_SENSOR_BINARY   1
#define SUIT_SENSOR_VITAL    2
#define SUIT_SENSOR_TRACKING 3

// Hair Defines
#define HAIR_VERY_SHORT 0x1
#define HAIR_TIEABLE 0x4
