#define MATSYN_WATER "water"
#define MATSYN_NANITES "nanites"
#define MATSYN_WIRE "wire"
#define MATSYN_METAL "metal"
#define MATSYN_GLASS "glass"
#define MATSYN_DRUGS "medicine"
#define MATSYN_WOOD "wood"
#define MATSYN_PLASTIC "plastic"
#define MATSYN_PLASTEEL "plasteel"

#define MATTER_SYNTH_WITH_NAME(K,T,N,V...) .[K] = new /datum/matter_synth/##T { name = N } (V)
#define MATTER_SYNTH(K,T,V...) .[K] = new /datum/matter_synth/##T (V)
#define CYBORG_STACK(T,K) do { var/obj/item/stack/S = new /obj/item/stack/##T(src); S.synths = __cyborg_stack_map(K); . += S } while (FALSE)

/obj/item/robot_module/proc/__cyborg_stack_map(list/targets)
	if (!islist(targets))
		targets = list(targets)
	. = list()
	for (var/item in targets)
		. += synths_by_kind[item]
