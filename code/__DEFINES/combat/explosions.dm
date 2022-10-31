//! Global balancing numbers; everything should derive off of these so we can adjust everything at once.
/// global default multiplier for falloff factor
#define EXPLOSION_FALLOFF_FACTOR 1
/// global default multiplier for bypass factor
#define EXPLOSION_BYPASS_FACTOR 1
/// global default "nominal" maxcap power; being hit by this is what causes the most severe effects like turfs completely peeling away, people gibbing, etc.
#define EXPLOSION_CONSTANT_DEVASTATING 1000
/// global default "nominal" heavy power; being hit by this is what causes things like turfs exploding, people taking immediately lethal damage/devastating damage, etc.
#define EXPLOSION_CONSTANT_SEVERE (EXPLOSION_CONSTANT_DEVASTATING * 0.5)
/// global default "nominal" minor power; being hit by this is what causes minor wounds
#define EXPLOSION_CONSTANT_MINOR  (EXPLOSION_CONSTANT_DEVASTATING * 0.25)
/// below this explosions are considered so trivial we just drop the wave
#define EXPLOSION_CONSTANT_DROPPED 50

//? Rest of defines will come when we fully implement new explosions.

//! legacy shims
#define LEGACY_EXPLOSION_DEVASTATE_POWER EXPLOSION_CONSTANT_DEVASTATING
#define LEGACY_EXPLOSION_SEVERE_POWER EXPLOSION_CONSTANT_SEVERE
#define LEGACY_EXPLOSION_MINOR_POWER EXPLOSION_CONSTANT_MINOR

// why the extra numbers? so if someone does weird math we don't out of bounds
GLOBAL_REAL(_legacy_expowers, /list) = list(
	LEGACY_EXPLOSION_DEVASTATE_POWER,
	LEGACY_EXPLOSION_SEVERE_POWER,
	LEGACY_EXPLOSION_MINOR_POWER,
	0,
	0,
	0
)

// this works out becuase epxlosions are 1-3 in legacy, so we can just use it as list indices
#define LEGACY_EX_ACT(ATOM, POWER, TARGET) ATOM.legacy_ex_act(POWER, TARGET); ATOM.ex_act(_legacy_expowers[POWER]);
