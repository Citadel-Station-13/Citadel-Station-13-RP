#define MATSYN_WATER "water"
#define MATSYN_NANITES "nanites"
#define MATSYN_WIRE "wire"
#define MATSYN_NANOPASTE "nanopaste"
#define MATSYN_METAL "metal"
#define MATSYN_GLASS "glass"
#define MATSYN_DRUGS "medicine"
#define MATSYN_WOOD "wood"
#define MATSYN_PLASTIC "plastic"
#define MATSYN_PLASTEEL "plasteel"

#define MATTER_SYNTH_WITH_NAME(K,T,N,V...) .[K] = new /datum/matter_synth/##T { name = N } (V)
#define MATTER_SYNTH(K,T,V...) .[K] = new /datum/matter_synth/##T (V)
