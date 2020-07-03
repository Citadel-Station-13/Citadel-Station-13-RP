// simple is_type and similar inline helpers

#define in_range(source, user) (get_dist(source, user) <= 1 && (get_step(source, 0)?:z) == (get_step(user, 0)?:z))

#define isatom(A) (isloc(A))

#define isweakref(D) (istype(D, /datum/weakref))

//Datums

#define isTaurTail(A)	istype(A, /datum/sprite_accessory/tail/taur)

//Turfs

#define isopenspace(A) istype(A, /turf/simulated/open)

//Objs
#define isobj(A) istype(A, /obj) //override the byond proc because it returns true on children of /atom/movable that aren't objs

#define isitem(A) (istype(A, /obj/item))

#define isclothing(A) (istype(A, /obj/item/clothing))

#define isstorage(A)	istype(A, /obj/item/storage)

#define isstructure(A) (istype(A, /obj/structure))

#define ismachinery(A) (istype(A, /obj/machinery))

#define ismecha(A) (istype(A, /obj/mecha))

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isbelly(A)		istype(A, /obj/belly)

//Areas

//Mobs

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isanimal(A) istype(A, /mob/living/simple_mob)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define iscorgi(A) istype(A, /mob/living/simple_mob/animal/passive/dog/corgi)

#define isEye(A) istype(A, /mob/observer/eye)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define isliving(A) istype(A, /mob/living)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)

#define isnewplayer(A) istype(A, /mob/new_player)

#define isobserver(A) istype(A, /mob/observer/dead)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define issilicon(A) istype(A, /mob/living/silicon)

#define isvoice(A) istype(A, /mob/living/voice)

#define isslime(A) istype(A, /mob/living/simple_mob/slime)

#define isbot(A) istype(A, /mob/living/bot)

#define isxeno(A) istype(A, /mob/living/simple_mob/xeno)
