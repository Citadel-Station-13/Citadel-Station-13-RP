/************************************************************************/
/*
#    An explaination of the naming format for guns and ammo:
#
#    a = Ammo, as in individual rounds of ammunition.
#    b = Box, intended to have ammo taken out one at a time by hand. Really obsolete. Don't use this.
#    c = Clips, intended to reload magazines or guns quickly.
#    m = Magazine, intended to hold rounds of ammo.
#    s = Speedloaders, intended to reload guns quickly.
#
#    Use this format, followed by the caliber. For example, a shotgun's caliber
#    variable is "12g" as a result. Ergo, a shotgun round's path would have "a12g",
#    or a magazine with shotgun shells would be "m12g" instead. To avoid confusion
#    for developers and in-game admins spawning these items, stick to this format.
#    Likewise, when creating new rounds, the caliber variable should match whatever
#    the name says.
#
#    This comment is copied in rounds.dm as well.
#
#    Also, if a magazine is only meant for a specific gun, include the name
#    of the specific gun in the path. Example: m45uzi is only for the Uzi.
*/
/************************************************************************/



///////// .357 /////////

/obj/item/ammo_magazine/s357
	name = "speedloader (.357)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "38"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(MAT_STEEL = 1260)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s357/silver
	name = "speedloader (.357 silver)"
	icon_state = "ag_38"
	ammo_type = /obj/item/ammo_casing/a357/silver
	matter = list(MAT_STEEL = 2100, MAT_SILVER = 1200)

///////// .38 /////////

/obj/item/ammo_magazine/s38
	name = "speedloader (.38)"
	desc = "A speedloader for .38 revolvers."
	icon_state = "38"
	caliber = ".38"
	matter = list(MAT_STEEL = 360)
	ammo_type = /obj/item/ammo_casing/a38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s38/rubber
	name = "speedloader (.38 rubber)"
	icon_state = "T38"
	ammo_type = /obj/item/ammo_casing/a38/rubber

/obj/item/ammo_magazine/s38/emp
	name = "speedloader (.38 haywire)"
	ammo_type = /obj/item/ammo_casing/a38/emp

/obj/item/ammo_magazine/s38/silver
	name = "speedloader (.38 silver)"
	icon_state = "ag_38"
	ammo_type = /obj/item/ammo_casing/a38/silver
	matter = list(MAT_STEEL = 780, MAT_SILVER = 600)

///////// .45 /////////

/obj/item/ammo_magazine/m45
	name = "pistol magazine (.45)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/m45/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45/hunter
	name = "magazine (.45 hunter)"
	ammo_type = /obj/item/ammo_casing/a45/hunter

/obj/item/ammo_magazine/m45/rubber
	name = "magazine (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/m45/practice
	name = "magazine (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/m45/flash
	name = "magazine (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/m45/ap
	name = "magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/box/emp/b45
	name = "ammunition box (.45 haywire)"
	ammo_type = /obj/item/ammo_casing/a45/emp

/obj/item/ammo_magazine/m45uzi
	name = "stick magazine (.45)"
	icon_state = "uzi45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 1200)
	caliber = ".45"
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/m45uzi/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45uzi/wt274
	name = "double-stack magazine (.45)"
	icon_state = "wt274"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 2400)
	caliber = ".45"
	max_ammo = 32
	multiple_sprites = 1

/obj/item/ammo_magazine/m45tommy
	name = "Tommy Gun magazine (.45)"
	icon_state = "tommy-mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 1500)
	caliber = ".45"
	max_ammo = 20

/obj/item/ammo_magazine/m45tommy/ap
	name = "Tommy Gun magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/m45tommy/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45tommydrum
	name = "Tommy Gun drum magazine (.45)"
	icon_state = "tommy-drum"
	w_class = ITEMSIZE_NORMAL // Bulky ammo doesn't fit in your pockets!
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 3750)
	caliber = ".45"
	max_ammo = 50

/obj/item/ammo_magazine/m45tommydrum/ap
	name = "Tommy Gun drum magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/m45tommydrum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c45
	name = "ammo clip (.45)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .45 rounds into magazines."
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 675) // metal costs very roughly based around one .45 casing = 75 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c45/rubber
	name = "ammo clip (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/clip/c45/hunter
	name = "ammo clip (.45 hunter)"
	ammo_type = /obj/item/ammo_casing/a45/hunter

