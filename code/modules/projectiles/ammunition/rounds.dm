/************************************************************************/
/*
#    An explaination of the naming format for guns and ammo:
#
#    a = Ammo, as in individual rounds of ammunition.
#    b = Box, intended to have ammo taken out one at a time by hand.
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
#    This comment is copied in magazines.dm as well.
*/
/************************************************************************/

/*
 * .357
 */

/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = ".357"
	projectile_type = /obj/projectile/bullet/pistol/strong
	materials = list(MAT_STEEL = 210)

/obj/item/ammo_casing/a357/silver
	desc = "A .357 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	caliber = ".357"
	icon_state = "ag-casing"
	projectile_type = /obj/projectile/bullet/pistol/strong
	materials = list(MAT_STEEL = 350, MAT_SILVER = 200)

/*
 * .38
 */

/obj/item/ammo_casing/a38
	desc = "A .38 bullet casing."
	caliber = ".38"
	projectile_type = /obj/projectile/bullet/pistol
	materials = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a38/rubber
	desc = "A .38 rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a38/emp
	name = ".38 haywire round"
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "empcasing"
	projectile_type = /obj/projectile/ion/small
	materials = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a38/silver
	desc = "A .38 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "ag-casing"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials = list(MAT_STEEL = 130, MAT_SILVER = 100)


/*
 * .44
 */

/obj/item/ammo_casing/a44
	desc = "A .44 bullet casing."
	caliber = ".44"
	projectile_type = /obj/projectile/bullet/pistol/strong
	materials = list(MAT_STEEL = 210)

/obj/item/ammo_casing/a44/rubber
	icon_state = "r-casing"
	desc = "A .44 rubber bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/rubber/strong
	materials = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a44/silver
	desc = "A .44 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "ag_casing"
	projectile_type = /obj/projectile/bullet/pistol/strong/silver
	materials = list(MAT_STEEL = 350, MAT_SILVER = 200)

/*
 * .75 (aka Gyrojet Rockets, aka admin abuse)
 */

/obj/item/ammo_casing/a75
	desc = "A .75 gyrojet rocket sheathe."
	caliber = ".75"
	projectile_type = /obj/projectile/bullet/gyro
	materials = list(MAT_STEEL = 4000)

/*
 * 9mm
 */

/obj/item/ammo_casing/a9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/projectile/bullet/pistol
	materials = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a9mm/ap
	desc = "A 9mm armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/ap
	materials = list(MAT_STEEL = 80)

/obj/item/ammo_casing/a9mm/hp
	desc = "A 9mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hp

/obj/item/ammo_casing/a9mm/hunter
	desc = "A 9mm hunting bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hunter
	materials = list(MAT_STEEL = 80)

/obj/item/ammo_casing/a9mm/flash
	desc = "A 9mm flash shell casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/energy/flash

/obj/item/ammo_casing/a9mm/rubber
	desc = "A 9mm rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a9mm/practice
	desc = "A 9mm practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/practice

/obj/item/ammo_casing/a9mm/silver
	desc = "A 9mm silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "ag-casing"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials = list(MAT_STEEL = 130, MAT_SILVER = 100)

/*
 * 5.7
 */
