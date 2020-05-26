// simple is_type and similar inline helpers

#define in_range(source, user) (get_dist(source, user) <= 1 && (get_step(source, 0)?:z) == (get_step(user, 0)?:z))

#define isatom(A) (isloc(A))

#define isweakref(D) (istype(D, /datum/weakref))

//Datums

#define isTaurTail(A)	istype(A, /datum/sprite_accessory/tail/taur)

//Turfs
//#define isturf(A) (istype(A, /turf)) This is actually a byond built-in. Added here for completeness sake.

#define isopenspace(A) istype(A, /turf/simulated/open)

//add turfs later

//Mobs
#define isliving(A) (istype(A, /mob/living))

#define isbrain(A) (istype(A, /mob/living/carbon/brain))

//Carbon mobs
#define iscarbon(A) (istype(A, /mob/living/carbon))

#define ishuman(A) (istype(A, /mob/living/carbon/human))

//Human sub-species
//insert /datum/species here

//More carbon mobs
#define isalien(A) istype(A, /mob/living/carbon/alien)

 //yes, xenos apparently fall in here according to tg
#define isxeno(A) istype(A, /mob/living/simple_mob/xeno)

//Silicon mobs
#define issilicon(A) istype(A, /mob/living/silicon)

// #define issiliconoradminghost(A) (istype(A, /mob/living/silicon) || IsAdminGhost(A)) no adminbuse ghost yet

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

//Simple animals
#define isanimal(A) istype(A, /mob/living/simple_animal)

#define isbot(A) istype(A, /mob/living/bot)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)

#define isslime(A) istype(A, /mob/living/simple_mob/slime)

#define iscorgi(A) istype(A, /mob/living/simple_mob/animal/passive/dog/corgi)

//Misc mobs
#define isnewplayer(A) istype(A, /mob/new_player)

#define isobserver(A) istype(A, /mob/observer/dead)

#define isEye(A) istype(A, /mob/observer/eye)

#define isvoice(A) istype(A, /mob/living/voice)



//Objs
#define isobj(A) istype(A, /obj) //override the byond proc because it returns true on children of /atom/movable that aren't objs

#define isitem(A) (istype(A, /obj/item))

#define isidcard(I) (istype(I, /obj/item/card/id))

#define isstructure(A) (istype(A, /obj/structure))

#define ismachinery(A) (istype(A, /obj/machinery))

#define ismecha(A) (istype(A, /obj/mecha))

// #define is_cleanable(A) (istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/rune)) //if something is cleanable

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isclothing(A) (istype(A, /obj/item/clothing))

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isstorage(A)	istype(A, /obj/item/storage)