/obj/item/ammo_magazine/clip/c45/practice
	name = "ammo clip (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/clip/c45/flash
	name = "ammo clip (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/s45
	name = "speedloader (.45)"
	icon_state = "45s"
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/s45/empty
	initial_ammo = 0

/obj/item/ammo_magazine/s45/rubber
	name = "speedloader (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/s45/practice
	name = "speedloader (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/s45/flash
	name = "speedloader (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/s45/ap
	name = "speedloader (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/s45/silver
	name = "speedloader (.45 silver)"
	icon_state = "ag45s"
	ammo_type = /obj/item/ammo_casing/a45/silver
	matter = list(MAT_STEEL = 780, MAT_SILVER = 600)

///////// 10x24mm Caseless /////////

/obj/item/ammo_magazine/m10x24mm
	name = "debug magazine that shouldn't appear please report it if you do (10mm caseless)"
	ammo_type = /obj/item/ammo_casing/a10x24mmcaseless
	icon_state = "usmc-large"
	caliber = "10mmCL"
	w_class = ITEMSIZE_NORMAL
	matter = list(MAT_STEEL = 8500)
	mag_type = MAGAZINE
	max_ammo = 96
	multiple_sprites = 1

/obj/item/ammo_magazine/m10x24mm/large
	name = "magazine (large) (10mm caseless)"
	icon_state = "usmc-large"
	matter = list(MAT_STEEL = 8500)
	max_ammo = 96

/obj/item/ammo_magazine/m10x24mm/large/hp
	name = "magazine (large) (10mm caseless hollow-point)"
	ammo_type = /obj/item/ammo_casing/a10x24mmcaseless/hp
	icon_state = "usmc-large-hp"

/obj/item/ammo_magazine/m10x24mm/large/ap
	name = "magazine (large) (10mm caseless armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a10x24mmcaseless/ap
	icon_state = "usmc-large-ap"

/obj/item/ammo_magazine/m10x24mm/med
	name = "magazine (medium) (10mm caseless)"
	icon_state = "usmc-med"
	matter = list(MAT_STEEL = 5500)
	max_ammo = 64
	multiple_sprites = 1

/obj/item/ammo_magazine/m10x24mm/med/hp
	name = "magazine (medium) (10mm caseless hollow-point)"
	ammo_type = /obj/item/ammo_casing/a10x24mmcaseless/hp
	icon_state = "usmc-med-hp"

/obj/item/ammo_magazine/m10x24mm/med/ap
	name = "magazine (medium) (10mm caseless armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a10x24mmcaseless/ap
	icon_state = "usmc-med-ap"

/obj/item/ammo_magazine/m10x24mm/small
	name = "magazine (small) (10mm caseless)"
	icon_state = "usmc-small"
	matter = list(MAT_STEEL = 2500)
	max_ammo = 32
	multiple_sprites = 1

/obj/item/ammo_magazine/m10x24mm/small/hp
	name = "magazine (small) (10mm caseless hollow-point)"
	ammo_type = /obj/item/ammo_casing/a10x24mmcaseless/hp
	icon_state = "usmc-small-hp"
	caliber = "10mmCL"
	max_ammo = 32
	multiple_sprites = 1

/obj/item/ammo_magazine/m10x24mm/small/ap
	name = "magazine (small) (10mm caseless armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a10x24mmcaseless/ap
	icon_state = "usmc-small-ap"
	caliber = "10mmCL"
	max_ammo = 32
	multiple_sprites = 1

/obj/item/ammo_magazine/m10x24mm/small/snark
	desc = "A magazine for some kind of gun. Taped on it is a reminder to \"watch those firing lanes\" and a drawing of a stickman wearing a helmet. The helmet has a hole in it. The stickman is dead."

/obj/item/ammo_magazine/m10x24mm/small/hp/snark
	desc = "A magazine for some kind of gun. Taped on it is a reminder to \"watch those firing lanes\" and a drawing of a stickman wearing a helmet. The helmet has a hole in it. The stickman is dead."

/obj/item/ammo_magazine/m10x24mm/small/ap/snark
	desc = "A magazine for some kind of gun. Taped on it is a reminder to \"watch those firing lanes\" and a drawing of a stickman wearing a helmet. The helmet has a hole in it. The stickman is dead."

///////// 5mm Caseless /////////

