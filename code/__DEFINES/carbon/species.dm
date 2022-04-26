///*ALL SPECIES-RELATED FLAGS GO HERE*/


//! ## Species flags.
/// Can step on broken glass with no ill-effects. Either thick skin (diona), cut resistant (slimes) or incorporeal (shadows)
#define NO_MINOR_CUT (1 << 0)
/// Is a treeperson.
#define IS_PLANT (1 << 1)
/// Cannot be scanned in a DNA machine/genome-stolen.
#define NO_SCAN (1 << 2)
/// Cannot suffer halloss/recieves deceptive health indicator.
#define NO_PAIN (1 << 3)
/// Cannot fall over.
#define NO_SLIP (1 << 4)
/// Cannot not suffer toxloss.
#define NO_POISON (1 << 5)
/// Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define NO_EMBED (1 << 6)
/// Don't hallucinate, ever.
#define NO_HALLUCINATION (1 << 7)
/// Never bleed, never show blood amount.
#define NO_BLOOD (1 << 8)
/// Various things that living things don't do, mostly for skeletons.
#define UNDEAD (1 << 9)
/// Don't allow infections in limbs or organs, similar to IS_PLANT, without other strings.
#define NO_INFECT (1 << 10)
/// Cannot be defibbed.
#define NO_DEFIB (1 << 11)
///(Phoron) Contamination doesnt affect them.
#define CONTAMINATION_IMMUNE (1 << 12)
// unused: 0x8000 - higher than this will overflow


//! ## Species spawn flags
/// Must be whitelisted to play.
#define SPECIES_IS_WHITELISTED (1 << 0)
/// Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_IS_RESTRICTED (1 << 1)
/// Species is selectable in chargen.
#define SPECIES_CAN_JOIN (1 << 2)
/// FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CONSTRUCTION (1 << 3)
/// FBP of this species can't be selected at chargen.
#define SPECIES_NO_FBP_CHARGEN (1 << 4)
/// Species cannot start with robotic organs or have them attached.
#define SPECIES_NO_ROBOTIC_INTERNAL_ORGANS (1 << 5)
/// Can select and customize, but not join as
#define SPECIES_WHITELIST_SELECTABLE (1 << 6)


//! ## Species appearance flags
/// Skin tone selectable in chargen. (0-255)
#define HAS_SKIN_TONE (1 << 0)
/// Skin colour selectable in chargen. (RGB)
#define HAS_SKIN_COLOR (1 << 1)
/// Lips are drawn onto the mob icon. (lipstick)
#define HAS_LIPS (1 << 2)
/// Underwear is drawn onto the mob icon.
#define HAS_UNDERWEAR (1 << 3)
/// Eye colour selectable in chargen. (RGB)
#define HAS_EYE_COLOR (1 << 4)
/// Hair colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR (1 << 5)
/// Radiation causes this character to glow.
#define RADIATION_GLOWS (1 << 6)
/// Sets default skin colors based on icons.
#define BASE_SKIN_COLOR (1 << 7)


//! ## Species skin flags
#define SKIN_NORMAL (1 << 0)
#define SKIN_THREAT (1 << 1)
#define SKIN_CLOAK  (1 << 2)


//! ## Environmental Defines ## !//

//! ## Pressure limits.
/// This determines at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant
#define HAZARD_HIGH_PRESSURE 550
/// This determines when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
#define WARNING_HIGH_PRESSURE 325
/// This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
#define WARNING_LOW_PRESSURE 50
/// This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)
#define HAZARD_LOW_PRESSURE 20

//! ## Body Temperature
/// The natural temperature for a body
#define BODYTEMP_NORMAL 310.15
/// This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_DIVISOR 28
/// Minimum amount of kelvin moved toward 310K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_AUTORECOVERY_MINIMUM 3
///Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_COLD_DIVISOR 15
/// Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR 15
/// The maximum number of degrees that your body can cool in 1 tick, due to the environment, when in a cold area.
#define BODYTEMP_COOLING_MAX -30
/// The maximum number of degrees that your body can heat up in 1 tick, due to the environment, when in a hot area.
#define BODYTEMP_HEATING_MAX 30

/// This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define TEMPERATURE_DAMAGE_COEFFICIENT 1.5

//! ## Body Temperature Limits
/// The body temperature limit the human body can take before it starts taking damage from heat.
/// This also affects how fast the body normalises it's temperature when hot.
/// 340k is about 66c, and rather high for a human.
#define BODYTEMP_HEAT_DAMAGE_LIMIT (BODYTEMP_NORMAL + 30)
/// The body temperature limit the human body can take before it starts taking damage from cold.
/// This also affects how fast the body normalises it's temperature when cold.
/// 270k is about -3c, that is below freezing and would hurt over time.
#define BODYTEMP_COLD_DAMAGE_LIMIT (BODYTEMP_NORMAL - 40)
/// The body temperature limit the human body can take before it will take wound damage.
#define BODYTEMP_HEAT_WOUND_LIMIT (BODYTEMP_NORMAL + 90) // 400.5 k
/// The modifier on cold damage limit hulks get ontop of their regular limit
#define BODYTEMP_HULK_COLD_DAMAGE_LIMIT_MODIFIER 25
/// The modifier on cold damage hulks get.
#define HULK_COLD_DAMAGE_MOD 2

//! ## Body Temperature Warning Icons
/// The temperature the light green icon is displayed.
#define BODYTEMP_COLD_WARNING_1 (BODYTEMP_COLD_DAMAGE_LIMIT) //270k
/// The temperature the cyan icon is displayed.
#define BODYTEMP_COLD_WARNING_2 (BODYTEMP_COLD_DAMAGE_LIMIT - 70) //200k
/// The temperature the blue icon is displayed.
#define BODYTEMP_COLD_WARNING_3 (BODYTEMP_COLD_DAMAGE_LIMIT - 150) //120k

/// The temperature the yellow icon is displayed.
#define BODYTEMP_HEAT_WARNING_1 (BODYTEMP_HEAT_DAMAGE_LIMIT) //340K
/// The temperature the orange icon is displayed.
#define BODYTEMP_HEAT_WARNING_2 (BODYTEMP_HEAT_DAMAGE_LIMIT + 120) //460K
/// The temperature the red icon is displayed.
#define BODYTEMP_HEAT_WARNING_3 (BODYTEMP_HEAT_DAMAGE_LIMIT + 360) //+700k
