
#define isdatum(D)		istype(D, /datum)
#define isweakref(A)	istype(A, /datum/weakref)

#define islist(D)		istype(D, /list)

//---------------
#define isatom(D)		istype(D, /atom)
#define ismovableatom(D)	istype(D, /atom/movable)

//---------------
//#define isobj(D)		istype(D, /obj)		//Built in

#define ismecha(D)		istype(D, /obj/mecha)

#define isitem(D)		istype(D, /obj/item)

#define isairlock(A)	istype(A, /obj/machinery/door/airlock)

#define isorgan(A)		istype(A, /obj/item/organ/external)

//---------------
//#define isarea(D)		istype(D, /area)	//Built in

//---------------
//#define ismob(D)		istype(D, /mob)		//Built in
#define isliving(A)		istype(A, /mob/living)

#define isobserver(A)	istype(A, /mob/observer/dead)
#define isEye(A)		istype(A, /mob/observer/eye)

#define isnewplayer(A)	istype(A, /mob/new_player)

#define isanimal(A)		istype(A, /mob/living/simple_animal)
#define ismouse(A)		istype(A, /mob/living/simple_animal/mouse)
#define iscorgi(A)		istype(A, /mob/living/simple_animal/corgi)
#define isslime(A)		istype(A, /mob/living/simple_animal/slime)
#define isxeno(A)		istype(A, /mob/living/simple_animal/space/alien)

#define iscarbon(A)		istype(A, /mob/living/carbon)
#define isalien(A)		istype(A, /mob/living/carbon/alien)
#define isbrain(A)		istype(A, /mob/living/carbon/brain)
#define ishuman(A)		istype(A, /mob/living/carbon/human)

#define issilicon(A)	istype(A, /mob/living/silicon)
#define isAI(A)			istype(A, /mob/living/silicon/ai)
#define isrobot(A)		istype(A, /mob/living/silicon/robot)
#define ispAI(A)		istype(A, /mob/living/silicon/pai)

#define isbot(A)		istype(A, /mob/living/bot)

#define isvoice(A)		istype(A, /mob/living/voice)

//---------------
//#define isturf(D)		istype(D, /turf)	//Built in
#define isopenspace(A)	istype(A, /turf/simulated/open)
#define isspaceturf(A)	istype(A, /turf/space)