/obj/item/ammo_magazine/m5mmcaseless
	name = "prototype rifle magazine (5mm caseless)"
	ammo_type = /obj/item/ammo_casing/a5mmcaseless
	icon_state = "caseless-mag"
	caliber = "5mm caseless"
	mag_type = MAGAZINE
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/m5mmcaseless/stun
	icon_state = "caseless-mag-alt"
	ammo_type = /obj/item/ammo_casing/a5mmcaseless/stun

///////// 9mm /////////

/obj/item/ammo_magazine/m9mm
	name = "magazine (9mm)"
	icon_state = "9x19p_fullsize"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 600)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mm/large
	desc = "\"FOR LAW ENFORCEMENT/MILITARY USE ONLY\" is clearly etched on the magazine. This is probably illegal for you to have." // Remember, Security is not Law Enforcement, so it's illegal for Security to use as well.
	icon_state = "9x19p_highcap"
	max_ammo = 17
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)

/obj/item/ammo_magazine/m9mm/large/licensed // Sold by traders.
	desc = "A large capacity magazine produced via a joint NT-Hephaestus license, making it legal to own."

/obj/item/ammo_magazine/m9mm/large/licensed/hp // Hollow Point Version
	name = "magazine (9mm hollow-point)"
	ammo_type = /obj/item/ammo_casing/a9mm/hp

/obj/item/ammo_magazine/m9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mm/flash
	name = "magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mm/practice
	name = "magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mm/practice

// Compact
/obj/item/ammo_magazine/m9mm/compact
	name = "compact magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 480)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mm/compact/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mm/compact/flash
	name = "compact magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mm/compact/rubber
	name = "compact magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mm/compact/practice
	name = "compact magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mm/practice

// SMG
/obj/item/ammo_magazine/m9mmt
	name = "top mounted magazine (9mm)"
	icon_state = "9mmt"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a9mm
	matter = list(MAT_STEEL = 1200)
	caliber = "9mm"
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmt/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mmt/hunter
	name = "top mounted magazine (9mm hunter)"
	ammo_type = /obj/item/ammo_casing/a9mm/hunter

/obj/item/ammo_magazine/m9mmt/rubber
	name = "top mounted magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mmt/flash
	name = "top mounted magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mmt/practice
	name = "top mounted magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/clip/c9mm
	name = "ammo clip (9mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 9mm rounds into magazines."
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	matter = list(MAT_STEEL = 600) // metal costs are very roughly based around one 9mm casing = 60 metal
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c9mm/hunter
	name = "ammo clip (9mm hunter)"
	ammo_type = /obj/item/ammo_casing/a9mm/hunter

/obj/item/ammo_magazine/clip/c9mm/rubber
	name = "ammo clip (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/clip/c9mm/practice
	name = "ammo clip (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/clip/c9mm/flash
	name = "ammo clip (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/clip/c9mm/silver
	name = "ammo clip (9mm silver)"
	ammo_type = /obj/item/ammo_casing/a9mm/silver
	icon_state = "clip_pistol_ag"
	matter = list(MAT_STEEL = 1300, MAT_SILVER = 1000)

/obj/item/ammo_magazine/m9mmAdvanced
	desc = "A very high capacity double stack magazine made specially for the Advanced SMG. Filled with 21 9mm bullets."
	icon_state = "S9mm"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a9mm
	matter = list(MAT_STEEL = 1200)
	caliber = "9mm"
	max_ammo = 21
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmAdvanced/ap
	desc = "A high capacity double stack magazine made specially for the Advanced SMG. Filled with 21 9mm armor piercing bullets."
	icon_state = "S9mm"
	ammo_type = /obj/item/ammo_casing/a9mm/ap
	matter = list(MAT_STEEL = 2000)

/obj/item/ammo_magazine/m9mmR/saber/empty
	initial_ammo = 0

/////// 5.7x28mm ////////
/obj/item/ammo_magazine/m57x28mm
	name = "magazine (5.7x28mm)"
	desc = "A durable top-loading magazine, designed for withstanding rough treatment."
	icon_state = "fiveseven"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 300, MAT_COPPER = 300)
	caliber = "5.7x28mm"
	ammo_type = /obj/item/ammo_casing/a57x28mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m57x28mm/ap
	name = "magazine (5.7x28mm armor piercing)"
	desc = "A standard capacity magazine loaded with armor piercing bullets."
	ammo_mark = "ap"
	ammo_type = /obj/item/ammo_casing/a57x28mm/ap