/obj/item/ammo_casing/a57x28mm
	desc = "A 5.7x28mm bullet casing."
	caliber = "5.7x28mm"
	projectile_type = /obj/projectile/bullet/pistol/lap
	materials = list(MAT_STEEL = 30, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/ap
	desc = "A 5.7x28mm armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/ap
	materials = list(MAT_STEEL = 80, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/hp
	desc = "A 5.7x28mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hp
	materials = list(MAT_STEEL = 60, MAT_COPPER = 30)

/obj/item/ammo_casing/a57x28mm/hunter
	desc = "A 5.7x28mm hunting bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/hunter
	materials = list(MAT_STEEL = 30, MAT_COPPER = 50)

/*
 * .45
 */

/obj/item/ammo_casing/a45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/projectile/bullet/pistol/medium
	materials = list(MAT_STEEL = 75)

/obj/item/ammo_casing/a45/ap
	desc = "A .45 Armor-Piercing bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/pistol/medium/ap

/obj/item/ammo_casing/a45/hunter
	desc = "A .45 hunting bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/medium/hunter
	materials = list(MAT_STEEL = 75)

/obj/item/ammo_casing/a45/practice
	desc = "A .45 practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/practice
	materials = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/rubber
	desc = "A .45 rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/pistol/rubber
	materials = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/flash
	desc = "A .45 flash shell casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/energy/flash
	materials = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/emp
	name = ".45 haywire round"
	desc = "A .45 bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/projectile/ion/small
	icon_state = "empcasing"
	materials = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a45/hp
	desc = "A .45 hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/medium/hp

/obj/item/ammo_casing/a45/silver
	name = ".45 silver round"
	desc = "A .45 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "ag-casing"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials = list(MAT_STEEL = 130, MAT_SILVER = 100)


/*
 * 10mm
 */

/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/projectile/bullet/pistol/medium
	materials = list(MAT_STEEL = 75)

/obj/item/ammo_casing/a10mm/emp
	name = "10mm haywire round"
	desc = "A 10mm bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/projectile/ion/small
	icon_state = "empcasing"
	materials = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/*
 * 12g (aka shotgun ammo)
 */

/obj/item/ammo_casing/a12g
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	caliber = "12g"
	projectile_type = /obj/projectile/bullet/shotgun
	materials = list(MAT_STEEL = 360)
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')

/obj/item/ammo_casing/a12g/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun

/obj/item/ammo_casing/a12g/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = /obj/projectile/bullet/blank
	materials = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a12g/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	projectile_type = /obj/projectile/bullet/practice
	materials = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a12g/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/projectile/bullet/shotgun/beanbag
	materials = list(MAT_STEEL = 180)

/obj/item/ammo_casing/a12g/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "improvshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_improvised
	materials = list(MAT_STEEL = 500, MAT_GLASS = 200)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/a12g/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/energy/electrode/stunshot
	materials = list(MAT_STEEL = 360, MAT_GLASS = 720)

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/a12g/flare
	name = "flare shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	projectile_type = /obj/projectile/energy/flash/flare
	materials = list(MAT_STEEL = 90, MAT_GLASS = 90)

//Silver 12g
/obj/item/ammo_casing/a12g/silver
	name = " Silver shotgun shell"
	desc = "A 12 gauge slug. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "agshell"
	caliber = "12g"
	projectile_type = /obj/projectile/bullet/pellet/shotgun/silver
	materials = list(MAT_STEEL = 360, MAT_SILVER = 240)

//Wooden Stake 12g
/obj/item/ammo_casing/a12g/stake
	name = "Wooden stake shell"
	desc = "A specialized shell designed to launch a wooden stake. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "agshell"
	caliber = "12g"
	projectile_type = /obj/projectile/bullet/shotgun/stake
	materials = list(MAT_STEEL = 500)

//Techshell & Derivatives
/obj/item/ammo_casing/a12g/techshell
	name = "unloaded technological shell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	icon_state = "cshell"
	caliber = "12g"
	projectile_type = null
	materials = list(MAT_STEEL = 500, MAT_PHORON = 200)

/obj/item/ammo_casing/a12g/techshell/meteorslug
	name = "meteorslug shell"
	desc = "A shotgun shell rigged with CMC technology, which launches a massive slug when fired."
	icon_state = "mshell"
	projectile_type = /obj/projectile/meteor/slug
	materials = list(MAT_STEEL = 500, MAT_GOLD = 200)

/obj/item/ammo_casing/a12g/techshell/emp
	name = "ion shell"
	desc = "An advanced shotgun round that creates a small EMP when it strikes a target."
	icon_state = "empshell"
	projectile_type = /obj/projectile/scatter/ion
//	projectile_type = /obj/projectile/bullet/shotgun/ion
	materials = list(MAT_STEEL = 360, MAT_URANIUM = 240)

/obj/item/ammo_casing/a12g/techshell/pulseslug
	name = "pulse slug"
	desc = "A delicate device which can be loaded into a shotgun. The primer acts as a button which triggers the gain medium and fires a powerful \
	energy blast. While the heat and power drain limit it to one use, it can still allow an operator to engage targets that ballistic ammunition \
	would have difficulty with."
	icon_state = "plshell"
	projectile_type = /obj/projectile/beam/pulse/shotgun
	materials = list(MAT_STEEL = 500, MAT_SILVER = 200)

/obj/item/ammo_casing/a12g/techshell/dragonsbreath
	name = "dragonsbreath shell"
	desc = "A shotgun shell which fires a spread of incendiary pellets."
	icon_state = "ishell"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun

/obj/item/ammo_casing/a12g/techshell/frag12
	name = "FRAG-12 slug"
	desc = "A high explosive breaching round for a 12 gauge shotgun."
	icon_state = "heshell"
	projectile_type = /obj/projectile/bullet/shotgun/frag12
	materials = list(MAT_STEEL = 500, MAT_PHORON = 200)

/obj/item/ammo_casing/a12g/techshell/laserslug
	name = "scatter laser shell"
	desc = "An advanced shotgun shell that uses a micro laser to replicate the effects of a scatter laser weapon in a ballistic package."
	icon_state = "lshell"
	projectile_type = /obj/projectile/scatter/laser
	materials = list(MAT_STEEL = 500, MAT_GLASS = 200)

/*
 * 7.62mm
 */

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "7.62mm"
	icon_state = "rifle-casing"
	projectile_type = /obj/projectile/bullet/rifle/a762
	materials = list(MAT_STEEL = 200)

/obj/item/ammo_casing/a762/ap
	desc = "A 7.62mm armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a762/ap
	materials = list(MAT_STEEL = 300)

/obj/item/ammo_casing/a762/practice
	desc = "A 7.62mm practice bullet casing."
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/projectile/bullet/practice
	materials = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a762/blank
	desc = "A blank 7.62mm bullet casing."
	projectile_type = /obj/projectile/bullet/blank
	materials = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a762/hp
	desc = "A 7.62mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a762/hp

/obj/item/ammo_casing/a762/hunter
	desc = "A 7.62mm hunting bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a762/hunter

/obj/item/ammo_casing/a762/sniper
	desc = "A 7.62mm high velocity bullet casing optimised for a marksman rifle."
	projectile_type = /obj/projectile/bullet/rifle/a762/sniper

/obj/item/ammo_casing/a762/sniperhunter
	desc = "A 7.62mm high velocity hunter bullet casing optimised for a marksman rifle."
	projectile_type = /obj/projectile/bullet/rifle/a762/sniperhunter

/obj/item/ammo_casing/a762/silver
	desc = "A 7.62mm hunting bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "agrifle-casing"
	projectile_type = /obj/projectile/bullet/rifle/a762/silver
	materials = list(MAT_STEEL = 300, MAT_SILVER = 150)

/*
 * 12.7mm (anti-materiel rifle round)
 */

/obj/item/ammo_casing/a127
	desc = "A 12.7mm shell."
	icon_state = "lcasing"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/rifle/a127
	materials = list(MAT_STEEL = 1250)

/*
 * 5.56mm
 */

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "5.56mm"
	icon_state = "rifle-casing"
	projectile_type = /obj/projectile/bullet/rifle/a556
	materials = list(MAT_STEEL = 180)

/obj/item/ammo_casing/a556/ap
	desc = "A 5.56mm armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a556/ap
	materials = list(MAT_STEEL = 270)

/obj/item/ammo_casing/a556/practice
	desc = "A 5.56mm practice bullet casing."
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/projectile/bullet/practice
	materials = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a556/blank
	desc = "A blank 5.56mm bullet casing."
	projectile_type = /obj/projectile/bullet/blank
	materials = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a556/hp
	desc = "A 5.56mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a556/hp

/obj/item/ammo_casing/a556/hunter
	desc = "A 5.56mm hunting bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a556/hunter

/*
 * 10x24mm Caseless
 */

/obj/item/ammo_casing/a10x24mmcaseless
	desc = "A 10x24mm caseless round, common during the Xenomorph wars due to its use the the battle rifles of the United Solar Marine Corps."
	caliber = "10mmCL"
	icon_state = "casing"
	projectile_type = /obj/projectile/bullet/pistol/medium
	materials = list(MAT_STEEL = 180)
	casing_flags = CASING_DELETE

/obj/item/ammo_casing/a10x24mmcaseless/ap
	desc = "A 10x24mm caseless round, common during the Xenomorph wars due to its use the the battle rifles of the United Solar Marine Corps. This one was meant to shred armored targets."
	caliber = "10mmCL"
	icon_state = "casing"
	projectile_type = /obj/projectile/bullet/pistol/medium/ap
	materials = list(MAT_STEEL = 180)

/obj/item/ammo_casing/a10x24mmcaseless/hp
	desc = "A 10x24mm caseless round, common during the Xenomorph wars due to its use the the battle rifles of the United Solar Marine Corps. This one was meant to shred armored targets."
	caliber = "10mmCL"
	icon_state = "casing"
	projectile_type = /obj/projectile/bullet/pistol/medium/hp
	materials = list(MAT_STEEL = 180)

/*
 * 5mm Caseless
 */

/obj/item/ammo_casing/a5mmcaseless
	desc = "A 5mm solid phoron caseless round."
	caliber = "5mm caseless"
	icon_state = "casing" // Placeholder. Should probably be purple.
	projectile_type = /obj/projectile/bullet/pistol // Close enough to be comparable.
	materials = list(MAT_STEEL = 180)
	casing_flags = CASING_DELETE

/obj/item/ammo_casing/a5mmcaseless/stun
	desc = "A 5mm solid phoron caseless stun round."
	projectile_type = /obj/projectile/energy/electrode // Maybe nerf this considering there's 30 rounds in a mag.

/*
 * Misc
 */

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell_alt"
	projectile_type = /obj/projectile/bullet/srmrocket
	caliber = "rocket"
	materials = list(MAT_STEEL = 10000)

/obj/item/ammo_casing/rocket/weak
	name = "low-yield rocket shell"
	projectile_type = /obj/projectile/bullet/srmrocket/weak
	materials = list(MAT_STEEL = 5000)

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	icon_state = "r-casing"
	color = "#FF0000"
	projectile_type = /obj/projectile/bullet/pistol/cap
	materials = list(MAT_STEEL = 85)

/obj/item/ammo_casing/spent // For simple hostile mobs only, so they don't cough up usable bullets when firing. This is for literally nothing else.
	icon_state = "s-casing-spent"
	projectile_type = null

/obj/item/ammo_casing/organic
	name = "biomatter globule"
	desc = "Globular biomatter rendered and ready for compression."
	caliber = "organic"
	icon_state = "globule"
	color = "#FFE0E2"
	projectile_type = /obj/projectile/bullet/organic
	materials = list("flesh" = 100)

/obj/item/ammo_casing/organic/wax
	name = "wax globule"
	desc = "Tacky wax rendered semi-solid and ready for compression."
	caliber = "apidean"
	icon_state = "globule"
	color = "#E6E685"
	projectile_type = /obj/projectile/bullet/organic/wax
	materials = list("wax" = 100)

/obj/item/ammo_casing/musket
	name = "musket ball"
	desc = "A solid ball made of lead."
	icon_state = "musketball"
	caliber = "musket"
	projectile_type = /obj/projectile/bullet/musket
	materials = list("lead" = 100)
	casing_flags = CASING_DELETE

/obj/item/ammo_casing/musket/silver
	name = "silver musket ball"
	desc = "A solid ball made of a lead-silver alloy."
	icon_state = "silverball"
	projectile_type = /obj/projectile/bullet/musket/silver
	materials = list("lead" = 100, "silver" = 100)

/obj/item/ammo_casing/musket/blunderbuss
	name = "shot"
	desc = "A bundle of lead balls and other assorted shrapnel."
	icon_state = "blunderbuss"
	caliber = "blunderbuss"
	projectile_type = /obj/projectile/bullet/pellet/blunderbuss
	materials = list("lead" = 500)

/obj/item/ammo_casing/musket/blunderbuss/silver
	name = "sliver shot"
	desc = "A bundle of silver lead allow balls and other assorted bits of silver."
	icon_state = "silverbuss"
	projectile_type = /obj/projectile/bullet/pellet/blunderbuss/silver
	materials = list("lead" = 500, "silver" = 500)

//Ten Gauge Rounds for Exotic Shotguns
/obj/item/ammo_casing/a10g
	name = "heavy shotgun slug"
	desc = "A brass jacketed 10 gauge slug shell."
	icon_state = "brshell"
	caliber = "10g"
	projectile_type = /obj/projectile/bullet/heavy_shotgun
	materials = list(MAT_STEEL = 300, "brass" = 200)
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')

/obj/item/ammo_casing/a10g/pellet //Spread variant.
	name = "heavy shotgun shell"
	desc = "A brass jacketed 10 gauge shot shell."
	projectile_type = /obj/projectile/scatter/heavy_shotgun

/obj/item/ammo_casing/a10g/silver
	name = "heavy silver shotgun shell"
	desc = "A brass jacketed 10 gauge filled with blessed silver shot."
	projectile_type = /obj/projectile/scatter/heavy_shotgun/silver

//Related to the above, knockback specific variants for Grit.
/obj/item/ammo_casing/a10g/grit
	name = "tooled heavy shotgun slug"
	desc = "A custom brass jacketed 10 gauge slug shell."
	projectile_type = /obj/projectile/bullet/heavy_shotgun/grit

/obj/item/ammo_casing/a10g/pellet/grit
	name = "tooled heavy shotgun shell"
	desc = "A custom brass jacketed 10 gauge shot shell."
	projectile_type = /obj/projectile/scatter/heavy_shotgun/grit

//Arrows
/obj/item/ammo_casing/arrow
	name = "arrow of questionable material"
	desc = "You shouldn't be seeing this arrow."
	projectile_type = /obj/projectile/bullet/reusable/arrow
	caliber = "arrow"
	icon_state = "arrow"
	throw_force = 3 //good luck hitting someone with the pointy end of the arrow
	throw_speed = 3
	casing_flags = CASING_DELETE

/obj/item/ammo_casing/arrow/wood
	name = "wooden arrow"
	desc = "An arrow made of wood, typically fired from a bow."

/obj/item/ammo_casing/arrow/bone
	name = "bone arrow"
	desc = "An arrow made of bone, knapped to a piercing tip."
	icon_state = "ashenarrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/bone

/obj/item/ammo_casing/arrow/ash
	name = "ashen arrow"
	desc = "An arrow made of wood, hardened by fire."
	icon_state = "ashenarrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/ash

/obj/item/ammo_casing/arrow/bone_ap
	name = "hardened bone arrow"
	desc = "An arrow made of bone and sinew. The tip is sharp enough to pierce through a goliath plate."
	icon_state = "bonearrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/bone_ap

/obj/item/ammo_casing/arrow/bronze
	name = "bronze arrow"
	desc = "An arrow made of wood, tipped with bronze. The tip is dense enough to provide some armor penetration."
	icon_state = "bronzearrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/bronze

//Plunger
/obj/item/ammo_casing/arrow/plunger
	name = "plunger"
	desc = "It's a plunger, for plunging."
	icon_state = "plunger"
	projectile_type = /obj/projectile/bullet/reusable/plunger

//Foam Darts
/obj/item/ammo_casing/foam
	name = "foam dart"
	desc = "A soft projectile made out of orange foam with a blue plastic tip."
	projectile_type = /obj/projectile/bullet/reusable/foam
	caliber = "foamdart"
	icon_state = "foamdart"
	throw_force = 0 //good luck hitting someone with the pointy end of the arrow
	throw_speed = 3
	casing_flags = CASING_DELETE
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/ammo_casing/foam/riot
	name = "riot dart"
	desc = "A flexible projectile made out of hardened orange foam with a red plastic tip."
	projectile_type = /obj/projectile/bullet/reusable/foam/riot
	icon_state = "foamdart_riot"
