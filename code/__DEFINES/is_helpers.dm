// simple is_type and similar inline helpers

#define in_range(source, user) (get_dist(source, user) <= 1 && (get_step(source, 0)?:z) == (get_step(user, 0)?:z))

//* Datatypes *//

/**
 * used to filter nans and non-numbers from player input
 */
#if DM_VERSION < 515
#define is_safe_number(N) (isnum(N) && (N == N))
#else
#define is_safe_number(N) (isnum(N) && !isnan(N))
#endif

//* Typepaths *//

#define isatom(A) (isloc(A))

#define isdatum(thing) (istype(thing, /datum))

#define isweakref(D) (istype(D, /datum/weakref))

#define isimage(thing) (istype(thing, /image))

GLOBAL_VAR_INIT(magic_appearance_detecting_image, new /image) // appearances are awful to detect safely, but this seems to be the best way ~ninjanomnom
#define isappearance(thing) (!isimage(thing) && !ispath(thing) && istype(GLOB.magic_appearance_detecting_image, thing))

// The filters list has the same ref type id as a filter, but isnt one and also isnt a list, so we have to check if the thing has Cut() instead
GLOBAL_VAR_INIT(refid_filter, TYPEID(filter(type="angular_blur")))
#define isfilter(thing) (!hascall(thing, "Cut") && TYPEID(thing) == GLOB.refid_filter)

#define ismutableappearance(D) (istype(D, /mutable_appearance))

//Datums

#define isTaurTail(A)	istype(A, /datum/sprite_accessory/tail/legacy_taur)

//Turfs

//#define isturf(A) (istype(A, /turf)) This is actually a byond built-in. Added here for completeness sake.

#define isfloorturf(A) (istype(A, /turf/simulated/floor))

#define isopenturf(A) istype(A, /turf/simulated/open)

#define isspaceturf(A) istype(A, /turf/space)

#define ismineralturf(A) istype(A, /turf/simulated/mineral)

//Objects
///override the byond proc because it returns true on children of /atom/movable that aren't objs
#define isobj(A) istype(A, /obj)

#define isitem(A) (istype(A, /obj/item))

#define isclothing(A) (istype(A, /obj/item/clothing))

#define isstorage(A)	istype(A, /obj/item/storage)

#define isstructure(A) (istype(A, /obj/structure))

#define ismachinery(A) (istype(A, /obj/machinery))

#define ismecha(A) (istype(A, /obj/vehicle/sealed/mecha))

#define isvehicle(A) (istype(A, /obj/vehicle_old) || istype(A, /obj/vehicle) || istype(A, /obj/vehicle/sealed/mecha))

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isbelly(A) istype(A, /obj/belly)

#define is_reagent_container(O) (istype(O, /obj/item/reagent_containers))

#define iseffect(O) (istype(O, /obj/effect))
//Areas

//Mobs

#define isliving(A) istype(A, /mob/living)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

//Carbon mobs

#define iscarbon(A) istype(A, /mob/living/carbon)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define isdummy(A) (istype(A, /mob/living/carbon/human/dummy))

//More carbon mobs
#define isalien(A) istype(A, /mob/living/carbon/alien)

//Silicon mobs
#define issilicon(A) istype(A, /mob/living/silicon)
#define isAI(A) istype(A, /mob/living/silicon/ai)
#define isrobot(A) istype(A, /mob/living/silicon/robot)
#define ispAI(A) istype(A, /mob/living/silicon/pai)
#define isDrone(A) istype(A, /mob/living/silicon/robot/drone)
#define isMatriarchDrone(A) istype(A, /mob/living/silicon/robot/drone/matriarch)


//Simple animals
#define issimplemob(A) istype(A, /mob/living/simple_mob)
#define isanimal_legacy_this_is_broken(A) istype(A, /mob/living/simple_animal)

#define iscorgi(A) istype(A, /mob/living/simple_mob/animal/passive/dog/corgi)
#define ismouse(A) istype(A, /mob/living/simple_mob/animal/passive/mouse)
#define isslime(A) istype(A, /mob/living/simple_mob/slime)
#define isxeno(A) istype(A, /mob/living/simple_mob/xeno)

//Eye mobs
#define isEye(A) istype(A, /mob/observer/eye)

//Dead mobs
#define isobserver(A) istype(A, /mob/observer/dead)

#define isnewplayer(A) istype(A, /mob/new_player)

//Misc mobs
#define isbot(A) istype(A, /mob/living/bot)
#define isvoice(A) istype(A, /mob/living/voice)

/proc/is_species_type(atom/A, path)
	if(!istype(A, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = A
	return istype(H.species, path)

#define fast_is_species_type(H, path)	istype(H.species, path)

#define is_holosphere_shell(A) istype(A, /mob/living/simple_mob/holosphere_shell)