/obj/item/ammo_magazine/m57x28mm/hp
	name = "magazine (5.7x28mm hollow-point)"
	ammo_mark = "hp"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/hunter
	name = "magazine (5.7x28mm hunter)"
	ammo_mark = "hunter"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m57x28mm/large
	name = "large capacity magazine (5.7x28mm)"
	icon_state = "fiveseven_highcap"
	max_ammo = 30
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)

/obj/item/ammo_magazine/m57x28mm/large/ap
	name = "large capacity magazine (5.7x28mm armor piercing)"
	desc = "A high capacity magazine loaded with armor piercing bullets."
	ammo_mark = "ap"
	ammo_type = /obj/item/ammo_casing/a57x28mm/ap
/obj/item/ammo_magazine/m57x28mm/large/hp
	name = "large capacity magazine (5.7x28mm hollow-point)"
	ammo_mark = "hp"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/large/hunter
	name = "large capacity magazine (5.7x28mm hunter)"
	ammo_mark = "hunter"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/large/empty
	initial_ammo = 0

//Vintage Mags
/obj/item/ammo_magazine/m57x28mm/vintage
	name = "vinage magazine (5.7x28mm)"
	desc = "A sturdy double stack magazine with a reinforced spring, designed for withstanding rough treatment."
	icon_state = "fiveseven_old"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 300, MAT_COPPER = 300)
	caliber = "5.7x28mm"
	ammo_type = /obj/item/ammo_casing/a57x28mm
	max_ammo = 15
	multiple_sprites = 1

/obj/item/ammo_magazine/m57x28mm/vintage/ap
	name = "magazine (5.7x28mm armor piercing)"
	desc = "A standard capacity magazine loaded with armor piercing bullets."
	ammo_mark = "ap"
	ammo_type = /obj/item/ammo_casing/a57x28mm/ap

/obj/item/ammo_magazine/m57x28mm/vintage/hp
	name = "magazine (5.7x28mm hollow-point)"
	ammo_mark = "hp"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/vintage/hunter
	name = "magazine (5.7x28mm hunter)"
	ammo_mark = "hunter"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/vintage/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m57x28mm/vintage/large
	name = "large capacity vintage magazine (5.7x28mm)"
	icon_state = "fiveseven_highcap"
	max_ammo = 30
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)

/obj/item/ammo_magazine/m57x28mm/vintage/large/ap
	name = "large capacity magazine (5.7x28mm armor piercing)"
	desc = "A high capacity magazine loaded with armor piercing bullets."
	ammo_mark = "ap"
	ammo_type = /obj/item/ammo_casing/a57x28mm/ap
/obj/item/ammo_magazine/m57x28mm/vintage/large/hp
	name = "large capacity magazine (5.7x28mm hollow-point)"
	ammo_mark = "hp"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hp

/obj/item/ammo_magazine/m57x28mm/vintage/large/hunter
	name = "large capacity magazine (5.7x28mm hunter)"
	ammo_mark = "hunter"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mm/vintage/large/empty
	initial_ammo = 0

//p90
/obj/item/ammo_magazine/m57x28mmp90
	name = "large capacity top mounted magazine (5.7x28mm armor-piercing)"
	icon_state = "p90"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a57x28mm/ap
	matter = list(MAT_STEEL = 1500, MAT_COPPER = 1500)
	caliber = "5.7x28mm"
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m57x28mmp90/hunter
	name = "large capacity top mounted magazine (5.7x28mm hunter)"
	ammo_type = /obj/item/ammo_casing/a57x28mm/hunter

/obj/item/ammo_magazine/m57x28mmp90/empty
	initial_ammo = 0

///////// 10mm /////////

/obj/item/ammo_magazine/m10mm
	name = "magazine (10mm)"
	icon_state = "10mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	matter = list(MAT_STEEL = 1500)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c10mm
	name = "ammo clip (10mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 5mm rounds into magazines."
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm
	matter = list(MAT_STEEL = 675) // metal costs are very roughly based around one 10mm casing = 75 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/box/emp/b10
	name = "ammunition box (10mm haywire)"
	ammo_type = /obj/item/ammo_casing/a10mm/emp

