//! mobs
//? add/remove
/// radiation applied via rad_act is multiplied by this
#define RAD_MOB_ACT_COEFFICIENT 0.20
/// flat loss to radiation hitting mobs via rad_act per wave source
#define RAD_MOB_ACT_PROTECTION_PER_WAVE_SOURCE 5
/// rad overdose coefficient. calculates radiation ** 2 * this threshold = number of times less radiation to take
#define RAD_MOB_OVERDOSE_REDUCTION 0.000001
/// add radiation taking into account overdose
#define RAD_MOB_ADDITIONAL(amt, rads) (amt * (1 / (((rads ** 1.5) * RAD_MOB_OVERDOSE_REDUCTION) + 1)))
/// radiation to drop every second
#define RAD_MOB_PASSIVE_LOSS_FOR(amt, dt) ((amt > 1000? ((amt / 1000) ** 1.3) : 1) * dt)
/// radiation below which we don't tick effects at all
#define RAD_MOB_NEGLIGIBLE 500
//? warning
/// minimum amount for warning
#define RAD_MOB_WARNING_THRESHOLD 750
/// chance per second of warning
#define RAD_MOB_WARNING_CHANCE(rads, dt) (dt * 1)
//? toxins
/// minimum amount for toxins
#define RAD_MOB_TOXIN_THRESHOLD 500
/// toxin damage per tick
#define RAD_MOB_TOXIN_DAMAGE_FOR(amt, dt) (min(3, (amt / 1000) * 0.1) * dt)
// #define RAD_MOB_TOXIN_DAMAGE_FOR(amt, dt) (min(3, ((amt / 500) ** 1.2) * 0.1) * dt)
/// toxin damage per tick, synths
#define RAD_MOB_SYNTH_INSTABILITY_FOR(amt, dt) RAD_MOB_TOXIN_DAMAGE_FOR(amt, dt) // same for now
//? burns
/// minimum amount for burns
#define RAD_MOB_BURN_THRESHOLD 1500 // boy you fucked up if your skin is blistering
/// burn per tick
#define RAD_MOB_BURN_DAMAGE_FOR(amt, dt) (min(5, (((amt - 1500) / 750) ** 1.3) * 0.1) * dt)
/// do we burn synths
// #define RAD_MOB_BURNS_SYNTHETICS
/// burn per tick, synths
#define RAD_MOB_SYNTH_BURN_FOR(amt, dt) 0 // synth gang synth gang
//? genes
// todo: good genetics
/// mutate threshold
// #define RAD_MOB_MUTATE_THREHSOLD 1250
/// mutate chance
// #define RAD_MOB_MUTATE_CHANCE(amt, dt)
//? hair
/// hairloss threshold
#define RAD_MOB_HAIRLOSS_THRESHOLD 800
/// hairloss chance
#define RAD_MOB_HAIRLOSS_CHANCE(amt, dt) (dt)
//? vomit
/// vomit threshold
#define RAD_MOB_VOMIT_THRESHOLD 2000
/// vomit chance
#define RAD_MOB_VOMIT_CHANCE(amt, dt) (dt)
//? cloneloss
/// declone threshold
#define RAD_MOB_DECLONE_THRESHOLD 2000
/// declone chance
#define RAD_MOB_DECLONE_CHANCE(amt, dt) (dt * 0.5)
/// declone amount
#define RAD_MOB_DECLONE_DAMAGE(amt, dt) rand(3, 8)
//? paralysis
/// knockdown threshold
#define RAD_MOB_KNOCKDOWN_THRESHOLD 2000
/// do we proc on synths?
// #define RAD_MOB_KNOCKDOWN_SYNTHETICS
/// knockdown chance
#define RAD_MOB_KNOCKDOWN_CHANCE(amt, dt) (dt)
/// knockdown amount
#define RAD_MOB_KNOCKDOWN_AMOUNT(amt, dt) 3

//! monkies
// todo: add harambe
// #define RAD_MONKEY_GORILLIZE 1650					// How much stored radiation to check for Harambe time.
// #define RAD_MONKEY_GORILLIZE_FACTOR 100
// #define RAD_MONKEY_GORILLIZE_EXPONENT 0.5

//! virology

#define RAD_VIRUS_MUTATE 200	// threshold for viruses to mutate

//! stuff passed into afflict/cure_radiation

#define RAD_MOB_AFFLICT_STRENGTH_SIFSLURRY_OD(removed) (50 * removed)
#define RAD_MOB_AFFLICT_STRENGTH_ASLIMETOXIN(removed) (50 * removed)
#define RAD_MOB_AFFLICT_STRENGTH_SLIMETOXIN(removed) (75 * removed)
#define RAD_MOB_AFFLICT_STRENGTH_MUTAGEN(removed) (100 * removed)
#define RAD_MOB_AFFLICT_STRENGTH_RADIUM(removed) (100 * removed)
#define RAD_MOB_AFFLICT_DNA_INJECTOR (rand(150, 300))
#define RAD_MOB_AFFLICT_FLORARAY_ON_PLANT (rand(30, 80))
#define RAD_MOB_AFFLICT_VIRUS_RADIAN(multiplier) (multiplier * 15)
#define RAD_MOB_AFFLICT_ANOMALY_BURST 500
#define RAD_MOB_AFFLICT_DNA_MODIFIER(intensity, duration) (intensity * duration)
#define RAD_MOB_AFFLICT_DNA_MODIFIER_PULSE 150
#define RAD_MOB_AFFLICT_DNA_MODIFIER_TRANSFER 150

#define RAD_MOB_CURE_STRENGTH_HYRONALIN(removed) (50 * removed)
#define RAD_MOB_CURE_STRENGTH_ARITHRAZINE(removed) (100 * removed)
#define RAD_MOB_CURE_STRENGTH_CLEANSALAZE(removed) (50 * removed)
#define RAD_MOB_CURE_STRENGTH_MEDIGUN 100
#define RAD_MOB_CURE_STRENGTH_VODKA(removed) (20 * removed)
#define RAD_MOB_CURE_STRENGTH_GODKA(removed) (100 * removed)
#define RAD_MOB_CURE_ADHERENT_BATH 75
#define RAD_MOB_CURE_SYNTH_CHARGER 75
#define RAD_MOB_CURE_PROTEAN_REGEN 50
#define RAD_MOB_CURE_ANOMALY_BURST 500

//! stuff passed into rad_act
//! you should generally be using afflict radiation instead.

#define RAD_MOB_ACT_STRENGTH_
