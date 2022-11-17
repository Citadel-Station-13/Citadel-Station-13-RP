/*
////////////////////////////
/  =--------------------=  /
/  == Ear Definitions  ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory_meta/ears
	name = "You should not see this..."
	icon = 'icons/mob/sprite_accessories/ears.dmi'
	do_colouration = 0 // Set to 1 to blend (ICON_ADD) hair color

	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2
	var/desc = "You should not see this..."

/datum/sprite_accessory_meta/ears/render_emissive_appearances()
	. = ..()
#warn lol fuck why

// Ears avaliable to anyone

/datum/sprite_accessory_meta/ears/antennae
	name = "antennae, colorable"
	desc = ""
	icon_state = "antennae"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/antlercrown
	name = "antler crown"
	desc = ""
	icon_state = "antlercrown"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/antlers
	name = "antlers"
	desc = ""
	icon_state = "antlers"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/antlers_e
	name = "antlers with ears"
	desc = ""
	icon_state = "cow-nohorns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "antlers_mark"

/datum/sprite_accessory_meta/ears/antlers_large
	name = "Antlers (large)"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "antlers_large"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/bear_brown
	name = "bear, brown"
	desc = ""
	icon_state = "bear-brown"

/datum/sprite_accessory_meta/ears/bear_panda
	name = "bear, panda"
	desc = ""
	icon_state = "panda"

/datum/sprite_accessory_meta/ears/bearhc
	name = "bear, colorable"
	desc = ""
	icon_state = "bear"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/bee
	name = "bee antennae"
	desc = ""
	icon_state = "bee"

/datum/sprite_accessory_meta/ears/bnnuy //bnnuy
	name = "Bnnuy Ears"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "bnnuy"
	extra_overlay = "bnnuy-inner"
	extra_overlay2 = "bnnuy-tips"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/bnnuy2
	name = "Bnnuy Ears 2"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "bnnuy2"
	extra_overlay = "bnnuy-inner"
	extra_overlay2 = "bnnuy-tips2"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/bunnyalt
	name = "bunny 2, dual-color"
	desc = ""
	icon_state = "bunny-alt"
	extra_overlay = "bunny-alt-inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/bunnyhc
	name = "bunny, colorable"
	desc = ""
	icon_state = "bunny"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/bunny_floppy
	name = "floppy bunny ears (colorable)"
	desc = ""
	icon_state = "floppy_bun"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/bunny_tall
	name = "Bunny Tall Ears"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "bunny-tall"
	extra_overlay = "bunny-tall-inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/bunny_white
	name = "bunny, white"
	desc = ""
	icon_state = "bunny"

/datum/sprite_accessory_meta/ears/caprahorns
	name = "caprine horns"
	desc = ""
	icon_state = "caprahorns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/cow
	name = "cow, horns"
	desc = ""
	icon_state = "cow"

/datum/sprite_accessory_meta/ears/cowc
	name = "cow, horns, colorable"
	desc = ""
	icon_state = "cow-c"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/cow_nohorns
	name = "cow, no horns"
	desc = ""
	icon_state = "cow-nohorns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/curly_bug
	name = "curly antennae, colorable"
	desc = ""
	icon_state = "curly_bug"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/deer
	name = "deer ears"
	desc = ""
	icon_state = "deer"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/demon_horns1
	name = "demon horns"
	desc = ""
	icon_state = "demon-horns1"

/datum/sprite_accessory_meta/ears/demon_horns1_c
	name = "demon horns, colorable"
	desc = ""
	icon_state = "demon-horns1_c"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/demon_horns2
	name = "demon horns, colorable(outward)"
	desc = ""
	icon_state = "demon-horns2"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/demon_horns3
	name = "demon horns, colorable(upward)"
	desc = ""
	icon_state = "demon-horns3"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/demon_horns4
	name = "demon horns, colorable ring(upward)"
	desc = ""
	icon_state = "demon-horns4"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "demon-horns4-ring"

/datum/sprite_accessory_meta/ears/demon_horns5
	name = "demon horns, colorable (stubby)"
	desc = ""
	icon_state = "demon-horns5"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/donkey
	name = "donkey, colorable"
	desc = ""
	icon_state = "donkey"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "otie-inner"

/datum/sprite_accessory_meta/ears/dragon_horns
	name = "dragon horns, colorable"
	desc = ""
	icon_state = "dragon-horns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/drake
	name = "drake frills"
	desc = ""
	icon_state = "drake"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/dual_robot
	name = "synth antennae, colorable"
	desc = ""
	icon_state = "dual_robot_antennae"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/elfs
	name = "elven ears"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/elfshort
	name = "elven ears (short)"
	desc = ""
	icon_state = "elfshort"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/fenears
	name = "flatland zorren ears"
	desc = ""
	icon_state = "fenears"

/datum/sprite_accessory_meta/ears/fenearshc
	name = "flatland zorren ears, colorable"
	desc = ""
	icon_state = "fenearshc"
	extra_overlay = "fenears-inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/floppyelf
	name = "floppy elven ears"
	desc = ""
	icon_state = "floppy-elf"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/foxears
	name = "highlander zorren ears"
	desc = ""
	icon_state = "foxears"

/datum/sprite_accessory_meta/ears/foxearshc
	name = "highlander zorren ears, colorable"
	desc = ""
	icon_state = "foxearshc"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/inkling
	name = "colorable mature inkling tentacles"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "inkling-colorable"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/jackalope
	name = "Jackalope Ears and Antlers"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "jackalope"
	extra_overlay = "jackalope-antlers"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/kittyhc
	name = "kitty, colorable"
	desc = ""
	icon_state = "kitty"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "kittyinner"

/datum/sprite_accessory_meta/ears/kittyr
	name = "kitty right only, colorable"
	icon = 'icons/mob/sprite_accessories/ears_uneven.dmi'
	desc = ""
	icon_state = "kittyrinner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "kittyr"

/datum/sprite_accessory_meta/ears/large_dragon
	name = "vary large dragon horns"
	desc = ""
	icon_state = "big_liz"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/leafeon
	name = "Leaf Ears"
	desc = ""
	icon_state = "leaf_ears"

/datum/sprite_accessory_meta/ears/left_robot
	name = "left synth, colorable"
	desc = ""
	icon_state = "left_robot_antennae"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/mousehc
	name = "mouse, colorable"
	desc = ""
	icon_state = "mouse"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "mouseinner"

/datum/sprite_accessory_meta/ears/mousehcno
	name = "mouse, colorable, no inner"
	desc = ""
	icon_state = "mouse"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/mouse_grey
	name = "mouse, grey"
	desc = ""
	icon_state = "mouse-grey"

/datum/sprite_accessory_meta/ears/oni_h1
	name = "oni horns"
	desc = ""
	icon_state = "oni-h1"

/datum/sprite_accessory_meta/ears/oni_h1_c
	name = "oni horns, colorable"
	desc = ""
	icon_state = "oni-h1_c"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/otie
	name = "otie, colorable"
	desc = ""
	icon_state = "otie"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "otie-inner"

/datum/sprite_accessory_meta/ears/peekinghuman
	name = "peeking ears"
	desc = ""
	icon_state = "earpeek"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/rabbit_swept
	name = "Rabbit Ears (swept back)"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "rabbit-swept"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/ram
	name = "ram horns"
	desc = ""
	icon_state = "ram"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/right_robot
	name = "right synth, colorable"
	desc = ""
	icon_state = "right_robot_antennae"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/sandfox
	name = "Sandfox Ears"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "sandfox"
	extra_overlay = "sandfox-inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/sergal //Redundant
	name = "Sergal ears"
	icon_state = "serg_plain_s"

/datum/sprite_accessory_meta/ears/sergalhc
	name = "Sergal ears, colorable"
	icon_state = "serg_plain_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/sleek
	name = "sleek ears"
	desc = ""
	icon_state = "sleek"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/smallantlers
	name = "small antlers"
	desc = ""
	icon_state = "smallantlers"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/smallantlers_e
	name = "small antlers with ears"
	desc = ""
	icon_state = "smallantlers"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "deer"

/datum/sprite_accessory_meta/ears/smallbear
	name = "small bear"
	desc = ""
	icon_state = "smallbear"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/squirrelhc
	name = "squirrel, colorable"
	desc = ""
	icon_state = "squirrel"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/squirrel_orange
	name = "squirel, orange"
	desc = ""
	icon_state = "squirrel-orange"

/datum/sprite_accessory_meta/ears/squirrel_red
	name = "squirrel, red"
	desc = ""
	icon_state = "squirrel-red"

/datum/sprite_accessory_meta/ears/swooped_bunny
	name = "Swooped bunny ears (colorable)"
	desc = ""
	icon_state = "swooped_bunny"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/synthhorns_curly
	name = "Synth horns, curly"
	desc = ""
	icon_state = "synthhorns_curled"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/synthhorns_plain
	name = "Synth horns, plain"
	desc = ""
	icon_state = "synthhorns_plain"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "synthhorns_plain_light"

/datum/sprite_accessory_meta/ears/synthhorns_thick
	name = "Synth horns, thick"
	desc = ""
	icon_state = "synthhorns_thick"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "synthhorns_thick_light"

/datum/sprite_accessory_meta/ears/teppiears
	name = "Teppi Ears"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "teppi_ears"
	extra_overlay = "teppi_ears_inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/teppihorns
	name = "Teppi Horns"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "teppi_horns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/teppiearshorns
	name = "Teppi Ears and Horns"
	desc = ""
	icon = 'icons/mob/sprite_accessories/ears_32x64.dmi'
	icon_state = "teppi_ears"
	extra_overlay = "teppi_ears_inner"
	extra_overlay2 = "teppi_horns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/teshari
	name = "Teshari ears (colorable)"
	desc = ""
	icon_state = "teshari"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshariinner"

/datum/sprite_accessory_meta/ears/tesharihigh
	name = "Teshari upper ears (colorable)"
	desc = ""
	icon_state = "tesharihigh"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "tesharihighinner"

/datum/sprite_accessory_meta/ears/tesharilow
	name = "Teshari lower ears (colorable)"
	desc = ""
	icon_state = "tesharilow"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "tesharilowinner"

/datum/sprite_accessory_meta/ears/tesh_pattern_ear_male
	name = "Teshari male ear pattern (colorable)"
	desc = ""
	icon_state = "teshari"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1
	extra_overlay = "teshari_male_pattern"

/datum/sprite_accessory_meta/ears/tesh_pattern_ear_female
	name = "Teshari female ear pattern (colorable)"
	desc = ""
	icon_state = "teshari"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1
	extra_overlay = "teshari_female_pattern"

/datum/sprite_accessory_meta/ears/vulp
	name = "vulpkanin, dual-color"
	desc = ""
	icon_state = "vulp"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "vulp-inner"

/datum/sprite_accessory_meta/ears/vulp_jackal
	name = "vulpkanin thin, dual-color"
	desc = ""
	icon_state = "vulp_jackal"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "vulp_jackal-inner"

/datum/sprite_accessory_meta/ears/vulp_short
	name = "vulpkanin short"
	desc = ""
	icon_state = "vulp_terrier"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/ears/vulp_short_dc
	name = "vulpkanin short, dual-color"
	desc = ""
	icon_state = "vulp_terrier"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "vulp_terrier-inner"

/datum/sprite_accessory_meta/ears/wisewolf
	name = "wolf, wise"
	desc = ""
	icon_state = "wolf-wise"

/datum/sprite_accessory_meta/ears/wolfhc
	name = "wolf, colorable"
	desc = ""
	icon_state = "wolf"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "wolfinner"

/datum/sprite_accessory_meta/ears/wolf_green
	name = "wolf, green"
	desc = ""
	icon_state = "wolf-green"

/datum/sprite_accessory_meta/ears/wolf_grey
	name = "wolf, grey"
	desc = ""
	icon_state = "wolf-grey"

/datum/sprite_accessory_meta/ears/zears
	name = "jagged ears"
	desc = ""
	icon_state = "zears"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

//Moths
/datum/sprite_accessory_meta/ears/moth_antenna_fluff_burnt
	name = "burnt moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_burnt"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_deathhead
	name = "death's-head hawkmoth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_deathhead"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_firewatch
	name = "firewatch moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_firewatch"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_gothic
	name = "gothic moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_goth"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_jungle
	name = "jungle moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_jungle"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_lovers
	name = "lovers moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_lovers"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_moonfly
	name = "moonfly moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_moonfly"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_oakworm
	name = "oakworm moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_oakworm"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_plain
	name = "plain moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_plain"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_poison
	name = "poison moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_poison"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_ragged
	name = "ragged moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_ragged"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_red
	name = "red moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_red"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_royal
	name = "royal moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_royal"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_snowy
	name = "snowy moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_snowy"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_whitefly
	name = "whitefly moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_whitefly"

/datum/sprite_accessory_meta/ears/moth_antenna_fluff_witchwing
	name = "witchwing moth antennae and fluff"
	desc = ""
	icon_state = "moth_antenna_fluff_witchwing"

//Mushroom Heads - Ha.
/datum/sprite_accessory_meta/ears/fungal_muscaria
    name = "fungal muscaria cap"
    desc = ""
    icon_state = "fungal_muscaria"

/datum/sprite_accessory_meta/ears/fungal_polypore
    name = "fungal polyporous cap"
    desc = ""
    icon_state = "fungal_polypore"

// Species-unique ears
/datum/sprite_accessory_meta/ears/shadekin
	name = "Shadekin Ears, colorable"
	desc = ""
	icon_state = "shadekin"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	apply_restrictions = TRUE
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

// Special snowflake (Read: Whitelisted) ears go below here.
//None of these seem to be for Citadel users, but I'm retaining them for now.
/datum/sprite_accessory_meta/ears/alurane
	name = "alurane ears/hair (Pumila)"
	desc = ""
	icon_state = "alurane-ears"
	ckeys_allowed = list("natje")

/datum/sprite_accessory_meta/ears/aronai
	name = "aronai ears/head (Aronai)"
	desc = ""
	icon_state = "aronai"
	ckeys_allowed = list("arokha")

/datum/sprite_accessory_meta/ears/frost
    name = "Frost antenna"
    desc = ""
    icon_state = "frosted_tips"
    ckeys_allowed = list("tucker0666")

/datum/sprite_accessory_meta/ears/holly
	name = "tigress ears (Holly Sharp)"
	desc = ""
	icon_state = "tigressears"
	ckeys_allowed = list("hoodoo")

/datum/sprite_accessory_meta/ears/kerena
	name = "wingwolf ears (Kerena)"
	desc = ""
	icon_state = "kerena"
	ckeys_allowed = list("somekindofpony")

/datum/sprite_accessory_meta/ears/lilimoth_antennae
	name = "citheronia antennae (Kira72)"
	desc = ""
	icon_state = "lilimoth_antennae"
	ckeys_allowed = list("kira72")

/datum/sprite_accessory_meta/ears/miria_fluffdragon
	name = "fluffdragon ears (Miria Masters)"
	desc = ""
	icon_state = "miria-fluffdragonears"
	ckeys_allowed = list("miriamasters")

/datum/sprite_accessory_meta/ears/molenar_deathclaw
	name = "deathclaw ears"
	desc = ""
	icon_state = "molenar-deathclaw"

/datum/sprite_accessory_meta/ears/miria_kitsune
	name = "kitsune ears (Miria Masters)"
	desc = ""
	icon_state = "miria-kitsuneears"
	ckeys_allowed = list("miriamasters")

/datum/sprite_accessory_meta/ears/molenar_inkling
	name = "teal mature inkling hair (Kari Akiren)"
	desc = ""
	icon_state = "molenar-tentacle"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory_meta/ears/molenar_kitsune
	name = "quintail kitsune ears (Molenar)"
	desc = ""
	icon_state = "molenar-kitsune"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory_meta/ears/rosey
	name = "tritail kitsune ears (Rosey)"
	desc = ""
	icon_state = "rosey"
	ckeys_allowed = list("joey4298")

/datum/sprite_accessory_meta/ears/runac
	name = "fennecsune ears (Runac)"
	desc = ""
	icon_state = "runac"
	ckeys_allowed = list("rebcom1807")

/datum/sprite_accessory_meta/ears/shock
	name = "pharoah hound ears (Shock Diamond)"
	desc = ""
	icon_state = "shock"
	ckeys_allowed = list("icowom","cameron653")