///////// 5.45mm /////////

/obj/item/ammo_magazine/m545
	name = "magazine (5.45mm)"
	icon_state = "m545"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "5.45mm"
	matter = list(MAT_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/a545
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m545/ext
	name = "extended magazine (5.45mm)"
	matter = list(MAT_STEEL = 2700)
	max_ammo = 30

/obj/item/ammo_magazine/m545/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/ext/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/practice
	name = "magazine (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545/practice

/obj/item/ammo_magazine/m545/practice/ext
	name = "extended magazine (5.45mm practice)"
	max_ammo = 30

/obj/item/ammo_magazine/m545/ap
	name = "magazine (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/m545/ap/ext
	name = "extended magazine (5.45mm armor-piercing)"
	max_ammo = 30

/obj/item/ammo_magazine/m545/hunter
	name = "magazine (5.45mm hunting)"
	ammo_type = /obj/item/ammo_casing/a545/hunter

/obj/item/ammo_magazine/m545/hunter/ext
	name = "extended magazine (5.45mm hunting)"
	max_ammo = 30

/obj/item/ammo_magazine/m545/small
	name = "reduced magazine (5.45mm)"
	icon_state = "m545-small"
	matter = list(MAT_STEEL = 900)
	max_ammo = 10

/obj/item/ammo_magazine/m545/small/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/small/practice
	name = "magazine (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545/practice

/obj/item/ammo_magazine/m545/small/ap
	name = "magazine (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/m545/small/hunter
	name = "magazine (5.45mm hunting)"
	ammo_type = /obj/item/ammo_casing/a545/hunter

/obj/item/ammo_magazine/clip/c545
	name = "ammo clip (5.45mm)"
	icon_state = "clip_rifle"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545
	matter = list(MAT_STEEL = 450) // metal costs are very roughly based around one 10mm casing = 180 metal
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c545/ap
	name = "rifle clip (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/clip/c545/hunter
	name = "rifle clip (5.45mm hunting)"
	ammo_type = /obj/item/ammo_casing/a545/hunter

/obj/item/ammo_magazine/clip/c545/practice
	name = "rifle clip (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545

/obj/item/ammo_magazine/m545saw
	name = "magazine box (5.45mm)"
	icon_state = "a545"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "5.45mm"
	matter = list(MAT_STEEL = 10000)
	ammo_type = /obj/item/ammo_casing/a545
	w_class = ITEMSIZE_NORMAL // This should NOT fit in your pocket!!
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m545saw/ap
	name = "magazine box (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/m545saw/hunter
	name = "magazine box (5.45mm hunting)"
	ammo_type = /obj/item/ammo_casing/a545/hunter

/obj/item/ammo_magazine/m545saw/empty
	initial_ammo = 0

///////// .44 Magnum /////////

/obj/item/ammo_magazine/m44
	name = "magazine (.44)"
	icon_state = "m44"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = ".44"
	matter = list(MAT_STEEL = 1260)
	ammo_type = /obj/item/ammo_casing/a44
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/m44/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c44
	name = "ammo clip (.44)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .44 rounds into magazines."
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44
	matter = list(MAT_STEEL = 1620) // metal costs are very roughly based around one .50 casing = 180 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/s44
	name = "speedloader (.44)"
	icon_state = "44"
	icon = 'icons/obj/ammo.dmi'
	ammo_type = /obj/item/ammo_casing/a44
	matter = list(MAT_STEEL = 1260) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".44"
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s44/empty
	initial_ammo = 0

/obj/item/ammo_magazine/s44/rubber
	name = "speedloader (.44 rubber)"
	icon_state = "R44"
	ammo_type = /obj/item/ammo_casing/a44/rubber

/obj/item/ammo_magazine/s44/silver
	name = "speedloader (.44 silver)"
	icon_state = "ag44"
	ammo_type = /obj/item/ammo_casing/a44/silver
	matter = list(MAT_STEEL = 2100, MAT_SILVER = 1200)

///////// 7.62mm /////////

/obj/item/ammo_magazine/m762
	name = "magazine (7.62mm)"
	icon_state = "m762-small"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(MAT_STEEL = 2000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m762m // Intentionally not a subtype of m762 because it's supposed to be incompatible with the Z8 Bulldog rifle.
	name = "magazine (7.62mm)"
	icon_state = "m762"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(MAT_STEEL = 4000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m762m/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762m/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m762garand
	name = "garand clip (7.62mm)" // The clip goes into the magazine, hence the name. I'm very sure this is correct.
	icon_state = "gclip"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(MAT_STEEL = 1600)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/m762garand/ap
	name = "garand clip (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762garand/hunter
	name = "garand clip (7.62mm Hunting)"
	ammo_type = /obj/item/ammo_casing/a762/hunter

/obj/item/ammo_magazine/m762garand/sniperhunter
	name = "garand clip (7.62mm HV Hunting)"
	ammo_type = /obj/item/ammo_casing/a762/sniperhunter

/obj/item/ammo_magazine/m762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c762
	name = "ammo clip (7.62mm)"
	icon_state = "clip_rifle"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762
	matter = list(MAT_STEEL = 1000) // metal costs are very roughly based around one 7.62 casing = 200 metal
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c762/ap
	name = "rifle clip (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/clip/c762/practice
	name = "rifle clip (7.62mm practice)"
	ammo_type = /obj/item/ammo_casing/a762/practice

/obj/item/ammo_magazine/clip/c762/hunter
	name = "rifle clip (7.62mm hunting)"
	ammo_type = /obj/item/ammo_casing/a762/hunter

/obj/item/ammo_magazine/clip/c762/sniper
	name = "rifle clip (7.62mm HV)"
	ammo_type = /obj/item/ammo_casing/a762/sniper

/obj/item/ammo_magazine/clip/c762/sniperhunter
	name = "rifle clip (7.62mm HV hunting)"
	ammo_type = /obj/item/ammo_casing/a762/sniperhunter

/obj/item/ammo_magazine/clip/c762/silver
	name = "rifle clip (7.62mm silver)"
	icon_state = "agclip_rifle"
	ammo_type = /obj/item/ammo_casing/a762/silver
	matter = list(MAT_STEEL = 1500, MAT_SILVER = 750)

/obj/item/ammo_magazine/m762svd
	name = "\improper SVD magazine (7.62mm)"
	icon_state = "SVD"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(MAT_STEEL = 2000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762svd/ap
	name = "\improper SVD magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762svd/empty
	initial_ammo = 0

///////// 12g /////////

/obj/item/ammo_magazine/m12gdrum
	name = "magazine (12 gauge)"
	icon_state = "ashot-mag"
	mag_type = MAGAZINE
	caliber = "12g"
	matter = list(MAT_STEEL = 13000)
	ammo_type = /obj/item/ammo_casing/a12g
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/m12gdrum/beanbag
	name = "magazine (12 gauge beanbag)"
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/m12gdrum/pellet
	name = "magazine (12 gauge pellet)"
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/m12gdrum/flare
	name = "magazine (12 gauge flash)"
	ammo_type = /obj/item/ammo_casing/a12g/flare

/obj/item/ammo_magazine/m12gdrum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c12g
	name = "ammo clip (12g slug)"
	icon_state = "12gclipslug" // Still a placeholder sprite. Feel free to make a better one.
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with slugs."
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g
	matter = list(MAT_STEEL = 1070) // slugs shells x2 + 350 metal for the clip itself.
	max_ammo = 2
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c12g/pellet
	name = "ammo clip (12g buckshot)"
	icon_state = "12gclipshell"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with buckshot."
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	matter = list(MAT_STEEL = 1070) // buckshot and slugs cost the same

/obj/item/ammo_magazine/clip/c12g/beanbag
	name = "ammo clip (12g beanbag)"
	icon_state = "12gclipbean"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with beanbags."
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
	matter = list(MAT_STEEL = 710) //beanbags x2 + 350 metal

/obj/item/ammo_magazine/clip/c12g/silver
	name = "ammo clip (12g buckshot)"
	icon_state = "12gclipag"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with silver buckshot."
	ammo_type = /obj/item/ammo_casing/a12g/silver
	matter = list(MAT_STEEL = 1070, MAT_SILVER = 480)

/obj/item/ammo_magazine/holyshot_mag
	name = "blessed drum magazine (12 gauge)"
	icon_state = "holyshotgun_mag"
	desc = "Thrice-blessed, this drum magazine is loaded with silver shot designed to combat supernatural threats."
	mag_type = MAGAZINE
	caliber = "12g"
	matter = list(MAT_STEEL = 100, MAT_SILVER = 1100)
	ammo_type = /obj/item/ammo_casing/a12g/silver
	max_ammo = 12

/obj/item/ammo_magazine/holyshot_mag/stake
	name = "blessed drum magazine (stakes)"
	desc = "Thrice-blessed, this drum magazine is loaded with wooden stakes soaked in sacred oils."
	ammo_type = /obj/item/ammo_casing/a12g/stake

///////// .75 Gyrojet /////////

/obj/item/ammo_magazine/m75
	name = "magazine (.75 Gyrojet)"
	icon_state = "75"
	mag_type = MAGAZINE
	caliber = ".75"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/m75/empty
	initial_ammo = 0

///////// Misc. /////////

/obj/item/ammo_magazine/caps
	name = "speedloader (caps)"
	icon_state = "T38"
	caliber = "caps"
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MAT_STEEL = 600)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/mcompressedbio
	name = "magazine (Compressed Biomatter)"
	desc = "An advanced matter compression unit, used to feed biomass into a Rapid On-board Fabricator. Accepts biomass globules."
	icon_state = "bio"
	mag_type = MAGAZINE
	caliber = "organic"
	ammo_type = /obj/item/ammo_casing/organic
	matter = list("flesh" = 1000)
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/mcompressedbio/compact
	max_ammo = 10

/obj/item/ammo_magazine/mcompressedbio/large
	icon_state = "bio_large"
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/mcompressedbio/large/banana
	icon_state = "bio_large_banana"

/obj/item/ammo_magazine/biovial
	name = "bio-vial (Liquid Wax)"
	desc = "Biological Munitions Vials, commonly referred to as bio-vials, contain liquid biomatter of some form, for use in exotic weapons systems. This one accepts wax globules."
	icon_state = "bio_vial"
	mag_type = MAGAZINE
	caliber = "apidean"
	ammo_type = /obj/item/ammo_casing/organic/wax
	matter = list("wax" = 1000)
	max_ammo = 10
	multiple_sprites = 1

//Foam
/obj/item/ammo_magazine/mfoam
	name = "abstract toy magazine"
	desc = "You shouldn't be seeing this, contact a Maintainer!"
	icon_state = "toy_pistol"
	mag_type = MAGAZINE
	matter = list(MAT_PLASTIC = 480)
	caliber = "foamdart"
	ammo_type = /obj/item/ammo_casing/foam
	max_ammo = 8
	multiple_sprites = 1

//Foam Pistol
/obj/item/ammo_magazine/mfoam/pistol
	name = "toy pistol magazine"
	desc = "A plastic pistol magazine for foam darts!"

/obj/item/ammo_magazine/mfoam/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mfoam/pistol/riot
	name = "toy pistol magazine (riot)"
	ammo_type = /obj/item/ammo_casing/foam/riot

//Foam c20r
/obj/item/ammo_magazine/mfoam/c20
	name = "toy c20r magazine"
	desc = "A plastic recreation of the classic c20r submachine gun."
	icon_state = "toy_c20"
	matter = list(MAT_PLASTIC = 1500)
	max_ammo = 20

/obj/item/ammo_magazine/mfoam/c20/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mfoam/c20/riot
	name = "toy c20r magazine (riot)"
	ammo_type = /obj/item/ammo_casing/foam/riot

//Foam LMG
/obj/item/ammo_magazine/mfoam/lmg
	name = "toy magazine box"
	desc = "A heavy plastic box designed to hold belts of foam darts! Wow!"
	icon_state = "toy_lmg"
	matter = list(MAT_PLASTIC = 10000)
	w_class = ITEMSIZE_NORMAL
	max_ammo = 50

/obj/item/ammo_magazine/mfoam/lmg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mfoam/lmg/riot
	name = "toy magazine box (riot)"
	ammo_type = /obj/item/ammo_casing/foam/riot

//Foam SMGs
/obj/item/ammo_magazine/mfoam/smg
	name = "toy submachine gun magazine"
	desc = "A plastic recreation of a double-stack submachine gun magazine."
	icon_state = "toy_smg"
	matter = list(MAT_PLASTIC = 1200)
	max_ammo = 20

/obj/item/ammo_magazine/mfoam/smg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mfoam/smg/riot
	name = "toy submachine gun magazine (riot)"
	ammo_type = /obj/item/ammo_casing/foam/riot
